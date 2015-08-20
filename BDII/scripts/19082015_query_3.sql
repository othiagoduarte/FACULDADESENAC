create table ex_motorista
(cnh char(5) primary key,
nome varchar(20) not null,
totalMultas decimal(9,2) );

create table ex_multa
(id serial primary key,
cnh char(5) references ex_motorista(cnh) not null,
velocidadeApurada decimal(5,2) not null,
velocidadeCalculada decimal(5,2),
pontos integer not null,
valor decimal(9,2) not null);

insert into ex_motorista values
('123AB', 'Carlo');
