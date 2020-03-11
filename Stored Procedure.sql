/* Te shfaqen te dhenat e shfrytezuesve duke e ditur username-n e tyre */
delimiter //
create procedure searchForUser(pusername varchar(50))
begin 
select * from shfrytezuesit s
inner join kredencialet k on k.sid=s.sid
where k.username=pusername;
end //
delimiter //
call searchForUser("lauragashi");

/*==============================================================================================================================*/
 
/* Te shtohet nje film festiv per festat e fundvitit me ane te nje stored procedure */
delimiter // 
create procedure addMovie(p_femri varchar(50), p_fregjisori varchar(50), p_fprotagonisti varchar(50), 
p_fzhanri varchar(50), p_sid integer) begin 
insert into Filmat
set  femri=p_femri, fregjisori = p_fregjisori, fprotagonisti= p_fprotagonisti, fzhanri = p_fzhanri,sid=p_sid;
end //
delimiter //

call addMovie("Home Alone 3", "Paul Feig", "Kevin", "Familjar", 12);
Select * from Filmat where femri = "Home Alone 3";

/*==============================================================================================================================*/

/* Gjej shfrytezuesit duke kerkuar me shkronjen e pare te emrit ose mbiemrit */
delimiter $$
CREATE PROCEDURE searchUser(theFirstLetter char(1))
begin
SELECT * FROM shfrytezuesit
WHERE(semri LIKE CONCAT(theFirstLetter,'%') OR 
      smbiemri LIKE CONCAT(theFirstLetter,'%')
      );
end $$;
delimiter $$
call searchUser('D');