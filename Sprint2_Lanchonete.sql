DROP DATABASE IF EXISTS EdeDoce;
CREATE DATABASE EdeDoce;
USE EdeDoce;

-- CRIAÇÃO DAS TABELAS --

-- VALORES DAS CATEGORIAS
CREATE TABLE Categorias(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    categoria VARCHAR(100) NOT NULL
);

-- VALORES DOS PRODUTOS
CREATE TABLE Produtos(
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
    produto VARCHAR(100) NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    quantidade INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
	fk_categoria INT NOT NULL,
    
    CONSTRAINT chk_produto_preco CHECK (preco > 0),
    CONSTRAINT chk_produto_qtd CHECK (quantidade >= 0),
    CONSTRAINT fk_produto_categoria
		FOREIGN KEY(fk_categoria) REFERENCES Categorias(id_categoria)
);

ALTER TABLE Produtos AUTO_INCREMENT = 1;

-- VALORES DOS CLIENTES
CREATE TABLE Clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha CHAR(64) NOT NULL
);

-- VALORES DOS PEDIDOS
CREATE TABLE Pedidos(
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL,  -- Representa a data e o horário que a compra do pedido foi efetivada
    fk_cliente INT NOT NULL,
    
    CONSTRAINT uk_pedido_cliente UNIQUE (data_pedido, fk_cliente),
    CONSTRAINT fk_pedidos_cliente
    FOREIGN KEY(fk_cliente) REFERENCES Clientes(id_cliente)
);

-- VALORES DO CARRINHO
CREATE TABLE Carrinho(
	id_carrinho INT PRIMARY KEY AUTO_INCREMENT,
    quantidade INT NOT NULL,
    data_adicao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- Representa a data e o horário que o produto foi adicionado ao carrinho
    fk_cliente INT NOT NULL,
    fk_produto INT NOT NULL,
    
    CONSTRAINT chk_carrinho_qtd CHECK (quantidade > 0),
    CONSTRAINT uk_carrinho_cliente_produto UNIQUE (fk_cliente, fk_produto),
    CONSTRAINT fk_carrinho_cliente
        FOREIGN KEY (fk_cliente) REFERENCES Clientes(id_cliente),
    CONSTRAINT fk_carrinho_produto	
        FOREIGN KEY (fk_produto) REFERENCES Produtos(id_produto)
);

-- VALORES DOS ITENS PEDIDOS
CREATE TABLE ItensPedidos(
    id_item_pedido INT PRIMARY KEY AUTO_INCREMENT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED, -- calcula o valor total fazendo quant. x preco_unitario
    fk_pedido INT NOT NULL,
    fk_produto INT NOT NULL,
    
    CONSTRAINT chk_item_qtd CHECK (quantidade > 0),
    CONSTRAINT uk_item_pedido_produto UNIQUE (fk_pedido, fk_produto),
    CONSTRAINT fk_itens_pedido
        FOREIGN KEY (fk_pedido) REFERENCES Pedidos(id_pedido),
    CONSTRAINT fk_itens_produto
        FOREIGN KEY (fk_produto) REFERENCES Produtos(id_produto)
);

-- INSERÇÃO DOS VALORES DAS TABELAS --
INSERT INTO Categorias(categoria)
		VALUES('Tortas Doces'),
			  ('Tortas Salgadas'),
              ('Bebidas');
              
INSERT INTO Produtos(fk_categoria, produto, descricao, quantidade, preco)
		VALUES
			  -- Tortas Doces
			  (1, 'Torta de Floresta Negra', 'Camadas macias de bolo de chocolate com recheio cremoso de chantilly', 12, 18.00),
			  (1, 'Torta de Limão', 'Refrescante creme de limão e a doçura do merengue tostado por cima', 10, 15.00),
              (1, 'Torta de Pudim', 'Torta doce com a cremosidade inconfundível e finalizada com uma generosa calda de caramelo', 15, 16.50),
              
              -- Tortas Salgadas
              (2, 'Torta de Carne com Banana da Terra', 'Camadas definidas que revelam o dourado da banana', 15, 16.50),
              (2, 'Torta de Frango com Quatro queijos', 'Recheio super cremoso de frango desfiado', 12, 16.50),
              (2, 'Torta de Queijo e Presunto', 'Massa leve e macia recheada com camadas fartas de presunto e queijo', 9, 16.50),
              
              -- Bebidas
              (3, 'Suco de Morango', 'Leve e equilibrado entre o doce e o levemente ácido da fruta', 15, 8.50),
              (3, 'Suco de Limão', 'Uma bebida cítrica, refrescante e ácida', 12, 15.00),
              (3, 'Água Mineral', 'Sem gás', 10, 5.00),
              (3, 'Água Gaseificada', 'Com gás', 10, 6.00);

