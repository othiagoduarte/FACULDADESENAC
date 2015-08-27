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
valor decimal(9,2) not null,
infracao char(10) references ex_categoriaMulta(infracao) not null,
DataInfracao DATE default NOW()
);

insert into ex_motorista values
('123AB', 'Carlo');

create table ex_categoriaMulta(

infracao char(10) primary key,
pontos integer not null,
valorMulta decimal(9,2) not null

)

create table ex_excessovelocidade(
id serial primary key,
infracao char(10) references ex_categoriaMulta(infracao) not null,
velocidadeInicial decimal(5,2) not null,
velocidadeFinal decimal(5,2) not null
)

insert into ex_categoriaMulta(infracao,pontos,valorMulta)
    values('GRAVE',60,680);
insert into ex_categoriaMulta(infracao,pontos,valorMulta)
    values('MEDIA',40,350);
insert into ex_categoriaMulta(infracao,pontos,valorMulta)
    values('LEVE',20,120);

insert into ex_excessovelocidade (infracao,velocidadeInicial,velocidadeFinal)
values('GRAVE',140.1,999);

insert into ex_excessovelocidade (infracao,velocidadeInicial,velocidadeFinal)
values('MEDIA',110.01,140);

insert into ex_excessovelocidade (infracao,velocidadeInicial,velocidadeFinal)
values('LEVE',80.01,110);
