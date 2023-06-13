Which doctor is treating which patient at what time?

select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tbldoctorstage;
select * from "lookupSchema".tblappointmentstage;

select "medicalHealthCare".tbldoctor.doctorid , patientid,  firstname, lastname, "medicalHealthCare".tblpatient.firstname , 
"medicalHealthCare".tblpatient.lastname ,appointtime, appointdate, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid);
end;

select * from "lookupSchema".tblpatdesstage;-- "lookupSchema".tblpatdesstage definition

-- Drop table

-- DROP TABLE "lookupSchema".tblpatdesstage;

CREATE TABLE "lookupSchema".tblpatdesstage (
	pdescid serial NOT NULL,
	summary varchar(50) NOT NULL,
	heightinft numeric(15,2) NOT NULL,
	weightinkg numeric(15,2) NOT NULL,
	bloodpressure int4 NOT NULL,
	patientid int4 NOT NULL,
	CONSTRAINT tblpatdesstage_pkey PRIMARY KEY (pdescid)
);

select * from "lookupSchema".tblappointmentstage;

SELECT a.studentid, a.name, b.total_marks
FROM student a, marks b
WHERE a.studentid = b.studentid AND b.total_marks >
(SELECT total_marks
FROM marks
WHERE studentid =  'V002');

create table test1(
	studentid int8 not null,
	stdname VARCHAR(50) not null,
	total_marks numeric (10) not null,
	constraint tbl_testpk primary key (studentid)
);

insert into test1 (studentid , stdname, total_marks) 
values (101, 'Ram Sharma', 45), (102, 'Sita Sharma', 75), (103, 'Hari Sharma', 80), (104, 'Daisy Sharma', 60),
(105, 'Saine Shrestha', 45),(106, 'Birju Shrestha', 60),(107, 'Tej Shakya', 55);

select * from test1;
select a.studentid , a.stdname, b.total_marks
from student a, marks b
where a.studentid =b.studentid and b.total_marks > 
(select total_marks from marks where studentid = '003')

select * from "lookupSchema".tblappointmentstage;
select * from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblcriticalbygenre;

CREATE OR REPLACE PROCEDURE "lookupSchema".DocAppointproc() 
LANGUAGE plpgsql
as
$$
begin
--insert into "lookupSchema".tblStageDocAppoint (doctorid, patientid,firstname,lastname,appointtime,appointdate,appointstatus,days) 
select "medicalHealthCare".tbldoctor.doctorid , patientid,  firstname, lastname, appointtime, appointdate, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid);
end;
$$;

alter "lookupSchema".tblcriticalbygenre add column patientid type int4;

CREATE OR REPLACE FUNCTION appointment_fn() RETURNS TRIGGER AS $pat_appoint$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO emp_audit SELECT 'D', now(), user, OLD.*;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO emp_audit SELECT 'U', now(), user, NEW.*;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO emp_audit SELECT 'I', now(), user, NEW.*;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$pat_appoint$ LANGUAGE plpgsql;


select appointtime , appointdate , appointtype  from "lookupSchema".tblappointmentstage left join
"lookupSchema".tblpatientstage on ("lookupSchema".tblappointmentstage. patientid = "lookupSchema".tblpatientstage.patientid)
left join "lookupSchema".tbldoctorStage on ("lookupSchema".tbldoctorstage.doctorid = "lookupSchema".tblappointmentstage.doctorid);

select * from "lookupSchema".tblpatdocStage;
select * from "lookupSchema".tblstagedocappoint;

select firstname , lastname , appointStatus from "lookupSchema".tblstagedocappoint 
where patientid in (select patientid , genrefrom tblcriticalbygenre group by genre)










