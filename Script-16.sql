-- "medicalHealthCare".tblpatdes definition

-- Drop table

-- DROP TABLE "medicalHealthCare".tblpatdes;

CREATE TABLE "lookupSchema".tblheight (

	heightid SERIAL PRIMARY KEY,
	height numeric(3) NOT NULL,
	measureIn varchar(2) NOT NULL

);

select * from "lookupSchema".tblheight;

insert INTO "lookupSchema".tblheight (height, measureIn) values (175, 'cm'), 
															 (200 , 'cm'),
															(5.9, 'ft'),
															(70, 'in'),
															(65, 'in');
commit;

CREATE TABLE "lookupSchema".tblheightStage (
	heightid SERIAL PRIMARY KEY,
	heightFt numeric(3) NOT NULL
);

drop table "lookupSchema".tblheightStage;

select * from "lookupSchema".tblheightStage; 

CREATE TABLE example ( id SERIAL PRIMARY KEY, column1 TEXT, column2 INTEGER );


-- "medicalHealthCare".tblpatdes foreign keys

ALTER TABLE "medicalHealthCare".tblpatdes ADD CONSTRAINT fk_pat_des FOREIGN KEY (patientid) REFERENCES "medicalHealthCare".tblpatient(patientid);

select heightid, 
case
WHEN measureIn = 'in' THEN round(height/12,2) 
WHEN measureIn = 'cm' then  round(height/30.48,2)
ELSE height 
END as heightInFt from "lookupSchema".tblheight;

--value insert from table height
--insert into "lookupSchema".tblheightStage 
select x.heightId ,x.heightInFt from (
	select heightid, 
case
WHEN measureIn = 'in' THEN round(height/12,2) 
WHEN measureIn = 'cm' then  round(height/30.48,2)
ELSE height 
END as heightInFt from "lookupSchema".tblheight
) x;

truncate table "lookupSchema".tblheightStage; 
alter table "lookupSchema".tblheightStage alter column heightFt type decimal;

select * from "lookupSchema".tblheightStage; 

commit

insert into "lookupSchema".tblheightStage (heightid , heightFt)
select heightid , height from "lookupSchema".tblheight; 

insert into "lookupSchema".tblheightStage (heightid , heightFt)
values ( 10,5.6);


select heightid, 
case
WHEN measureIn = 'in' THEN round(height/12,2) 
WHEN measureIn = 'cm' then  round(height/30.48,2)
ELSE height 
END as heightInFt from "lookupSchema".tblheight;





















