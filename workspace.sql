USE ROLE ACCOUNTADMIN;
-- Create role STREAMLIT_APP_DEMO_ROLE
CREATE OR REPLACE ROLE STREAMLIT_APP_DEMO_ROLE;

CREATE OR REPLACE ROLE STREAMLIT_APP_DEMO_USER_ROLE;

GRANT ROLE STREAMLIT_APP_DEMO_ROLE TO ROLE ACCOUNTADMIN ;


GRANT ROLE STREAMLIT_APP_DEMO_USER_ROLE TO USER USER_A;


-- Create STREAMLIT_APP_DEMO_WH warehouse
CREATE OR REPLACE WAREHOUSE STREAMLIT_APP_DEMO_WH WAREHOUSE_SIZE = XSMALL, AUTO_SUSPEND = 300, AUTO_RESUME= TRUE;
GRANT OWNERSHIP ON WAREHOUSE STREAMLIT_APP_DEMO_WH TO ROLE STREAMLIT_APP_DEMO_ROLE;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE STREAMLIT_APP_DEMO_ROLE;

-- Use role and create streamlit_db database and schema.
CREATE OR REPLACE DATABASE streamlit_db;
GRANT OWNERSHIP ON DATABASE streamlit_db TO ROLE STREAMLIT_APP_DEMO_ROLE;
CREATE OR REPLACE SCHEMA streamlit_schema;
GRANT OWNERSHIP ON SCHEMA streamlit_db.streamlit_schema TO ROLE STREAMLIT_APP_DEMO_ROLE;


CREATE OR REPLACE SCHEMA data;
GRANT OWNERSHIP ON SCHEMA streamlit_db.data TO ROLE STREAMLIT_APP_DEMO_ROLE;

-- Use role
USE ROLE STREAMLIT_APP_DEMO_ROLE;

-- use database and DATA schema
USE DATABASE streamlit_db;
USE SCHEMA streamlit_schema;


CREATE STAGE streamlit_stage DIRECTORY = ( ENABLE = true );

list @streamlit_stage;


CREATE STREAMLIT Demo_Multi_page_Streamlit_App
ROOT_LOCATION = '@streamlit_db.streamlit_schema.streamlit_stage'
MAIN_FILE = '/streamlit_main.py'
QUERY_WAREHOUSE = STREAMLIT_APP_DEMO_WH;



GRANT USAGE ON DATABASE streamlit_db TO ROLE STREAMLIT_APP_DEMO_USER_ROLE;
GRANT USAGE ON SCHEMA streamlit_db.streamlit_schema TO ROLE STREAMLIT_APP_DEMO_USER_ROLE;
GRANT USAGE on STREAMLIT streamlit_db.streamlit_schema.Demo_Multi_page_Streamlit_App to ROLE STREAMLIT_APP_DEMO_USER_ROLE;



--------------------------------
--          APP DATA
--------------------------------

USE SCHEMA data;

-- table
CREATE OR REPLACE TABLE issues (
  customer   varchar,
  product    varchar,
  spend      decimal(20, 2),
  sale_date  date,
  region     varchar,
  assigned_user_name varchar,
  status varchar
);


--drop table issues;


insert into issues VALUES('CUSTOMER A','product 1',10,CURRENT_DATE(),'region 1','USER_A','DONE');
insert into issues VALUES('CUSTOMER B','product 1',10,CURRENT_DATE(),'region 1','USER_B','IN PROGRESS ');
insert into issues VALUES('CUSTOMER C','product 1',10,CURRENT_DATE(),'region 1','USER_C','IN PROGRESS');
insert into issues VALUES('CUSTOMER D','product 1',10,CURRENT_DATE(),'region 1','','OPEN');



CREATE or replace TABLE users (
  user_name   varchar,
  is_admin    BOOLEAN

);

insert into users VALUES('MENY',true);
insert into users VALUES('USER_A',false);
insert into users VALUES('USER_B',false);
insert into users VALUES('USER_C',false);

select * from streamlit_db.data.users;




SHOW USERS;




CREATE USER USER_A PASSWORD='abc123' DEFAULT_ROLE = STREAMLIT_APP_DEMO_USER_ROLE MUST_CHANGE_PASSWORD = FALSE;



DESC STREAMLIT Demo_Multi_page_Streamlit_App;

SHOW STREAMLITS;

--Clean up
drop table issues;
drop table users;
drop streamlit Demo_Multi_page_Streamlit_App;

