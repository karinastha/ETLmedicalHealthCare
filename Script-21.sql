--insert into "lookupSchema".tblpatdesStage
--select x.pdescid , x.summary ,x.heightInFt, x.weightInKg , x.bloodpressure, x.patientId from (
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
from "medicalHealthCare".tblpatdes
--) x;

select * from "lookupSchema".tblpatient;

select * from "medicalHealthCare".tblpatient;

-- "medicalHealthCare".tblpatient definition

-- Drop table

-- DROP TABLE "medicalHealthCare".tblpatient;

CREATE TABLE "lookupSchema".tblpatientStage (
	patientid int4 NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	address varchar(50) NOT NULL,
	gender char(1) NOT NULL,
	contact numeric(15) NOT NULL,
	dob date NOT NULL,
	age int4 not null,
	ageCategory varchar(15) not null,
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);

truncate table "lookupSchema".tblpatientstage;

alter table "lookupSchema".tblpatientStage alter column contact type varchar(50) set not null ;

alter table "lookupSchema".tblpatientStage alter column gender type varchar(50);
alter table "lookupSchema".tblpatientStage alter column CONTACT set not NULL;

select * from "lookupSchema".tblpatientstage;
drop table "lookupSchema".tblpatientstage;

insert into "lookupSchema".tblpatientstage
select x.patientid , x.patientfirstname ,x.patientlastname, x.patientaddress , x.gender, x.contact, x.dateofbirth,
x.age, x.agecategory from (
	select patientid, patientfirstname, patientlastname, patientaddress ,concat(984,contact) contact  ,
	date_part('year',age(dateofbirth)) age,
case
WHEN upper(gender) ='FEMALE' or gender = '1' then 'F'
WHEN upper(gender) ='MALE' or gender = '0' then 'M'
ELSE gender 
END as gender, 
case
when date_part('year',age(dateofbirth)) >= 41 then 'OLD'
when date_part('year',age(dateofbirth)) <= 40 and date_part('year',age(dateofbirth)) >= 26 then 'MID'
when date_part('year',age(dateofbirth)) <= 25  then 'YOUNG'
END as ageCategory,dateofbirth 
from "medicalHealthCare".tblpatient
) x;

select overlay(contact placing '' from 3) from "medicalHealthCare".tblpatient;
select age( current_date , dateofbirth ) from "medicalHealthCare".tblpatient;

SELECT REGEXP_REPLACE('enter  prise ', '\s+$', '');

update "medicalHealthCare".tblpatient set contact = 
overlay(contact placing '' from 1 for length(substring(contact from '^\s*(.*?)\s*$')))
where contact is not null;



select date_part('year',age(dateofbirth))
--|| date_part('month', age(dateofbirth)) || || date_part('day', age(dateofbirth)) || 'days' 
--as exact_age
 from  
"medicalHealthCare".tblpatient;

select * from "medicalHealthCare".tblpatient;
alter table "medicalHealthCare".tblpatient alter column contact type varchar(15);
truncate table "medicalHealthCare".tblpatient;

-- "medicalHealthCare".tblpatient definition

-- Drop table

DROP TABLE "medicalHealthCare".tblpatient;

CREATE TABLE "medicalHealthCare".tblpatient (
	patientid int4 NOT NULL,
	patientfirstname varchar(50) NOT NULL,
	patientlastname varchar(50) NOT NULL,
	patientaddress varchar(50) NOT NULL,
	gender varchar(50) NOT NULL,
	contact varchar(15) NOT NULL,
	dateofbirth date NOT NULL,
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);

select * from 
"medicalHealthCare".tblpatient;



























