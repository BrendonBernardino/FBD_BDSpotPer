USE BDSpotPer

--a
select * from Album
where pr_compra > dbo.media_all_album()

--b
select G.nome, count(P.id_play) as Qtd from Gravadora G, Playlist P
inner join Faixa_Playlist FP on FP.id_play = P.id_play
inner join Faixa F on F.num_faixa = FP.num_faixa
inner join Album A on A.id_album = F.id_album
inner join Faixa_Compositor FC on FC.num_faixa = F.num_faixa
inner join Compositor C on C.id_compositor = FC.id_compositor
where G.id_grav = A.id_grav and C.nome = 'Antonín Dvorack'
group by G.id_grav, G.nome
order by count(P.id_play) DESC

--c
select C.nome, count(*) as Qtd_Faixas from Compositor C
inner join Faixa_Compositor FC on FC.id_compositor = C.id_compositor
inner join Faixa F on F.num_faixa = FC.num_faixa
inner join Faixa_Playlist FP on FP.num_faixa = F.num_faixa
inner join Playlist P on P.id_play = FP.id_play
group by C.nome
order by count(*) DESC
