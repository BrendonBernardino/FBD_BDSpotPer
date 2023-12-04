create function compositor_obras (@nome_compositor varchar(50))
returns @tab_result table (id_album smallint primary key not null, album_nome varchar(100) not null)
as
begin
	insert into @tab_result

	select distinct A.id_album, A.descrição as Album from Album A
	inner join Faixa F on F.id_album = A.id_album
	inner join Faixa_Compositor FC on FC.num_faixa = F.num_faixa
	inner join Compositor C on C.id_compositor = FC.id_compositor
	where C.nome = @nome_compositor
	
	return
end;
/*
select distinct A.descrição as 'Album(s)' from Album A
inner join Faixa F on F.id_album = A.id_album
inner join Faixa_Compositor FC on FC.num_faixa = F.num_faixa
inner join Compositor C on C.id_compositor = FC.id_compositor
where C.nome = 'Giorgia'

select * from Compositor

select * from Album
select * from Faixa
select * from Faixa_Compositor
select * from Compositor
*/

select * from Compositor
select * from compositor_obras('Manon')

select * from Album
select * from Faixa
select * from Faixa_Compositor
select * from Compositor

/*
deve retornar media de preços de compra de todos os albuns
*/
create function media_all_album()
returns dec(8,2)
as
begin
	declare @media dec(8,2)
	select @media = avg(pr_compra) from Album
	return @media
end;

select dbo.media_all_album()