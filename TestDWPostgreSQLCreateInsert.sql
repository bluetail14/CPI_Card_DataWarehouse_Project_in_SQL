
-- Drop Existing Tables--
DROP TABLE IF EXISTS T_Error_Log;
DROP TABLE IF EXISTS T_Job_Change_Data;
DROP TABLE IF EXISTS T_Job_F;
DROP TABLE IF EXISTS T_Lead_F;
DROP TABLE IF EXISTS T_Location_D;
DROP TABLE IF EXISTS T_Time_D;
DROP TABLE IF EXISTS T_Sales_Class_D;
DROP TABLE IF EXISTS T_Sales_Agent_D;
DROP TABLE IF EXISTS T_Customer_D;

--Drop Existing Sequences--
DROP SEQUENCE IF EXISTS T_Cust_Seq;
DROP SEQUENCE IF EXISTS T_SalesAgent_Seq;
DROP SEQUENCE IF EXISTS T_SalesClass_Seq;
DROP SEQUENCE IF EXISTS T_Location_Seq;
DROP SEQUENCE IF EXISTS T_Lead_Seq;
DROP SEQUENCE IF EXISTS T_Job_Seq;
DROP SEQUENCE IF EXISTS T_Error_Log_Seq;

-- CREATE SEQUENCE values starting with 1
CREATE SEQUENCE T_Cust_Seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE T_SalesAgent_Seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE T_SalesClass_Seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE T_Location_Seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE T_Lead_Seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE T_Job_Seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE T_Error_Log_Seq;

-- Create Tables--
/*********************************
        T_CUSTOMER_D
**********************************/
CREATE TABLE T_Customer_D
(	Cust_Key		INTEGER,
	Cust_Name		VARCHAR(50) NOT NULL,
	City			VARCHAR(25)	NOT NULL,
	Country			VARCHAR(25)	NOT NULL,
	Credit_Limit	DECIMAL(10,2) NOT NULL,
	E_Mail_Address	VARCHAR(50)	NOT NULL,
	Cust_State		VARCHAR(2)	NOT NULL,
	ZIP				VARCHAR(10)	NOT NULL,
	Terms_Code		VARCHAR(10)	NOT NULL,
	CONSTRAINT T_Customer_D_Pk PRIMARY KEY (Cust_Key)	
);

/*********************************
        T_SALES_AGENT
**********************************/ 
CREATE TABLE T_Sales_Agent_D
(	Sales_Agent_Id		INTEGER,
	Sales_Agent_Name	VARCHAR(60)	NOT NULL,
	Sales_Agent_State	VARCHAR(2)	NOT NULL,
	Country				VARCHAR(25)	NOT NULL ,
	CONSTRAINT T_Sales_Agent_D_Pk PRIMARY KEY (Sales_Agent_Id)
);

/*********************************
        T_SALES_CLASS_D
**********************************/
CREATE TABLE T_Sales_Class_D
(	Sales_Class_Id		INTEGER,
	Sales_Class_Desc	VARCHAR(250) NOT NULL,
	Base_Price			DECIMAL(8,4) NOT NULL,
	CONSTRAINT T_Sales_Class_D_Pk PRIMARY KEY (Sales_Class_Id)	
);

/*********************************
        T_TIME_D
**********************************/ 
CREATE TABLE T_Time_D
(	Time_Id			INTEGER	NOT NULL,
	Time_Year		INTEGER	NOT NULL,
	Time_Quarter	INTEGER	NOT NULL,
	Time_Month		INTEGER	NOT NULL,
	Time_Day		INTEGER	NOT NULL,
	CONSTRAINT T_Time_D_Pk PRIMARY KEY (Time_Id),
	CONSTRAINT T_Time_D_Uniquegoup1 UNIQUE (Time_Year, Time_Month, Time_Day) 
);

/*********************************
        T_LOCATION_D
**********************************/ 
CREATE TABLE T_Location_D
(	Location_Id		INTEGER,
	Location_Name	VARCHAR(50)	NOT NULL,
	CONSTRAINT T_Location_D_Pk PRIMARY KEY (Location_Id), 
	CONSTRAINT T_Location_Unique1 UNIQUE (Location_Name)
);

