SELECT * FROM HistoricoEmprego;

-- Buscar os colaboradores com os maiores salários (limitado aos 5 maiores valores)
SELECT *
FROM HistoricoEmprego
ORDER BY salario DESC
LIMIT 5;

-- Buscar os colaboradores com os maiores salários (limitado aos 5 maiores valores)
-- que ainda estão empregados na empresa
SELECT *
FROM HistoricoEmprego
WHERE datatermino IS NULL
ORDER BY salario DESC
LIMIT 5;

-- Buscar os colaboradores com os maiores salários (limitado aos 5 maiores valores)
-- que não estão mais empregados na empresa
SELECT *
FROM HistoricoEmprego
WHERE datatermino IS NOT NULL
ORDER BY salario DESC
LIMIT 5;

-- Buscar um treinamento que um colaborador relatou ter gostado
SELECT *
FROM Treinamento
WHERE curso LIKE 'O Poder%';

-- Buscar um treinamento que um colaborador relatou ter gostado
SELECT *
FROM Treinamento
WHERE curso LIKE '%realizar%';

-- Buscar um profissional com determinada atividade que não esteja trabalhando
SELECT *
FROM HistoricoEmprego
WHERE cargo = 'Professor'
  AND datatermino IS NOT NULL;

-- Buscar um profissional com mais de uma atividade
SELECT *
FROM HistoricoEmprego
WHERE cargo = 'Dermatologista'
   OR cargo = 'Oftalmologista';

-- Buscar um profissional com mais de uma atividade (usando IN)
SELECT *
FROM HistoricoEmprego
WHERE cargo IN ('Dermatologista', 'Oftalmologista', 'Professor');

-- Buscar um profissional com atividades que não estejam no filtro
SELECT *
FROM HistoricoEmprego
WHERE cargo NOT IN ('Dermatologista', 'Oftalmologista', 'Professor');

-- Realizar consultas com mais de um critério (colaboradores)
SELECT *
FROM Treinamento
WHERE (curso LIKE 'O direito%' AND instituicao = 'da Rocha')
   OR (curso LIKE 'O conforto%' AND instituicao = 'das Neves');

-- Trazer os dados do mês com maior índice de faturamento
SELECT mes, MAX(faturamento_bruto)
FROM faturamento;

-- Trazer os dados do mês com menor índice de faturamento
SELECT mes, MIN(faturamento_bruto)
FROM faturamento;

-- Soma de novos clientes no ano de 2023
SELECT SUM(numero_novos_clientes) AS "Novos Clientes 2023"
FROM faturamento
WHERE mes LIKE '%2023';

-- Validar a média de despesas
SELECT AVG(despesas) AS "Média de despesa mensal"
FROM faturamento;

-- Validar a média de lucro
SELECT AVG(lucro_liquido) AS "Média de lucro mensal"
FROM faturamento;

-- Validar a quantidade de colaboradores desempregados
SELECT COUNT(*)
FROM HistoricoEmprego
WHERE datatermino IS NOT NULL;

-- Contar a quantidade de licenças do tipo férias
SELECT COUNT(*)
FROM Licencas
WHERE tipolicenca = 'férias';

-- Validar os graus de parentesco presentes na tabela
SELECT parentesco
FROM Dependentes
GROUP BY parentesco;

-- Validar a quantidade de familiares por grau de parentesco
SELECT parentesco, COUNT(*) AS quantidade
FROM Dependentes
GROUP BY parentesco;

-- Verificar quais instituições possuem mais cursos cadastrados
SELECT instituicao, COUNT(curso) AS quantidade
FROM Treinamento
GROUP BY instituicao
HAVING COUNT(curso) > 2;

-- Validar quais cargos são mais frequentes
SELECT cargo, COUNT(*) AS qtd
FROM HistoricoEmprego
GROUP BY cargo
HAVING COUNT(*) >= 2;

-- Validar a quantidade de caracteres em uma coluna (CPF com 11 dígitos)
SELECT nome, LENGTH(cpf) AS qtd
FROM Colaboradores
WHERE LENGTH(cpf) = 11;

SELECT LENGTH(cpf) AS qtd, COUNT(*)
FROM Colaboradores
WHERE LENGTH(cpf) = 11;

-- Extrair dados da tabela e transformá-los em texto
SELECT
  'A pessoa colaboradora ' || nome ||
  ' com o CPF ' || cpf ||
  ' possui o seguinte endereço: ' || endereco AS texto
FROM Colaboradores;

SELECT
  UPPER(
    'A pessoa colaboradora ' || nome ||
    ' com o CPF ' || cpf ||
    ' possui o seguinte endereço: ' || endereco
  ) AS texto
FROM Colaboradores;

SELECT
  LOWER(
    'A pessoa colaboradora ' || nome ||
    ' com o CPF ' || cpf ||
    ' possui o seguinte endereço: ' || endereco
  ) AS texto
FROM Colaboradores;

-- Transformar a data retornada da consulta de licença
SELECT id_colaborador,
       strftime('%m/%Y', datainicio) AS "mês/ano"
FROM Licencas;

-- Validar o tempo em dias que a pessoa esteve contratada
SELECT id_colaborador,
       julianday(datatermino) - julianday(datacontratacao) AS "Dias contratados"
FROM HistoricoEmprego
WHERE datatermino IS NOT NULL;

-- Arredondamento de números
SELECT AVG(faturamento_bruto),
       ROUND(AVG(faturamento_bruto), 2)
FROM faturamento;

SELECT CEIL(faturamento_bruto), CEIL(despesas)
FROM faturamento;

SELECT FLOOR(faturamento_bruto), FLOOR(despesas)
FROM faturamento;

-- Conversão de dados
SELECT
  'O valor médio de faturamento é: ' ||
  CAST(ROUND(AVG(faturamento_bruto), 2) AS TEXT)
FROM faturamento;

-- Utilizando CASE
SELECT id_colaborador, cargo, salario,
  CASE
    WHEN salario < 3000 THEN 'Baixo'
    WHEN salario BETWEEN 3000 AND 6000 THEN 'Médio'
    ELSE 'Alto'
  END AS categoria_salario
FROM HistoricoEmprego;

-- Renomear tabela
ALTER TABLE HistoricoEmprego
RENAME TO CargosColaboradores;

-- Exercícios

SELECT *
FROM clientes
ORDER BY nome
LIMIT 5;

SELECT *
FROM produtos
WHERE descricao IS NULL;

SELECT *
FROM funcionario
WHERE nome LIKE 'a%'
  AND nome LIKE '%s';

SELECT departamento,
       AVG(media_salarial) AS "Média"
FROM funcionarios
GROUP BY departamento
HAVING AVG(media_salarial) > 5000;

SELECT
  primeiro_nome || ' ' || ultimo_nome AS nome_completo,
  LENGTH(primeiro_nome || ' ' || ultimo_nome) AS tamanho_nome
FROM clientes;


-- Breno