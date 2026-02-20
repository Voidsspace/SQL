-- Retorna a média de notas dos alunos em história. 

select round(AVG(nota),2) from Notas where id_disciplina = 2

-- Retornar as informações dos alunos cujo nome começa com 'A'

select * from Alunos where nome_aluno like 'A%'

-- Buscar apenas os alunos que fazem aniversario em fevereiro.

select * from Alunos where STRFTIME('%m', data_nascimento) = '02'

-- Realizar uma consulta que calcula a idade dos alunos

select (date('now') - data_nascimento) Idade_aluno from Alunos 

-- Retorna se o aluno está ou não aprovado. aluno é considerado aprovado se a sua nota for igual ou maior que 6

select id_aluno, id_disciplina,
CASE
when avg(nota) >= 6 then 'Aprovado'
else 'Reprovado'
end as situacao_aluno from Notas GROUP by  id_aluno,id_disciplina