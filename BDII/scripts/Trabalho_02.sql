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
  
CREATE OR REPLACE FUNCTION fn_inserirhospedes(p_qtd integer, p_minidade integer, p_maxidade integer)
  RETURNS character varying AS
$BODY$
Declare
	
begin 

	if P_MinIdade < 18 OR P_MinIdade > 65 then
		raise notice 'Idade mínima inválida';
	end if;

	if P_MaxIdade < 18 OR P_MaxIdade > 65 then
		raise notice 'Idade máxima inválida';
	end if;

	if P_MinIdade >= P_MaxIdade  then
		raise notice 'Idade mínima deve ser maior que a idade máxima';
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
CREATE OR REPLACE FUNCTION fn_preenhcerhospedagen(p_qtd integer, p_dataInicial date ,p_dataFinal date )
  RETURNS varchar AS
$$
declare

	V_dataEntrada date;
	V_dataSaida date;
	V_diferenca integer;
	V_quartos integer[]; 
	V_numAux integer;
	cur_hospedes refCursor;
	v_codHospede integer;
	v_codAtendente integer;
	
begin 

	begin --Validação dos parâmetros de entrada - Inicio
		if p_qtd is null then
			RAISE EXCEPTION 'a quantidade não pode ser nula ';
		end if;
		
		if p_qtd <= 0 then
			RAISE EXCEPTION 'a quantidade tem que ser maior que ZERO';
		end if;

		if p_dataInicial is null then
			RAISE EXCEPTION 'Data inicial não pode ser nula';
		end if;
		
		if p_dataFinal is null then
			RAISE EXCEPTION 'Data final não pode ser nula';
		end if;
		
		if p_dataInicial >= p_dataFinal then
			RAISE EXCEPTION 'Data inicial tem que ser menor que a data final';
		end if;
	end;--Validação dos parâmetros de entrada - Fim

	Begin 

		open cur_hospedes

		for
			select codHospede 
			 from Hospede h1
			where not exists (select 'N' from Hospedagem h2
					    where h2.codHospede = h1.CodHospede
					 ) 
			order by random()
			limit p_qtd;
				
		for i in 1.. 200 loop

			V_quartos[i]:= 100 + coalesce((select max(numQuarto) from hospedagem ),0) +  i;
			
		end loop;
				
		For i in 1..p_qtd loop

			FETCH cur_hospedes INTO v_codHospede;

			select codAtendente into v_codAtendente
			 from atendente
			 order by random()
			 limit 1;

			V_diferenca:= trunc((random ()* (p_dataFinal - p_dataInicial))) + 1;
			v_dataEntrada:= (p_dataInicial + V_diferenca);

			V_diferenca:= trunc((random ()* (p_dataFinal - v_dataEntrada))) + 1;
			v_dataSaida:= (v_dataEntrada + V_diferenca);
	
			If ( i % 3) = 0 then
				v_dataSaida:= null;
				raise notice 'Data Entrada:% Data saida: % Numero do quarto% hospede: % Atendente: %',v_dataEntrada,v_dataSaida, V_quartos[i], v_codHospede,v_codAtendente;
			else
				raise notice 'Data Entrada:% Data saida: % Numero do quarto% hospede: % Atendente: %',v_dataEntrada,v_dataSaida, V_quartos[i],v_codHospede,v_codAtendente;
			end if;
			
			insert into Hospedagem( codAtendente, codHospede, DataEntrada ,DataSaida, numQuarto,valorDiaria)
			values( v_codAtendente,v_codHospede,v_dataEntrada, v_dataSaida,V_quartos[i],0);
			
		End loop;

		close cur_hospedes;
		
		commit;
		
	End;

return 'Sucesso ao inserir';

End;

$$
LANGUAGE plpgsql;
create or replace Function FN_atualizarHospedagem(P_codHospedagem  integer, P_codAtendente integer, P_datasaida date ,P_valorDiaria decimal)
returns integer as
$$
declare

V_sql varchar(1000);
V_alteracao varchar(200);
v_total integer;
begin

	if (P_codHospedagem is null ) then
		raise exception 'Codigo da hospedagem invalido. O valor não pode ser nulo';
	end if;  
	
	if (P_codatendente <= 0) then
		raise exception 'Codigo da hospedagem invalido. O valor tem que ser maior que ZERO';
	end if;

	if (P_codAtendente is not null) and P_codAtendente > 0  then
	
		perform codAtendente from  Atendente where codAtendente = P_codAtendente; 

		if not Found then
			raise exception 'O codigo do atentende informado não existe';
		end if;
		
	end if;

		 
	V_alteracao:= '';	
	if P_codAtendente  is not null then
		V_alteracao:= V_alteracao ||' codAtendente = '||P_codAtendente;
	End if;

	if P_datasaida is not null then
		V_alteracao:= V_alteracao || ', datasaida = ' ||QUOTE_LITERAL(P_datasaida);
	end if;

	if P_valorDiaria is not null then
		V_alteracao:= V_alteracao || ',valorDiaria = '||P_valorDiaria ;
	end if;
	
	V_sql:= ' UPDATE HOSPEDAGEM SET';
	V_sql:= V_sql || V_alteracao; 
	V_sql:= V_sql || ' WHERE CODHOSPEDAGEM = ' ||P_codHospedagem ;

	execute V_sql;
	
	raise notice 'query %',V_sql;
	
	GET DIAGNOSTICS v_total = ROW_COUNT;
	return v_total;
