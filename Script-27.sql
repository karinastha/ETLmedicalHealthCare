CREATE TABLE "lookupSchema".tblfinalpatdocStage (
	id int4 not null,
	patientid int4 NOT NULL,
	doctorid int4 not null,
	firstname varchar(50) NOT NULL,
	lastname varchar(50) NOT NULL,
	
	CONSTRAINT tblpatient_pkey PRIMARY KEY (patientid)
);

select * from "lookupSchema".tblfinalpatdocStage;
select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblbillingstage;
select * from "lookupSchema".tblstagedocappoint;
select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tbldoctorstage;
select * from "lookupSchema".tblappointmentstage;


select "lookupSchema".tblpatientstage.patientid, doctorid , firstname, lastname, 
--"lookupSchema".tbldoctorstage.firstname ,
--"lookupSchema".tbldoctorstage.lastname,
appointtime, appointdate, appointstatus, days
from 
"lookupSchema".tblpatientstage inner join "lookupSchema".tblappointmentstage
on ("lookupSchema".tblpatientstage.patientid ="lookupSchema".tblappointmentstage.patientid )
inner join "lookupSchema".tbldoctorstage
on ("lookupSchema".tbldoctorstage.doctorid ="lookupSchema".tblappointmentstage.doctorid);

select * from "lookupSchema".tblnotcriticalbygenre;








