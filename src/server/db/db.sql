drop table if exists users;
drop table if exists Gara;
drop table if exists Disputa_Gara;
drop table if exists Pilota;
drop table if exists Si_Ritira;


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

create table Gara (
  data_gara date primary key,
  nome_gara varchar(80) not null,
  num_giri_previsti number(2,0) not null,
  num_giri_effettuati number(2,0) not null,
  ora_prevista_gara char(5) not null,
  ora_inizio_gara char(5),
  ora_fine_gara char(5),
  discriminatore_gara varchar(15) not null check (
    discriminatore_gara in ('sprint', 'completa', 'Sprint', 'Completa','SPRINT','COMPLETA')
  ),
  marca_MC varchar(30) not null,
  marca_SC varchar(30) not null,
  num_tesserino char(10) not null,
  nome_sponsor varchar(50),
  nome_circuito varchar(50) not null,
	numero_pilota number(2,0),
	constraint check_sprint_giro check ((discriminatore_gara <> 'sprint' and discriminatore_gara <> 'Sprint' and discriminatore_gara <> 'SPRINT') or
	(discriminatore_gara = 'sprint' and numero_pilota is null) or (discriminatore_gara = 'Sprint' and numero_pilota is null) or
	(discriminatore_gara = 'SPRINT' and numero_pilota is null)),
  constraint fk_medical_car_gara foreign key (marca_MC) references Medical_Car (marca_MC) on delete cascade,
	constraint fk_safety_car_gara foreign key (marca_SC) references Safety_Car (marca_SC) on delete cascade,
  constraint fk_direttore_gara foreign key (num_tesserino) references Direttore (num_tesserino) on delete cascade,
  constraint fk_sponsor_gara foreign key (nome_sponsor) references Sponsor (nome_sponsor) on delete set null,
  constraint fk_circuito_gara foreign key (nome_circuito) references Circuito (nome_circuito) on delete cascade,
	constraint fk_pilota_gara foreign key (numero_pilota) references Pilota (numero_pilota) on delete set null
);

create table Disputa_Gara (
  data_gara date,
  numero_pilota number(2,0),
  posizione_finale_gara number(2,0) not null check (posizione_finale_gara >= 1 and posizione_finale_gara <= 20),
  constraint pk_disputa_gara primary key (data_gara,numero_pilota),
	constraint uniq_gara_pos unique (data_gara,posizione_finale_gara),
	constraint fk_gara_disputa_gara foreign key (data_gara) references Gara (data_gara) on delete cascade,
  constraint fk_pilota_disputa_gara foreign key (numero_pilota) references Pilota (numero_pilota) on delete cascade
);

create table Si_Ritira (
  data_gara date,
  numero_pilota number(2,0),
  num_giro varchar(2) not null,
  causa varchar(30) not null check (
		causa in ('guasto','Guasto','GUASTO','incidente','Incidente','INCIDENTE')
  ),
	constraint pk_ritiro primary key (data_gara,numero_pilota),
  constraint fk_gara_ritiro foreign key (data_gara) references Gara (data_gara) on delete cascade,
  constraint fk_pilota_ritiro foreign key (numero_pilota) references Pilota (numero_pilota) on delete cascade
);

create table Pilota (
  numero_pilota number(2,0) primary key check (numero_pilota >= 1 and numero_pilota <= 99),
  nome_pilota varchar(50) not null,
  cognome_pilota varchar(50) not null,
  nazione_pilota varchar(30),
  nome_scuderia varchar(30) not null,
  constraint fk_scuderia_pilota foreign key (nome_scuderia) references Scuderia (nome_scuderia) on delete cascade
);

-- Pilota
insert into Pilota values (77,'Valtteri','Bottas','Finlandia','Alfa Romeo');
insert into Pilota values (24,'Guanyu','Zhou','Cina','Alfa Romeo');
insert into Pilota values (88,'Robert','Kubica','Polonia','Alfa Romeo');
insert into Pilota values (98,'Theo','Pourchaire','Francia','Alfa Romeo');
insert into Pilota values (10,'Pierre','Gasly','Francia','AlphaTauri');
insert into Pilota values (22,'Yuki','Tsunoda','Giappone','AlphaTauri');
insert into Pilota values (40,'Liam','Lawson','Nuova Zelanda','AlphaTauri');
insert into Pilota values (14,'Fernando','Alonso','Spagna','Alpine');
insert into Pilota values (31,'Esteban','Ocon','Francia','Alpine');
insert into Pilota values (82,'Jack','Doohan','Australia','Alpine');
insert into Pilota values (18,'Lance','Stroll','Canada','Aston Martin');
insert into Pilota values (5,'Sebastian','Vettel','Germania','Aston Martin');
insert into Pilota values (27,'Nico','Hulkenberg','Germania','Aston Martin');
insert into Pilota values (34,'Felipe','Drugovich','Brasile','Aston Martin');
insert into Pilota values (16,'Charles','Leclerc','Monaco','Ferrari');
insert into Pilota values (55,'Carlos','Sainz Jr.','Spagna','Ferrari');
insert into Pilota values (39,'Robert','Shwartzman','Russia','Ferrari');
insert into Pilota values (20,'Kevin','Magnussen','Danimarca','Haas');
insert into Pilota values (47,'Mick','Schumacher','Germania','Haas');
insert into Pilota values (99,'Antonio','Giovinazzi','Italia','Haas');
insert into Pilota values (51,'Pietro','Fittipaldi','Brasile','Haas');
insert into Pilota values (3,'Daniel','Ricciardo','Australia','McLaren');
insert into Pilota values (4,'Lando','Norris','Regno Unito','McLaren');
insert into Pilota values (28,'Alex','Palou','Spagna','McLaren');
insert into Pilota values (29,'Patricio','O''Ward','Messico','McLaren');
insert into Pilota values (44,'Lewis','Hamilton','Regno Unito','Mercedes');
insert into Pilota values (63,'George','Russell','Regno Unito','Mercedes');
insert into Pilota values (1,'Max','Verstappen','Olanda','Red Bull Racing');
insert into Pilota values (11,'Sergio','Perez','Messico','Red Bull Racing');
insert into Pilota values (36,'Juri','Vips','Estonia','Red Bull Racing');
insert into Pilota values (23,'Alexander','Albon','Thailandia','Williams Racing');
insert into Pilota values (45,'Nyck','De Vries','Olanda','Williams Racing'); 
insert into Pilota values (6,'Nicholas','Latifi','Canada','Williams Racing');
insert into Pilota values (46,'Logan','Sargeant','Stati Uniti','Williams Racing');

