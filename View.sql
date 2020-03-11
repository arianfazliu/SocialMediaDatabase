

/* Gjeni emrin dhe mbiemrin e shfrytezuesve qe kane konfirmuar kerkesat e shoqerise dje ose sot*/
create view FriendRequestConfirmed as (
select distinct s.sid, s.semri as "Emri i pranuesit", s.smbiemri as "Mbiemri i pranuesit" from shfrytezuesit s
inner join KPSH k on k.sid_pranuesi = s.sid
where k.statusi = 'Confirmed' and ( k.data_statusit = curdate()
or k.data_statusit = curdate() - interval 1 day) );

select * from FriendRequestConfirmed;

/*==============================================================================================================================*/

/*Gjeni moshen(nga data e tyre e lindjes) e top 5 shfrytezuesve me te vjeter*/
create view AgeFromDOB as ( 
SELECT s.sid, semri, TIMESTAMPDIFF(YEAR, s.datelindja, CURDATE()) AS age FROM shfrytezuesit s 
order by age desc limit 5
);
select * from AgeFromDOB;

/*==============================================================================================================================*/

/* Listoni grupet sipas popullaritetit te tyre(Grupet qe kane me se shumti anetar) */

create view MostPopularGroups as (
select gl.gid, g.gemri, count(*) as 'NrAnetareve'
from grup_lista gl
inner join grupet g on g.gid = gl.gid
group by gl.gid
order by count(*) desc, gl.gid desc  );

select * from MostPopularGroups;