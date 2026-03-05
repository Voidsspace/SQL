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

-- Traga todos os dados da cliente Maria Silva.
select * from clientes where nome = 'Maria Silva'
-- Busque o ID do pedido e o ID do cliente dos pedidos onde o status esteja como entregue.
select id, idcliente from pedidos where status = 'Entregue'
-- Retorne todos os produtos onde o preço seja maior que 10 e menor que 15.
select * from produtos where preco > 10 and preco < 15 
-- Busque o nome e cargo dos colaboradores que foram contratados entre 2022-01-01 e 2022-06-30.
select nome, cargo from colaboradores where datacontratacao BETWEEN '2022-01-01' and '2022-06-30'
-- Recupere o nome do cliente que fez o primeiro pedido.
SELECT nome from clientes c 
RIGHT join pedidos p on c.id = p.idcliente 
order by datahorapedido limit 1

--Liste os produtos que nunca foram pedidos.
select * from itenspedidos where idproduto is NULL
select pr.nome, i.idpedido, idproduto from produtos pr
LEFT join itenspedidos i on pr.id = i.idproduto where i.idproduto is NULL

--Liste os nomes dos clientes que fizeram pedidos entre 2023-01-01 e 2023-12-31.

SELECT x.nome from (select c. nome, p.datahorapedido from clientes c
left join pedidos p on c.id = p.idcliente ) as x
where x.datahorapedido BETWEEN '2023-01-01' and '2023-12-31'


--Recupere os nomes dos produtos que estão em menos de 15 pedidos.
SELECT * from produtos
select * from pedidos

insert into produtos
values (31,'lasanha 4 queijos', 'Uma deliciosa lasanha de 4 queijos', 23.57, 'Almoço')

insert into itenspedidos
VALUES (463,31,8,23.57)

select p.nome, SUM(i.quantidade) as qtd  from produtos p 
left JOIN itenspedidos i on p.id = i.idproduto GROUP by p.nome HAVING qtd < 15

--Liste os produtos e o ID do pedido que foram realizados pelo cliente 
--"Pedro Alves" ou pela cliente "Ana Rodrigues".

select c.nome as nomecliente, p.nome as nomeproduto, pe.id as idpedido from produtos p 
inner join itenspedidos it on p.id = it.idproduto
inner join pedidos pe on pe.id = it.idpedido
INNER join clientes c on c.id = pe.idcliente
where c.nome in ('Pedro Alves','Ana Rodrigues')

--Recupere o nome e o ID do cliente que mais comprou(valor) no Serenatto.
select x.nome, x.idcliente, gastototal from (select c.nome, SUM(i.quantidade * i.precounitario) as gastototal, pe.idcliente from itenspedidos i 
inner join pedidos pe on pe.id = i.idpedido
inner join clientes c on c.id = pe.idcliente GROUP by c.nome) as x order by x.gastototal  desc LIMIT 1


-- Buscar o nome do professor e a turma que ele é orientador
SELECT p.Nome_Professor, t.Nome_Turma from Professores p 
RIGHT join Turmas t on t.ID_Professor_Orientador = p.ID_Professor

-- Retornar o nome e a nota do aluno que possui a melhor nota na disciplina de Matemática

SELECT a.Nome_Aluno, n.Nota from Alunos a 
inner join Turma_Alunos ta on a.ID_Aluno = ta.ID_Aluno
inner join Turma_Disciplinas td on ta.ID_Turma = td.ID_Turma
INNER join Disciplinas d on d.ID_Disciplina = td.ID_Disciplina
INNER join Notas n on n.ID_Aluno = a.ID_Aluno
where d.Nome_Disciplina = 'Matemática' ORDER by n.Nota desc LIMIT 1

select * from Disciplinas

--Identificar o total de alunos por turma
SELECT * FROM Turma_Alunos

select COUNT(ta.ID_Aluno) from Turma_Alunos ta
INNER join Turmas t on t.ID_Turma = ta.ID_Turma GROUP by t.ID_Turma

--Listar os Alunos e as disciplinas em que estão matriculados
SELECT * from Turma_Disciplinas


SELECT a.Nome_Aluno, d.Nome_Disciplina FROM Alunos a 
inner join Turma_Alunos ta on a.ID_Aluno = ta.ID_Aluno
inner join Turma_Disciplinas td on td.ID_Turma = ta.ID_Turma
inner join Disciplinas d on d.ID_Disciplina = td.ID_Disciplina ORDER by d.Nome_Disciplina

-- Criar uma view que apresenta o nome, a disciplina e a nota dos alunos

create VIEW v_relatorio_alunos as

SELECT a.Nome_Aluno as nome_aluno, d.Nome_Disciplina as nome_disciplina, n.Nota as nota_aluno
from Alunos a 
INNER join Turma_Alunos ta on a.ID_Aluno = ta.ID_Aluno
inner join Turma_Disciplinas td on td.ID_Turma = ta.ID_Turma
INNER JOIN Disciplinas d on d.ID_Disciplina = td.ID_Disciplina
inner join Notas n on n.ID_Disciplina = d.ID_Disciplina order by nome_disciplina

select * from v_relatorio_alunos