/*********************************
        T_LEAD_F
**********************************/ 
CREATE TABLE T_Lead_F
(	Lead_Id			INTEGER,
	Quote_Qty		INTEGER NOT NULL,
	Quote_Price		DECIMAL(11,2) NOT NULL,
	Lead_Success	VARCHAR(1)	NOT NULL,
	Job_Id			INTEGER,
	Created_Date	INTEGER NOT NULL,
	Cust_Id			INTEGER NOT NULL,
	Location_Id		INTEGER NOT NULL,
	Sales_Agent_Id	INTEGER NOT NULL,
	Sales_Class_Id	INTEGER NOT NULL,
	CONSTRAINT T_Lead_F_Pk PRIMARY KEY (Lead_Id),
	CONSTRAINT T_Lead_Created_Date_Fk FOREIGN KEY (Created_Date) REFERENCES T_Time_D (Time_Id),
	CONSTRAINT T_Lead_Cust_Id_Fk FOREIGN KEY (Cust_Id) REFERENCES T_Customer_D (Cust_Key),
	CONSTRAINT T_Lead_Location_Id_Fk FOREIGN KEY (Location_Id) REFERENCES T_Location_D (Location_Id),
	CONSTRAINT T_Lead_Sales_Agent_Id_Fk FOREIGN KEY (Sales_Agent_Id) REFERENCES T_Sales_Agent_D (Sales_Agent_Id),
	CONSTRAINT T_Lead_Sales_Class_Id_Fk FOREIGN KEY (Sales_Class_Id) REFERENCES T_Sales_Class_D (Sales_Class_Id)
);

/*********************************
        T_JOB_F
**********************************/ 
CREATE TABLE T_Job_F
(	Job_Id				INTEGER,
	Contract_Date		INTEGER	NOT NULL,
	Sales_Agent_Id		INTEGER	NOT NULL,
	Sales_Class_Id		INTEGER NOT NULL,
	Location_Id			INTEGER	NOT NULL,
	Cust_Id_Ordered_By	INTEGER	NOT NULL,
	Date_Promised		INTEGER,
	Date_Ship_By		INTEGER,
	Number_Of_Subjobs	INTEGER	NOT NULL,
	Unit_Price			DECIMAL(6,2) NOT NULL,
	Quantity_Ordered	INTEGER NOT NULL,
	Quote_Qty			INTEGER NOT NULL,
	CONSTRAINT T_Job_F_Pk PRIMARY KEY (Job_Id),
	CONSTRAINT T_Job_Contract_Date_Fk FOREIGN KEY (Contract_Date) REFERENCES T_Time_D (Time_Id),
	CONSTRAINT T_Job_Sales_Agent_Fk FOREIGN KEY (Sales_Agent_Id) REFERENCES T_Sales_Agent_D (Sales_Agent_Id),
	CONSTRAINT T_Job_Sales_Class_Fk FOREIGN KEY (Sales_Class_Id) REFERENCES T_Sales_Class_D (Sales_Class_Id),
	CONSTRAINT T_Job_Location_Id_Fk FOREIGN KEY (Location_Id) REFERENCES T_Location_D (Location_Id),
	CONSTRAINT T_Job_Cust_Id_Order_By_Fk FOREIGN KEY (Cust_Id_Ordered_By) REFERENCES T_Customer_D (Cust_Key),
	CONSTRAINT T_Job_Date_Promised_Fk FOREIGN KEY (Date_Promised) REFERENCES T_Time_D (Time_Id),
	CONSTRAINT T_Job_Date_Ship_By_Fk FOREIGN KEY (Date_Ship_By) REFERENCES T_Time_D	(Time_Id)
);

/*********************************
    T_JOB_CHANGE_DATA
**********************************/
CREATE TABLE T_Job_Change_Data
(	Change_Id			INTEGER NOT NULL ,
	Contract_Date		CHAR(10),
	Sales_Agent_Id		INTEGER,
	Sales_Class_Id		INTEGER,
	Location_Id			INTEGER,
	Cust_Id_Ordered_By	INTEGER,
	Date_Promised		CHAR(10),
	Date_Ship_By		CHAR(10),
	Number_Of_Subjobs	INTEGER,
	Unit_Price			DECIMAL(6,2),
	Quantity_Ordered	INTEGER,
	Quote_Qty			INTEGER,
	Lead_Id				INTEGER,
	CONSTRAINT T_Job_Change_Data_Pk PRIMARY KEY (Change_Id)		
);

