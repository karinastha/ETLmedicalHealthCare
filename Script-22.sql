select * from "lookupSchema".tblpatient;
-- "lookupSchema".tblpatient definition

-- Drop table

-- DROP TABLE "lookupSchema".tblpatient;

CREATE TABLE "medicalHealthCare".tblpatient (
	patientid int4 NOT NULL,
	patientfirstname varchar(50) NOT NULL,
	patientlastname varchar(50) NOT NULL,
	patientaddress varchar(50) NOT NULL,
	gender varchar(50) NOT NULL,
	contact numeric(15) NOT NULL,
	dateofbirth date NOT NULL,
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);

select * from "lookupSchema".tblheightstage;
select * from "lookupSchema".tblpatdesstage;

select * from "lookupSchema".tblpatient;

select * from "medicalHealthCare".tblpatient;
ALTER table "lookupSchema".tblpatient  
DROP COLUMN paatientid;



CREATE TABLE "lookupSchema".tblpatientStage (
	patientid int4 NOT NULL,
	patientfirstname varchar(50) NOT NULL,
	patientlastname varchar(50) NOT NULL,
	patientaddress varchar(50) NOT NULL,
	gender varchar(50) NOT NULL,
	contact numeric(15) NOT NULL,
	dateofbirth date NOT NULL,
	paatientid int4 NULL,
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);
















