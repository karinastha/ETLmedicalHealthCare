select * from "dbMedicalLoad".tblpatdesload;
CREATE TABLE "dbMedicalLoad".tblpatdesload (
	pdescid int4 NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	avgWeightInKg numeric(10) not null,
	avgHeightInFt numeric(10) not null,
	weightClass varchar(50) not null,
	heightClass varchar(50) not null,
	CONSTRAINT tblpatdesload_pkey PRIMARY KEY (pdescid)
);

drop table "dbMedicalLoad".tblpatdesload;

CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procpatdes()
 LANGUAGE plpgsql
AS $procedure$
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
	patientid int4,
	avgWeightInKg numeric(10),
	avgHeightInFt numeric(10) ,
	weightClass varchar(50) ,
	heightClass varchar(50)
);	
end;
$procedure$
;

call "dbMedicalLoad".procpatdes();


