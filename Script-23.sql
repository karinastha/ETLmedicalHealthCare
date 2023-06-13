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


CREATE OR REPLACE PROCEDURE "lookupSchema".patientproc() 
LANGUAGE plpgsql
as
$$
	declare result varchar;
begin
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
end;
$$;

truncate table "lookupSchema".tblpatientstage;

call "lookupSchema".patientproc(); 

select * from "lookupSchema".tbldoctor;

select * from "medicalHealthCare".tbldoctor;


CREATE TABLE "medicalHealthCare".tbldoctor(
	doctorid int4 NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	address varchar(50) not null,
	gender varchar(50) not null,
	contact numeric(15) NOT NULL,
	nmc varchar(50) NOT NULL,
	CONSTRAINT tbldoctor_pkey PRIMARY KEY (doctorid)
);

select * from "medicalHealthCare".tbldoctor;

CREATE TABLE "lookupSchema".tbldoctorStage(
	doctorid int4 NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	address varchar(50) not null,
	gender varchar(50) not null,
	contact numeric(15) NOT NULL,
	nmc varchar(50) NOT NULL,
	CONSTRAINT tbldoctor_pkey PRIMARY KEY (doctorid)
);
insert into "lookupSchema".tbldoctorstage
select x.doctorid , x.firstname ,x.lastname, x.address , x.gender, x.contact, x.nmc
from (
	select doctorid, firstname, lastname, address ,contact, nmc,
case
WHEN upper(gender) ='FEMALE' or gender = '1' then 'F'
WHEN upper(gender) ='MALE' or gender = '0' then 'M'
ELSE gender 
END as gender
from "medicalHealthCare".tbldoctor
) x;	

select * from "medicalHealthCare".tbldoctor;

select * from "lookupSchema".tbldoctorstage;
truncate table "lookupSchema".tbldoctorstage;

CREATE OR REPLACE PROCEDURE "lookupSchema".doctorproc() 
LANGUAGE plpgsql
as
$$
	declare result varchar;
begin
	insert into "lookupSchema".tbldoctorstage
select x.doctorid , x.firstname ,x.lastname, x.address , x.gender, x.contact, x.nmc
from (
	select doctorid, firstname, lastname, address ,contact, nmc,
case
WHEN upper(gender) ='FEMALE' or gender = '1' then 'F'
WHEN upper(gender) ='MALE' or gender = '0' then 'M'
ELSE gender 
END as gender
from "medicalHealthCare".tbldoctor
) x;	
end;
$$;
call "lookupSchema".doctorproc(); 



CREATE TABLE "medicalHealthCare".tblbilling (
	billid int8 NULL,
	patientid int8 NOT NULL,
	doctorid int8 NOT NULL,
	dateofadmission date NOT NULL,
	dateofdischarge date NOT NULL,
	dateofbill date NOT NULL,
	dateofpayment date NOT NULL,
	totalamount numeric NOT NULL,
	tax numeric NOT NULL,
	vat numeric NOT NULL,
	currency varchar(50) NOT null,
	
);

alter table "medicalHealthCare".tblbilling add CONSTRAINT tblbilling_pkey PRIMARY KEY (billid);
select * from  "lookupSchema".tblbilling ;
insert into  "medicalHealthCare".tblbilling 
select * from "lookupSchema".tblbilling ;

select * from "medicalHealthCare".tblbilling;



CREATE TABLE "lookupSchema".tblbillingStage (
	billid int8 NULL,
	patientid int8 NOT NULL,
	doctorid int8 NOT NULL,
	dateofadmission date NOT NULL,
	dateofdischarge date,
	stayDuration numeric(50),
	dateofbill date NOT NULL,
	dateofpayment date NOT NULL,
	amountDollar numeric NOT NULL,
	CONSTRAINT tblbillingstage_pkey PRIMARY KEY (billid)
);

drop table "lookupSchema".tblbillingStage;
select * from "lookupSchema".tblbillingStage;


select "lookupSchema".calculateVatTax(200,13,10);
select * from "lookupSchema".tblbillingStage;

insert into "lookupSchema".tblbillingstage
select x.billid , x.patientid ,x.doctorid, x.dateofadmission , x.dateofdischarge,x.stayduration, x.dateofbill, x.dateofpayment,
"lookupSchema".calculateVatTax(x.totalamount, x.tax, x.vat)
from (
	select billid, patientid, doctorid, dateofadmission ,dateofdischarge,
case 
WHEN dateofdischarge is null then null
when ( dateofdischarge - dateofadmission) >= 0 then dateofdischarge - dateofadmission
when ( dateofdischarge - dateofadmission) < 0 then 0
END as stayduration ,dateofbill , dateofpayment , tax , vat, totalamount
from "medicalHealthCare".tblbilling
) x;	

truncate table"lookupSchema".tblbillingstage;

select billid, patientid, doctorid, dateofadmission ,dateofdischarge,
case 
WHEN dateofdischarge is null then null
when ( dateofdischarge - dateofadmission) >= 0 then dateofdischarge - dateofadmission
END as stayduration ,dateofbill , dateofpayment , tax , vat, totalamount
from "medicalHealthCare".tblbilling














select * from "medicalHealthCare".tblbilling;

select dateofdischarge , dateofadmission ,date_part('day', dateofdischarge - dateofadmission) as date_diff from "medicalHealthCare".tblbilling;

select EXTRACT(DAY from dateofdischarge - dateofadmission) AS DateDifference from "medicalHealthCare".tblbilling;

select( dateofdischarge - dateofadmission) as datediff from "medicalHealthCare".tblbilling;


select 
totalamount * 0.1 as tax , totalamount + (totalamount * 0.1) as totalamountVAT ,
totalamountVAT * 0.13 as VAT , totalamountVAT + (totalamountVAT * 0.13) as totalamountData from "medicalHealthCare".tblbilling;

 select ROUND(x.taxi + x.taxi* 0.13 , 2) as totalamount from
(select  
totalamount + totalamount * 0.1 as taxi from "medicalHealthCare".tblbilling) x;

 --select ROUND(x.taxi + x.taxi * 0.13 , 2) as totalamount from
select ROUND(x.taxi + x.taxi * 0.13 , 2) as totalamount from 
(select  
totalamount + totalamount * 0.1 as taxi from "medicalHealthCare".tblbilling)
x;




