-- Gara
insert into Gara values ('20-MAR-2022','Bahrain Grand Prix',57,57,'18:00','18:00','19:37','Completa','Mercedes','Mercedes','0193000032','Gulf Air','Bahrain International Circuit',16);
insert into Gara values ('27-MAR-2022','Saudi Arabian Grand Prix',50,50,'20:00','20:00','21:24','Completa','Mercedes','Mercedes','0193000032','STC','Jeddah Corniche Circuit',16);
insert into Gara values ('10-APR-2022','Australian Grand Prix',58,58,'15:00','15:00','16:27','Completa','Aston Martin','Aston Martin','0193000032','Heineken','Albert Park Circuit',16);
insert into Gara values ('23-APR-2022','Gran Premio del Made in Italy e dell''Emilia Romagna',21,21,'16:30','16:30','17:00','Sprint','Aston Martin','Aston Martin','0193000032','Rolex','Autodromo Enzo e Dino Ferrari',NULL);
insert into Gara values ('24-APR-2022','Gran Premio del Made in Italy e dell''Emilia Romagna',63,63,'15:00','15:00','16:32','Completa','Aston Martin','Aston Martin','0193000032','Rolex','Autodromo Enzo e Dino Ferrari',1);
insert into Gara values ('08-MAY-2022','Miami Grand Prix',57,57,'15:30','15:30','17:04','Completa','Mercedes','Mercedes','0193000032','Crypto.com','Miami International Autodrome',1);
insert into Gara values ('22-MAY-2022','Gran Premio de Espana',66,66,'15:00','15:00','16:37','Completa','Aston Martin','Aston Martin','0193000033','Pirelli','Circuit de Barcelona-Catalunya',11);
insert into Gara values ('29-MAY-2022','Grand Prix de Monaco',78,64,'15:00','15:00','16:56','Completa','Mercedes','Mercedes','0193000033',NULL,'Circuit de Monaco',4);
insert into Gara values ('12-JUN-2022','Azerbaijan Grand Prix',51,51,'15:00','15:00','16:34','Completa','Mercedes','Mercedes','0193000032',NULL,'Baku City Circuit',11);
insert into Gara values ('19-JUN-2022','Grand Prix du Canada',70,70,'14:00','14:00','15:36','Completa','Mercedes','Mercedes','0193000033','AWS','Circuit Gilles Villeneuve',55);
insert into Gara values ('03-JUL-2022','British Grand Prix',52,52,'15:00','15:00','17:17','Completa','Aston Martin','Aston Martin','0193000032','Lenovo','Silverstone Circuit',44);
insert into Gara values ('09-JUL-2022','Grosser Preis von Osterreich',23,23,'16:30','16:30','16:56','Sprint','Aston Martin','Aston Martin','0193000032','Rolex','Red Bull Ring',NULL);
insert into Gara values ('10-JUL-2022','Grosser Preis von Osterreich',71,71,'15:00','15:00','16:24','Completa','Aston Martin','Aston Martin','0193000032','Rolex','Red Bull Ring',1);
insert into Gara values ('24-JUL-2022','Grand Prix de France',53,53,'15:00','15:00','16:30','Completa','Mercedes','Mercedes','0193000033','Lenovo','Circuit Paul Ricard',55);
insert into Gara values ('31-JUL-2022','Magyar Nagydij',70,70,'15:00','15:00','16:39','Completa','Aston Martin','Aston Martin','0193000033','Aramco','Hungaroring',44);
insert into Gara values ('28-AUG-2022','Belgian Grand Prix',44,44,'15:00','15:00','16:25','Completa','Mercedes','Mercedes','0193000032','Rolex','Circuit de Spa-Francorchamps',1);
insert into Gara values ('04-SEP-2022','Dutch Grand Prix',72,72,'15:00','15:00','16:36','Completa','Mercedes','Mercedes','0193000033','Heineken','Circuit Zandvoort',1);
insert into Gara values ('11-SEP-2022','Gran Premio d''Italia',53,53,'15:00','15:00','16:20','Completa','Aston Martin','Aston Martin','0193000032','Pirelli','Autodromo nazionale di Monza',11);
insert into Gara values ('02-OCT-2022','Singapore Grand Prix',61,59,'20:00','20:00','22:02','Completa','Mercedes','Mercedes','0193000033','Singapore Airlines','Marina Bay Street Circuit',63);
insert into Gara values ('09-OCT-2022','Japanese Grand Prix',53,28,'14:00','14:00','17:01','Completa','Mercedes','Mercedes','0193000033','Honda','Suzuka International Racing Course',24);
insert into Gara values ('23-OCT-2022','United States Grand Prix',56,56,'14:00','14:00','15:42','Completa','Aston Martin','Aston Martin','0193000032','Aramco','Circuit of the Americas',63);
insert into Gara values ('30-OCT-2022','Gran Premio de la Ciudad de Mexico',71,71,'14:00','14:00','15:38','Completa','Aston Martin','Aston Martin','0193000032',NULL,'Autodromo Hermanos Rodriguez',63);
insert into Gara values ('12-NOV-2022','Grande Premio de Sao Paulo',24,24,'15:30','15:30','16:00','Sprint','Aston Martin','Aston Martin','0193000032','Heineken','Autodromo Jose Carlos Pace',NULL);
insert into Gara values ('13-NOV-2022','Grande Premio de Sao Paulo',71,71,'15:00','15:00','16:38','Completa','Aston Martin','Aston Martin','0193000032','Heineken','Autodromo Jose Carlos Pace',63);
insert into Gara values ('20-NOV-2022','Abu Dhabi Grand Prix',58,58,'17:00','17:00','18:27','Completa','Mercedes','Mercedes','0193000032','Etihad Airways','Yas Marina Circuit',4);

-- Disputa_Gara
insert into Disputa_Gara values ('20-MAR-2022',16,1);
insert into Disputa_Gara values ('20-MAR-2022',55,2);
insert into Disputa_Gara values ('20-MAR-2022',44,3);
insert into Disputa_Gara values ('20-MAR-2022',63,4);
insert into Disputa_Gara values ('20-MAR-2022',20,5);
insert into Disputa_Gara values ('20-MAR-2022',77,6);
insert into Disputa_Gara values ('20-MAR-2022',31,7);
insert into Disputa_Gara values ('20-MAR-2022',22,8);
insert into Disputa_Gara values ('20-MAR-2022',14,9);
insert into Disputa_Gara values ('20-MAR-2022',24,10);
insert into Disputa_Gara values ('20-MAR-2022',47,11);
insert into Disputa_Gara values ('20-MAR-2022',18,12);
insert into Disputa_Gara values ('20-MAR-2022',23,13);
insert into Disputa_Gara values ('20-MAR-2022',3,14);
insert into Disputa_Gara values ('20-MAR-2022',4,15);
insert into Disputa_Gara values ('20-MAR-2022',6,16);
insert into Disputa_Gara values ('20-MAR-2022',27,17);
insert into Disputa_Gara values ('20-MAR-2022',11,18);
insert into Disputa_Gara values ('20-MAR-2022',1,19);
insert into Disputa_Gara values ('20-MAR-2022',10,20);

