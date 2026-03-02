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
    
select p.nome, x.idpedido, x.idproduto from(SELECT ip.idproduto,ip.idpedido from pedidos pe INNER join itenspedidos ip on pe.id = ip.idpedido where strftime('%m',datahorapedido) = '10') x
right JOIN  produtos p on p.id = x.idproduto

-- Filtrar clientes que não realizaram comprar em um determinado mês. 

select c.nome, p.status, p.datahorapedido from clientes c
left join pedidos p on c.id = p.idcliente 

select c.nome, x.id , x.idcliente from clientes c
left join (select p.id, p.idcliente from pedidos p where strftime('%m', p.datahorapedido) = '10') x on c.id = x.idcliente where x.idcliente is null

-- Retornar pedidos cuja não tem clientes vinculados. 
select c.nome, p.id from clientes c
full join pedidos p on c.id = p.idcliente WHERE c.nome ISNULL

-- Calcular o preço total de um pedido. 

SELECT idpedido, quantidade, precounitario,(quantidade * precounitario) as 'Preço total' from itenspedidos

SELECT cli.nome,p.id as idpedido,pro.nome, x.quantidade, x.precounitario, x.precototal, p.datahorapedido from pedidos p
RIGHT join (SELECT idpedido,quantidade,precounitario,idproduto,(quantidade * precounitario) as precototal from itenspedidos) x on x.idpedido = p.id
inner join clientes cli on p.idcliente = cli.id 
inner join produtos pro on x.idproduto = pro.id

-- Criação de view para facilitar a consulta de relatorios. 

create VIEW viewprecototal as 

SELECT cli.nome,p.id as idpedido,pro.nome, x.quantidade, x.precounitario, x.precototal, p.datahorapedido from pedidos p
RIGHT join (SELECT idpedido,quantidade,precounitario,idproduto,(quantidade * precounitario) as precototal from itenspedidos) x on x.idpedido = p.id
inner join clientes cli on p.idcliente = cli.id 
inner join produtos pro on x.idproduto = pro.id

SELECT * from viewprecototal

-- Criando calculo de faturamento diario e automatizando com Trigger 

select date(datahorapedido) as dia, sum(ip.precounitario * ip.quantidade) from pedidos p
join itenspedidos ip
on ip.idpedido = p.id 
GROUP BY dia ORDER by dia	

CREATE TABLE faturamentodiario(
  	
  	dia date,
  	faturamentototal decimal (10,2))
    
    
insert into faturamentodiario(dia,faturamentototal)
select date(datahorapedido) as dia, sum(ip.precounitario * ip.quantidade) 
        from pedidos p join itenspedidos ip on ip.idpedido = p.id 
		GROUP BY dia ORDER by dia;
    
CREATE TRIGGER calculafaturamentodiario
AFTER INSERT on itenspedidos
for EACH ROW

BEGIN
DELETE FROM faturamentodiario;
insert into faturamentodiario(dia,faturamentototal)
select date(datahorapedido) as dia, sum(ip.precounitario * ip.quantidade) 
        from pedidos p join itenspedidos ip on ip.idpedido = p.id 
		GROUP BY dia ORDER by dia;
end;

SELECT * from pedidos

INSERT into pedidos
VALUES(463,27,datetime('now'),'Em andamento');

insert into itenspedidos
VALUES(463,14,2,6.0),
	  (463,13,1,7.0)
      
SELECT * from faturamentodiario

-- Atualizando dados em tabelas. 

PRAGMA foreign_keys = on -- No SGBD SQLLITE ONLINE as chaves estrageiras das tabelas 
-- não tem verificação para isso é preciso habilitar essa correspondecia. 

select * from produtos where nome like ('Croiss%')

UPDATE produtos set preco = 13.0 where id =30

UPDATE produtos set descricao ='Croissant recheado com amêndoas' where id = 28

-- Excluir dados que não são mais necessarios. 

SELECT * from colaboradores

DELETE from colaboradores where id = 3

select * from clientes where id = 27
select * from pedidos where idcliente = 27
select * from itenspedidos where idpedido = 463

SELECT from 

DELETE from clientes where id = 27 

-- Sempre validar quando configurar nas tabelas on delete casct

update pedidos set status = 'concluido'
