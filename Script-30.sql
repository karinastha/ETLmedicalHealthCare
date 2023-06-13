CREATE TABLE "dbMedicalLoad".tblpatdesload (
	pdescid serial NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	CONSTRAINT tblpatdesload_pkey PRIMARY KEY (pdescid)
);

drop table "dbMedicalLoad".tblpatdeslod;


CREATE TABLE  "dbMedicalLoad".tblappointmentload (
	appid int4 NOT NULL,
	patientid int4 NOT NULL,
	doctorid int4 NOT NULL,
	daysremaining numeric(5) NOT NULL,
	iscritical numeric(2) NOT NULL,
	appointdate date NOT NULL,
	appointtime time NOT NULL,
	appointtype varchar NOT NULL,
	appointgenre varchar(20) NULL DEFAULT 'consultation'::character varying,
	ismissed numeric(2) NOT NULL,
	appointreason varchar NOT NULL,
	appointstatus varchar(20) NULL DEFAULT 'pending'::character varying,
	CONSTRAINT pk_app PRIMARY KEY (appid),
	CONSTRAINT tblappointmentload_appointgenre_check CHECK (((appointgenre)::text = ANY ((ARRAY['testing'::character varying, 'therapy'::character varying, 'operation'::character varying, 'consultation'::character varying])::text[]))),
	CONSTRAINT tblappointmentload_appointstatus_check CHECK (((appointstatus)::text = ANY ((ARRAY['confirmed'::character varying, 'scheduled'::character varying, 'completed'::character varying, 'rescheduled'::character varying, 'canceled'::character varying])::text[])))
);


CREATE TABLE "dbMedicalLoad".tblbillingload (
	billid int8 NOT NULL,
	patientid int8 NOT NULL,
	doctorid int8 NOT NULL,
	dateofadmission date NOT NULL,
	dateofdischarge date NULL,
	stayduration numeric(50) NULL,
	dateofbill date NOT NULL,
	dateofpayment date NOT NULL,
	amountdollar numeric NOT NULL,
	CONSTRAINT tblbillingload_pkey PRIMARY KEY (billid)
);
drop table "dbMedicalLoad".tblbillingstage;

CREATE TABLE "dbMedicalLoad".tblcriticalbygenre (
	id int4 NOT NULL,
	count numeric(15) NOT NULL,
	genre varchar(50) NOT NULL,
	CONSTRAINT genre_critical UNIQUE (genre) DEFERRABLE,
	CONSTRAINT tblcriticalgenre_pkey PRIMARY KEY (id)
);


CREATE TABLE "dbMedicalLoad".tbldoctorload (
	doctorid int4 NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	address varchar(50) NOT NULL,
	gender varchar(50) NOT NULL,
	contact numeric(15) NOT NULL,
	nmc varchar(50) NOT NULL,
	CONSTRAINT tbldoctor_pkey PRIMARY KEY (doctorid)
);



CREATE TABLE "dbMedicalLoad".tblnotcriticalbygenre (
	id int4 NOT NULL,
	count numeric(15) NOT NULL,
	genre varchar(50) NOT NULL,
	CONSTRAINT genre UNIQUE (genre) DEFERRABLE,
	CONSTRAINT tblnotcriticalgenre_pkey PRIMARY KEY (id)
);

select * from "dbMedicalLoad".tblnotcriticalbygenre;
select * from "dbMedicalLoad".tblcriticalbygenre;

CREATE TABLE "dbMedicalLoad".tblpatdocload (
	id int4 NOT NULL,
	patientid int4 NOT NULL,
	doctorid int4 NOT NULL,
	isactivecheck bpchar(1) NOT NULL,
	CONSTRAINT tblpatdocload_pkey PRIMARY KEY (id)
);



CREATE TABLE "dbMedicalLoad".tblpatientload (
	patientid int4 NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	address varchar(50) NOT NULL,
	gender varchar(50) NOT NULL,
	contact varchar(50) NOT NULL,
	dob date NOT NULL,
	age int4 NOT NULL,
	agecategory varchar(15) NOT NULL,
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);



CREATE TABLE "dbMedicalLoad".tblloaddocappoint (
	id int4 NOT NULL,
	doctorid int4 NOT NULL,
	patientid int4 NOT NULL,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	appointtime time NOT NULL,
	appointdate date NOT NULL,
	appointstatus varchar(50) NOT NULL,
	days varchar(50) NOT NULL,
	CONSTRAINT tbldocappoint_pkey PRIMARY KEY (id)
);

select * from "dbMedicalFinal"."dbMedicalLoad".tblappointmentload ;
select * from "lookupSchema".tblappointmentstage;