insert into Disputa_Gara values ('27-MAR-2022',1,1);
insert into Disputa_Gara values ('27-MAR-2022',16,2);
insert into Disputa_Gara values ('27-MAR-2022',55,3);
insert into Disputa_Gara values ('27-MAR-2022',11,4);
insert into Disputa_Gara values ('27-MAR-2022',63,5);
insert into Disputa_Gara values ('27-MAR-2022',31,6);
insert into Disputa_Gara values ('27-MAR-2022',4,7);
insert into Disputa_Gara values ('27-MAR-2022',10,8);
insert into Disputa_Gara values ('27-MAR-2022',20,9);
insert into Disputa_Gara values ('27-MAR-2022',44,10);
insert into Disputa_Gara values ('27-MAR-2022',24,11);
insert into Disputa_Gara values ('27-MAR-2022',27,12);
insert into Disputa_Gara values ('27-MAR-2022',18,13);
insert into Disputa_Gara values ('27-MAR-2022',23,14);
insert into Disputa_Gara values ('27-MAR-2022',77,15);
insert into Disputa_Gara values ('27-MAR-2022',14,16);
insert into Disputa_Gara values ('27-MAR-2022',3,17);
insert into Disputa_Gara values ('27-MAR-2022',6,18);
insert into Disputa_Gara values ('27-MAR-2022',22,19);
insert into Disputa_Gara values ('27-MAR-2022',47,20);

insert into Disputa_Gara values ('10-APR-2022',16,1);
insert into Disputa_Gara values ('10-APR-2022',11,2);
insert into Disputa_Gara values ('10-APR-2022',63,3);
insert into Disputa_Gara values ('10-APR-2022',44,4);
insert into Disputa_Gara values ('10-APR-2022',4,5);
insert into Disputa_Gara values ('10-APR-2022',3,6);
insert into Disputa_Gara values ('10-APR-2022',31,7);
insert into Disputa_Gara values ('10-APR-2022',77,8);
insert into Disputa_Gara values ('10-APR-2022',10,9);
insert into Disputa_Gara values ('10-APR-2022',23,10);
insert into Disputa_Gara values ('10-APR-2022',24,11);
insert into Disputa_Gara values ('10-APR-2022',18,12);
insert into Disputa_Gara values ('10-APR-2022',47,13);
insert into Disputa_Gara values ('10-APR-2022',20,14);
insert into Disputa_Gara values ('10-APR-2022',22,15);
insert into Disputa_Gara values ('10-APR-2022',6,16);
insert into Disputa_Gara values ('10-APR-2022',14,17);
insert into Disputa_Gara values ('10-APR-2022',1,18);
insert into Disputa_Gara values ('10-APR-2022',5,19);
insert into Disputa_Gara values ('10-APR-2022',55,20);

insert into Disputa_Gara values ('23-APR-2022',1,1);
insert into Disputa_Gara values ('23-APR-2022',16,2);
insert into Disputa_Gara values ('23-APR-2022',11,3);
insert into Disputa_Gara values ('23-APR-2022',55,4);
insert into Disputa_Gara values ('23-APR-2022',4,5);
insert into Disputa_Gara values ('23-APR-2022',3,6);
insert into Disputa_Gara values ('23-APR-2022',77,7);
insert into Disputa_Gara values ('23-APR-2022',20,8);
insert into Disputa_Gara values ('23-APR-2022',14,9);
insert into Disputa_Gara values ('23-APR-2022',47,10);
insert into Disputa_Gara values ('23-APR-2022',63,11);
insert into Disputa_Gara values ('23-APR-2022',22,12);
insert into Disputa_Gara values ('23-APR-2022',5,13);
insert into Disputa_Gara values ('23-APR-2022',44,14);
insert into Disputa_Gara values ('23-APR-2022',18,15);
insert into Disputa_Gara values ('23-APR-2022',31,16);
insert into Disputa_Gara values ('23-APR-2022',10,17);
insert into Disputa_Gara values ('23-APR-2022',23,18);
insert into Disputa_Gara values ('23-APR-2022',6,19);
insert into Disputa_Gara values ('23-APR-2022',24,20);

insert into Disputa_Gara values ('24-APR-2022',1,1);
insert into Disputa_Gara values ('24-APR-2022',11,2);
insert into Disputa_Gara values ('24-APR-2022',4,3);
insert into Disputa_Gara values ('24-APR-2022',63,4);
insert into Disputa_Gara values ('24-APR-2022',77,5);
insert into Disputa_Gara values ('24-APR-2022',16,6);
insert into Disputa_Gara values ('24-APR-2022',22,7);
insert into Disputa_Gara values ('24-APR-2022',5,8);
insert into Disputa_Gara values ('24-APR-2022',20,9);
insert into Disputa_Gara values ('24-APR-2022',18,10);
insert into Disputa_Gara values ('24-APR-2022',23,11);
insert into Disputa_Gara values ('24-APR-2022',10,12);
insert into Disputa_Gara values ('24-APR-2022',44,13);
insert into Disputa_Gara values ('24-APR-2022',31,14);
insert into Disputa_Gara values ('24-APR-2022',24,15);
insert into Disputa_Gara values ('24-APR-2022',6,16);
insert into Disputa_Gara values ('24-APR-2022',47,17);
insert into Disputa_Gara values ('24-APR-2022',3,18);
insert into Disputa_Gara values ('24-APR-2022',14,19);
insert into Disputa_Gara values ('24-APR-2022',55,20);

insert into Disputa_Gara values ('08-MAY-2022',1,1);
insert into Disputa_Gara values ('08-MAY-2022',16,2);
insert into Disputa_Gara values ('08-MAY-2022',55,3);
insert into Disputa_Gara values ('08-MAY-2022',11,4);
insert into Disputa_Gara values ('08-MAY-2022',63,5);
insert into Disputa_Gara values ('08-MAY-2022',44,6);
insert into Disputa_Gara values ('08-MAY-2022',77,7);
insert into Disputa_Gara values ('08-MAY-2022',31,8);
insert into Disputa_Gara values ('08-MAY-2022',23,9);
insert into Disputa_Gara values ('08-MAY-2022',18,10);
insert into Disputa_Gara values ('08-MAY-2022',14,11);
insert into Disputa_Gara values ('08-MAY-2022',22,12);
insert into Disputa_Gara values ('08-MAY-2022',3,13);
insert into Disputa_Gara values ('08-MAY-2022',6,14);
insert into Disputa_Gara values ('08-MAY-2022',47,15);
insert into Disputa_Gara values ('08-MAY-2022',20,16);
insert into Disputa_Gara values ('08-MAY-2022',5,17);
insert into Disputa_Gara values ('08-MAY-2022',10,18);
insert into Disputa_Gara values ('08-MAY-2022',4,19);
insert into Disputa_Gara values ('08-MAY-2022',24,20);

