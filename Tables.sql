use BDSpotPer

create table Gravadora(
	id_grav smallint not null,
	nome varchar(20),
	ender varchar(30),
	ender_home varchar(30),

	constraint pk_gravadora primary key(id_grav)
) on bdspotper_fg01

create table Telefone(
	telefone varchar(11) not null,
	id_grav smallint not null,

	constraint pk_telefone primary key(telefone),
	constraint fk_id_grav_telefone foreign key(id_grav) references Gravadora
) on bdspotper_fg01

create table Album(
	id_album smallint not null,
	descrição varchar(100),
	pr_compra dec(7,2) not null,
	data_compra date not null,
	data_grav date not null,
	tipo_compra varchar(10) not null,
	meio_fisico varchar(10) not null,
	qtd_cds_vinis smallint,
	id_grav smallint not null,

	constraint pk_album primary key(id_album),
	constraint fk_id_grav_album foreign key(id_grav) references Gravadora,
	constraint ck_data_grav check(data_grav > '2000-01-01'), --check data acima de 1-1-2000
	constraint ck_meio_fisico check(meio_fisico in ('CD', 'Vinil', 'Download'))
) on bdspotper_fg01

create table Composicao(
	id_composicao smallint not null,
	descricao varchar(100),
	tipo varchar(20) not null,

	constraint pk_id_comp primary key(id_composicao),
	constraint ck_tipo_comp check(tipo in ('Sinfonia', 'Ópera', 'Sonata', 'Concerto'))
) on bdspotper_fg01

create table Faixa(
	num_faixa int not null,
	descricao varchar(70),
	tipo_gravacao varchar(3),
	tempo_exec dec(5,2) not null,
	id_album smallint not null,
	id_composicao smallint not null,

	constraint pk_num_faixa primary key nonclustered(num_faixa),
	constraint fk_id_album_faixa foreign key(id_album) references Album on delete cascade on update cascade, -- se album removido, todas as faixas dele deletadas
	constraint fk_id_comp_faixa foreign key(id_composicao) references Composicao on delete no action on update cascade
) on bdspotper_fg02

create clustered index idx_id_album 
on Faixa(id_album)
with(pad_index=on, fillfactor=100) 

create nonclustered index idx_id_composicao_tipo 
on Faixa(id_composicao)
with(pad_index=on, fillfactor=100) 

create table Playlist(
	id_play smallint not null,
	nome varchar(40) not null,
	data_criacao date not null,
	tempo_exec dec(5,2) not null,

	constraint pk_id_play primary key(id_play)
) on bdspotper_fg02

create table Faixa_Playlist(
	data_ultima_tocada date not null,
	qtd_tocada int not null,
	id_play smallint not null,
	num_faixa int not null,

	constraint pk_faixa_playlist primary key(id_play, num_faixa),
	constraint fk_id_play_faixaplaylist foreign key(id_play) references Playlist on delete no action on update cascade,
	constraint fk_num_faixa_faixaplaylist foreign key(num_faixa) references Faixa on delete no action on update cascade
) on bdspotper_fg02

create table Interprete(
	id_interp smallint not null,
	nome varchar(50) not null,
	tipo varchar(20) not null,

	constraint pk_id_interp primary key(id_interp),
	constraint ck_tipo_interprete check(tipo in ('Orquestra', 'Trio', 'Quarteto', 'Ensemble', 'Soprano', 'Tenor'))
) on bdspotper_fg01

create table Periodo_Musical(
	id_per_musical smallint not null,
	descricao varchar(15),
	int_tempo_ativo varchar(50),

	constraint pk_id_per_musical primary key(id_per_musical),
	constraint ck_descricao check (descricao in ('Idade média','Renascença', 'Barroco', 'Clássico', 'Romântico', 'Moderno'))
) on bdspotper_fg01

create table Compositor(
	id_compositor smallint not null,
	nome varchar(50) not null,
	cidade_nasc varchar(20) not null,
	pais_nasc varchar(20) not null,
	data_nasc date not null,
	data_morte date,
	id_per_musical smallint not null,

	constraint pk_id_compositor primary key(id_compositor),
	constraint fk_id_permusical_compositor foreign key(id_per_musical) references Periodo_Musical
) on bdspotper_fg01

create table Faixa_Compositor(
	num_faixa int not null,
	id_compositor smallint not null,

	constraint pk_faixa_compositor primary key(num_faixa, id_compositor),
	constraint fk_num_faixa_compositor foreign key(num_faixa) references Faixa on delete cascade,
	constraint fk_id_compositor_faixa foreign key(id_compositor) references Compositor on delete cascade
) on bdspotper_fg01

create table Faixa_Interprete(
	num_faixa int not null,
	id_interp smallint not null,

	constraint pk_faixa_interprete primary key(num_faixa, id_interp),
	constraint fk_num_faixa_interprete foreign key(num_faixa) references Faixa on delete cascade,
	constraint fk_id_interp_faixa foreign key(id_interp) references Interprete on delete cascade
) on bdspotper_fg01