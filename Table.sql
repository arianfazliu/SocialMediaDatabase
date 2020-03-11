use db_project;

CREATE USER 'arian1'@'localhost' IDENTIFIED BY "fiek2017" ;
GRANT ALL PRIVILEGES ON bank.* TO 'arian1'@'localhost' WITH GRANT OPTION;
GRANT FILE ON *.* TO 'arian1'@'localhost';  
/*-------------------------------------Create tables -------------------------------------*/


/*-------------------Shfrytezuesit-------------------*/

CREATE TABLE shfrytezuesit(
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

drop table shfrytezuesit;
select * from shfrytezuesit;

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

drop trigger date_check;

/*-----------------------------Profili-----------------------------*/

create table profili(
prid int auto_increment primary key,
foto_profilit mediumblob,
aftesitePro varchar(60),
spershkrimi varchar(70),
sid integer not null unique,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table profili;

select * from profili;

SHOW VARIABLES LIKE 'max_allowed_packet';
SHOW VARIABLES LIKE "secure_file_priv";



/*--------------------------Albumi-----------------------------------*/
create table Albumi(
aid integer auto_increment primary key,
emrialbumit varchar(50), 
sid integer not null,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

ALTER TABLE Albumi AUTO_INCREMENT = 1221;
select * from albumi;
drop table albumi;

/*-----------------------------Fotografite---------------------------------*/
create table fotografite(
phid integer auto_increment primary key,
foto varchar(50) not  null,
aid integer not null,
foreign key(aid) references albumi(aid) on delete cascade);

ALTER TABLE fotografite AUTO_INCREMENT = 1321;

drop table fotografite;

/* --------------------------Videot-------------------------------*/
create table videot(
vid integer auto_increment primary key,
video varchar(50) not null,
aid integer not null,
foreign key(aid) references albumi(aid) on delete cascade);

ALTER TABLE videot AUTO_INCREMENT = 1421;

drop table videot;

/*---------------------------Kredencialet-----------------------*/
create table kredencialet(
kid integer auto_increment primary key,
email varchar (50) unique not null,
username varchar(50) unique not null,
password varchar(20) not null,
sid integer,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table kredencialet;

/*----------------------------Edukimi----------------------------*/
create table edukimi(
eid integer auto_increment primary key,
efakulteti varchar(60),
edepartamenti varchar (60),
eprogrami varchar (60),
eviti_fillimit date,
eviti_mbarimit date,
enota_mes real check(enota_mes between 6.00 and 10.00),
eshk_fillore varchar(60),
eshk_mesme varchar(60),
edrejtimi varchar(60),
sid integer,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);


drop table edukimi;
select * from edukimi;

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

drop trigger date_check_start_end_date;

/*-------------------------------------Punesimi --------------------------------------*/
create table punesimi(
pid integer auto_increment primary key,
p_meparshme varchar (50),
poz_meparshme varchar(50),
pdata_fillimitmp date,
pdata_mbarimit date,
p_tanishme varchar(50),
poz_tanishme varchar(50),
pdata_ft date,
sid integer not null,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table punesimi;

/*Trigeri per vitin e filimit dhe mbarimit*/
DELIMITER $$
CREATE TRIGGER date_check_start_end_date_punesimi
BEFORE INSERT ON punesimi
FOR EACH ROW
BEGIN
IF NEW.pdata_fillimitmp >= NEW.pdata_mbarimit
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Start date must be less than end date!';
END IF;
END$$
DELIMITER ;

drop trigger date_check_start_end_date_punesimi;

/*-------------------------------------Hobi-----------------------------------------*/
create table hobi(
hid integer auto_increment primary key,
pershkrimi_hobit varchar(100),
sid integer,
foreign key(sid) references shfrytezuesit(sid) on delete set null);

drop table hobi;

/*----------------------------------------Muzika------------------------------------*/
create table Muzika (
mid integer auto_increment primary key,
memri varchar(50),
mkengetari varchar(50),
mzhanri varchar(30),
sid integer,
foreign key(sid) references shfrytezuesit(sid) on delete set null);

drop table muzika;

/*---------------------------------------Librat-------------------------------------*/
create table Librat(
lid integer auto_increment primary key,
lemri varchar(50),
lautori varchar(50),
lzhanri varchar(30),
sid integer,
foreign key(sid) references shfrytezuesit(sid) on delete set null);

drop table librat;


/*---------------------------------------Filmat-------------------------------------*/
create table Filmat(
fid integer auto_increment primary key,
femri varchar(50),
fregjisori varchar(50),
fprotagonisti varchar(50),
fzhanri varchar(30),
sid integer,
foreign key(sid) references shfrytezuesit(sid) on delete set null);

drop table filmat;

/*----------------------------------------Postimet-----------------------------------*/
create table Postimet(
poid integer auto_increment primary key,
dpost date,
kpost time,
plokacioni varchar(50),
sid integer not null,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table postimet;

ALTER TABLE postimet AUTO_INCREMENT = 10001;

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

drop trigger post_date_check;

/*--------------------------------------Permbajtja e postimit -----------------------------*/
create table Permb_Postimit(
pmbid integer auto_increment primary key,
permbajtja_tjera varchar(100),
vid integer,
phid integer,
poid integer not null,
foreign key(vid) references videot(vid) on delete cascade,
foreign key(phid) references fotografite(phid) on delete set null,
foreign key(poid) references postimet(poid) on delete cascade);

drop table Permb_Postimit;

/*----------------------------------------Komentet--------------------------------------*/
create table Komentet(
cid integer auto_increment primary key,
data_komentit date,
koha_komentit time,
permbajtja varchar(150),
poid integer not null,
sid integer not null,
foreign key(poid) references postimet(poid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table Komentet;

ALTER TABLE komentet AUTO_INCREMENT = 1201;

/*--Trigeri per daten e komentit--*/
DELIMITER $$
CREATE TRIGGER comment_date_check
BEFORE INSERT ON komentet
FOR EACH ROW
BEGIN
IF NEW.data_komentit >= CURDATE() and NEW.koha_komentit  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid comment date or time!';
END IF;
END$$
DELIMITER ;

drop trigger comment_date_check;

/*-------------------------Pelqimi i komenteve-------------------------------*/
create table Pelqimi_Komenteve(
pcid integer auto_increment primary key,
data_pc date,
koha_pc time,
cid integer not null,
sid integer not null,
foreign key(cid) references komentet(cid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table Pelqimi_Komenteve;

/*--Trigeri per daten e pelqimit te komentit--*/
DELIMITER $$
CREATE TRIGGER commentLike_date_check
BEFORE INSERT ON Pelqimi_Komenteve
FOR EACH ROW
BEGIN
IF NEW.data_pc >= CURDATE() and NEW.koha_pc  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid comment like date or time!';
END IF;
END$$
DELIMITER ;

drop trigger commentLike_date_check;

/*---------------------------------Pelqimet------------------------------------*/
create table Pelqimet(
plid integer auto_increment primary key,
data_pl date,
koha_pl time,
poid integer not null,
sid integer not null,
foreign key(poid) references postimet(poid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table pelqimet;

DELIMITER $$
CREATE TRIGGER likes_date_check
BEFORE INSERT ON Pelqimet
FOR EACH ROW
BEGIN
IF NEW.data_pl >= CURDATE() and NEW.koha_pl  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid like date or time!';
END IF;
END$$
DELIMITER ;

drop trigger likes_date_check;

/*----------------------------Pelqimet e vecanta---------------------------*/
create table Pelqimet_Vecanta (
plvid integer auto_increment primary key,
data_plv date,
koha_plv time,
pmbid integer not null, 
sid integer not null,
foreign key(pmbid) references permb_postimit(pmbid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table Pelqimet_Vecanta;

DELIMITER $$
CREATE TRIGGER special_likes_date_check
BEFORE INSERT ON Pelqimet_Vecanta
FOR EACH ROW
BEGIN
IF NEW.data_plv >= CURDATE() and NEW.koha_plv  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid special like date or time!';
END IF;
END$$
DELIMITER ;

drop trigger special_likes_date_check;

/*-------------------------------------Shperndarjet-----------------------------------*/
create table shperndarjet(
shid integer auto_increment primary key,
data_sh date,
koha_sh time,
poid integer not null, 
sid integer not null,
foreign key(poid) references postimet(poid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table shperndarjet;

DELIMITER $$
CREATE TRIGGER share_date_check
BEFORE INSERT ON shperndarjet
FOR EACH ROW
BEGIN
IF NEW.data_sh >= CURDATE() and NEW.koha_sh  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid share date or time!';
END IF;
END$$
DELIMITER ;

drop trigger share_date_check;

/*------------------------------------------Komenti i shperndarjeve-------------------------------*/
create table Komenti_Shperndarjet(
 kshid integer auto_increment primary key,
 data_ksh date,
 koha_sh time,
 permbajtja varchar(100),
 shid integer not null,
 sid integer not null,
 foreign key(shid) references shperndarjet(shid) on delete cascade,
 foreign key(sid) references shfrytezuesit(sid) on delete cascade);
 
 drop table Komenti_Shperndarjet;
 
 DELIMITER $$
CREATE TRIGGER share_comment_date_check
BEFORE INSERT ON Komenti_Shperndarjet
FOR EACH ROW
BEGIN
IF NEW.data_ksh >= CURDATE() and NEW.koha_sh  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid share comment date or time!';
END IF;
END$$
DELIMITER ;

drop trigger share_comment_date_check;

/*------------------------------Pelqimet e shperndarjeve ------------------------------*/
create table Pelqimi_Shperndarjet(
plshid integer auto_increment primary key, 
data_plsh date,
koha_plsh time, 
shid integer not null, 
sid integer not null,
foreign key(shid) references shperndarjet(shid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table Pelqimi_Shperndarjet;

DELIMITER $$
CREATE TRIGGER like_comment_date_check
BEFORE INSERT ON Pelqimi_Shperndarjet
FOR EACH ROW
BEGIN
IF NEW.data_plsh >= CURDATE() and NEW.koha_plsh  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid share like date or time!';
END IF;
END$$
DELIMITER ;

drop trigger like_comment_date_check;

/*---------------------------------Kerkesa per shoqeri ---------------------------------*/
create table KPSH(
 kpshid integer auto_increment primary key,
 data_dergimit date,
 koha_dergimit time, 
 statusi enum("Confirmed", "Ignored", "Pending"),
 data_statusit date,
 koha_statusit time,
 sid_derguesi integer not null,
 sid_pranuesi integer not null,
 foreign key(sid_derguesi) references shfrytezuesit(sid) on delete cascade,
 foreign key(sid_pranuesi) references shfrytezuesit(sid) on delete cascade);
 
 drop table KPSH;

DELIMITER $$
CREATE TRIGGER friend_request_date_check
BEFORE INSERT ON KPSH
FOR EACH ROW
BEGIN
IF NEW.data_dergimit >= CURDATE() and NEW.koha_dergimit  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid friend request date or time!';
END IF;
END$$
DELIMITER ;


drop trigger friend_request_date_check;

/*-----------------------------------Shoket----------------------------------------*/
create table shoket (
shoid integer auto_increment primary key,
data_sho date,
koha_sho time, 
sid1 integer, 
sid2 integer,
foreign key(sid1) references shfrytezuesit(sid) on delete cascade,
foreign key(sid2) references shfrytezuesit(sid) on delete cascade);

drop table shoket;

DELIMITER $$
CREATE TRIGGER friends_date_check
BEFORE INSERT ON shoket
FOR EACH ROW
BEGIN
IF NEW.data_sho >= CURDATE() and NEW.koha_sho  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid friendship date or time!';
END IF;
END$$
DELIMITER ;

drop trigger friends_date_check;

/*---------------------------------Grupet--------------------------------------*/
create table Grupet (
gid integer auto_increment primary key, 
gemri varchar(50), 
data_g date,
koha_g time,
sid integer not null,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table grupet;

DELIMITER $$
CREATE TRIGGER groups_date_check
BEFORE INSERT ON grupet
FOR EACH ROW
BEGIN
IF NEW.data_g >= CURDATE() and NEW.koha_g  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid group date or time!';
END IF;
END$$
DELIMITER ;

drop trigger groups_date_check;

/*-----------------------------------Grup lista------------------------------*/
create table Grup_lista(
glid integer auto_increment primary key, 
data_gl date,
koha_gl time, 
gid integer not null, 
sid integer,
foreign key (gid) references grupet(gid) on delete cascade,
foreign key (sid) references shfrytezuesit(sid) on delete set null);

drop table Grup_lista;

DELIMITER $$
CREATE TRIGGER groupList_date_check
BEFORE INSERT ON Grup_lista
FOR EACH ROW
BEGIN
IF NEW.data_gl >= CURDATE() and NEW.koha_gl  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid group join date or time!';
END IF;
END$$
DELIMITER;

drop trigger groupList_date_check;

/*------------------------------------Eventet-----------------------------------*/
create table Eventet(
evid integer auto_increment primary key, 
evemri varchar(50) not null, 
elokacioni varchar(50) not null,
evendi varchar(50) not null, 
evpershkrimi varchar(150),
ev_data_fillimit date not null,
ev_koha_fillimit time not null,
ev_data_mbarimit date not null,
ev_koha_mbarimit time not null,
sid integer not null,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);


select * from eventet;


DELIMITER $$
CREATE TRIGGER check_start_end_date_eventet
BEFORE INSERT ON eventet
FOR EACH ROW
BEGIN
IF NEW.ev_data_fillimit >= NEW.ev_data_mbarimit
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Start date must be less than end date!';
END IF;
END$$
DELIMITER ;


drop trigger check_start_end_date_eventet;

DELIMITER $$
CREATE TRIGGER check_start_end_date_time_eventet
BEFORE INSERT ON eventet
FOR EACH ROW
BEGIN
IF NEW.ev_data_fillimit>=current_date() and ev_koha_fillimit > current_time()
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid event date or time!';
END IF;
END$$
DELIMITER ;

drop trigger check_start_end_date_time_eventet;

/*--------------------------------------------Konfirmimi i Eventit-----------------------------*/
create table Konfirmimi_Eventit(
kfid integer auto_increment primary key, 
data_kf date, 
koha_kf time,
evid integer not null, 
sid integer not null,
foreign key(evid) references eventet(evid) on delete cascade,
foreign key(sid) references shfrytezuesit(sid) on delete cascade);

drop table Konfirmimi_Eventit;

DELIMITER $$
CREATE TRIGGER confirm_event_date_check
BEFORE INSERT ON Konfirmimi_Eventit
FOR EACH ROW
BEGIN
IF NEW.data_kf>= CURDATE() and NEW.koha_kf  > curtime() 
THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid event confirm date or time!';
END IF;
END$$
DELIMITER ;

drop trigger confirm_event_date_check;