CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc()
 LANGUAGE plpgsql
AS $procedure$
	declare result varchar;
begin
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
	
end;
$procedure$
;

call "lookupSchema".patdesproc();

truncate table "lookupSchema".tblpatdesstage;
select * from  "lookupSchema".tblpatdesstage;


-- "lookupSchema".tblpatdes definition

-- Drop table

-- DROP TABLE "lookupSchema".tblpatdes;

CREATE TABLE "medicalHealthCare".tblpatdes (
	pdescid serial NOT NULL,
	summary varchar(50) NOT NULL,
	height numeric(3) NOT NULL,
	heightin varchar(2) NOT NULL,
	weight numeric(3) NOT NULL,
	weightin varchar(2) NOT NULL,
	bpsystolic numeric(5) NOT NULL,
	bpdystolic numeric(5) NOT NULL,
	patientid int4 NOT NULL,
	CONSTRAINT tblpatdes_pkey PRIMARY KEY (pdescid)
);
insert into "medicalHealthCare".tblpatdes 
select * from "lookupSchema".tblpatdes;
commit;

select * from "medicalHealthCare".tblpatdes ;


CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc()
 LANGUAGE plpgsql
AS $procedure$
	declare result varchar;
begin
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
from "medicalHealthCare".tblpatdes) x;
	
end;
$procedure$
;




