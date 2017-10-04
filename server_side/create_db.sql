drop database books;
create database books;
use books;

create table BOOKS(
ID varchar(8) primary key,
NAME varchar(24),
TITLE varchar(96),
PRICE float,
YR int,
DESCRIPTION varchar(128),
SALE_AMOUNT int);¡¡

insert into BOOKS values('201', 'sun', 
 'Java ',
 65, 2006, 'java', 20000);

insert into BOOKS values('202', 'sun', 
 ' truts', 49,
 2004, 'good', 80000);

insert into BOOKS values('203', 'sun', 
 'Tomcat ',
 45, 2004, 'tomcat', 40000);
