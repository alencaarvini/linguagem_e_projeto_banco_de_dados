-- BANCO DE DADOS II - MISSOES SQL
-- Base didatica com uma unica tabela, sem necessidade de JOIN
-- Compatibilidade: MySQL 8.0+

CREATE DATABASE IF NOT EXISTS bd_missoes_loja;
USE bd_missoes_loja;

DROP TABLE IF EXISTS produtos;

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
);

-- Os dados contemplam produtos sem estoque, estoques criticos,
-- quantidades nao divisiveis por 4 e 6, precos decimais e categorias
-- com diferentes volumes e valores de estoque.
INSERT INTO produtos (nome, categoria, preco, estoque) VALUES
('Notebook Pro 15', 'Eletronicos', 4299.90, 2),
('Smartphone Max', 'Eletronicos', 2199.99, 8),
('Tablet 10', 'Eletronicos', 899.50, 0),
('Monitor 27', 'Eletronicos', 1299.90, 15),
('Smart TV 43', 'Eletronicos', 1899.00, 23),
('Caixa de Som Bluetooth', 'Eletronicos', 149.99, 45),
('Mouse Gamer', 'Perifericos', 89.90, 0),
('Teclado Mecanico', 'Perifericos', 259.90, 4),
('Webcam Full HD', 'Perifericos', 179.50, 7),
('Headset USB', 'Perifericos', 129.99, 12),
('Mousepad XL', 'Perifericos', 49.90, 25),
('Hub USB-C', 'Perifericos', 119.90, 36),
('Cabo HDMI', 'Acessorios', 29.90, 80),
('Cabo USB-C', 'Acessorios', 24.50, 60),
('Carregador Rapido', 'Acessorios', 99.90, 40),
('Suporte de Celular', 'Acessorios', 39.90, 22),
('Adaptador USB', 'Acessorios', 19.99, 18),
('Power Bank', 'Acessorios', 199.90, 13),
('Cadeira Ergonomica', 'Moveis', 899.90, 3),
('Mesa de Escritorio', 'Moveis', 649.99, 5),
('Estante Compacta', 'Moveis', 329.50, 0),
('Gaveteiro', 'Moveis', 249.90, 10),
('Controle Sem Fio', 'Games', 299.90, 1),
('Jogo de Corrida', 'Games', 199.90, 4),
('Console Portatil', 'Games', 1599.90, 8),
('Headset Gamer', 'Games', 399.99, 12),
('Caderno Universitario', 'Papelaria', 29.90, 0),
('Caneta Kit 10', 'Papelaria', 18.50, 2),
('Agenda Executiva', 'Papelaria', 59.90, 4),
('Organizador de Mesa', 'Papelaria', 79.99, 6);

-- Conferencia inicial (nao e gabarito das missoes)
SELECT * FROM produtos ORDER BY id_produto;
SELECT COUNT(*) AS total_produtos FROM produtos;
-- missão 1 --
SELECT nome, preco, FLOOR(preco) AS preco_arredondado_baixo FROM produtos;

SELECT nome, estoque, FLOOR(estoque /6) AS caixas_completas FROM produtos;

SELECT nome, estoque, FLOOR(estoque /4) AS kits_completos FROM produtos;

SELECT categoria, AVG(preco) AS media_preco, FLOOR(AVG(preco)) AS media_arredondada FROM produtos
GROUP BY categoria;

-- missão 2 --
SELECT nome, preco, CEIL(preco) AS preco_arredondado_baixo FROM produtos;

SELECT nome, estoque, CEIL(estoque /6) AS caixas_completas FROM produtos;

SELECT nome, estoque, CEIL(25/8) AS quantidade_pacotes FROM produtos;

SELECT nome, preco AS preco_original, FLOOR(preco) AS  preco_arredondado_baixo, CEIL(preco) AS preco_arredondado_cima,
CEIL(preco) - FLOOR(preco) AS diferenca FROM produtos;

-- missão 3 --
SELECT categoria, COUNT(*) AS quantidade_produto FROM produtos
GROUP BY categoria
HAVING COUNT(*) >3;

SELECT categoria, SUM(estoque) AS total_estoque FROM produtos
GROUP BY categoria
HAVING SUM(estoque) >50;

SELECT categoria, AVG(preco) AS preco_medio FROM produtos
GROUP BY categoria
HAVING AVG(preco) > 100;

SELECT categoria, SUM(preco * estoque) AS valor_total_estoque FROM produtos
WHERE estoque > 0
GROUP BY categoria
HAVING SUM(preco * estoque) > 5000;

-- missão 4 --
SELECT nome, estoque, CASE WHEN estoque = 0 THEN 'fora de estoque' WHEN estoque > 0 THEN 'Disponível' END AS classificacao FROM produtos;

SELECT nome, estoque, CASE WHEN estoque = 0 THEN 'Esgotado' 
WHEN estoque <= 5 THEN 'Estoque Crítico'
WHEN estoque <= 20 THEN 'Estoque Moderado'
WHEN estoque > 20 THEN 'Estoque Adequado'	
END AS classificacao FROM produtos;

SELECT nome, preco, CASE WHEN preco < 100 THEN 'Econômico'
WHEN preco <= 500 THEN 'Intermediário'
WHEN preco > 500 THEN 'Premium'
END AS classificacao FROM produtos;

SELECT nome, estoque AS estoque_atual,
CASE
WHEN estoque < 20 THEN 20 - estoque
ELSE 0
END AS quantidade_reposicao FROM produtos;

SELECT categoria, COUNT(*) AS quantidade_produto,
SUM(estoque) AS total_estoque,
AVG(preco) AS preco_medio,
CEIL(AVG(preco)) AS preco_medio_cima,
SUM(preco * estoque) AS valor_estoque,
CASE
WHEN SUM(estoque) < 20 THEN 'Reposição urgente'
WHEN SUM(estoque) <= 50 THEN 'Atenção'
ELSE 'Estoque confortável'
END AS classificacao_estoque FROM produtos
GROUP BY categoria
HAVING COUNT(*) >= 2
ORDER BY SUM(estoque) ASC;
