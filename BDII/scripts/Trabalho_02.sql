--Criação dos objetos - Definido no trabalho
CREATE TABLE HOSPEDE (
 codHospede SERIAL NOT NULL ,
 nome VARCHAR(50) ,
 cidade VARCHAR(50) ,
 dataNascimento DATE ,
PRIMARY KEY(codHospede));
CREATE TABLE ATENDENTE (
 codAtendente SERIAL NOT NULL ,
 codSuperior INTEGER NOT NULL ,
 nome VARCHAR(50) ,
PRIMARY KEY(codAtendente),
 FOREIGN KEY(codSuperior)
 REFERENCES ATENDENTE(codAtendente));
CREATE INDEX IFK_Rel_01 ON ATENDENTE (codSuperior);
CREATE TABLE HOSPEDAGEM (
 codHospedagem SERIAL NOT NULL ,
 codAtendente INTEGER NOT NULL ,
 codHospede INTEGER NOT NULL ,
 dataEntrada DATE ,
 dataSaida DATE ,
 numQuarto INTEGER ,
 valorDiaria DECIMAL(9,2) ,
PRIMARY KEY(codHospedagem),
 FOREIGN KEY(codHospede)
 REFERENCES HOSPEDE(codHospede),
 FOREIGN KEY(codAtendente)
 REFERENCES ATENDENTE(codAtendente));
CREATE INDEX IFK_Rel_02 ON HOSPEDAGEM (codHospede);
CREATE INDEX IFK_Rel_03 ON HOSPEDAGEM (codAtendente);


--Criação dos objetos desenvolvidos para entrega do trabalho
create table cidade(
	id serial primary key,
	nome varchar(30)
);

Create or Replace Function FN_DataNacimentoAleatoria(P_MinIdade integer , P_MaxIdade integer) 
Returns date AS 
$$
Declare

	V_idade integer;
	V_intervalo char(10);
	V_ano integer;
begin 

	V_idade:= P_MinIdade + trunc( random() * P_MaxIdade - P_MinIdade);
	V_ano = date_part('year' , now() ) - V_idade ;

return round (random() *27)+1||'/'||round (random() *11)+1|| '/'|| V_ano ;

end ;

$$ 
Language PlpgSQL;