CREATE EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblappointmentload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblappointmentstage')
AS t(
	appid int4 ,
	patientid int4,
	doctorid int4 ,
	daysremaining numeric(5),
	iscritical numeric(2) ,
	appointdate date,
	appointtime time ,
	appointtype varchar ,
	appointgenre varchar(20) ,
	ismissed numeric(2) ,
	appointreason varchar,
	appointstatus varchar(20) 
);


CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procLoadAppointment() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblappointmentload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblappointmentstage')
AS t(
	appid int4 ,
	patientid int4,
	doctorid int4 ,
	daysremaining numeric(5),
	iscritical numeric(2) ,
	appointdate date,
	appointtime time ,
	appointtype varchar ,
	appointgenre varchar(20) ,
	ismissed numeric(2) ,
	appointreason varchar,
	appointstatus varchar(20) 
);	
end;
$$;

call "dbMedicalLoad".procLoadAppointment();
select * from "dbMedicalLoad".tblappointmentload ;
truncate table "dbMedicalLoad".tblappointmentload ;

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procLoadBilling() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblbillingload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblbillingstage')
AS t(
	billid int8,
	patientid int8 ,
	doctorid int8 ,
	dateofadmission date ,
	dateofdischarge date,
	stayduration numeric(50),
	dateofbill date,
	dateofpayment date,
	amountdollar numeric
);	
end;
$$;
call "dbMedicalLoad".procLoadBilling();

select * from "dbMedicalLoad".tblbillingload;

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procLoadDoctor() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tbldoctorload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tbldoctorstage')
AS t(
	doctorid int4 ,
	firstname varchar(50),
	lastname varchar(50),
	address varchar(50),
	gender varchar(50),
	contact numeric(15),
	nmc varchar(50)
);	
end;
$$;
call "dbMedicalLoad".procLoadDoctor();

select * from  "dbMedicalLoad".tbldoctorload;

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procPatDes() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblpatdesload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblpatdesstage')
AS t(
	pdescid int4,
	summary varchar(50),
	heightinft numeric(15,2),
	weightinkg numeric(15,2),
	bloodpressure int4 ,
	patientid int4
);	
end;
$$;
call "dbMedicalLoad".procPatDes();
select * from "dbMedicalLoad".tblpatdesload;

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procPatDoc() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblpatdocload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblpatdocstage')
AS t(
	id int4,
	patientid int4,
	doctorid int4,
	isactivecheck bpchar(1) 
);	
end;
$$;
call "dbMedicalLoad".procPatDoc();
select * from "dbMedicalLoad".tblpatdocload ;

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procPatient() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblpatientload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblpatientstage')
AS t(
	patientid int4 ,
	firstname varchar(50),
	lastname varchar(50),
	address varchar(50),
	gender varchar(50) ,
	contact varchar(50),
	dob date,
	age int4,
	agecategory varchar(15)
);	
end;
$$;
call "dbMedicalLoad".procPatient();
select * from "dbMedicalLoad".tblpatientload ;
drop table "dbMedicalLoad".tblpatientload;



CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procloaddocappoint() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblloaddocappoint 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblstagedocappoint')
AS t(
	id int4,
	doctorid int4,
	patientid int4,
	firstname varchar(50),
	lastname varchar(50),
	appointtime time,
	appointdate date,
	appointstatus varchar(50),
	days varchar(50) 
);	
end;
$$;
call "dbMedicalLoad".procloaddocappoint();
select * from "dbMedicalLoad".tblloaddocappoint ;

select * from "dbMedicalLoad".tblcriticalbygenre;
select * from 
"dbMedicalLoad".tbldoctorload;


CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procLoadCritical() 
LANGUAGE plpgsql
as
$$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblcriticalbygenre 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblcriticalbygenre')
AS t(
	id int4,
	count numeric(15),
	genre varchar(50)
);	
end;
$$;
call "dbMedicalLoad".procLoadCritical();
select * from "dbMedicalLoad".tblcriticalbygenre;

create or replace procedure "dbMedicalLoad".procLoadNotCritical()
language plpgsql
as 
$$
begin 
	insert into "dbMedicalFinal"."dbMedicalLoad".tblnotcriticalbygenre
	SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblcriticalbygenre')
AS t(
	id int4 ,
	count numeric(15) ,
	genre varchar(50) 
	);
end;
$$;
call "dbMedicalLoad".procLoadNotCritical();
select * from "dbMedicalLoad".tblnotcriticalbygenre;


select * from "dbMedicalLoad".tblpatientload;
select * from "dbMedicalLoad".tbldoctorload;

SELECT 
    firstname,
    lastname,
    address
    RANK() OVER(PARTITION BY gender ORDER BY contact) AS rank_gender
FROM "dbMedicalLoad".tbldoctorload;

CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');
CREATE TABLE person (
    name text,
    current_mood mood
);

INSERT INTO person VALUES ('Moe', 'happy');
SELECT * FROM person WHERE current_mood = 'happy';
 name | current_mood
------+--------------
 Moe  | happy




