/*********************************
    T_ERROR_LOG
**********************************/
CREATE TABLE T_Error_Log 
(	Log_Id		INTEGER NOT NULL,
	Change_Id	INTEGER,
	Job_Id		INTEGER,
	Note		VARCHAR(200),
	CONSTRAINT T_Error_Log_Pk PRIMARY KEY (Log_Id),
	CONSTRAINT T_Error_Log_Change_Id_Fk FOREIGN KEY(Change_Id) REFERENCES T_Job_Change_Data (Change_Id)
);

-- Insert into Time Dimension table--
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130101,2013,1,1,1);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130102,2013,1,1,2);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130103,2013,1,1,3);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130104,2013,1,1,4);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130107,2013,1,1,7);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130108,2013,1,1,8);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130109,2013,1,1,9);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130110,2013,1,1,10);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130111,2013,1,1,11);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130114,2013,1,1,14);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130115,2013,1,1,15);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130116,2013,1,1,16);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130117,2013,1,1,17);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130118,2013,1,1,18);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130121,2013,1,1,21);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130122,2013,1,1,22);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130123,2013,1,1,23);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130124,2013,1,1,24);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130125,2013,1,1,25);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130128,2013,1,1,28);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130129,2013,1,1,29);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130130,2013,1,1,30);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130131,2013,1,1,31);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130201,2013,1,2,1);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130204,2013,1,2,4);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130205,2013,1,2,5);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130206,2013,1,2,6);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130207,2013,1,2,7);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130208,2013,1,2,8);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130211,2013,1,2,11);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130212,2013,1,2,12);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130213,2013,1,2,13);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130214,2013,1,2,14);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130215,2013,1,2,15);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130218,2013,1,2,18);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130219,2013,1,2,19);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130220,2013,1,2,20);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130221,2013,1,2,21);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130222,2013,1,2,22);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130225,2013,1,2,25);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130226,2013,1,2,26);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130227,2013,1,2,27);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130228,2013,1,2,28);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130301,2013,1,3,1);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130304,2013,1,3,4);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130305,2013,1,3,5);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130306,2013,1,3,6);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130307,2013,1,3,7);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130308,2013,1,3,8);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130311,2013,1,3,11);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130312,2013,1,3,12);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130313,2013,1,3,13);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130314,2013,1,3,14);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130315,2013,1,3,15);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130318,2013,1,3,18);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130319,2013,1,3,19);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130320,2013,1,3,20);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130321,2013,1,3,21);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130322,2013,1,3,22);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130325,2013,1,3,25);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130326,2013,1,3,26);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130327,2013,1,3,27);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130328,2013,1,3,28);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130329,2013,1,3,29);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130401,2013,1,4,1);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130402,2013,1,4,2);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130403,2013,1,4,3);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130404,2013,1,4,4);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130405,2013,1,4,5);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130408,2013,1,4,8);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130409,2013,1,4,9);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130410,2013,1,4,10);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130411,2013,1,4,11);
INSERT INTO T_Time_D (Time_Id, Time_Year, Time_Quarter, Time_Month, Time_Day) VALUES(20130412,2013,1,4,12);

-- Insert into Location Dimension table--

INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'New York');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Atlanta');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Chicago');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Dallas');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Denver');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Los Angeles');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Seattle');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Toronto');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Montreal');
INSERT INTO T_Location_D (Location_Id, Location_Name) VALUES(nextval('t_location_seq'),'Vancouver');

-- Insert into Sales Class Dimension table--

INSERT INTO T_Sales_Class_D (Sales_Class_Id, Sales_Class_Desc, Base_Price) VALUES(nextval('t_salesclass_seq'), 'Credit Card - Smart Card',1.6);
INSERT INTO T_Sales_Class_D (Sales_Class_Id, Sales_Class_Desc, Base_Price) VALUES(nextval('t_salesclass_seq'), 'Credit Card - No Smart Card',0.8);
INSERT INTO T_Sales_Class_D (Sales_Class_Id, Sales_Class_Desc, Base_Price) VALUES(nextval('t_salesclass_seq'), 'Debit Card - Smart Card',1.5);
INSERT INTO T_Sales_Class_D (Sales_Class_Id, Sales_Class_Desc, Base_Price) VALUES(nextval('t_salesclass_seq'), 'Debit Card - No Smart Card',0.75);
INSERT INTO T_Sales_Class_D (Sales_Class_Id, Sales_Class_Desc, Base_Price) VALUES(nextval('t_salesclass_seq'), 'Prepaid Card - No Smart Card',0.85);
INSERT INTO T_Sales_Class_D (Sales_Class_Id, Sales_Class_Desc, Base_Price) VALUES(nextval('t_salesclass_seq'), 'Loyalty Card - No Smart Card',0.7);