insert into Disputa_Gara values ('22-MAY-2022',1,1);
insert into Disputa_Gara values ('22-MAY-2022',11,2);
insert into Disputa_Gara values ('22-MAY-2022',63,3);
insert into Disputa_Gara values ('22-MAY-2022',55,4);
insert into Disputa_Gara values ('22-MAY-2022',44,5);
insert into Disputa_Gara values ('22-MAY-2022',77,6);
insert into Disputa_Gara values ('22-MAY-2022',31,7);
insert into Disputa_Gara values ('22-MAY-2022',4,8);
insert into Disputa_Gara values ('22-MAY-2022',14,9);
insert into Disputa_Gara values ('22-MAY-2022',22,10);
insert into Disputa_Gara values ('22-MAY-2022',5,11);
insert into Disputa_Gara values ('22-MAY-2022',3,12);
insert into Disputa_Gara values ('22-MAY-2022',10,13);
insert into Disputa_Gara values ('22-MAY-2022',47,14);
insert into Disputa_Gara values ('22-MAY-2022',18,15);
insert into Disputa_Gara values ('22-MAY-2022',6,16);
insert into Disputa_Gara values ('22-MAY-2022',20,17);
insert into Disputa_Gara values ('22-MAY-2022',23,18);
insert into Disputa_Gara values ('22-MAY-2022',24,19);
insert into Disputa_Gara values ('22-MAY-2022',16,20);

insert into Disputa_Gara values ('29-MAY-2022',11,1);
insert into Disputa_Gara values ('29-MAY-2022',55,2);
insert into Disputa_Gara values ('29-MAY-2022',1,3);
insert into Disputa_Gara values ('29-MAY-2022',16,4);
insert into Disputa_Gara values ('29-MAY-2022',63,5);
insert into Disputa_Gara values ('29-MAY-2022',4,6);
insert into Disputa_Gara values ('29-MAY-2022',14,7);
insert into Disputa_Gara values ('29-MAY-2022',44,8);
insert into Disputa_Gara values ('29-MAY-2022',77,9);
insert into Disputa_Gara values ('29-MAY-2022',5,10);
insert into Disputa_Gara values ('29-MAY-2022',10,11);
insert into Disputa_Gara values ('29-MAY-2022',31,12);
insert into Disputa_Gara values ('29-MAY-2022',3,13);
insert into Disputa_Gara values ('29-MAY-2022',18,14);
insert into Disputa_Gara values ('29-MAY-2022',6,15);
insert into Disputa_Gara values ('29-MAY-2022',24,16);
insert into Disputa_Gara values ('29-MAY-2022',22,17);
insert into Disputa_Gara values ('29-MAY-2022',23,18);
insert into Disputa_Gara values ('29-MAY-2022',47,19);
insert into Disputa_Gara values ('29-MAY-2022',20,20);

insert into Disputa_Gara values ('12-JUN-2022',1,1);
insert into Disputa_Gara values ('12-JUN-2022',11,2);
insert into Disputa_Gara values ('12-JUN-2022',63,3);
insert into Disputa_Gara values ('12-JUN-2022',44,4);
insert into Disputa_Gara values ('12-JUN-2022',10,5);
insert into Disputa_Gara values ('12-JUN-2022',5,6);
insert into Disputa_Gara values ('12-JUN-2022',14,7);
insert into Disputa_Gara values ('12-JUN-2022',3,8);
insert into Disputa_Gara values ('12-JUN-2022',4,9);
insert into Disputa_Gara values ('12-JUN-2022',31,10);
insert into Disputa_Gara values ('12-JUN-2022',77,11);
insert into Disputa_Gara values ('12-JUN-2022',23,12);
insert into Disputa_Gara values ('12-JUN-2022',22,13);
insert into Disputa_Gara values ('12-JUN-2022',47,14);
insert into Disputa_Gara values ('12-JUN-2022',6,15);
insert into Disputa_Gara values ('12-JUN-2022',18,16);
insert into Disputa_Gara values ('12-JUN-2022',20,17);
insert into Disputa_Gara values ('12-JUN-2022',24,18);
insert into Disputa_Gara values ('12-JUN-2022',16,19);
insert into Disputa_Gara values ('12-JUN-2022',55,20);

insert into Disputa_Gara values ('19-JUN-2022',1,1);
insert into Disputa_Gara values ('19-JUN-2022',55,2);
insert into Disputa_Gara values ('19-JUN-2022',44,3);
insert into Disputa_Gara values ('19-JUN-2022',63,4);
insert into Disputa_Gara values ('19-JUN-2022',16,5);
insert into Disputa_Gara values ('19-JUN-2022',31,6);
insert into Disputa_Gara values ('19-JUN-2022',77,7);
insert into Disputa_Gara values ('19-JUN-2022',24,8);
insert into Disputa_Gara values ('19-JUN-2022',14,9);
insert into Disputa_Gara values ('19-JUN-2022',18,10);
insert into Disputa_Gara values ('19-JUN-2022',3,11);
insert into Disputa_Gara values ('19-JUN-2022',5,12);
insert into Disputa_Gara values ('19-JUN-2022',23,13);
insert into Disputa_Gara values ('19-JUN-2022',10,14);
insert into Disputa_Gara values ('19-JUN-2022',4,15);
insert into Disputa_Gara values ('19-JUN-2022',6,16);
insert into Disputa_Gara values ('19-JUN-2022',20,17);
insert into Disputa_Gara values ('19-JUN-2022',22,18);
insert into Disputa_Gara values ('19-JUN-2022',47,19);
insert into Disputa_Gara values ('19-JUN-2022',11,20);

