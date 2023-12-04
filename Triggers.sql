create trigger tg_barroco_ddd
on Faixa_Compositor
for update, insert
as
begin
	declare @num_faixa int,
			@id_compositor smallint,
			@descricao_periodo_musical varchar(15),
			@tipo_gravacao varchar(3)

	select @num_faixa = num_faixa, @id_compositor = id_compositor from inserted
	
	select @tipo_gravacao = F.tipo_gravacao, @descricao_periodo_musical = PM.descricao from Faixa F, Periodo_Musical PM, Compositor C1
	where PM.id_per_musical = C1.id_per_musical and C1.id_compositor = @id_compositor and F.num_faixa = @num_faixa

	if @descricao_periodo_musical = 'Barroco'
	begin
		if @tipo_gravacao <> 'DDD' or @tipo_gravacao is NULL
		begin
			print @num_faixa;
			print @id_compositor;
			raiserror('Error: Um álbum, com faixas de músicas do período barroco, só pode ser inserido no banco de dados, caso o tipo de gravação seja DDD', 16, 1)
			rollback tran
		end
	end
end

create trigger tg_album_64faixa
on Faixa
for update, insert
as
begin
	declare @qtd_faixas int

	select @qtd_faixas = count(F.num_faixa) from Faixa F
	where F.id_album = (select id_album from inserted)

	if @qtd_faixas > 64
	begin
		raiserror('Error: Um álbum não pode conter mais de 64 faixas.', 16, 1)
		rollback tran
	end
end

create trigger tg_add_ddd
on Faixa
for update, insert
as
begin
	declare @num_faixa int,
			@descricao varchar(70),
			@tipo_gravacao varchar(3),
			@tempo_exec dec(5,2),
			@id_album smallint,
			@id_composicao smallint,
			@meio_fis varchar(10)

	select @num_faixa = num_faixa, @descricao = descricao, @tipo_gravacao = tipo_gravacao, @tempo_exec = tempo_exec, @id_album = id_album, @id_composicao = id_composicao
	from inserted

	select @meio_fis = A.meio_fisico from Album A, Faixa F
	where @id_album = A.id_album

	print @meio_fis;
	print @tipo_gravacao;
	if @meio_fis = 'CD'
	begin
		print @meio_fis;
		if (@tipo_gravacao != 'ADD' and @tipo_gravacao != 'DDD') or @tipo_gravacao is NULL
		begin
			raiserror('Error: CD só pode ser do tipo de gravação ADD ou DDD', 16, 1)
			rollback tran
		end
	end
	else
	begin
		if @tipo_gravacao is not NULL
		begin
			raiserror('Warning: Download e Vinil não tem tipo de gravação.', 10, 1)
			rollback tran
			insert into Faixa (num_faixa, descricao, tipo_gravacao, tempo_exec, id_album, id_composicao) 
			values (@num_faixa, @descricao, NULL, @tempo_exec, @id_album, @id_composicao)
		end
	end
end

create trigger tg_media_album
on Album
for update, insert
as
begin
	declare @media dec(7,2),
			@preco_compra dec(7,2)

	select @preco_compra = A.pr_compra from Album A
	
	select @media = avg(Alb.pr_compra) from (select A.id_album, A.pr_compra from Album A, Faixa F
	where F.id_album = A.id_album and F.tipo_gravacao = 'DDD'
	except
	select A.id_album, A.pr_compra from Album A, Faixa F
	where F.id_album = A.id_album and F.tipo_gravacao != 'DDD') as Alb

	if @preco_compra > @media*3
	begin
		raiserror('Error: O preço de compra de um álbum não dever ser superior a três vezes a média do preço de compra de álbuns, com todas as faixas com tipo de gravação DDD.', 16, 1)
		rollback tran
	end
end
