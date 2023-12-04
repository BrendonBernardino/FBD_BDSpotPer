create view playlist_qtd_albuns (nome_play, qtd_albuns)
as
select P.nome as Playlist, count(distinct A.id_album) as Qtd_Albuns from Playlist P, Album A
inner join Faixa F on F.id_album = A.id_album
inner join Faixa_Playlist FB on FB.num_faixa = F.num_faixa
where P.id_play = FB.id_play
--inner join Playlist P on P.id_play = FB.id_play
--where P.id_play = 4
group by P.id_play, P.nome