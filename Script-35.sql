select * from "dbMedicalLoad".tblpatdesload;
drop table "dbMedicalLoad".tblpatdesload;

CREATE TABLE "dbMedicalLoad".tblpatdesload (
	row_number numeric(15) not null,
	pdescid int4 NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	avgweightinkg numeric(10,2) NOT NULL,
	avgheightinft numeric(10,2) NOT NULL,
	weightclass varchar(50) NOT NULL,
	heightclass varchar(50) NOT NULL,
	dense_summary numeric(15) not null,
	ntilebphighlevel varchar(20) not null,
	ntilebplowlevel varchar(20) not null,
	CONSTRAINT tblpatdesload_pkey PRIMARY KEY (pdescid)
);

call procpatdes(); 
CREATE OR REPLACE PROCEDURE "dbMedicalLoad".procpatdes()
 LANGUAGE plpgsql
AS $procedure$
begin
--create EXTENSION dblink;
insert into "dbMedicalFinal"."dbMedicalLoad".tblpatdesload 
SELECT * FROM dblink('dbname=dbMedical user=postgres password=rootpassword host=localhost', 
'SELECT * FROM "lookupSchema".tblpatdesstage')
AS t(
	row_number numeric(15),
	pdescid int4,
	summary varchar(50),
	heightinft numeric(15,2),
	weightinkg numeric(15,2),
	bloodpressure int4 ,
	patientid int4,
	avgWeightInKg numeric(10),
	avgHeightInFt numeric(10) ,
	weightClass varchar(50) ,
	heightClass varchar(50),
	dense_summary numeric(15),
	ntilebphighlevel varchar(20),
	ntilebplowlevel varchar(20)
);	--temporary data mapping 
end;
$procedure$
;
select * from "dbMedicalLoad".tblpatdesload ;

select * from "dbMedicalLoad".tblbillingload;