end;
$$
language
plPGsql;

--Cosultas - 1

	select h2.Nome as NomeHospede
		  ,a.Nome as NomeAtendente
		  ,h1.NumQuarto
		  ,((h1.DataSaida - h1.DataEntrada) * h1.ValorDiaria) as ValorHospedagem
	  from hospedagem h1
	 inner join hospede h2 on h2.CodHospede = h1.CodHospede
				  and h2.DataNascimento < ( now() - ( interval '21 YEAR' ))
	 inner join Atendente a on a.CodAtendente = h1.CodAtendente
	 where h1.DataSaida is not null
	   and exists ( select h3.DataEntrada
					from hospedagem h3
				   inner join hospede h4 on h4.CodHospede = h3.CodHospede
											and h4.DataNascimento between ( now() - ( interval '45 YEAR' )) and ( now() - ( interval '40 YEAR' ))
				   where h1.DataEntrada > h3.DataEntrada 
			   )
	 order by ((h1.DataSaida - h1.DataEntrada) * h1.ValorDiaria) ,h2.Nome
	 limit 10
			 
--Cosultas - 2			 

select to_char(DataSaida ,'YYYYMM') Periodo
      ,sum( (h.dataSaida - h.DataEntrada) * h.valorDiaria) valorTotal
      ,upper(a2.Nome) as Superior
  from hospedagem h 
  inner join atendente a on a.codAtendente = h.codAtendente
  inner join atendente a2 on a2.CodAtendente = a.CodSuperior
  where dataSaida is not null  
    and dataSaida not between '01/06/2015' and '30/07/2015'
    and ((h.dataSaida - h.DataEntrada) * h.valorDiaria) > (select trunc(avg((h3.dataSaida - h3.DataEntrada) * h3.valorDiaria)) 
							    from hospedagem h3 
					                   where h3.DataSaida is not null
                                                           limit 10
							 )
 group by to_char(DataSaida ,'YYYYMM') ,a2.Nome
 order by to_char(DataSaida ,'YYYYMM')
 --Consulta - 3
 
 select h2.Nome
      ,sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria) valorTotal
      ,case
	when (sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria)) between 0 and 1000 then
	'E'
	when (sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria)) between 1000.01 and 3000.00 then
	'D'
	when (sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria)) between 3000.01  and 7000.00 then
	'C'
	when (sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria)) between 7001.00  and 10000 then
	'B'
	when (sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria)) > 10000 then
	'10'
	else
	'N'
      end as Classe 	
  from hospedagem h1
 inner join hospede h2 on h2.CodHospede = h1.CodHospede
 inner join Atendente a on a.CodAtendente = h1.CodAtendente
		       and ( substring(h2.Cidade,1,1) in ('A','M')
		           or exists ( select h5.Nome
					 from hospedagem h4
					inner join Hospede h5 on h5.CodHospede = h4.CodHospede
		                                             and h5.Nome like '%FABIO%'
		                                             and h5.codHospede = h2.codHospede 
					where h4.DataEntrada > ( now() - interval '30 DAYS' )
					) 
		          )
 where h1.DataEntrada > '01/01/2010'
 group by h2.Nome
 order by Classe, Nome
 
 ;
 select h2.Cidade
       ,(sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria)) valorTotal	
  from hospedagem h1
 inner join hospede h2 on h2.CodHospede = h1.CodHospede
 where h1.DataSaida is not null
 group by h2.Cidade
 having ((sum( (h1.dataSaida - h1.DataEntrada) * h1.valorDiaria))  in (select (sum( (h4.dataSaida - h4.DataEntrada) * h4.valorDiaria)) valorTotal	
								       from hospedagem h4
								      inner join hospede h3 on h3.CodHospede = h4.CodHospede
								      where h4.DataSaida is not null
								      group by h3.Cidade	
								      order by valorTotal desc
								     limit 3)
	)
 order by valorTotal desc
 ;
 select a1.Nome NomeAtendente, a2.Nome as NomeSuperior , Count(h1.CodHospedagem) Atendimento
  from Atendente a1 
 left join Hospedagem h1 on a1.CodAtendente = h1.CodAtendente 
			and h1.DataEntrada > (( now() - interval '30 DAY' ))
 inner join Atendente a2 on a2.CodAtendente = a1.CodSuperior
 group by a2.CodAtendente ,a1.CodAtendente 
 order by Atendimento desc 