insert into Disputa_Gara values ('03-JUL-2022',55,1);
insert into Disputa_Gara values ('03-JUL-2022',11,2);
insert into Disputa_Gara values ('03-JUL-2022',44,3);
insert into Disputa_Gara values ('03-JUL-2022',16,4);
insert into Disputa_Gara values ('03-JUL-2022',14,5);
insert into Disputa_Gara values ('03-JUL-2022',4,6);
insert into Disputa_Gara values ('03-JUL-2022',1,7);
insert into Disputa_Gara values ('03-JUL-2022',47,8);
insert into Disputa_Gara values ('03-JUL-2022',5,9);
insert into Disputa_Gara values ('03-JUL-2022',20,10);
insert into Disputa_Gara values ('03-JUL-2022',18,11);
insert into Disputa_Gara values ('03-JUL-2022',6,12);
insert into Disputa_Gara values ('03-JUL-2022',3,13);
insert into Disputa_Gara values ('03-JUL-2022',22,14);
insert into Disputa_Gara values ('03-JUL-2022',31,15);
insert into Disputa_Gara values ('03-JUL-2022',10,16);
insert into Disputa_Gara values ('03-JUL-2022',77,17);
insert into Disputa_Gara values ('03-JUL-2022',63,18);
insert into Disputa_Gara values ('03-JUL-2022',24,19);
insert into Disputa_Gara values ('03-JUL-2022',23,20);

insert into Disputa_Gara values ('09-JUL-2022',1,1);
insert into Disputa_Gara values ('09-JUL-2022',16,2);
insert into Disputa_Gara values ('09-JUL-2022',55,3);
insert into Disputa_Gara values ('09-JUL-2022',63,4);
insert into Disputa_Gara values ('09-JUL-2022',11,5);
insert into Disputa_Gara values ('09-JUL-2022',31,6);
insert into Disputa_Gara values ('09-JUL-2022',20,7);
insert into Disputa_Gara values ('09-JUL-2022',44,8);
insert into Disputa_Gara values ('09-JUL-2022',47,9);
insert into Disputa_Gara values ('09-JUL-2022',77,10);
insert into Disputa_Gara values ('09-JUL-2022',4,11);
insert into Disputa_Gara values ('09-JUL-2022',3,12);
insert into Disputa_Gara values ('09-JUL-2022',18,13);
insert into Disputa_Gara values ('09-JUL-2022',24,14);
insert into Disputa_Gara values ('09-JUL-2022',10,15);
insert into Disputa_Gara values ('09-JUL-2022',23,16);
insert into Disputa_Gara values ('09-JUL-2022',22,17);
insert into Disputa_Gara values ('09-JUL-2022',6,18);
insert into Disputa_Gara values ('09-JUL-2022',5,19);
insert into Disputa_Gara values ('09-JUL-2022',14,20);

insert into Disputa_Gara values ('10-JUL-2022',16,1);
insert into Disputa_Gara values ('10-JUL-2022',1,2);
insert into Disputa_Gara values ('10-JUL-2022',44,3);
insert into Disputa_Gara values ('10-JUL-2022',63,4);
insert into Disputa_Gara values ('10-JUL-2022',31,5);
insert into Disputa_Gara values ('10-JUL-2022',47,6);
insert into Disputa_Gara values ('10-JUL-2022',4,7);
insert into Disputa_Gara values ('10-JUL-2022',20,8);
insert into Disputa_Gara values ('10-JUL-2022',3,9);
insert into Disputa_Gara values ('10-JUL-2022',14,10);
insert into Disputa_Gara values ('10-JUL-2022',77,11);
insert into Disputa_Gara values ('10-JUL-2022',23,12);
insert into Disputa_Gara values ('10-JUL-2022',18,13);
insert into Disputa_Gara values ('10-JUL-2022',24,14);
insert into Disputa_Gara values ('10-JUL-2022',10,15);
insert into Disputa_Gara values ('10-JUL-2022',22,16);
insert into Disputa_Gara values ('10-JUL-2022',5,17);
insert into Disputa_Gara values ('10-JUL-2022',55,18);
insert into Disputa_Gara values ('10-JUL-2022',6,19);
insert into Disputa_Gara values ('10-JUL-2022',11,20);

insert into Disputa_Gara values ('24-JUL-2022',1,1);
insert into Disputa_Gara values ('24-JUL-2022',44,2);
insert into Disputa_Gara values ('24-JUL-2022',63,3);
insert into Disputa_Gara values ('24-JUL-2022',11,4);
insert into Disputa_Gara values ('24-JUL-2022',55,5);
insert into Disputa_Gara values ('24-JUL-2022',14,6);
insert into Disputa_Gara values ('24-JUL-2022',4,7);
insert into Disputa_Gara values ('24-JUL-2022',31,8);
insert into Disputa_Gara values ('24-JUL-2022',3,9);
insert into Disputa_Gara values ('24-JUL-2022',18,10);
insert into Disputa_Gara values ('24-JUL-2022',5,11);
insert into Disputa_Gara values ('24-JUL-2022',10,12);
insert into Disputa_Gara values ('24-JUL-2022',23,13);
insert into Disputa_Gara values ('24-JUL-2022',77,14);
insert into Disputa_Gara values ('24-JUL-2022',47,15);
insert into Disputa_Gara values ('24-JUL-2022',24,16);
insert into Disputa_Gara values ('24-JUL-2022',6,17);
insert into Disputa_Gara values ('24-JUL-2022',20,18);
insert into Disputa_Gara values ('24-JUL-2022',16,19);
insert into Disputa_Gara values ('24-JUL-2022',22,20);

insert into Disputa_Gara values ('31-JUL-2022',1,1);
insert into Disputa_Gara values ('31-JUL-2022',44,2);
insert into Disputa_Gara values ('31-JUL-2022',63,3);
insert into Disputa_Gara values ('31-JUL-2022',55,4);
insert into Disputa_Gara values ('31-JUL-2022',11,5);
insert into Disputa_Gara values ('31-JUL-2022',16,6);
insert into Disputa_Gara values ('31-JUL-2022',4,7);
insert into Disputa_Gara values ('31-JUL-2022',14,8);
insert into Disputa_Gara values ('31-JUL-2022',31,9);
insert into Disputa_Gara values ('31-JUL-2022',5,10);
insert into Disputa_Gara values ('31-JUL-2022',18,11);
insert into Disputa_Gara values ('31-JUL-2022',10,12);
insert into Disputa_Gara values ('31-JUL-2022',24,13);
insert into Disputa_Gara values ('31-JUL-2022',47,14);
insert into Disputa_Gara values ('31-JUL-2022',3,15);
insert into Disputa_Gara values ('31-JUL-2022',20,16);
insert into Disputa_Gara values ('31-JUL-2022',23,17);
insert into Disputa_Gara values ('31-JUL-2022',6,18);
insert into Disputa_Gara values ('31-JUL-2022',22,19);
insert into Disputa_Gara values ('31-JUL-2022',77,20);

