Create or Replace Function FN_AplicarMulta(P_CNH Varchar(20) , P_velocidade Decimal) 
Returns Varchar(100) AS 
$$
	Declare

		V_Mensagem Varchar(100);
		V_NomeMotorista Varchar(100);
		V_Multa Decimal;
		V_MultaTotal Decimal;
		V_VelocidadeApurada Decimal;
		V_Pontos Integer;
		V_Infracao varchar(10);
		
	Begin		
		V_VelocidadeApurada:= P_velocidade * 0.90; -- 90% da velocidade apurada
		V_pontos:= 0;
		V_Multa:= 0;
		
                select c.Pontos, c.valorMulta , c.Infracao
		  into V_pontos,V_Multa ,V_Infracao
                  from ex_excessovelocidade e
		 inner join ex_categoriaMulta c on c.Infracao = e.Infracao
		  where V_VelocidadeApurada between  e.VelocidadeInicial and e.VelocidadeFinal;
		
		If V_Multa > 0 Then
			
			Select Nome into V_NomeMotorista
			  From ex_motorista
			 Where Cnh = P_cnh;

			Insert Into ex_multa(cnh,velocidadeApurada,velocidadeCalculada,pontos,valor,Infracao)
			Values(P_cnh, P_velocidade,V_VelocidadeApurada,V_pontos,V_Multa,V_Infracao); 
			
			Select Sum(Pontos)
			  Into V_MultaTotal 
			  from ex_multa
			 Where Cnh = P_cnh;  


			V_Mensagem:= 'O motorista '||V_NomeMotorista||' soma '||V_MultaTotal||' pontos em multas';
		End If;

		Return V_Mensagem;

	End;
$$ 
Language PlpgSQL;
Create or Replace Function FN_AtualiarTotalMultas() 
Returns Varchar(100) AS 
$$
	Declare
	
	V_Mensagem varchar(100);
	V_Cursor RECORD; 
	
	Begin		
				
		for V_Cursor in (select Mo.CNH , sum( COALESCE(mu.valor,0) ) as Total   
		                   from ex_motorista mo
                                   Left join ex_multa mu on mu.CNH = mo.CNH
                                  group by Mo.CNH 
				)
		loop
			begin
			
				update ex_motorista
				  set totalMultas = V_Cursor.Total
				where cnh = V_Cursor.cnh; 

			End;
			
		end loop;
		
		V_Mensagem:= 'Atualização realizada com sucesso';
				
		Return V_Mensagem;
	
	End;
$$ 
Language PlpgSQL;

Create or Replace Function FN_ConsultaPontosValor() 
Returns setof  record AS 
$$

 	
select mu.Infracao, sum(valor) totalPontos
  from ex_motorista mo
 inner join ex_Multa mu on mu.CNH = mo.CNH
 group by mu.Infracao;
	
$$ 
Language sql;


Create or Replace Function FN_ConsultaInfracaoPontosValor() 
Returns setof  record AS 
$$

<<<<<<< HEAD
begin 
	return 
=======
>>>>>>> a3ddc1582bfda12738cba445ea521d51d5c2ab0c
         select Count(*) as TotalInfracao,mu.Infracao, DataInfracao,sum(pontos) totalPontos
	   from ex_motorista mo
	   inner join ex_Multa mu on mu.CNH = mo.CNH
	   group by mu.Infracao, DataInfracao;

$$ 
Language sql;
