-- "medicalHealthCare".tblpatdes definition

-- Drop table

-- DROP TABLE "medicalHealthCare".tblpatdes;

CREATE TABLE "lookupSchema".tblpatdes (
	pdescid SERIAL primary key,
	summary varchar(50) NOT NULL,
	height numeric(3) NOT NULL,
	heightIn varchar(2) not null,
	weight numeric(3) NOT NULL,
	weightIn varchar(2) not null,
	bpSystolic numeric(5) NOT NULL,
	bpDystolic numeric(5) NOT NULL,
	patientid int4 NOT NULL
	
);
drop table "lookupSchema".tblpatdes; 

CREATE TABLE "lookupSchema".tblpatdesStage (
	pdescid SERIAL primary key,
	summary varchar(50) NOT NULL,
	heightInFt numeric(15,2) not null,
	weightInKg numeric(15,2) not null,
	bloodpressure int NOT NULL,
	patientid int4 NOT NULL
	
);

drop table "lookupSchema".tblpatdesStage;


alter table "dbMedical"."medicalHealthCare".tblpatdes alter column pdescid serial;


alter table "lookupSchema".tblpatdesStage alter column heightInFt type numeric(3,2);

insert into "lookupSchema".tblpatdes(pdescid,summary,height,heightIn,weight,weightIn,bpSystolic,bpDystolic,patientid)
values (1,'bone fracture','160','cm','150','pd','120','90',1),
		(2,'headche','250','cm','60','kg','140','70',2),
		(3,'Stomach pain','5.5','ft','50','kg','120','90',3),
		(4,'heartattack','4.5','ft','145','pd','140','70',4),
		(5,'hand fracture','70','in','155','pd','90','50',5),
		(6,'diabetes','80','in','90','kg','120','90',6),
		(7,'leg fluid retention','110','cm','20','kg','100','40',7),
		(8,'asthama','150','cm','60','kg','120','90',8),
		(9,'headache','130','cm','170','pd','100','70',9),
		(10,'bone fracture','75','in','150','pd','120','90',10);
commit;

insert into "lookupSchema".tblpatdes(pdescid,summary,height,heightIn,weight,weightIn,bpSystolic,bpDystolic,patientid)
values (11,'bone fracture','180','cm','180','pd','140','110',10);

select * from "lookupSchema".tblpatdesStage;

update "lookupSchema".tblpatdes 
set bpSystolic = 75, bpDystolic= 40 where pdescid=2;

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
from "lookupSchema".tblpatdes;





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




		






-- "medicalHealthCare".tblpatdes foreign keys

ALTER TABLE "medicalHealthCare".tblpatdes ADD CONSTRAINT fk_pat_des FOREIGN KEY (patientid) REFERENCES "medicalHealthCare".tblpatient(patientid);