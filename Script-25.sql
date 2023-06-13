select COUNT(*) from "lookupSchema".tblpatientstage;
select avg(AGE) from "lookupSchema".tblpatientstage;
select * from "lookupSchema".tblpatientstage;
select max(AGE) from "lookupSchema".tblpatientstage;

select * from "lookupSchema".tbldoctorstage;
select doctorId , sum() from "lookupSchema".tbldoctorstage;

select patientId , SUM(age) from  "lookupSchema".tblpatientstage group by patientId ; 
select count(*) , gender from "medicalHealthCare".tblpatient group by gender;

select * from "medicalHealthCare".tblpatdes;

select COUNT(*) , summary from  "medicalHealthCare".tblpatdes group by summary order by 1 desc;

select COUNT(*), age   from "lookupSchema".tblpatientstage group by  age having  AVG(age) < 50 ;

select COUNT(*), age   from "lookupSchema".tblpatientstage group by  age having  AVG(age) > 50 and   AVG(age) < 80 ;
select COUNT(*), age   from "lookupSchema".tblpatientstage group by  age having  AVG(age) > 50 BETWEEN  AVG(age) < 80 ;
select agecategory , count(*)  from "lookupSchema".tblpatientstage group by ageCategory having count(*) > 500; 

select * from "lookupSchema".tblappointmentstage;

--stage data for number of patients who are critical in each genre whose are older than average patient age
select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage group by appointgenre ;
select count(patientId) , isCritical from "lookupSchema".tblappointmentstage group by isCritical;


select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage where isCritical = 1  group by appointgenre  ;

select count(patientId) , appointgenre   from  "lookupSchema".tblappointmentstage where
patientid in (
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage )
) and 
isCritical = 0  group by appointgenre ;

	
	
select patientid from "lookupSchema".tblpatientstage where age > (
	select AVG(age) from "lookupSchema".tblpatientstage ) and
		patientid in (
			select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage where isCritical = 1  group by appointgenre );


select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage 

where isCritical = 1 and patientId in 
group by appointgenre ;

select patientId from "lookupSchema".tblpatientstage where AGE > (select AVG(AGE) from "lookupSchema".tblpatientstage);
select AVG(AGE) from "lookupSchema".tblpatientstage;

select * from "lookupSchema".tblappointmentstage;

select * from "lookupSchema".tblbillingstage; 
select * from "medicalHealthCare".tblbilling;
select * from "lookupSchema".tbldoctorstage;


--data deduplication
select COUNT(*) , doctorid , firstname , lastname, address , gender , contact , nmc from 
"lookupSchema".tbldoctorstage group by doctorid , firstname , lastname, address , gender , contact , nmc;

select * from "lookupSchema".tblpatdoc;
with cte as
(
select doctorid , firstname ,row_number() over (partition by gender)
from "lookupSchema".tbldoctorstage
);

select * from "lookupSchema".tblbillingstage except
select * from "medicalHealthCare".tblbilling
union
select * from "medicalHealthCare".tblbilling except
select * from "lookupSchema".tblbillingstage;

describe table "medicalHealthCare".tblbilling;

select * from 
"lookupSchema".tblappointmentstage;

select patientid  from "lookupSchema".tblpatientstage where patientid IN (
select patientid , age from "lookupSchema".tblpatientstage HAVING age > AVG(age) (
select count(patientId) , appointgenre from  "lookupSchema".tblappointmentstage where isCritical = 1  group by appointgenre ));


-- "lookupSchema".tbldoctorstage definition

-- Drop table

-- DROP TABLE "lookupSchema".tbldoctorstage;

CREATE TABLE "medicalHealthCare".tbldoctorRoutine (
	doctorRoutineid int4 NOT NULL,
	time date not null,
	doctorId int4 not null,
	CONSTRAINT tbldoctorRoutine_pkey PRIMARY KEY (doctorRoutineid),
	 CONSTRAINT fk_doctorRoutine
      FOREIGN KEY(doctorId) 
	  REFERENCES "medicalHealthCare".tbldoctor(doctorId)
);

alter table "medicalHealthCare".tbldoctorroutine alter column days type varchar(50);
alter table "medicalHealthCare".tbldoctorroutine alter column time type varchar(50);


ALTER TABLE "medicalHealthCare".tbldoctorroutine
ADD COLUMN days varchar(50);

CONSTRAINT constraint_name 
FOREIGN KEY (fk_columns) 
REFERENCES parent_table (parent_key_columns);

CONSTRAINT fk_customer
      FOREIGN KEY(customer_id) 
      REFERENCES customers(customer_id)

--stage data for number of appointments each doctor has to attend for this week. Need to group by day.

select * from "medicalHealthCare".tblappointment;
select * from "medicalHealthCare".tbldoctorroutine;
select * from "medicalHealthCare".tbldoctor;

select COUNT(appid) from "medicalHealthCare".tblappointment;
select doctorroutineId , days from "medicalHealthCare".tbldoctorroutine where DAYS = 'Wednesday' ; 

select doctorId , firstname from "medicalHealthCare".tbldoctor where doctorid  in (
select days from"medicalHealthCare".tbldoctorroutine
);

 group by ageCategory having count(*) > 500;


select "medicalHealthCare".tbldoctor.doctorid , patientid, appointdate, firstname, appointtime, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid)  where DAYS = 'Wednesday';

select doctorid, firstname from "medicalHealthCare".tbldoctor where "medicalHealthCare".tbldoctor.doctorid IN(
	select doctorid ,appointdate , appointtime , appointstatus, patientid from "medicalHealthCare".tblappointment where 
	"medicalHealthCare".tblappointment.doctorid IN(
		select doctorid , days from "medicalHealthCare".tbldoctorroutine where 
		"medicalHealthCare".tblappointment.doctorid in 
	)
)

select * from "medicalHealthCare".tblappointment;
select * from "medicalHealthCare".tbldoctor;
select * from "medicalHealthCare".tbldoctorroutine;

select tbldoctorroutine.doctorid,tbldoctorroutine.days,count(1) TOTAL
from "medicalHealthCare".tbldoctorroutine group by tbldoctorroutine.doctorid,tbldoctorroutine.days;

group by "medicalHealthCare".tbldoctorroutine.doctorid,"medicalHealthCare".tbldoctorroutine


--stage data for number of appointments each doctor has to attend for this week. Need to group by day.
select count(doctorid) as No_of_time,days from "medicalHealthCare".tbldoctorroutine group by days;


select doctorid,patientid,appointdate,firstname,appointtime,appointstatus,days from "medicalHealthCare".tbldoctor Doc
inner join 
"medicalHealthCare".tblappointment

select "medicalHealthCare".tbldoctor.doctorid , patientid,  firstname, lastname, appointtime, appointdate, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid)

select t1.days,count(t1.appointdate) as numberoftimes from (
select "medicalHealthCare".tbldoctor.doctorid , patientid, appointdate, firstname, appointtime, appointstatus, days
from 
"medicalHealthCare".tbldoctor inner join "medicalHealthCare".tblappointment
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tblappointment.doctorid )
inner join "medicalHealthCare".tbldoctorroutine
on ("medicalHealthCare".tbldoctor.doctorid ="medicalHealthCare".tbldoctorroutine.doctorid)
) as t1 group by days;














