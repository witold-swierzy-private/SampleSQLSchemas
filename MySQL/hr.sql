DROP TABLE IF EXISTS JOB_GRADES;
DROP TABLE IF EXISTS JOB_HISTORY;
DROP TABLE IF EXISTS EMPLOYEES;
DROP TABLE IF EXISTS JOBS;
DROP TABLE IF EXISTS DEPARTMENTS;
DROP TABLE IF EXISTS LOCATIONS;
DROP TABLE IF EXISTS COUNTRIES;
DROP TABLE IF EXISTS REGIONS;


CREATE TABLE REGIONS
( REGION_ID  NUMERIC PRIMARY KEY,
    REGION_NAME  VARCHAR(25)
);

CREATE TABLE COUNTRIES
( COUNTRY_ID  CHAR(2) PRIMARY KEY,
    COUNTRY_NAME  VARCHAR(40),
    REGION_ID  NUMERIC REFERENCES REGIONS(REGION_ID)
);

CREATE TABLE   LOCATIONS
( LOCATION_ID  NUMERIC(4,0) PRIMARY KEY,
    STREET_ADDRESS  VARCHAR(40),
    POSTAL_CODE  VARCHAR(12),
    CITY  VARCHAR(30) NOT NULL,
    STATE_PROVINCE  VARCHAR(25),
    COUNTRY_ID  CHAR(2) REFERENCES COUNTRIES(COUNTRY_ID)
);

CREATE INDEX   LOC_CITY_IX  ON   LOCATIONS  ( CITY );
CREATE INDEX   LOC_COUNTRY_IX  ON   LOCATIONS  ( COUNTRY_ID );
CREATE INDEX   LOC_STATE_PROVINCE_IX  ON   LOCATIONS  ( STATE_PROVINCE );

CREATE TABLE   DEPARTMENTS
( DEPARTMENT_ID  NUMERIC(4,0) PRIMARY KEY,
    DEPARTMENT_NAME  VARCHAR(30) NOT NULL,
    MANAGER_ID  NUMERIC(6,0),
    LOCATION_ID  NUMERIC(4,0) REFERENCES LOCATIONS(LOCATION_ID)
);


CREATE INDEX   DEPT_LOCATION_IX  ON   DEPARTMENTS  ( LOCATION_ID );

CREATE TABLE   JOBS
( JOB_ID  VARCHAR(10) PRIMARY KEY,
    JOB_TITLE  VARCHAR(35) NOT NULL,
    MIN_SALARY  NUMERIC(6,0),
    MAX_SALARY  NUMERIC(6,0)
);

CREATE TABLE EMPLOYEES
( EMPLOYEE_ID  NUMERIC(6,0) PRIMARY KEY,
    FIRST_NAME  VARCHAR(20),
    LAST_NAME  VARCHAR(25) NOT NULL,
    EMAIL  VARCHAR(25) NOT NULL UNIQUE,
    PHONE_NUMBER  VARCHAR(20),
    HIRE_DATE  DATE NOT NULL,
    JOB_ID  VARCHAR(10) NOT NULL REFERENCES JOBS(JOB_ID),
    SALARY  NUMERIC(8,2),
    COMMISSION_PCT  NUMERIC(2,2),
    MANAGER_ID  NUMERIC(6,0) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    DEPARTMENT_ID  NUMERIC(4,0) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    BONUS  VARCHAR(5),
    CONSTRAINT EMP_SALARY_MIN CHECK(SALARY>0)
);




CREATE INDEX   EMP_DEPARTMENT_IX  ON   EMPLOYEES  ( DEPARTMENT_ID );
CREATE INDEX   EMP_JOB_IX  ON   EMPLOYEES  ( JOB_ID );
CREATE INDEX   EMP_MANAGER_IX  ON   EMPLOYEES  ( MANAGER_ID );
CREATE INDEX   EMP_NAME_IX  ON   EMPLOYEES  ( LAST_NAME ,  FIRST_NAME );

