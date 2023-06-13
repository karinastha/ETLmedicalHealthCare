select * from tblpatient;
select * from tbldoctor;
select * from tbldocspec  ;
select * from tblpatdes;
select * from tblappointment;
select * from tblpatdoc;


delete from tblpatdes where pdescid between 1 and 1000;

copy "dbMedical"."medicalHealthCare".tblbilling (billid, dateOfbill, dateOfPayment)
from 'D:\appointment.csv'
with (FORMAT csv, header False);

alter table tblbilling alter column billid type numeric(10,0);

insert into "dbMedical"."medicalHealthCare".tblbilling (billid, dateOfbill, dateOfPayment) 
values (1001, '05-17-2022', '10-19-2023');
select * from tblbilling;

alter table tblbilling 
add column dateofpayment date;

drop table tblbilling ;

create table "dbMedical"."medicalHealthCare".tblbilling (
	billid numeric,
	dateOfBill date,
	dateOfPayment date
);

delete from tblbilling where billid between 1 and 1000;
