select * from categorias;
select * from produtos;

select * from produtos;
select count(*) as vendas_totais from vendas;

select count(*) from vendas where strftime('%m', data_venda) = '11'

SELECT count(*) from produtos 
where preco not BETWEEN 20 and 100 and nome_produto = 'Bola de Futebol'

SELECT * from produtos 
where preco BETWEEN 10 and 50 and nome_produto = 'Chocolate'

update produtos
SET preco = 50 where preco not BETWEEN 10 and 50 and nome_produto = 'Chocolate'

SELECT count(*) from produtos 
where preco not BETWEEN 80 and 5000 and nome_produto = 'Celular'

SELECT count(*) from produtos 
where preco not BETWEEN 10 and 200 and nome_produto = 'Livro de Ficção'

SELECT count(*) from produtos 
where preco  not BETWEEN 80 and 200 and nome_produto = 'Camisa'
