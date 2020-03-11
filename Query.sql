/*1. Listoni të gjithë shfrytëzuesit që janë nga qyteti i Prishtinës.*/
select sid, semri, smbiemri, qyteti 
from Shfrytezuesit 
where qyteti = 'Prishtine';


/*2. Cilët shfrytëzues (numrat unik, emrat dhe mbiemrat e tyre) 
dje dhe sot kanë postuar, komentuar dhe kanë bërë shpërndarje (share)?*/
select s.sid, s.semri, s.smbiemri from shfrytezuesit s 
inner join postimet p on s.sid = p.sid
inner join komentet k on s.sid = k.sid
inner join shperndarjet sh on s.sid =sh.sid
where p.dpost  = curdate() - interval 1 day and
k.data_komentit = curdate() - interval 1 day and
sh.data_sh = curdate() - interval 1 day and 
s.sid in 
		(select s.sid from shfrytezuesit s 
		inner join postimet p on s.sid = p.sid
		inner join komentet k on s.sid = k.sid
		inner join shperndarjet sh on s.sid =sh.sid
		where p.dpost  = curdate() and
		k.data_komentit = curdate() and
		sh.data_sh = curdate())
        group by sid;
        
        
/*3. Paraqitni të gjitha ngjarjet (events) që janë caktuar për nesër në
qytetin e Prishtinës dhe për të cilat ngjarje ka shfrytëzues që kanë
konfirmuar pjesëmarrjen.*/

select e.evid, e.evemri, e.elokacioni, e.evendi from eventet e
where e.ev_data_fillimit = curdate() + interval 1 day and e.evendi = 'Prishtine' and
e.evid in (
select e.evid from konfirmimi_eventit );



/* 4. Listoni shfrytëzuesit të cilët dje kanë postuar dy ose më shumë
statuse ndërsa sot nuk kanë postuar asnjë status. */

select s.sid, s.semri, s.smbiemri from shfrytezuesit s
inner join postimet p on p.sid = s.sid
where p.dpost = curdate() - interval 1 day
group by p.sid
having count(*)>=2 
and s.sid not in(select sid from postimet 
where dpost =curdate()
);

/* 5.  Listoni top 5 shfrytëzuesit me numër maksimal të postimeve në dy muajt e fundit. 
Lista të paraqes të dhënat e shfrytëzuesit (numrin unik, emrin, mbiemrin, qytetin dhe email-in)
 duke përfshirë edhe numrin e postimeve. */

select s.sid, s.semri, s.smbiemri, s.qyteti, k.email, count(p.poid) as "Numri i postimeve"
from shfrytezuesit s 
inner join kredencialet k on k.sid = s.sid 
inner join postimet p on p.sid = s.sid
where p.dpost between (now() - interval 2 month) and now() 
group by s.sid order by count(p.poid) 
desc limit 5;



/*6. Paraqitni top 10 postimet (statuset) që janë postuar nga shfrytëzuesit që kanë numër maksimal të shokëve dhe që këto postime kanë marr numër maksimal të pëlqimeve. 
Lista të përmbaj këto të dhëna: emrin dhe mbiemrin e shfrytëzuesit që ka bërë postimin, numrin e shokëve (friends) që ka shfrytëzuesi që ka bërë postimin,
datën/kohën e postimit, përmbajtjen e postimit (tekstin), vendin e postimit- lokacionin nëse ka, numrin e pëlqimeve që ka marr postimi*/

select p.poid, sh.semri, sh.smbiemri, NumriShokeve(p.sid), p.dpost, p.kpost, pmb.permbajtja_tjera, p.plokacioni, NumriPelqimeve(p.poid)
from postimet p
inner join shfrytezuesit sh on  sh.sid = p.sid
left join permb_postimit pmb on pmb.poid = p.poid
group by p.poid order by NumriShokeve(p.sid) desc, NumriPelqimeve(p.poid) desc limit 10;


-- Funksioni per paraqitjen e numrit te shokeve qe ka shfrytezuesi qe ka bere postimin
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `NumriShokeve`(postimetSid integer) RETURNS integer
deterministic
BEGIN
declare numriShokeve integer;
select count(*) into numriShokeve from shoket where sid1 = postimetSid or sid2 = postimetSid
group by postimetSid;
return numriShokeve;
END//
DELIMITER ;


-- Funksioni per paraqitjen e numrit te pelqimeve qe ka marr postimi
DELIMITER //
CREATE DEFINER = `root`@`localhost` FUNCTION `NumriPelqimeve`(postId integer) RETURNS integer
deterministic
BEGIN
declare numriPelqimeve integer;
select count(*) into numriPelqimeve from pelqimet where poid = postId;
return numriPelqimeve;
END//
DELIMITER ;

select distinct poid, plokacioni, NumriPelqimeve(poid) from postimet;