insert into Disputa_Gara values ('28-AUG-2022',1,1);
insert into Disputa_Gara values ('28-AUG-2022',11,2);
insert into Disputa_Gara values ('28-AUG-2022',55,3);
insert into Disputa_Gara values ('28-AUG-2022',63,4);
insert into Disputa_Gara values ('28-AUG-2022',14,5);
insert into Disputa_Gara values ('28-AUG-2022',16,6);
insert into Disputa_Gara values ('28-AUG-2022',31,7);
insert into Disputa_Gara values ('28-AUG-2022',5,8);
insert into Disputa_Gara values ('28-AUG-2022',10,9);
insert into Disputa_Gara values ('28-AUG-2022',23,10);
insert into Disputa_Gara values ('28-AUG-2022',18,11);
insert into Disputa_Gara values ('28-AUG-2022',4,12);
insert into Disputa_Gara values ('28-AUG-2022',22,13);
insert into Disputa_Gara values ('28-AUG-2022',24,14);
insert into Disputa_Gara values ('28-AUG-2022',3,15);
insert into Disputa_Gara values ('28-AUG-2022',20,16);
insert into Disputa_Gara values ('28-AUG-2022',47,17);
insert into Disputa_Gara values ('28-AUG-2022',6,18);
insert into Disputa_Gara values ('28-AUG-2022',77,19);
insert into Disputa_Gara values ('28-AUG-2022',44,20);

insert into Disputa_Gara values ('04-SEP-2022',1,1);
insert into Disputa_Gara values ('04-SEP-2022',63,2);
insert into Disputa_Gara values ('04-SEP-2022',16,3);
insert into Disputa_Gara values ('04-SEP-2022',44,4);
insert into Disputa_Gara values ('04-SEP-2022',11,5);
insert into Disputa_Gara values ('04-SEP-2022',14,6);
insert into Disputa_Gara values ('04-SEP-2022',4,7);
insert into Disputa_Gara values ('04-SEP-2022',55,8);
insert into Disputa_Gara values ('04-SEP-2022',31,9);
insert into Disputa_Gara values ('04-SEP-2022',18,10);
insert into Disputa_Gara values ('04-SEP-2022',10,11);
insert into Disputa_Gara values ('04-SEP-2022',23,12);
insert into Disputa_Gara values ('04-SEP-2022',47,13);
insert into Disputa_Gara values ('04-SEP-2022',5,14);
insert into Disputa_Gara values ('04-SEP-2022',20,15);
insert into Disputa_Gara values ('04-SEP-2022',24,16);
insert into Disputa_Gara values ('04-SEP-2022',3,17);
insert into Disputa_Gara values ('04-SEP-2022',6,18);
insert into Disputa_Gara values ('04-SEP-2022',77,19);
insert into Disputa_Gara values ('04-SEP-2022',22,20);

insert into Disputa_Gara values ('11-SEP-2022',1,1);
insert into Disputa_Gara values ('11-SEP-2022',16,2);
insert into Disputa_Gara values ('11-SEP-2022',63,3);
insert into Disputa_Gara values ('11-SEP-2022',55,4);
insert into Disputa_Gara values ('11-SEP-2022',44,5);
insert into Disputa_Gara values ('11-SEP-2022',11,6);
insert into Disputa_Gara values ('11-SEP-2022',4,7);
insert into Disputa_Gara values ('11-SEP-2022',10,8);
insert into Disputa_Gara values ('11-SEP-2022',45,9);
insert into Disputa_Gara values ('11-SEP-2022',24,10);
insert into Disputa_Gara values ('11-SEP-2022',31,11);
insert into Disputa_Gara values ('11-SEP-2022',47,12);
insert into Disputa_Gara values ('11-SEP-2022',77,13);
insert into Disputa_Gara values ('11-SEP-2022',22,14);
insert into Disputa_Gara values ('11-SEP-2022',6,15);
insert into Disputa_Gara values ('11-SEP-2022',20,16);
insert into Disputa_Gara values ('11-SEP-2022',3,17);
insert into Disputa_Gara values ('11-SEP-2022',18,18);
insert into Disputa_Gara values ('11-SEP-2022',14,19);
insert into Disputa_Gara values ('11-SEP-2022',5,20);

insert into Disputa_Gara values ('02-OCT-2022',11,1);
insert into Disputa_Gara values ('02-OCT-2022',16,2);
insert into Disputa_Gara values ('02-OCT-2022',55,3);
insert into Disputa_Gara values ('02-OCT-2022',4,4);
insert into Disputa_Gara values ('02-OCT-2022',3,5);
insert into Disputa_Gara values ('02-OCT-2022',18,6);
insert into Disputa_Gara values ('02-OCT-2022',1,7);
insert into Disputa_Gara values ('02-OCT-2022',5,8);
insert into Disputa_Gara values ('02-OCT-2022',44,9);
insert into Disputa_Gara values ('02-OCT-2022',10,10);
insert into Disputa_Gara values ('02-OCT-2022',77,11);
insert into Disputa_Gara values ('02-OCT-2022',20,12);
insert into Disputa_Gara values ('02-OCT-2022',47,13);
insert into Disputa_Gara values ('02-OCT-2022',63,14);
insert into Disputa_Gara values ('02-OCT-2022',22,15);
insert into Disputa_Gara values ('02-OCT-2022',31,16);
insert into Disputa_Gara values ('02-OCT-2022',23,17);
insert into Disputa_Gara values ('02-OCT-2022',14,18);
insert into Disputa_Gara values ('02-OCT-2022',6,19);
insert into Disputa_Gara values ('02-OCT-2022',24,20);

insert into Disputa_Gara values ('09-OCT-2022',1,1);
insert into Disputa_Gara values ('09-OCT-2022',11,2);
insert into Disputa_Gara values ('09-OCT-2022',16,3);
insert into Disputa_Gara values ('09-OCT-2022',31,4);
insert into Disputa_Gara values ('09-OCT-2022',44,5);
insert into Disputa_Gara values ('09-OCT-2022',5,6);
insert into Disputa_Gara values ('09-OCT-2022',14,7);
insert into Disputa_Gara values ('09-OCT-2022',63,8);
insert into Disputa_Gara values ('09-OCT-2022',6,9);
insert into Disputa_Gara values ('09-OCT-2022',4,10);
insert into Disputa_Gara values ('09-OCT-2022',3,11);
insert into Disputa_Gara values ('09-OCT-2022',18,12);
insert into Disputa_Gara values ('09-OCT-2022',22,13);
insert into Disputa_Gara values ('09-OCT-2022',20,14);
insert into Disputa_Gara values ('09-OCT-2022',77,15);
insert into Disputa_Gara values ('09-OCT-2022',24,16);
insert into Disputa_Gara values ('09-OCT-2022',47,17);
insert into Disputa_Gara values ('09-OCT-2022',10,18);
insert into Disputa_Gara values ('09-OCT-2022',55,19);
insert into Disputa_Gara values ('09-OCT-2022',23,20);

