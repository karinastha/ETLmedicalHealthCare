select ROUND(x.taxi + x.taxi * 0.13 , 2) as totalamount from 
(select  
totalamount + totalamount * 0.1 as taxi from "medicalHealthCare".tblbilling)
x;

create or replace function FnVatTax(pvat numeric , ptax numeric)
returns varchar 
as 
$$
declare 
result numeric;
begin 
	select ROUND(x.taxi + x.taxi * 0.13 , 2) as totalamount into result from 
(select  
totalamount + totalamount * 0.1 as taxi from "medicalHealthCare".tblbilling)
x;
return result;
end;
$$
language plpgsql

select FnVatTax();

select * from "lookupSchema".tblbillingstage;
select * from "medicalHealthCare".tblbilling;

create or replace function FnVatTax(pvat numeric , ptax numeric, pamount numeric)
returns varchar 
as 
$$
declare 
resultTax numeric;
result numeric;
begin 
--	select ROUND(x.taxi + x.taxi * 0.13 , 2) as totalamount into result from 
--(select  
--totalamount + totalamount * 0.1 as taxi from "medicalHealthCare".tblbilling)
--x;
	
select ROUND(pamount + 0.1 * pamount) into resultTax from dual;

--select ROUND(resultTax + 0.1 * resultTax) into result;
return resultTax;
end;
$$
language plpgsql

select FnVatTax();

create or replace function "lookupSchema".calculate_vat(price numeric , vat_rate numeric, tax_rate numeric)
returns numeric as $$
declare
	taxedamount numeric;-- := (price * tax_rate / 100) + price;
	--vatedmount numeric := (taxedamount * vat_rate / 100) + taxedamount;
	result numeric ;
	
begin
	result := (price * tax_rate / 100) + price;
	return result;
	--return taxedamount;
	--return vatedamount;
end;
$$ language plpgsql

select "lookupSchema".calculate_vat(100,21,13) ;

create or replace function "lookupSchema".calculateVatTax(amount numeric, vat_rate numeric , tax_rate numeric)
returns numeric as $$
declare 
	vat numeric := amount * vat_rate / 100;
	tax numeric := amount * tax_rate / 100;
begin
	return ROUND( amount + vat + tax , 2);
end;
$$
language plpgsql;

select "lookupSchema".calculateVatTax(100,20,13);


insert into "lookupSchema".tblbillingstage
select x.billid , x.patientid ,x.doctorid, x.dateofadmission , x.dateofdischarge,x.stayduration, x.dateofbill, x.dateofpayment,
"lookupSchema".calculateVatTax(x.totalamount, x.tax, x.vat)
from (
	select billid, patientid, doctorid, dateofadmission ,dateofdischarge,
case 
WHEN dateofdischarge is null then null
when ( dateofdischarge - dateofadmission) >= 0 then dateofdischarge - dateofadmission
when ( dateofdischarge - dateofadmission) < 0 then 0
END as stayduration ,dateofbill , dateofpayment , tax , vat,
case 
when currency = 'Rs' then totalamount / 130
when currency = 'Pound' then totalamount * 0.8
else totalamount 
end as totalamount
from "medicalHealthCare".tblbilling
) x;	

truncate table "lookupSchema".tblbillingstage;
select * from "lookupSchema".tblbillingstage;
select * from "medicalHealthCare".tblbilling;

CREATE OR REPLACE PROCEDURE "lookupSchema".billingproc() 
LANGUAGE plpgsql
as
$$
begin
	insert into "lookupSchema".tblbillingstage
select x.billid , x.patientid ,x.doctorid, x.dateofadmission , x.dateofdischarge,x.stayduration, x.dateofbill, x.dateofpayment,
"lookupSchema".calculateVatTax(x.totalamount, x.tax, x.vat)
from (
	select billid, patientid, doctorid, dateofadmission ,dateofdischarge,
case 
WHEN dateofdischarge is null then null
when ( dateofdischarge - dateofadmission) >= 0 then dateofdischarge - dateofadmission
when ( dateofdischarge - dateofadmission) < 0 then 0
END as stayduration ,dateofbill , dateofpayment , tax , vat,
case 
when currency = 'Rs' then totalamount / 130
when currency = 'Pound' then totalamount * 0.8
else totalamount 
end as totalamount
from "medicalHealthCare".tblbilling
) x;	
end;
$$;
call "lookupSchema".billingproc(); 

select * from "lookupSchema".tblbillingstage;
truncate table "lookupSchema".tblbillingstage;


select * from "lookupSchema".tbldoctorstage;


CREATE TABLE "medicalHealthCare".tblappointment (
	appid int4 NOT NULL,
	patientid int4 NOT NULL,
	doctorid int4 NOT NULL,
	appointdate date NOT NULL,
	appointTime time not null,
	appointType varchar not null,
	appointReason varchar not null,
	appointStatus varchar not null,
	CONSTRAINT pk_app PRIMARY KEY (appid),
	constraint fk_pat foreign key (patientid) references "medicalHealthCare".tblpatient(patientid),
	constraint fk_doc foreign key (doctorid) references "medicalHealthCare".tbldoctor(doctorid)
);
select * from "medicalHealthCare".tblappointment; 

alter table "medicalHealthCare".tblappointment alter column appointTime type Timezone;

drop table "medicalHealthCare".tblappointment;