-- Exclusão de um produto
DELETE FROM Produtos
WHERE id_produto = 10;
             
INSERT INTO Clientes(id_cliente, nome, email, senha)
		VALUES
			  (1, 'Maria Joaquina', 'mariajoaquina@gmail.com', SHA2('123456', 256)),
			  (2, 'Luis Nathan', 'luisnathan@gmail.com', SHA2('654123', 256)),
			  (3, 'Mystyna Santana', 'mystynasantana@gmail.com', SHA2('789456', 256));
                            
INSERT INTO Pedidos(data_pedido, fk_cliente) 
		VALUES
			  ('2026-10-07 14:30:00', 1),
              ('2026-10-19 16:45:00', 2),
              ('2026-10-21 10:30:00', 3);
             
INSERT INTO Carrinho(fk_cliente, fk_produto, quantidade, data_adicao)
		VALUES
			  (1, 2, 2, '2026-10-07 14:00:00'),
			  (1, 7, 1, '2026-10-07 14:05:00'),
			  (2, 3, 2, '2026-10-19 16:30:00'),
			  (2, 8, 1, '2026-10-19 16:40:00'),
			  (3, 5, 1, '2026-10-21 10:15:00');
              
INSERT INTO ItensPedidos(fk_pedido, fk_produto, quantidade, preco_unitario)
			VALUES
				  (1, 2, 2, 15.00),
                  (1, 7, 1, 8.50),
                  (2, 3, 2, 16.50),
                  (2, 8, 1, 15.00),
                  (3, 5, 1, 16.50);

-- Diminuição do estoque
SET SQL_SAFE_UPDATES = 0;  -- Desativa temporariamente o safe mode para permitir o update abaixo

UPDATE Produtos
SET quantidade = quantidade - (SELECT COALESCE(SUM(ip.quantidade), 0)
FROM ItensPedidos ip
WHERE ip.fk_produto = Produtos.id_produto
);

SET SQL_SAFE_UPDATES = 1;  -- Ativa novamente o safe mode
                  
-- EXIBIR AS TABELAS --

-- TABELA CATEGORIAS
SELECT * FROM Categorias;

-- TABELA PRODUTOS
SELECT
	c.categoria AS nome_categoria,
	p.id_produto,
	p.produto,
    p.descricao,
    p.quantidade,
    p.preco
    FROM Produtos p
    INNER JOIN Categorias c ON p.fk_categoria = c.id_categoria
    ORDER BY fk_categoria ASC, p.produto ASC;

-- Mostra a quantidade de opções dos produtos, o preço médio e o total de cada categoria
SELECT
    c.categoria,
    COUNT(p.id_produto) AS qtd_produtos,
    ROUND(AVG(p.preco), 2) AS preco_medio,
    SUM(p.quantidade) AS estoque_total
FROM Categorias c
INNER JOIN Produtos p ON p.fk_categoria = c.id_categoria
GROUP BY c.id_categoria, c.categoria
ORDER BY c.categoria;
    
-- Organiza produtos acima de R$15,00
SELECT produto, preco
FROM Produtos
WHERE preco > 15.00
ORDER BY preco DESC, produto ASC;
    
-- TABELA CLIENTES
SELECT id_cliente, nome, email FROM Clientes;

-- TABELA PEDIDOS
SELECT * FROM Pedidos;

-- TABELA CARRINHO
SELECT 
    cli.nome AS cliente,
    prod.produto AS produto,
    prod.preco AS preco_unitario,
    car.quantidade,
    (car.quantidade * prod.preco) AS valor_total,
    car.data_adicao
FROM Carrinho car
INNER JOIN Clientes cli ON car.fk_cliente = cli.id_cliente
INNER JOIN Produtos prod ON car.fk_produto = prod.id_produto
ORDER BY cli.nome;

-- CRIAÇÃO DO VIEW RESUMO DOS PEDIDOS --
CREATE OR REPLACE VIEW vw_resumo_pedidos AS
SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    SUM(ip.quantidade) AS total_itens,
    SUM(ip.valor_total) AS total_pedido
FROM ItensPedidos ip
INNER JOIN Pedidos p ON ip.fk_pedido = p.id_pedido
INNER JOIN Clientes c ON p.fk_cliente = c.id_cliente
GROUP BY p.id_pedido, c.nome, p.data_pedido;
 
-- Exibir a view
SELECT * FROM vw_resumo_pedidos ORDER BY id_pedido;