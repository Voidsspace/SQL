select * from categorias;
select * from produtos;

select * from produtos;
select count(*) as vendas_totais from vendas;

select count(*) from vendas where strftime('%m', data_venda) = '11'

-- Tratamento de valores de dados para ajustar valor de venda de produtos para analise. 

SELECT count(*) from produtos 
where preco not BETWEEN 20 and 100 and nome_produto = 'Bola de Futebol'

update produtos
set preco = (SELECT ROUND(AVG(preco),2) from produtos
where preco BETWEEN 20 and 100 and nome_produto = 'Bola de Futebol')
where preco not BETWEEN 20 and 100 and nome_produto = 'Bola de Futebol'

SELECT * from produtos where nome_produto = 'Bola de Futebol'


SELECT count(*) from produtos 
where preco not BETWEEN 10 and 50 and nome_produto = 'Chocolate'

update produtos
SET preco = (SELECT ROUND(AVG(preco),2) from produtos
where preco BETWEEN 10 and 50 and nome_produto = 'Chocolate')             
where preco not BETWEEN 10 and 50 and nome_produto = 'Chocolate'

SELECT * from produtos where nome_produto = 'Chocolate'


SELECT count(*) from produtos 
where preco not BETWEEN 80 and 5000 and nome_produto = 'Celular'

update produtos
set preco = (SELECT ROUND(AVG(preco),2) from produtos
where preco BETWEEN 80 and 5000 and nome_produto = 'Celular')
where preco not BETWEEN 80 and 5000 and nome_produto = 'Celular';

SELECT * from produtos where nome_produto = 'Celular';


SELECT count(*) from produtos 
where preco not BETWEEN 10 and 200 and nome_produto = 'Livro de Ficção';


update produtos
set preco = (SELECT round(avg(preco),2) from produtos 
where preco BETWEEN 10 and 200 and nome_produto = 'Livro de Ficção') 
where preco not BETWEEN 10 and 200 and nome_produto = 'Livro de Ficção';

select * from produtos where nome_produto = 'Livro de Ficção';

SELECT count(*) from produtos 
where preco  not BETWEEN 80 and 200 and nome_produto = 'Camisa';

UPDATE produtos
set preco = (select round(avg(preco),2) as media_camisa from produtos 
where preco BETWEEN 80 and 200 and nome_produto = 'Camisa') 
where preco  not BETWEEN 80 and 200 and nome_produto = 'Camisa';

select * from produtos where nome_produto = 'Camisa';

-- Verificar quantidades de registro das tabelas. 

SELECT COUNT(*) as categorias from categorias;

SELECT COUNT(*) as cleintes from clientes;

SELECT COUNT(*) as fornecedores from  fornecedores;

SELECT COUNT(*) as itens_venda from itens_venda;

SELECT COUNT(*) as marcas from marcas;

SELECT COUNT(*) as produtos from produtos;

SELECT COUNT(*)  as vendas from vendas;

-- Validar periodo de vendas dos 50000 registros. 

SELECT DISTINCT(strftime('%Y',data_venda)) as Ano from vendas order by Ano

SELECT strftime('%Y',data_venda) as Ano, COUNT(id_venda) as total_vendas from vendas 
group by Ano ORDER by Ano;

SELECT strftime('%Y',data_venda) as Ano, strftime('%m',data_venda) as mes, COUNT(id_venda) as total_vendas from vendas 
group by Ano,Mes  HAVING Ano = '2023' ORDER by Mes

SELECT strftime('%Y',data_venda) as Ano, strftime('%m',data_venda) as mes, COUNT(id_venda) as total_vendas from vendas 
group by Ano,Mes  HAVING mes in ('01','11','12') ORDER by Ano


-- Preparação de relatorios para responder perguntas de negocio. 

-- Papel dos fornecedores na black friday.

select f.nome, strftime('%Y',v.data_venda) as Ano, strftime('%m',v.data_venda) as mes,
COUNT(i.produto_id) as produtos_vendidos
from fornecedores f 
inner join produtos p on p.fornecedor_id = f.id_fornecedor
INNER join itens_venda i on i.produto_id = p.id_produto
INNER join vendas v on v.id_venda = i.venda_id
GROUP by Ano,mes,f.nome  order by Ano,produtos_vendidos 

-- Calcular quantidade total de vendas. 
SELECT SUM(produtos_vendidos)
from(
  		select f.nome, strftime('%Y',v.data_venda) as Ano, strftime('%m',v.data_venda) as mes,
COUNT(i.produto_id) as produtos_vendidos
from fornecedores f 
inner join produtos p on p.fornecedor_id = f.id_fornecedor
INNER join itens_venda i on i.produto_id = p.id_produto
INNER join vendas v on v.id_venda = i.venda_id
GROUP by Ano,mes,f.nome  order by Ano,produtos_vendidos);


-- Categoria de produtos na black friday

SELECT c.nome_categoria as categoria, strftime('%Y',v.data_venda) 
as Ano, strftime('%m',v.data_venda) as mes, COUNT(v.id_venda) as total_vendas
from produtos p
INNER join categorias c on c.id_categoria = p.categoria_id
INNER join itens_venda i on i.produto_id = p.id_produto
inner join vendas v on v.id_venda = i.venda_id
GROUP by Ano,mes,categoria HAVING mes ='11' ORDER by Ano,total_vendas


-- relatorio de dados do pior forncedor em vendas na ultima black friday.
NebulaNetworks

select strftime('%Y',v.data_venda) as Ano, strftime('%m',v.data_venda) as mes,
COUNT(i.produto_id) as produtos_vendidos
from fornecedores f 
inner join produtos p on p.fornecedor_id = f.id_fornecedor
INNER join itens_venda i on i.produto_id = p.id_produto
INNER join vendas v on v.id_venda = i.venda_id
GROUP by Ano,f.nome,mes HAVING f.nome = 'NebulaNetworks'  order by Ano,mes
