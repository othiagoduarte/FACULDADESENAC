/*
1 – Selecionar o nome do cliente e quantidade de produtos comprados, somente para clientes que compraram Coca Cola.
2 – Selecionar o nome do cliente e o valor total comprado por ele.
3 – Selecionar a descrição e o maior preço de produto vendido.
4 – Selecionar o nome do cliente e descrição do tipo de pagamento utilizado nas vendas.
5 – Selecionar o nome do cliente, nnf, data da venda, descrição do tipo de pagamento, descrição do produto e quantidade vendida dos itens vendidos.
6 – Selecionar a média de preço dos produtos vendidos.
7 – Selecionar o nome do cliente e a descrição dos produtos comprados por ele. Não repetir os dados (distinct)
8 – Selecionar a descrição do tipo de pagamento, e a maior data de venda que utilizou esse tipo de pagamento. Ordenar a consulta pela descrição do tipo de pagamento.
9 – Selecionar a data da venda e a média da quantidade de produtos vendidos. Ordenar pela data da venda decrescente.
10 – Selecionar a descrição do produto e a média de quantidades vendidas do produto. Somente se a média for superior a 4
*/

--Query 01
select cli.CLiente
    , (select sum(its2.qtde) 
	 from xItensVenda its2 
        where its2.nnf = vd.nnf 
          and its2.dtVenda = vd.dtVenda 
      )as qtdProduto
  from xCliente cli
inner join xVenda vd on vd.CodCliente = cli.codcliente
inner join xItensVenda its on its.nnf = vd.nnf
			  and its.dtVenda = vd.dtVenda
inner join xProduto pd on pd.CodProduto = its.CodProduto
		      and upper(pd.DescricaoProduto) like Upper('%COCA COLA%')

--Query 02

select cli.CLiente, sum(vd.VlVenda)
  from xCliente cli
inner join xVenda vd on vd.CodCliente = cli.codcliente
group by cli.CLiente

--Query 03

select pd.DescricaoProduto ,pd.Preco
  from xVenda vd
 inner join xItensVenda its on its.nnf = vd.nnf
			  and its.dtVenda = vd.dtVenda
 inner join xProduto pd on pd.CodProduto = its.CodProduto
 group by pd.DescricaoProduto,pd.preco
 having pd.preco = (select max(pd1.Preco)from xproduto pd1)

--Query 04

select cli.Cliente, tp.DescricaotpPagamento
  from xCliente cli
inner join xVenda vd on vd.CodCliente = cli.codcliente
inner join xTiposPagamento tp on tp.codtpPagamento = vd.codTpPagamento 
		

--query 05

select cli.Cliente
      ,vd.nnf
      ,vd.dtVenda
      ,tp.DescricaotpPagamento
      ,pd.DescricaoProduto
      ,its.qtde
  from xCliente cli
inner join xVenda vd on vd.CodCliente = cli.codcliente
inner join xItensVenda its on its.nnf = vd.nnf
			  and its.dtVenda = vd.dtVenda
inner join xProduto pd on pd.CodProduto = its.CodProduto
inner join xTiposPagamento tp on tp.codtpPagamento = vd.codTpPagamento
group by cli.Cliente
	,vd.nnf
	,vd.dtVenda
	,tp.DescricaotpPagamento
	,pd.DescricaoProduto 
	,its.qtde
order by cli.Cliente
	,vd.nnf
	,vd.dtVenda
	,tp.DescricaotpPagamento
	,pd.DescricaoProduto 

--query 06

select round(cast( avg(pd.Preco) as numeric),2) as media
  from xCliente cli
inner join xVenda vd on vd.CodCliente = cli.codcliente
inner join xItensVenda its on its.nnf = vd.nnf
			  and its.dtVenda = vd.dtVenda
inner join xProduto pd on pd.CodProduto = its.CodProduto

--Query 07
select distinct cli.Cliente
      ,pd.DescricaoProduto
 from xCliente cli
inner join xVenda vd on vd.CodCliente = cli.codcliente
inner join xItensVenda its on its.nnf = vd.nnf
			  and its.dtVenda = vd.dtVenda
inner join xProduto pd on pd.CodProduto = its.CodProduto
group by cli.Cliente
	,pd.DescricaoProduto 
order by cli.Cliente


--query 08
select tp.DescricaotpPagamento,vd.DtVenda
  from xVenda vd
inner join xTiposPagamento tp on tp.codtpPagamento = vd.codTpPagamento		
group by tp.DescricaotpPagamento,vd.DtVenda
having vd.DtVenda = (select max(vd1.dtVenda) from xvenda vd1 where vd1.codtppagamento =  vd.codtppagamento)

