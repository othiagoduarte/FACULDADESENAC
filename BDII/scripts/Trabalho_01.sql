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
		
	Begin		
		--Teste 
		V_NomeMotorista:= 'Thiago Duarte';
		--Teste 
		V_VelocidadeApurada:= P_velocidade * 0.90; -- 90% da velocidade apurada
		
		--Calcular valor da multa	
		
		Case 
		
			When V_VelocidadeApurada Between 80.01 And 110 Then
				V_Multa:= 120;	
				V_Pontos:=20;
			When V_VelocidadeApurada Between 110.01 And 140 Then
				V_Multa:= 350;	
				V_Pontos:=40;
			When V_VelocidadeApurada > 140 Then
				V_Multa:= 680;
				V_Pontos:=60;
			Else
				V_Multa:= 0;
				V_Pontos:=0;	
		End Case;
		
		If V_Multa > 0 Then
			
			Select Nome into V_NomeMotorista
			  From ex_motorista
			 Where Cnh = P_cnh;

			Insert Into ex_multa(cnh,velocidadeApurada,velocidadeCalculada,pontos,valor)
			Values(P_cnh, P_velocidade,V_VelocidadeApurada,V_pontos,V_Multa); 
			
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