CREATE TABLE   JOB_GRADES
( GRADE_LEVEL  VARCHAR(3),
    LOWEST_SAL  NUMERIC,
    HIGHEST_SAL  NUMERIC
);

CREATE TABLE   JOB_HISTORY
( EMPLOYEE_ID  NUMERIC(6,0) NOT NULL,
    START_DATE  DATE NOT NULL,
    END_DATE  DATE NOT NULL,
    JOB_ID  VARCHAR(10)  NOT NULL REFERENCES JOBS(JOB_ID),
    DEPARTMENT_ID  NUMERIC(4,0) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    CONSTRAINT  JHIST_DATE_INTERVAL  CHECK (end_date > start_date),
    CONSTRAINT  JHIST_EMP_ID_ST_DATE_PK  PRIMARY KEY ( EMPLOYEE_ID ,  START_DATE )
);



CREATE INDEX   JHIST_DEPARTMENT_IX  ON   JOB_HISTORY  ( DEPARTMENT_ID );
CREATE INDEX   JHIST_EMPLOYEE_IX  ON   JOB_HISTORY  ( EMPLOYEE_ID );
CREATE INDEX   JHIST_JOB_IX  ON   JOB_HISTORY  ( JOB_ID );

--populate REGIONS table
    INSERT INTO REGIONS (region_id, region_name)
    Values(1,'Europe');
    INSERT INTO REGIONS (region_id, region_name)
    Values(2,'Americas');
    INSERT INTO REGIONS (region_id, region_name)
    Values(3,'Asia');
    INSERT INTO REGIONS (region_id, region_name)
    Values(4,'Middle East and Africa');

--populate COUNTRIES table
INSERT INTO COUNTRIES (country_id, country_name, region_id)
Values('CA','Canada',2);
INSERT INTO COUNTRIES (country_id, country_name, region_id)
Values('DE','Germany',1);
INSERT INTO COUNTRIES (country_id, country_name, region_id)
Values('UK','United Kingdom',1);
INSERT INTO COUNTRIES (country_id, country_name, region_id)
Values('US','United States of America',2);

