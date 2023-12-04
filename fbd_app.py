import pyodbc

driver='SQL Server' 
server='NAVE_MAE'
database='BDSpotPer'
# username=None
# password=None
trusted_connection='yes'

connect = f"DRIVER={driver};SERVER={server};DATABASE={database};TRUSTED_CONNECTION={trusted_connection}"
conexao = pyodbc.connect(connect)
print("Conexão Bem Sucedida")
cursor = conexao.cursor()

def criarPlaylist():
    id_playlist=(input('Informe qual será o código da playlist que será criada\n'))
    nome=(input('Informe o nome da nova Playlist:\n'))
    cursor.execute(f"insert into Playlist (id_play, nome, data_criacao, tempo_exec) values ({id_playlist}, '{nome}', '2023-12-04',0)")
    print("Playlist %s criada.\n"%(nome))
    conexao.commit()

    cursor.execute('select A.id_album, A.descrição, F.num_faixa, F.descricao from Album A inner join Faixa F on A.id_album=F.id_album')
    colunas =  cursor.fetchall()
    print('Álbuns e Faixas disponíveis:\n')
    for coluna in colunas :
        print("ID Faixa: %s - Nome da Faixa: %s - Álbum: %s\n" %(coluna[0],coluna[3],coluna[1]))
        cursor.fetchone()

    album=(input('Informe qual Álbum deseja adicionar:\n'))
    while(True):       
        faixa=(input('Informe quais faixas de '+ album +' deseja adicionar:\nOu digite x para finalizar\n'))
        if(faixa =='x'):
            break;
        else:
            cursor.execute(
                        f"insert into Faixa_Playlist (data_ultima_tocada, qtd_tocada, id_play, num_faixa) values ('2023-12-03',0, {id_playlist}, {faixa})")
            conexao.commit()
    print("Playlist concluída!!\n")

def alterarPlaylist():
    cursor.execute('select id_play, nome from Playlist')
    colunas =  cursor.fetchall()
    print('Playlists:\n')
    for coluna in colunas :
        print(coluna)
        cursor.fetchone()

    play=(input('Qual Playlist você gostaria de editar?\n'))
    print('Faixas da Playlist ' +play+ ':\n')
    cursor.execute(
        f"""select F.num_faixa, F.descricao 
            from Faixa F, Faixa_Playlist FP, Playlist P
            where F.num_faixa = FP.num_faixa and FP.id_play = P.id_play and P.id_play ={play}""")
    colunas=cursor.fetchall()
    for coluna in colunas :
        print(coluna)
        cursor.fetchone()

    action=(input('1 - Inserir musicas na playlist '+play+' \n2 - Remover musicas na playlist '+play+'\n'))

    ### Inserção
    if(action =='1'):
        insertMusic=(input('Informe o numero da musica que deseja adicionar:\n'))
        cursor.execute(f"insert into Faixa_Playlist (data_ultima_tocada, qtd_tocada, id_play, num_faixa) values ('2023-12-04', 0, {play}, {insertMusic})")
        print("Musica Inserida!!\n")

    ### Remoção
    elif(action=='2'):
        removeMusic=(input('Informe o numero da musica que deseja remover:\n'))
        cursor.execute(f'delete from Faixa_Playlist where id_play ={play} and num_faixa = {removeMusic}')
        print("Musica " +removeMusic+ " Removida!!")

    conexao.commit()

def albuns_most_value(cursor):
    command = 'select * from Album where pr_compra > (select avg(pr_compra) from Album)';
    cursor.execute(command);
    colunas = cursor.fetchall();
    print("Álbuns com preço maior que a média do preço de álbuns");
    for coluna in colunas:
        print(f"Id: {coluna[0]} | Nome: {coluna[1]}");      

def grav_dvorack(cursor):
    command = ("""select G.nome, count(P.id_play) as Qtd from Gravadora G, Playlist P
    inner join Faixa_Playlist FP on FP.id_play = P.id_play
    inner join Faixa F on F.num_faixa = FP.num_faixa
    inner join Album A on A.id_album = F.id_album
    inner join Faixa_Compositor FC on FC.num_faixa = F.num_faixa
    inner join Compositor C on C.id_compositor = FC.id_compositor
    where G.id_grav = A.id_grav and C.nome = 'Antonín Dvorack'
    group by G.id_grav, G.nome
    order by count(P.id_play) DESC""")
    cursor.execute(command);
    colunas = cursor.fetchall();

    print("Lista de Gravadoras com maior número de playlists com musica do Dvorack");

    for coluna in colunas:
        print(f"Nome: {coluna[0]} | Quantidade Playlists: {coluna[1]}");

def compositor_mais_faixas(cursor):
    command = ("""select C.nome, count(*) as Qtd_Faixas from Compositor C
    inner join Faixa_Compositor FC on FC.id_compositor = C.id_compositor
    inner join Faixa F on F.num_faixa = FC.num_faixa
    inner join Faixa_Playlist FP on FP.num_faixa = F.num_faixa
    inner join Playlist P on P.id_play = FP.id_play
    group by C.nome
    order by count(*) DESC""")
    cursor.execute(command)
    colunas = cursor.fetchall()

    print("Lista de Compositores com maior numero de faixas nas playlists");
    for coluna in colunas:
        print(f"Nome Compositor: {coluna[0]} | Quantidade Faixas: {coluna[1]}");

# albuns_most_value(cursor);
# grav_dvorack(cursor);
# compositor_mais_faixas(cursor);

criarPlaylist();
# alterarPlaylist();

cursor.close();
conexao.close();
