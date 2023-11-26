drop table if exists users;

create table users (
  title varchar(10) not null,
  firstName varchar(100) not null,
  lastName varchar(100) not null,
  country varchar(100) not null,
  birthDate date not null,
  username varchar(255) primary key not null,
  email varchar(255) unique not null,
  password varchar(256) not null,
  dateIns timestamp default current_timestamp not null,
  journalist char(1) check(journalist in('t', 'f', 'T', 'F'))
);