-- Insert into Sales Agent Dimension table--

INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Dave Allen','CO','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Kelly Booth','CA','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'James Cook','FL','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Samantha Davis','TX','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Phil Edwards','CO','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Justin Franks','OH','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Maria Garcia','CA','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Hank Hill','TX','USA');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Isabel Inman','ON','Canada');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Jamie Johnson','QC','Canada');
INSERT INTO T_Sales_Agent_D (Sales_Agent_Id, Sales_Agent_Name, Sales_Agent_State, Country) VALUES(nextval('t_salesagent_seq'), 'Rebecca Kramer','BC','Canada');

-- Insert into Customer Dimension Table--

INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Visa','San Mateo','USA',10000000,'zoe.blevins@visa.com','CA','COD','94404');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'MasterCard','New York','USA',8000000,'deshawn.morrison@mastercard.com','NY','Net60','10577');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Amex','New York','USA',2000000,'yasmin.stanley@amex.com','NY','Net30','10045');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Discover','Deerfield','USA',4600000,'cooper.franklin@discover.com','IL','Net30','60015');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Kroger','Cincinnati','USA',400000,'taylor.escobar@kroger.com','OH','Net60','45201');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Safeway','Pleasanton','USA',360000,'elvis.houston@safeway.com','CA','Net60','94566');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Costco','Issaquah','USA',2000000,'tiara.reeves@costco.com','WA','Net20','98027');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Sams Club','Bentonville','USA',4600000,'celia.davies@samsclub.com','AR','COD','72712');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Wells Fargo','San Francisco','USA',400000,'jenna.chen@wellsfargo.com','CA','COD','94110');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Bank of America','Charlotte','USA',360000,'michael.miller@.bankofamerica.com','NC','Net30','28204');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'JP Morgan Chase','New York','USA',2000000,'branson.mcbride@jpmorganchase.com','NY','COD','10017');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Citigroup','New York','USA',4600000,'brennan.harrell@citigroup.com','NY','Net60','10022');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'BNY Mellon','New York','USA',400000,'frida.wallace@bnymellon.com','NY','Net30','10281');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'HSBC Bank','New York','USA',360000,'skyler.peck@hsbcbank.com','NY','Net60','10020');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Capital One','Vienna','USA',2000000,'kobe.long@capitalone.com','VA','Net60','22182');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'PNC','Pittsburgh','USA',4600000,'rubi.pham@pnc.com','PA','Net30','15202');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Home Depot','Atlanta','USA',400000,'isabell.bullock@homedepot.com','GA','Net30','30339');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Best Buy','Minneapolis','USA',360000,'makaila.maxwell@bestbuy.com','MN','COD','55423');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Amazon','Seattle','USA',2000000,'belinda.hunt@amazon.com','WA','Net60','98101');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'eBay','San Jose','USA',4600000,'nancy.liu@ebay.com','CA','COD','95125');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Sports Authority','Englewood','USA',400000,'trinity.olsen@sportsauthority.com','CO','Net30','80110');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'CVS','Woonsocket','USA',360000,'heath.krause@.cvs.com','RI','Net60','02895');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Nordstrom','Seattle','USA',2000000,'charity.wong@nordstrom.com','WA','Net20','98101');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Neiman Marcus','Dallas','USA',4600000,'jerome.floyd@neimanmarcus.com','TX','Net30','75270');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'National Car Rental','Saint Louis','USA',400000,'ayaan.bright@nationalcarrental.com','MO','Net30','63105');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'RBC Royal Bank','Halifax','Canada',360000,'charles.carson@rbcroyalbank.ca','NS','Net30','B3H 2X7');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'TD Canada Trust','Toronto','Canada',2000000,'tanner.schneider@tdcanadatrust.ca','ON','Net20','M4C 4X4');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'Scotiabank','Halifax','Canada',4600000,'erin.jefferson@scotiabank.ca','NS','Net30','B3H 1A2');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'BMO Bank of Montreal','Montreal','Canada',400000,'maia.leach@bmobankofmontreal.ca','QC','Net60','H1C 1R8');
INSERT INTO T_Customer_D (Cust_Key, Cust_Name, City, Country, Credit_Limit, E_Mail_Address, Cust_State, Terms_Code, ZIP) VALUES(nextval('t_cust_seq'),'CIBC','Toronto','Canada',360000,'lina.frederick@cibc.ca','ON','Net30','M4E 1B4');

