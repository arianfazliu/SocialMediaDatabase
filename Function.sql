DELIMITER //	
CREATE DEFINER=`root`@`localhost` FUNCTION `niveli_pelqimeve`(postId integer)
RETURNS varchar(25) CHARSET utf8mb4
DETERMINISTIC
BEGIN
declare numriPelqimeve integer;
declare niveli varchar(25);
select count(*) into numriPelqimeve from pelqimet where poid = postId;
if numriPelqimeve < 1 then 
set niveli = 'Pa pelqyer';
elseif numriPelqimeve >=1 and numriPelqimeve <2 then
set niveli = 'Relativisht i pelqyer';
elseif numriPelqimeve >=2 and numriPelqimeve <=5 then
set niveli = 'Mire i pelqyer';
elseif numriPelqimeve>5 then
set niveli = 'Shume i pelqyer';
end if;
RETURN niveli;
END//
DELIMITER ;

drop function niveli_pelqimeve;

select dpost as 'Data e postimit', kpost as 'Koha e postimit', plokacioni as 'Lokacioni i postimit', niveli_pelqimeve(poid) as 'Niveli i pelqimeve' from postimet;
