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

	V_idade:= P_MinIdade + trunc( random() * (P_MaxIdade - P_MinIdade));
	V_ano = date_part('year' , now() ) - V_idade ;

return round (random() *27)+1||'/'||round (random() *11)+1|| '/'|| V_ano ;

end ;

$$ 
Language PlpgSQL;
Create or Replace Function FN_CidadeAleatoria ()
Returns varchar AS 
$$
Declare
	V_Cidade integer;
begin 

	select nome into V_Cidade from cidade order by random() limit 1;
	return V_Cidade;

end ;

$$ 
Language PlpgSQL;
Create or Replace Function FN_NomeAleatorio( ) 
Returns varchar AS 
$$
declare

 V_nome varchar(20)[15]:= '{"Maria","Mario","Ana","Jose","João","Joaquim","Daiane","Marcio","Carlos","Gilberto","Julia","Juliana","Carolina","Alfredo","Barbara"}';
 V_sobreNome varchar(20)[10]:= '{"Santos","Silva","Souza","Mello","Lima","Hunter","Camargo","Duarte","Antunes","Ferreira"}';
	
begin 

	return V_nome[ trunc((random() * 14)) + 1] || ' ' ||V_sobreNome[trunc(random() * 9) + 1];

end;
$$ 
Language PlpgSQL;

CREATE OR REPLACE FUNCTION fn_inserirAtendente(p_qtd integer)
  RETURNS character varying AS
$BODY$

declare 

v_int integer;

begin 

	select Count(*) into v_int from Atendente  where codAtendente = 1;

	if not FOUND then 
		insert into Atendente ( codAtendente,nome,codSuperior)
		     values(1,FN_NomeAleatorio(),1);
	end if ;

	FOR i IN 1..(P_qtd - 1 )LOOP

		insert into Atendente ( nome
					,codSuperior
				    )
			     values(	FN_NomeAleatorio()
					,1					
				    );
	END LOOP;


	return 'Sucesso ao inserir';

end ;

$BODY$
  LANGUAGE plpgsql;
  -- Function: fn_inserirhospedes(integer, integer, integer)

-- DROP FUNCTION fn_inserirhospedes(integer, integer, integer);

CREATE OR REPLACE FUNCTION fn_inserirhospedes(p_qtd integer, p_minidade integer, p_maxidade integer)
  RETURNS character varying AS
$BODY$
Declare
	
begin 

	if P_MinIdade < 18 OR P_MinIdade > 65 then

		return 'Idade mínima inválida';

	end if;

	if P_MaxIdade < 18 OR P_MaxIdade > 65 then

		return 'Idade máxima inválida';

	end if;

	if P_MinIdade >= P_MaxIdade  then

		return 'Idade mínima deve ser maior que a idade máxima';

	end if;

	FOR i IN 1..P_qtd LOOP

		insert into Hospede (  	 nome
					,cidade
					,dataNascimento
				    )
			     values(	FN_NomeAleatorio()
					,FN_CidadeAleatoria()
					,FN_DataNacimentoAleatoria(P_MinIdade,P_MaxIdade)
				    );
	END LOOP;

	

	return 'Sucesso ao inserir';

end ;

$BODY$
  LANGUAGE plpgsql;