-- Insert into Lead Fact table--

INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),5000000,1.6,'Y',1,20130102,1,6,4,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),600000,1.5,'N',NULL,20130104,26,9,9,3);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),1800000,0.75,'N',NULL,20130107,10,2,6,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),60000,0.8,'Y',2,20130107,4,4,1,2);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),4000,0.7,'Y',3,20130108,5,4,1,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),300000,0.7,'N',NULL,20130109,18,3,8,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2700000,1.5,'Y',4,20130110,9,6,4,3);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),70000,0.7,'N',NULL,20130110,21,5,1,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),100000,1.6,'Y',5,20130110,3,1,1,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),000000,0.85,'Y',6,20130114,1,6,4,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),12000,0.75,'N',NULL,20130116,15,2,6,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2000,0.7,'Y',7,20130110,7,7,1,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),1200000,0.75,'Y',8,20130121,27,8,2,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),3600000,0.85,'Y',9,20130121,2,1,4,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2300000,0.85,'N',NULL,20130124,4,4,1,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),800000,1.5,'Y',10,20130129,29,9,2,3);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2070000,1.6,'N',NULL,20130201,9,3,2,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),69000,0.85,'N',NULL,20130204,15,3,9,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),5000,1.5,'N',NULL,20130206,17,8,6,3);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),345000,0.7,'N',NULL,20130206,30,1,9,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),3105000,0.7,'N',NULL,20130208,16,9,7,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),81000,0.85,'N',NULL,20130211,26,4,8,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),115000,0.8,'N',NULL,20130214,18,2,11,2);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2300000,1.5,'N',NULL,20130214,25,7,11,3);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),14000,1.6,'N',NULL,20130219,28,3,6,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),3000,0.85,'N',NULL,20130220,11,7,9,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),1620000,0.75,'N',NULL,20130225,7,7,10,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),3060000,0.75,'N',NULL,20130225,24,2,11,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),1955000,1.6,'N',NULL,20130227,4,1,7,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),680000,0.8,'N',NULL,20130228,3,5,8,2);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2381000,1.6,'N',NULL,20130301,29,6,5,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),79000,0.75,'N',NULL,20130301,9,8,7,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),6000,1.6,'N',NULL,20130304,6,10,9,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),397000,0.8,'N',NULL,20130304,3,8,7,2);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),3571000,0.75,'N',NULL,20130304,10,4,11,4);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),93000,0.85,'N',NULL,20130305,17,3,2,5);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),132000,1.6,'N',NULL,20130306,4,4,4,1);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),2645000,1.5,'N',NULL,20130306,12,6,10,3);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),16000,0.7,'N',NULL,20130307,1,5,5,6);
INSERT INTO T_Lead_F (Lead_Id, Quote_Qty, Quote_Price, Lead_Success, Job_Id, Created_Date, Cust_Id, Location_Id, Sales_Agent_Id, Sales_Class_Id) VALUES(nextval('t_lead_seq'),3000,1.5,'N',NULL,20130308,22,1,1,3);

-- Insert into Job Fact table--

INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),5,1.6,5000000,5000000,20130110,4,1,6,1,20130201,20130129);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),1,0.8,64000,64000,20130116,1,2,4,4,20130208,20130204);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),1,0.7,4000,4000,20130116,1,6,4,5,20130211,20130206);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),3,1.5,2700000,2700000,20130117,4,3,6,9,20130214,20130208);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),1,1.6,100000,100000,20130122,1,1,1,3,20130214,20130211);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),2,0.85,2000000,2000000,20130123,4,5,6,1,20130219,20130214);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),1,0.7,2000,2000,20130129,1,6,7,7,20130225,20130219);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),2,0.75,1200000,1200000,20130201,2,4,8,27,20130225,20130220);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),4,0.85,3600000,3600000,20130206,4,5,1,2,20130227,20130221);
INSERT INTO T_Job_F (Job_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By) VALUES(nextval('t_job_seq'),1,1.5,800000,800000,20130207,2,3,9,29,20130228,20130221);

