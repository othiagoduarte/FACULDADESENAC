/*Limpar tabelas*/
drop table Xitensvenda;
drop table Xvenda;
drop table Xcliente;
drop table Xproduto;
drop table Xtipospagamento;

/*Criação das tabelas*/
create table Xproduto(
	 codproduto int not null
	,descricaoproduto varchar(50) not null
	,unidade char(2) not null
	,preco float not null
	--Chave primária - codproduto
);

alter table Xproduto
  add primary key (codproduto);

create table Xcliente(
	codcliente int not null
	,cliente varchar(50) not null
	,cpf char(11) not null
	,endereco char(30) not null
	--chave primária - codcliente
);

alter table Xcliente
  add primary key (codcliente);

create table Xtipospagamento(
	codtppagamento int not null
	,descricaotppagamento varchar(20) not null
	--chave primária - codtppagamento
);

alter table Xtipospagamento
  add primary key (codtppagamento);

create table Xvenda(
	nnf int not null
	,dtvenda date not null
	,codcliente int not null
	,codtppagamento int not null
	,vlvenda float not null
	--chave primária – nnf, dtvenda
	--chave estrangeira – codcliente da tabela de cliente
	--chave estrangeira – codtppagamento da tabela de tipospagamento
);

alter table Xvenda
  add primary key (nnf, dtvenda);

alter table Xvenda
  add foreign key (codcliente) references  Xcliente;

alter table Xvenda
  add foreign key (codtppagamento) references Xtipospagamento;

create table Xitensvenda(
	nnf int not null
	,dtvenda date not null
	,codproduto int not null
	,qtde float not null
	--chave primária – nnf, dtvenda, codproduto
	--chave estrangeira – nnf, dtvenda da tabela de venda
	--chave estrangeira – codproduto da tabela de produt
);

alter table Xitensvenda
  add primary key ( nnf, dtvenda, codproduto);

alter table Xitensvenda
  add foreign key (nnf, dtvenda) references Xvenda;

alter table Xitensvenda
  add foreign key (codproduto) references Xproduto;


/*Popular dados na base - Inicio*/
insert into Xproduto values (1, 'Coca Cola', 'lt', 1.20);
insert into Xproduto values (2, 'Presunto Sadia', 'kg', 5.40);
insert into Xproduto values (3, 'Sabonete Palmolive', 'un', 0.65);
insert into Xproduto values (4, 'Shampoo Colorama', 'un', 2.60);
insert into Xproduto values (5, 'Cerveja Skol', 'gf', 0.99);
insert into Xcliente values (1, 'Joao da Silva', '123456789', 'Rua Andradas, 250');
insert into Xcliente values (2, 'Maria do Rosario', '26547899', 'Rua Lima e Silva, 648');
insert into Xcliente values (3, 'Paulo Silveira', '8963254', 'Rua Plinio Brasil Milano, 980');
insert into Xcliente values (4, 'Rosa Aparecida dos Santos', '5896332123', 'Av Ipiranga, 8960');
insert into Xtipospagamento values (1, 'Cheque');
insert into Xtipospagamento values (2, 'Dinheiro');
insert into Xtipospagamento values (3, 'Crediario');
insert into Xvenda values (1, '20/04/2002', 1, 1, 15.00);
insert into Xvenda values (2, '20/04/2002', 2, 1, 7.50);
insert into Xvenda values (1, '25/04/2002', 3, 2, 7.90);
insert into Xvenda values (1, '30/04/2002', 3, 2, 8.50);
insert into Xitensvenda values (1, '20/04/2002', 1, 1);
insert into Xitensvenda values (1, '20/04/2002', 2, 2);
insert into Xitensvenda values (2, '20/04/2002', 1, 3);
insert into Xitensvenda values (2, '20/04/2002', 2, 2);
insert into Xitensvenda values (2, '20/04/2002', 4, 4);
insert into Xitensvenda values (1, '25/04/2002', 3, 9);
insert into Xitensvenda values (1, '30/04/2002', 3, 7);
/*Popular dados na base - fim*/