--populate LOCATIONS table
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
Values(1800,'460 Bloor St. W.','ON M5S 1X8','Toronto','Ontario','CA');
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
Values(2500,'Magdalen Centre, The Oxford Science Park','OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
Values(1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US');
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
Values(1500,'2011 Interiors Blvd','99236','South San Francisco','California','US');
INSERT INTO LOCATIONS (location_id, street_address, postal_code, city, state_province, country_id)
Values(1700,'2004 Charade Rd','98199','Seattle','Washington','US');

--populate DEPARTMENTS table
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(10,'Administration',200,1700);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(20,'Marketing',201,1800);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(50,'Shipping',124,1500);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(60,'IT',103,1400);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(80,'Sales',149,2500);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(90,'Executive',100,1700);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(110,'Accounting',205,1700);
INSERT INTO DEPARTMENTS (department_id, department_name, manager_id, location_id)
Values(190,'Contracting',null,1700);

--populate JOBS table
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('AD_PRES','President',20000,40000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('AD_VP','Administration Vice President',15000,30000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('AD_ASST','Administration Assistant',3000,6000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('AC_MGR','Accounting Manager',8200,16000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('AC_ACCOUNT','Public Accountant',4200,9000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('SA_MAN','Sales Manager',10000,20000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('SA_REP','Sales Representative',6000,12000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('ST_MAN','Stock Manager',5500,8500);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('ST_CLERK','Stock Clerk',2000,5000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('IT_PROG','Programmer',4000,10000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('MK_MAN','Marketing Manager',9000,15000);
INSERT INTO JOBS (job_id, job_title, min_salary, max_salary)
Values('MK_REP','Marketing Representative',4000,9000);

--populate EMPLOYEES table
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(100,'Steven','King','SKING','515.123.4567',STR_TO_DATE('1987-06-17','%Y-%m-%d'),'AD_PRES',24000,null,null,90);
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(101,'Neena','Kochhar','NKOCHHAR','515.123.4568',STR_TO_DATE('1989-09-21','%Y-%m-%d'),'AD_VP',17000,null,100,90 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(102,'Lex','De Haan','LDEHAAN','515.123.4569',STR_TO_DATE('1993-01-13','%Y-%m-%d'),'AD_VP',17000,null,100,90 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(200,'Jennifer','Whalen','JWHALEN','515.123.4444',STR_TO_DATE('1987-09-17','%Y-%m-%d'),'AD_ASST',4400,null,101,10 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(205,'Shelley','Higgins','SHIGGINS','515.123.8080',STR_TO_DATE('1994-06-07','%Y-%m-%d'),'AC_MGR',12000,null,101,110 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(206,'William','Gietz','WGIETZ','515.123.8181',STR_TO_DATE('1994-06-07','%Y-%m-%d'),'AC_ACCOUNT',8300,null,205,110 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id, bonus)
VALUES(149,'Eleni','Zlotkey','EZLOTKEY','011.44.1344.429018',STR_TO_DATE('2000-01-29','%Y-%m-%d'),'SA_MAN',10500,.2,100,80, '1500' );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id, bonus)
VALUES(174,'Ellen','Abel','EABEL','011.44.1644.429267',STR_TO_DATE('1996-05-11','%Y-%m-%d'),'SA_REP',11000,.3,149,80,'1700' );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id, bonus)
VALUES(176,'Jonathon','Taylor','JTAYLOR','011.44.1644.429265',STR_TO_DATE('1998-03-24','%Y-%m-%d'),'SA_REP',8600,.2,149,80,'1250' );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(178,'Kimberely','Grant','KGRANT','011.44.1644.429263',STR_TO_DATE('1999-05-24','%Y-%m-%d'),'SA_REP',7000,.15,149,null );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(124,'Kevin','Mourgos','KMOURGOS','650.123.5234',STR_TO_DATE('1999-11-16','%Y-%m-%d'),'ST_MAN',5800,null,100,50);
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(141,'Trenna','Rajs','TRAJS','650.121.8009',STR_TO_DATE('1995-10-17','%Y-%m-%d'),'ST_CLERK',3500,null,124,50 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(142,'Curtis','Davies','CDAVIES','650.121.2994',STR_TO_DATE('1997-01-29','%Y-%m-%d'),'ST_CLERK',3100,null,124,50 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(143,'Randall','Matos','RMATOS','650.121.2874',STR_TO_DATE('1998-03-15','%Y-%m-%d'),'ST_CLERK',2600,null,124,50 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(144,'Peter','Vargas','PVARGAS','650.121.2004',STR_TO_DATE('1998-07-09','%Y-%m-%d'),'ST_CLERK',2500,null,124,50 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(103,'Alexander','Hunold','AHUNOLD','590.423.4567',STR_TO_DATE('1990-01-03','%Y-%m-%d'),'IT_PROG',9000,null,102,60 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(104,'Bruce','Ernst','BERNST','590.423.4568',STR_TO_DATE('1991-05-21','%Y-%m-%d'),'IT_PROG',6000,null,103,60 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(107,'Diana','Lorentz','DLORENTZ','590.423.5567',STR_TO_DATE('1999-02-07','%Y-%m-%d'),'IT_PROG',4200,null,103,60 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(201,'Michael','Hartstein','MHARTSTE','515.123.5555',STR_TO_DATE('1996-02-17','%Y-%m-%d'),'MK_MAN',13000,null,100,20 );
INSERT INTO EMPLOYEES(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(202,'Pat','Fay','PFAY','603.123.6666',STR_TO_DATE('1997-08-17','%Y-%m-%d'),'MK_REP',6000,null,201,20 );

--populate JOB_HISTORY table
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(200,STR_TO_DATE('09-17-1987','%m-%d-%Y'),STR_TO_DATE('06-17-1993','%m-%d-%Y'),'AD_ASST',90 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(101,STR_TO_DATE('10-28-1993','%m-%d-%Y'),STR_TO_DATE('03-15-1997','%m-%d-%Y'),'AC_MGR',110 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(200,STR_TO_DATE('07-01-1994','%m-%d-%Y'),STR_TO_DATE('12-31-1998','%m-%d-%Y'),'AC_ACCOUNT',90 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(101,STR_TO_DATE('09-21-1989','%m-%d-%Y'),STR_TO_DATE('10-27-1993','%m-%d-%Y'),'AC_ACCOUNT',110 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(176,STR_TO_DATE('01-01-1999','%m-%d-%Y'),STR_TO_DATE('12-31-1999','%m-%d-%Y'),'SA_MAN',80 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(176,STR_TO_DATE('03-24-1998','%m-%d-%Y'),STR_TO_DATE('12-31-1998','%m-%d-%Y'),'SA_REP',80 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(122,STR_TO_DATE('01-01-1999','%m-%d-%Y'),STR_TO_DATE('12-31-1999','%m-%d-%Y'),'ST_CLERK',50 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(114,STR_TO_DATE('03-24-1998','%m-%d-%Y'),STR_TO_DATE('12-31-1999','%m-%d-%Y'),'ST_CLERK',50 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(102,STR_TO_DATE('01-13-1993','%m-%d-%Y'),STR_TO_DATE('07-24-1998','%m-%d-%Y'),'IT_PROG',60 );
INSERT INTO JOB_HISTORY(employee_id,start_date,end_date,job_id,department_id)
VALUES(201,STR_TO_DATE('02-17-1996','%m-%d-%Y'),STR_TO_DATE('12-19-1999','%m-%d-%Y'),'MK_REP',20 );

--populate JOB_GRADES table
INSERT INTO JOB_GRADES(grade_level,lowest_sal,highest_sal)
VALUES('A',1000,2999);
INSERT INTO JOB_GRADES(grade_level,lowest_sal,highest_sal)
VALUES('B',3000,5999);
INSERT INTO JOB_GRADES(grade_level,lowest_sal,highest_sal)
VALUES('C',6000,9999);
INSERT INTO JOB_GRADES(grade_level,lowest_sal,highest_sal)
VALUES('D',10000,14999);
INSERT INTO JOB_GRADES(grade_level,lowest_sal,highest_sal)
VALUES('E',15000,24999);
INSERT INTO JOB_GRADES(grade_level,lowest_sal,highest_sal)
VALUES('F',25000,40000);


CREATE OR REPLACE VIEW   EMP_DETAILS_VIEW  ( EMPLOYEE_ID ,  JOB_ID ,  MANAGER_ID ,  DEPARTMENT_ID ,  LOCATION_ID ,  COUNTRY_ID ,  FIRST_NAME ,  LAST_NAME ,  SALARY ,  COMMISSION_PCT ,  DEPARTMENT_NAME ,  JOB_TITLE ,  CITY ,  STATE_PROVINCE ,  COUNTRY_NAME ,  REGION_NAME )
AS SELECT
       e.employee_id, e.job_id, e.manager_id, e.department_id,
       d.location_id,
       l.country_id,
       e.first_name, e.last_name, e.salary, e.commission_pct,
       d.department_name,
       j.job_title,
       l.city, l.state_province,
       c.country_name,
       r.region_name
   FROM
       EMPLOYEES e,
       DEPARTMENTS d,
       JOBS j,
       LOCATIONS l,
       COUNTRIES c,
       REGIONS r
   WHERE
       e.department_id = d.department_id
     AND d.location_id = l.location_id
     AND l.country_id = c.country_id
     AND c.region_id = r.region_id
     AND j.job_id = e.job_id;