insert into Disputa_Gara values ('23-OCT-2022',1,1);
insert into Disputa_Gara values ('23-OCT-2022',44,2);
insert into Disputa_Gara values ('23-OCT-2022',16,3);
insert into Disputa_Gara values ('23-OCT-2022',11,4);
insert into Disputa_Gara values ('23-OCT-2022',63,5);
insert into Disputa_Gara values ('23-OCT-2022',4,6);
insert into Disputa_Gara values ('23-OCT-2022',14,7);
insert into Disputa_Gara values ('23-OCT-2022',5,8);
insert into Disputa_Gara values ('23-OCT-2022',20,9);
insert into Disputa_Gara values ('23-OCT-2022',22,10);
insert into Disputa_Gara values ('23-OCT-2022',31,11);
insert into Disputa_Gara values ('23-OCT-2022',24,12);
insert into Disputa_Gara values ('23-OCT-2022',23,13);
insert into Disputa_Gara values ('23-OCT-2022',10,14);
insert into Disputa_Gara values ('23-OCT-2022',47,15);
insert into Disputa_Gara values ('23-OCT-2022',3,16);
insert into Disputa_Gara values ('23-OCT-2022',6,17);
insert into Disputa_Gara values ('23-OCT-2022',18,18);
insert into Disputa_Gara values ('23-OCT-2022',77,19);
insert into Disputa_Gara values ('23-OCT-2022',55,20);

insert into Disputa_Gara values ('30-OCT-2022',1,1);
insert into Disputa_Gara values ('30-OCT-2022',44,2);
insert into Disputa_Gara values ('30-OCT-2022',11,3);
insert into Disputa_Gara values ('30-OCT-2022',63,4);
insert into Disputa_Gara values ('30-OCT-2022',55,5);
insert into Disputa_Gara values ('30-OCT-2022',16,6);
insert into Disputa_Gara values ('30-OCT-2022',3,7);
insert into Disputa_Gara values ('30-OCT-2022',31,8);
insert into Disputa_Gara values ('30-OCT-2022',4,9);
insert into Disputa_Gara values ('30-OCT-2022',77,10);
insert into Disputa_Gara values ('30-OCT-2022',10,11);
insert into Disputa_Gara values ('30-OCT-2022',23,12);
insert into Disputa_Gara values ('30-OCT-2022',24,13);
insert into Disputa_Gara values ('30-OCT-2022',5,14);
insert into Disputa_Gara values ('30-OCT-2022',18,15);
insert into Disputa_Gara values ('30-OCT-2022',47,16);
insert into Disputa_Gara values ('30-OCT-2022',20,17);
insert into Disputa_Gara values ('30-OCT-2022',6,18);
insert into Disputa_Gara values ('30-OCT-2022',14,19);
insert into Disputa_Gara values ('30-OCT-2022',22,20);

insert into Disputa_Gara values ('12-NOV-2022',63,1);
insert into Disputa_Gara values ('12-NOV-2022',55,2);
insert into Disputa_Gara values ('12-NOV-2022',44,3);
insert into Disputa_Gara values ('12-NOV-2022',1,4);
insert into Disputa_Gara values ('12-NOV-2022',11,5);
insert into Disputa_Gara values ('12-NOV-2022',16,6);
insert into Disputa_Gara values ('12-NOV-2022',4,7);
insert into Disputa_Gara values ('12-NOV-2022',20,8);
insert into Disputa_Gara values ('12-NOV-2022',5,9);
insert into Disputa_Gara values ('12-NOV-2022',10,10);
insert into Disputa_Gara values ('12-NOV-2022',3,11);
insert into Disputa_Gara values ('12-NOV-2022',47,12);
insert into Disputa_Gara values ('12-NOV-2022',24,13);
insert into Disputa_Gara values ('12-NOV-2022',77,14);
insert into Disputa_Gara values ('12-NOV-2022',22,15);
insert into Disputa_Gara values ('12-NOV-2022',18,16);
insert into Disputa_Gara values ('12-NOV-2022',31,17);
insert into Disputa_Gara values ('12-NOV-2022',14,18);
insert into Disputa_Gara values ('12-NOV-2022',6,19);
insert into Disputa_Gara values ('12-NOV-2022',23,20);

insert into Disputa_Gara values ('13-NOV-2022',63,1);
insert into Disputa_Gara values ('13-NOV-2022',44,2);
insert into Disputa_Gara values ('13-NOV-2022',55,3);
insert into Disputa_Gara values ('13-NOV-2022',16,4);
insert into Disputa_Gara values ('13-NOV-2022',14,5);
insert into Disputa_Gara values ('13-NOV-2022',1,6);
insert into Disputa_Gara values ('13-NOV-2022',11,7);
insert into Disputa_Gara values ('13-NOV-2022',31,8);
insert into Disputa_Gara values ('13-NOV-2022',77,9);
insert into Disputa_Gara values ('13-NOV-2022',18,10);
insert into Disputa_Gara values ('13-NOV-2022',5,11);
insert into Disputa_Gara values ('13-NOV-2022',24,12);
insert into Disputa_Gara values ('13-NOV-2022',47,13);
insert into Disputa_Gara values ('13-NOV-2022',10,14);
insert into Disputa_Gara values ('13-NOV-2022',23,15);
insert into Disputa_Gara values ('13-NOV-2022',6,16);
insert into Disputa_Gara values ('13-NOV-2022',22,17);
insert into Disputa_Gara values ('13-NOV-2022',4,18);
insert into Disputa_Gara values ('13-NOV-2022',20,19);
insert into Disputa_Gara values ('13-NOV-2022',3,20);

insert into Disputa_Gara values ('20-NOV-2022',1,1);
insert into Disputa_Gara values ('20-NOV-2022',16,2);
insert into Disputa_Gara values ('20-NOV-2022',11,3);
insert into Disputa_Gara values ('20-NOV-2022',55,4);
insert into Disputa_Gara values ('20-NOV-2022',63,5);
insert into Disputa_Gara values ('20-NOV-2022',4,6);
insert into Disputa_Gara values ('20-NOV-2022',31,7);
insert into Disputa_Gara values ('20-NOV-2022',18,8);
insert into Disputa_Gara values ('20-NOV-2022',3,9);
insert into Disputa_Gara values ('20-NOV-2022',5,10);
insert into Disputa_Gara values ('20-NOV-2022',22,11);
insert into Disputa_Gara values ('20-NOV-2022',24,12);
insert into Disputa_Gara values ('20-NOV-2022',23,13);
insert into Disputa_Gara values ('20-NOV-2022',10,14);
insert into Disputa_Gara values ('20-NOV-2022',77,15);
insert into Disputa_Gara values ('20-NOV-2022',47,16);
insert into Disputa_Gara values ('20-NOV-2022',20,17);
insert into Disputa_Gara values ('20-NOV-2022',44,18);
insert into Disputa_Gara values ('20-NOV-2022',6,19);
insert into Disputa_Gara values ('20-NOV-2022',14,20);

