-- "medicalHealthCare".tblpatdoc definition

-- Drop table

-- DROP TABLE "medicalHealthCare".tblpatdoc;

CREATE TABLE "lookupSchema".tblpatdoc(
	id int4 NOT NULL,
	patientid int4 NOT NULL,
	doctorid int4 NOT NULL,
	isactive varchar(50) NOT NULL, 
	CONSTRAINT tblpatdoc_pkey PRIMARY KEY (id)
);

drop table "lookupSchema".tblpatdoc;

select * from "lookupSchema".tblpatdoc;

insert into "lookupSchema".tblpatdocStage (id, patientid , doctorid , isactive)
values (1,1,1,'YES'),
		(2,2,2,'NO'),
		(3,3,3,'Y'),
		(4,4,4,'NO'),
		(5,5,5,'1'),
		(6,6,6,'0'),
		(7,7,7,'N'),
		(8,8,8,'YES'),
		(9,9,9,'N'),
		(10,10,10,'NO');
	
--TRANSFORMATION
select id, patientid, doctorid, 
case
WHEN isactive = 'YES' or isactive = '1' then 'Y'
WHEN isactive = 'NO' or isactive = '0' then 'N'
ELSE isactive
END as isactiveCheck
from "lookupSchema".tblpatdoc;

select * from "lookupSchema".tblpatdoc;

CREATE TABLE "lookupSchema".tblpatdocStage(
	id int4 NOT NULL,
	patientid int4 NOT NULL,
	doctorid int4 NOT NULL,
	isactiveCheck char(1) not null, 
	CONSTRAINT tblpatdocstage_pkey PRIMARY KEY (id)
);

insert into "lookupSchema".tblpatdocStage 
select x.id, x.patientid, x.doctorid, 
case
WHEN isactive = 'YES' or isactive = '1' then 'Y'
WHEN isactive = 'NO' or isactive = '0' then 'N'
ELSE isactive
END as isactiveCheck from "lookupSchema".tblpatdoc
 x;

select * from "lookupSchema".tblpatdocstage;


--drop table "lookupSchema".tblpatdocstage;

select * from "lookupSchema".tblpatdocstage;


SELECT EXTRACT(YEAR FROM TIMESTAMP '2020-12-31 13:30:15');
select * from "medicalHealthCare".tblpatient;
SELECT patientname, EXTRACT(year FROM age(current_date,dateofbirth)) :: int as patientAge from "medicalHealthCare".tblpatient;


select *,age(CURRENT_DATE,date(dateofbirth)) as age from "medicalHealthCare".tblpatient; 


CREATE TABLE "lookupSchema".tblpatient (
	patientid int4 NOT NULL,
	patientfirstname varchar(50) NOT NULL,
	patientlastname varchar(50) NOT NULL,
	patientaddress varchar(50) NOT NULL,
	gender varchar(50) not null,
	contact numeric(15) NOT NULL,
	dateofbirth date NOT NULL,
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);


SELECT patientfirstname, EXTRACT(year FROM age(current_date,dateofbirth)) :: int as patientAge from "lookupSchema".tblpatient;

select  patientid, doctorid, 
case
WHEN isactive = 'YES' or isactive = '1' then 'Y'
WHEN isactive = 'NO' or isactive = '0' then 'N'
ELSE isactive
END as isactiveCheck
from "lookupSchema".tblpatdoc;

create or replace function fnMakeFull(firstName varchar, lastName varchar)
returns varchar 
as 
$$
begin 
	if firstName is null and lastName is null then 
		return null;
	elseif firstName is null and lastName is not null then 
		return lastName;
	elseif firstName is not null and lastName is null then 
		return firstName;
	else
		return concat(firstName,' ',lastName);
	end if;
end;
$$
language plpgsql

select * from fnMakeFull('Karina', 'Shrestha');


drop table "lookupSchema".tblpatient;
select * from "lookupSchema".tblpatient;



insert into "lookupSchema".tblpatient (patientid, patientfirstname ,patientlastname,patientaddress,
gender, contact, dateofbirth)
values (1,1,1,'YES'),
		(2,2,2,'NO'),
		(3,3,3,'Y'),
		(4,4,4,'NO'),
		(5,5,5,'1'),
		(6,6,6,'0'),
		(7,7,7,'N'),
		(8,8,8,'YES'),
		(9,9,9,'N'),
		(10,10,10,'NO');
	
select * from "medicalHealthCare".tblpatient;

