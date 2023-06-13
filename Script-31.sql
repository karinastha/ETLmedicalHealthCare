select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblpatdesstage;

select 
	summary,
	weightinkg,
	ROUND (avg(weightinkg) over (), 2) as AVG_weightInKG,
	ROUND (avg(heightinft) over (), 2) as AVG_heightinFT,
case
WHEN (weightinkg - AVG(weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (weightinkg - AVG(weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass
--weightinkg - AVG(weightinkg) OVER () as  avg_weight
from "lookupSchema".tblpatdesstage;

CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc()
 LANGUAGE plpgsql
AS $procedure$
	declare result varchar;
begin
	insert into "lookupSchema".tblpatdesStage
select x.pdescid , x.summary , x.weightinkg, x.heightInFt, x.bloodpressure, x.patientId , 
ROUND (avg(x.weightinkg) over (), 2) as AVG_weightInKG,
ROUND (avg(x.heightinft) over (), 2) as AVG_heightinFT, 
case
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass from (
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
call "lookupSchema".patdesproc();

CREATE TABLE "lookupSchema".tblpatdesstage (
	pdescid serial NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	avgWeightInKg numeric(10) not null,
	avgHeightInFt numeric(10) not null,
	weightClass varchar(50) not null,
	heightClass varchar(50) not null,
	CONSTRAINT tblpatdesstage_pkey PRIMARY KEY (pdescid)
);
 
drop table  "lookupSchema".tblpatdesstage;

select x.pdescid , x.summary , x.weightinkg, x.heightInFt, x.bloodpressure, x.patientId , 
ROUND (avg(x.weightinkg) over (), 2) as AVG_weightInKG,
ROUND (avg(x.heightinft) over (), 2) as AVG_heightinFT, 
case
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass from (
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



select 
	summary,
	weightinkg,
	ROUND (avg(weightinkg) over (), 2) as AVG_weightInKG,
	ROUND (avg(heightinft) over (), 2) as AVG_heightinFT,
case
WHEN (weightinkg - AVG(weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (weightinkg - AVG(weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass
--weightinkg - AVG(weightinkg) OVER () as  avg_weight
from "lookupSchema".tblpatdesstage;

CREATE OR REPLACE PROCEDURE "lookupSchema".patdesproc()
 LANGUAGE plpgsql
AS $procedure$
	declare result varchar;
begin
	insert into "lookupSchema".tblpatdesStage
select x.pdescid , x.summary , x.weightinkg, x.heightInFt, x.bloodpressure, x.patientId , 
ROUND (avg(x.weightinkg) over (), 2) as AVG_weightInKG,
ROUND (avg(x.heightinft) over (), 2) as AVG_heightinFT, 
case
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass from (
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
call "lookupSchema".patdesproc();

CREATE TABLE "lookupSchema".tblpatdesstage (
	pdescid serial NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	avgWeightInKg numeric(10) not null,
	avgHeightInFt numeric(10) not null,
	weightClass varchar(50) not null,
	heightClass varchar(50) not null,
	CONSTRAINT tblpatdesstage_pkey PRIMARY KEY (pdescid)
);
 
drop table  "lookupSchema".tblpatdesstage;

select x.pdescid , x.summary , x.weightinkg, x.heightInFt, x.bloodpressure, x.patientId , 
ROUND (avg(x.weightinkg) over (), 2) as AVG_weightInKG,
ROUND (avg(x.heightinft) over (), 2) as AVG_heightinFT, 
case
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) > 0 THEN 'Overweight'
WHEN (x.weightinkg - AVG(x.weightinkg) OVER () ) < 0 THEN 'Underweight'
ELSE 'normal'
END as weightClass,
case
WHEN (heightinft - AVG(heightinft) OVER () ) > 0 THEN 'Over'
WHEN (heightinft - AVG(heightinft) OVER () ) < 0 THEN 'Under'
ELSE 'normal'
END as heightClass from (
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


select * from "lookupSchema".tblappointmentstage;