-- Si_Ritira (in ordine dal primo ritirato di ogni gara)
insert into Si_Ritira values ('20-MAR-2022',10,'44','Guasto');
insert into Si_Ritira values ('20-MAR-2022',1,'54','Guasto');
insert into Si_Ritira values ('20-MAR-2022',11,'56','Incidente');
insert into Si_Ritira values ('27-MAR-2022',47,'0','Incidente');
insert into Si_Ritira values ('27-MAR-2022',22,'0','Guasto');
insert into Si_Ritira values ('27-MAR-2022',6,'14','Incidente');
insert into Si_Ritira values ('27-MAR-2022',3,'35','Guasto');
insert into Si_Ritira values ('27-MAR-2022',14,'35','Guasto');
insert into Si_Ritira values ('27-MAR-2022',77,'36','Guasto');
insert into Si_Ritira values ('27-MAR-2022',23,'47','Incidente');
insert into Si_Ritira values ('10-APR-2022',55,'1','Incidente');
insert into Si_Ritira values ('10-APR-2022',5,'22','Incidente');
insert into Si_Ritira values ('10-APR-2022',1,'38','Guasto');
insert into Si_Ritira values ('23-APR-2022',24,'0','Incidente');
insert into Si_Ritira values ('24-APR-2022',55,'0','Incidente');
insert into Si_Ritira values ('24-APR-2022',14,'6','Incidente');
insert into Si_Ritira values ('08-MAY-2022',24,'6','Guasto');
insert into Si_Ritira values ('08-MAY-2022',4,'39','Incidente');
insert into Si_Ritira values ('08-MAY-2022',10,'45','Guasto');
insert into Si_Ritira values ('08-MAY-2022',5,'54','Incidente');
insert into Si_Ritira values ('08-MAY-2022',20,'56','Incidente');
insert into Si_Ritira values ('22-MAY-2022',16,'27','Guasto');
insert into Si_Ritira values ('22-MAY-2022',24,'28','Guasto');
insert into Si_Ritira values ('29-MAY-2022',20,'19','Guasto');
insert into Si_Ritira values ('29-MAY-2022',47,'24','Incidente');
insert into Si_Ritira values ('29-MAY-2022',23,'48','Guasto');
insert into Si_Ritira values ('12-JUN-2022',55,'8','Guasto');
insert into Si_Ritira values ('12-JUN-2022',16,'21','Guasto');
insert into Si_Ritira values ('12-JUN-2022',24,'23','Guasto');
insert into Si_Ritira values ('12-JUN-2022',20,'31','Guasto');
insert into Si_Ritira values ('12-JUN-2022',18,'46','Guasto');
insert into Si_Ritira values ('19-JUN-2022',11,'7','Guasto');
insert into Si_Ritira values ('19-JUN-2022',47,'18','Guasto');
insert into Si_Ritira values ('19-JUN-2022',22,'47','Incidente');
insert into Si_Ritira values ('03-JUL-2022',23,'0','Incidente');
insert into Si_Ritira values ('03-JUL-2022',24,'0','Incidente');
insert into Si_Ritira values ('03-JUL-2022',63,'0','Incidente');
insert into Si_Ritira values ('03-JUL-2022',77,'20','Guasto');
insert into Si_Ritira values ('03-JUL-2022',10,'26','Guasto');
insert into Si_Ritira values ('03-JUL-2022',31,'37','Guasto');
insert into Si_Ritira values ('09-JUL-2022',14,'0','Guasto');
insert into Si_Ritira values ('09-JUL-2022',5,'21','Incidente');
insert into Si_Ritira values ('10-JUL-2022',11,'24','Incidente');
insert into Si_Ritira values ('10-JUL-2022',6,'48','Guasto');
insert into Si_Ritira values ('10-JUL-2022',55,'56','Guasto');
insert into Si_Ritira values ('24-JUL-2022',22,'17','Guasto');
insert into Si_Ritira values ('24-JUL-2022',16,'17','Incidente');
insert into Si_Ritira values ('24-JUL-2022',20,'37','Incidente');
insert into Si_Ritira values ('24-JUL-2022',6,'40','Incidente');
insert into Si_Ritira values ('24-JUL-2022',24,'47','Guasto');
insert into Si_Ritira values ('31-JUL-2022',77,'65','Guasto');
insert into Si_Ritira values ('28-AUG-2022',44,'0','Incidente');
insert into Si_Ritira values ('28-AUG-2022',77,'1','Incidente');
insert into Si_Ritira values ('04-SEP-2022',22,'43','Guasto');
insert into Si_Ritira values ('04-SEP-2022',77,'53','Guasto');
insert into Si_Ritira values ('11-SEP-2022',5,'10','Guasto');
insert into Si_Ritira values ('11-SEP-2022',14,'31','Guasto');
insert into Si_Ritira values ('11-SEP-2022',18,'39','Guasto');
insert into Si_Ritira values ('11-SEP-2022',3,'45','Guasto');
insert into Si_Ritira values ('02-OCT-2022',24,'6','Incidente');
insert into Si_Ritira values ('02-OCT-2022',6,'7','Incidente');
insert into Si_Ritira values ('02-OCT-2022',14,'20','Guasto');
insert into Si_Ritira values ('02-OCT-2022',23,'25','Incidente');
insert into Si_Ritira values ('02-OCT-2022',31,'26','Guasto');
insert into Si_Ritira values ('02-OCT-2022',22,'34','Incidente');
insert into Si_Ritira values ('09-OCT-2022',23,'0','Guasto');
insert into Si_Ritira values ('09-OCT-2022',55,'0','Incidente');
insert into Si_Ritira values ('23-OCT-2022',55,'1','Incidente');
insert into Si_Ritira values ('23-OCT-2022',77,'16','Incidente');
insert into Si_Ritira values ('23-OCT-2022',18,'21','Incidente');
insert into Si_Ritira values ('30-OCT-2022',22,'50','Incidente');
insert into Si_Ritira values ('30-OCT-2022',14,'62','Guasto');
insert into Si_Ritira values ('12-NOV-2022',23,'12','Guasto');
insert into Si_Ritira values ('13-NOV-2022',3,'0','Incidente');
insert into Si_Ritira values ('13-NOV-2022',20,'0','Incidente');
insert into Si_Ritira values ('13-NOV-2022',4,'50','Guasto');
insert into Si_Ritira values ('20-NOV-2022',14,'27','Guasto');
insert into Si_Ritira values ('20-NOV-2022',6,'55','Guasto');
insert into Si_Ritira values ('20-NOV-2022',44,'55','Guasto');