-- table billing
CREATE TABLE "lookupSchema".tblbilling (
	billid  int8,
	patientid int8 not null,
	doctorid int8 not null,
	dateofadmission date not null,
	dateofdischarge date not null,
	dateofbill date NOT NULL,
	dateofpayment date NOT null,
	totalamount numeric not null,
	tax numeric not null,
	vat numeric not null,
	currency varchar(50) not null,
	constraint fk_pat foreign key (patientId) references tblpatient(patientId),
	constraint fk_doc foreign key (doctorId) references tbldoctor(doctorId)
);

CREATE TABLE "lookupSchema".tblbilling (
	billid  int8,
	patientid int8 ,
	doctorid int8 ,
	dateofadmission date,
	dateofdischarge date,
	dateofbill date,
	dateofpayment date,
	totalamount numeric ,
	tax numeric,
	vat numeric,
	currency varchar(50)
	--constraint fk_pat foreign key (patientId) references tblpatient(patientId),
	--constraint fk_doc foreign key (doctorId) references tbldoctor(doctorId)
);

drop table "lookupSchema".tblbilling; 
select * from "lookupSchema".tblbilling;

update "lookupSchema".tblbilling set patientid = 1 where billid = 1;

commit;

alter table "lookupSchema".tblbilling alter column currency type varchar(50);

insert into 
"lookupSchema".tblbilling values (1,1,1,'5/2/2017','3/25/2023','7/10/2020','7/17/2021',93901.18,9,7,'Rs');


create or replace function hello()
returns varchar 
as 
$$
begin 
	return 'Hello';
end;
$$
language plpgsql;
select hello();


create or replace function hello2(param1 integer, param2 varchar)
returns varchar 
as 
$$
begin 
--	return 'param1:' || param1 || ',param2:' || param2;
	return param1 || ' = ' || param2;
end;
$$
language plpgsql;
select hello2(45,'hey');



CREATE OR REPLACE PROCEDURE my_procedure(param1 INTEGER, param2 VARCHAR) 
LANGUAGE plpgsql
as
$$
	declare result varchar;
begin
	--raise notice return param1 || ' = ' || param2;	
	--raise notice 'hello';
	result := 'Parameter 1: ' || param1 || ', Parameter 2: ' || param2;
	--result := param1;
	RAISE NOTICE '%',result;
end;-- procedure code goes here END;
$$;

call my_procedure(1, 'helllooo helooo'); 

select * from "lookupSchema".tblpatdocStage;


select * from
"lookupSchema".tblpatdesstage;


insert into "lookupSchema".tblpatdesStage 
select x.pdescid , x.summary ,x.heightInFt, x.weightInKg , x.bloodpressure, x.patientId from (
	select pdescid, summary, 
case
WHEN heightIn = 'in' THEN round(height/12,2)
WHEN heightIn = 'cm' then round(height/30.48,2)
ELSE height 
END as heightInFt, 
case
WHEN weightIn = 'pd' THEN round(weight * 0.45,2)
ELSE weight 
END as weightInKg, 
case
WHEN bpSystolic > 110 AND bpDystolic > 90 then 1
WHEN bpSystolic < 90 AND bpDystolic < 60 then  -1
ELSE 0
END as bloodpressure, patientid
from "lookupSchema".tblpatdes) x;


CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc() 
LANGUAGE plpgsql
as
$$
	declare result varchar;
begin
	insert into "lookupSchema".tblpatdesStage2
select x.pdescid , x.summary ,x.heightInFt, x.weightInKg , x.bloodpressure, x.patientId from (
	select pdescid, summary, 
case
WHEN heightIn = 'in' THEN round(height/12,2)
WHEN heightIn = 'cm' then round(height/30.48,2)
ELSE height 
END as heightInFt, 
case
WHEN weightIn = 'pd' THEN round(weight * 0.45,2)
ELSE weight 
END as weightInKg, 
case
WHEN bpSystolic > 110 AND bpDystolic > 90 then 1
WHEN bpSystolic < 90 AND bpDystolic < 60 then  -1
ELSE 0
END as bloodpressure, patientid
from "lookupSchema".tblpatdes) x;
	
end;
$$;

call my_procedure(); 

select * from "lookupSchema".tblpatdesstage2;

-- "lookupSchema".tblpatdocstage definition

-- Drop table

-- DROP TABLE "lookupSchema".tblpatdocstage;

-- "lookupSchema".tblpatdesstage definition

-- Drop table

-- DROP TABLE "lookupSchema".tblpatdesstage;

CREATE TABLE "lookupSchema".tblpatdesstage2 (
	pdescid serial NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	CONSTRAINT tblpatdesstagetest_pkey PRIMARY KEY (pdescid)
);

select * from "medicalHealthCare".tblpatient;
select * from 
"lookupSchema".tblpatient;











