-------------------medicalHealthCare--------------------
CREATE TABLE "dbMedical"."medicalHealthCare".tblbilling (
	billId int4  not NULL,
	dateOfBill date not NULL,
	dateOfPayment date not null,
	constraint pk_bill primary key (billId)
);
---------------------LookupSchema------------------------------------
CREATE TABLE "lookupSchema".tblbillingstage (
	billid int8 NOT NULL,
	"row_number" numeric(15) NOT NULL,
	patientid int8 NOT NULL,
	doctorid int8 NOT NULL,
	dateofadmission date NOT NULL,
	dateofdischarge date NULL,
	stayduration numeric(50) NULL,
	dateofbill date NOT NULL,
	dateofpayment date NOT NULL,
	ntiledateofpayment numeric(15) NOT NULL,
	quarterdateofpayment varchar(30) NOT NULL,
	ntiletotalamount numeric(15) NOT NULL,
	quartertotalamount varchar(30) NOT NULL,
	amountdollar numeric NOT NULL,
	calculatevattax numeric(50) NOT NULL,
	CONSTRAINT tblbillingstage_pkey PRIMARY KEY (billid)
);
----------------------FinalLoadToBilling------------------------------------
CREATE TABLE "dbMedicalLoad".tblbillingload (
	billid int8 NOT NULL,
	"row_number" numeric(15) NOT NULL,
	patientid int8 NOT NULL,
	doctorid int8 NOT NULL,
	dateofadmission date NOT NULL,
	dateofdischarge date NULL,
	stayduration numeric(50) NULL,
	dateofbill date NOT NULL,
	dateofpayment date NOT NULL,
	ntiledateofpayment numeric(15) NOT NULL,
	quarterdateofpayment varchar(30) NOT NULL,
	ntiletotalamount numeric(15) NOT NULL,
	quartertotalamount varchar(30) NOT NULL,
	amountdollar numeric NOT NULL,
	calculatevattax numeric(50) NOT NULL,
	CONSTRAINT tblbillingload_pkey PRIMARY KEY (billid)
);