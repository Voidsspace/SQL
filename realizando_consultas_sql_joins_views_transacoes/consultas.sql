-- Retornar endereço de fornecedores e colaboradores
Select rua,bairro,cidade,estado,cep from colaboradores;
SELECT rua,bairro,cidade,estado,cep from fornecedores;

Select nome,rua,bairro,cidade,estado,cep from colaboradores
UNION all
SELECT nome,rua,bairro,cidade,estado,cep from fornecedores;

-- selecionar primeiro cliente a realizar um pedido. 
select nome,telefone from clientes where id = (select idcliente from pedidos order by datahorapedido limit 1)

-- Retornar todos os clientes que fizeram pedidos no mês 

select nome,telefone from clientes where id in (select idcliente from pedidos where strftime('%m', datahorapedido) = '01')

--Quais são os produtos que possuem o seu preço maior que a media dos protudos. 

SELECT nome, preco from produtos GROUP by nome,preco HAVING preco > (select round(AVG(preco),2) from produtos)

-- Buscar informações de quais cliente realizou pedidos. 

SELECT c.nome, p.id, p.datahorapedido from clientes as c 
INNER join pedidos as p on c.id = p.idcliente

--Verificar quais produtos foram vendidos. 
select p.id, i.idpedido, i.idproduto from itenspedidos i 
	right JOIN  produtos p on p.id = i.idproduto
    
select * from pedidos where idpedido in (select i.idpedido from itenspedidos i 
	right JOIN  produtos p on p.id = i.idproduto)
