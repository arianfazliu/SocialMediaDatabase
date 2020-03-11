/* Nese i njejti shfrytezues tenton te shperndaj(share) te njejtin postim me shume se 10 here atehere te 
ndalohet kjo me ane te nje Triggeri duke paraqitur mesazhin: " ERROR: Span is not allowed " */

delimiter $$
create trigger blockspamshares
before insert on shperndarjet for each row begin
DECLARE sharecount INT;
  set sharecount = (select count(shid) from shperndarjet where (sid = new.sid and poid=new.poid) group by sid  );
  if sharecount>=10
    then
      signal sqlstate '45000'
      set message_text='ERROR: Span is not allowed';
       end if;
     
end$$

/*==============================================================================================================================*/

/* Pas fshirjes se te dhenave ne relacionin Shfrytezuesit, te ruhen ato te dhena ne nje tabel tjeter
(Trigger duhet te kryej funksionin e njejte sikurse Recycle Bin) */

create table DeletedShfrytezuesit( 
sid integer auto_increment primary key,
semri varchar(50) not null,
smbiemri varchar(50) not null,
sgjinia enum('M','F','T') not null,
datelindja date not null,						
statusiMartesor varchar(20),
rruga varchar(50),
qyteti varchar(30),
shteti varchar(30),
tel_mobile varchar(20) unique,
tel_fix varchar(20) unique,
kodi_postal varchar(10),
gjuha varchar(50),
religjioni varchar(20));

select * from DeletedShfrytezuesit;

DELIMITER $$ 
create trigger TrashTable before 
delete on Shfrytezuesit 
for each row 
begin
insert into DeletedShfrytezuesit() values (old.sid, old.semri, old.smbiemri, old.sgjinia, old.datelindja, old.statusiMartesor, 
old.rruga, old.qyteti, old.shteti, old.tel_mobile, old.tel_fix, old.kodi_postal, old.gjuha, old.religjioni);
END $$
DELIMITER $$ ;

/*==============================================================================================================================*/

/*--Trigeri per datelindje--*/
DELIMITER $$
CREATE TRIGGER date_check
BEFORE INSERT ON shfrytezuesit
FOR EACH ROW
BEGIN
IF NEW.datelindja >= CURDATE() OR NEW.datelindja <= date '1905-01-01'
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid date!';
END IF;
END$$
DELIMITER ;

/*==============================================================================================================================*/

/*Trigeri per vitin e filimit dhe mbarimit*/
DELIMITER $$
CREATE TRIGGER date_check_start_end_date
BEFORE INSERT ON edukimi
FOR EACH ROW
BEGIN
IF NEW.eviti_fillimit >= NEW.eviti_mbarimit 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Start date must be less than end date!';
END IF;
END$$
DELIMITER ;

/*==============================================================================================================================*/

/*--Trigeri per daten e postimit--*/
DELIMITER $$
CREATE TRIGGER post_date_check
BEFORE INSERT ON Postimet
FOR EACH ROW
BEGIN
IF NEW.dpost >= CURDATE() and NEW.kpost > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid post date or time!';
END IF;
END$$
DELIMITER ;