CREATE TABLE "lookupSchema".tblappointmentStage (
	appid int4 NOT NULL,
	patientid int4 NOT NULL,
	doctorid int4 NOT NULL,
	daysRemaining numeric(5) not null,
	isCritical numeric(2) not null, 
	appointdate date NOT NULL,
	appointTime time not null,
	appointType varchar not null,
	appointGenre VARCHAR(20) DEFAULT 'consultation'::VARCHAR check
	(appointGenre IN ('testing', 'therapy', 'operation', 'consultation')),
	isMissed numeric(2) not null,
	appointReason varchar not null,
	appointStatus VARCHAR(20) DEFAULT 'pending'::VARCHAR check
	(appointstatus IN ('confirmed', 'scheduled', 'completed', 'rescheduled','canceled')),
	CONSTRAINT pk_app PRIMARY KEY (appid),
	constraint fk_pat foreign key (patientid) references "medicalHealthCare".tblpatient(patientid),
	constraint fk_doc foreign key (doctorid) references "medicalHealthCare".tbldoctor(doctorid)
);

status VARCHAR(20) DEFAULT 'pending'::VARCHAR CHECK (status IN ('pending', 'approved', 'rejected', 'canceled'))


select * from "lookupSchema".tblappointmentStage;
select * from "medicalHealthCare".tblappointment;

insert into "lookupSchema".tblappointmentStage
select x.appid , x.patientid ,x.doctorid, x.daysremaining , x.isCritical,x.appointdate, x.appointtime, x.appointtype,
x.appointgenre, x.isMissed, x.appointReason , x.appointstatus
from (
	select appid, patientid, doctorid, appointdate, appointtime, appointtype, appointreason, appointStatus,
case 
WHEN appointdate <= current_date  then 0
WHEN  appointdate > current_date then (appointdate - current_date)
end as daysremaining,
case 
when lower(appointtype) in ('heart condition', 'asthma', 'kidney problem' ,'broken bone' , 'stroke rehabilitation') then 1
else 0
end as isCritical, 
case 
when lower(appointtype) in ('cancer screening appointment' , 'stroke risk assessment appointment' ,'colonoscopy','mental health','rash','diarrhea','food allergy') then 'testing'
when lower(appointtype) in ('Diagnostic test' , 'surgical procedure','heart condition' ,'surgical consultation','immunization','upper respiratory infection','osteoporosis') then 'operation'
when lower(appointtype) in ('physical therapy' ,'preoperative assessment', 'occupational therapy session','sleep disorder','carpal tunnel syndrome') then 'therapy'
else 'consultation'
end as appointGenre,
case
when (current_date < appointdate)  then 0
when (current_date > appointdate) and (current_time < appointtime) then 1
else 0
end as isMissed
from "medicalHealthCare".tblappointment
) x;	

select billid, patientid, doctorid, dateofadmission ,dateofdischarge,
case
when doctorid = 1 then 1 + 1
when doctorid = 2 then 1 + 2
else doctorid  + 1
end as result
from "medicalHealthCare".tblbilling;


select concat(appointdate,appointtime) from "medicalHealthCare".tblappointment;
select current_time , current_date ;

select appointdate  - current_date from  "medicalHealthCare".tblappointment order by 1 desc ;
truncate table "medicalHealthCare".tblappointment;

select * from  "lookupSchema".tblappointmentstage;

CREATE OR REPLACE PROCEDURE "lookupSchema".appointmentproc() 
LANGUAGE plpgsql
as
$$
begin
	insert into "lookupSchema".tblappointmentStage
select x.appid , x.patientid ,x.doctorid, x.daysremaining , x.isCritical,x.appointdate, x.appointtime, x.appointtype,
x.appointgenre, x.isMissed, x.appointReason , x.appointstatus
from (
	select appid, patientid, doctorid, appointdate, appointtime, appointtype, appointreason, appointStatus,
case 
WHEN appointdate <= current_date  then 0
WHEN  appointdate > current_date then (appointdate - current_date)
end as daysremaining,
case 
when lower(appointtype) in ('heart condition', 'asthma', 'kidney problem' ,'broken bone' , 'stroke rehabilitation') then 1
else 0
end as isCritical, 
case 
when lower(appointtype) in ('cancer screening appointment' , 'stroke risk assessment appointment' ,'colonoscopy','mental health','rash','diarrhea','food allergy') then 'testing'
when lower(appointtype) in ('Diagnostic test' , 'surgical procedure','heart condition' ,'surgical consultation','immunization','upper respiratory infection','osteoporosis') then 'operation'
when lower(appointtype) in ('physical therapy' ,'preoperative assessment', 'occupational therapy session','sleep disorder','carpal tunnel syndrome') then 'therapy'
else 'consultation'
end as appointGenre,
case
when (current_date < appointdate)  then 0
when (current_date > appointdate) and (current_time < appointtime) then 1
else 0
end as isMissed
from "medicalHealthCare".tblappointment
) x;	
end;
$$;

call "lookupSchema".appointmentproc(); 

select * from "medicalHealthCare".tbldoctor;
select * from "lookupSchema".tbldoctorstage;


select * from "medicalHealthCare".tblpatdes;
select * from "lookupSchema".tblpatdesStage;

select * from "lookupSchema".tblpatdoc;
select * from "lookupSchema".tblpatdocStage;

























