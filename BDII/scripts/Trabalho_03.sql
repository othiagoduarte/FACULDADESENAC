
create table tr_emp (
idEmp integer primary key,
nome varchar(50) not null,
maxSal decimal(9,2) not null check (maxSal > 0),
dth_inc timestamp,
usu_inc varchar(20),
dth_atu timestamp,
usu_atu varchar(20));

create table tr_sal_emp
(idSal_emp integer primary key,
idEmp integer references tr_emp(idEmp) not null,
dtIni date not null,
dtFim date null check (dtFim > dtIni),
sal decimal(9,2) NOT NULL CHECK (sal > 0),
usu_inc varchar(20),
dth_inc timestamp,
usu_atu varchar(20),
dth_atu timestamp);

create table tr_promovido
( anoMes integer primary key,
qtd integer check (qtd > 0));