-- Insert into Job Change Data table—-

INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(101,1,0.85,81000,81000,'2013-02-07',8,5,4,26,'2013-03-07','2013-03-01',22);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(102,3,1.6,2070000,2070000,'2013-02-11',2,1,3,9,'2013-03-04','2013-02-27',17);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(103,1,0.85,69000,69000,'2012-02-12',9,5,3,15,'2012-03-06','2012-03-03',18);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(104,1,1.5,5000,5000,'2013-02-14',6,3,88,17,'2013-03-11','2013-03-07',19);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(105,5,1.5,4234000,4234000,'2013-02-21',1,3,1,18,'2013-03-18','2013-03-12',999);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(106,4,0.7,3105000,3105000,'2013-02-25',7,6,9,16,'2013-03-15','2013-03-11',21);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(107,3,1.5,2300000,2300000,'2013-03-01',11,NULL,7,25,'2013-03-22','2013-03-18',24);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(108,1,1.6,14000,14000,'2013-03-06',6,1,3,28,'2013-03-28','2013-03-22',25);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(109,2,0.75,1620000,1620000,'2013-03-08',10,4,7,7777777,'2013-03-29','2013-03-25',27);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(110,4,0.75,3060000,3060000,'2013-03-11',11,4,2,24,'2013-04-03','2013-03-28',28);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(111,2,1.6,1955000,1955000,'2013-03-12',7777777,1,1111111,4,'2013-04-04','2013-03-29',29);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(112,1,0.8,680000,680000,'2013-03-12',8,2,5,3,'2013-04-05','2013-04-01',30);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(113,3,1.6,2381000,2381000,'2013-03-12',NULL,1,6,29,'2013-04-08','2013-04-02',31);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(114,1,1.6,6000,6000,'2013-03-14',9,1,10,6,'2013-04-09','2013-03-28',33);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(115,4,0.75,3571000,3571000,'2013-03-15',11,4,4,10,'2013-04-10','2013-04-04',35);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(116,1,0.85,93000,93000,'2013-03-18',2,5,3,17,'2013-04-10','2013-04-09',36);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(117,1,1.6,132000,132000,'2013-03-20',4,1,4,4,'2013-04-12','2013-03-25',37);
INSERT INTO T_Job_Change_Data (Change_Id, Number_Of_Subjobs, Unit_Price, Quantity_Ordered, Quote_Qty, Contract_Date, Sales_Agent_Id, Sales_Class_Id, Location_Id, Cust_Id_Ordered_By, Date_Promised, Date_Ship_By, Lead_Id) VALUES(118,1,0.7,16000,16000,'2013-04-01',5,6,5,1,'2013-04-12','2013-04-08',39);

-- Select count from each table statements--

SELECT TTD.COUNT AS COUNT_T_TIME_D, /*74 Rows*/
	   TLD.COUNT AS COUNT_T_LOCATION_D, /*10 Rows*/
       TSCD.COUNT AS COUNT_T_SALES_CLASS_D, /*6 Rows*/
       TSAD.COUNT AS COUNT_T_SALES_AGENT_D, /*11 Rows*/
       TCD.COUNT AS COUNT_T_CUSTOMER_D, /*30 Rows*/
       TLF.COUNT AS COUNT_T_LEAD_F, /*40 Rows*/
       TJF.COUNT AS COUNT_T_JOB_F, /*10 Rows*/
       TJCD.COUNT AS COUNT_T_JOB_CHANGE_DATA /*18 Rows*/
FROM (SELECT COUNT(*) AS COUNT FROM T_TIME_D) TTD,
	 (SELECT COUNT(*) AS COUNT FROM T_LOCATION_D) TLD,
     (SELECT COUNT(*) AS COUNT FROM T_SALES_CLASS_D) TSCD,
     (SELECT COUNT(*) AS COUNT FROM T_SALES_AGENT_D) TSAD,
     (SELECT COUNT(*) AS COUNT FROM T_CUSTOMER_D) TCD,
     (SELECT COUNT(*) AS COUNT FROM T_LEAD_F) TLF,
     (SELECT COUNT(*) AS COUNT FROM T_JOB_F) TJF,
     (SELECT COUNT(*) AS COUNT FROM T_JOB_CHANGE_DATA) TJCD;
-- Should show 18 rows

-- commit insert statements
COMMIT;