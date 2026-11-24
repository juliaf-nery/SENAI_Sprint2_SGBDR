-- CREATE DATABASE EdeDoce
USE EdeDoce;

CREATE TABLE Categorias(
	id_categorias INT PRIMARY KEY AUTO_INCREMENT,
    categoria VARCHAR(100) NOT NULL
);

ALTER TABLE Categorias RENAME COLUMN categoria TO categorias;

CREATE TABLE Produtos(
	id_produtos INT PRIMARY KEY AUTO_INCREMENT,
    produtos VARCHAR(100) NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL,
    preco FLOAT NOT NULL,
    
	-- Pega o produto e referência a uma das categorias que existem
    fk_categorias INT,
   FOREIGN KEY(fk_categorias) REFERENCES Categorias(id_categorias)
);

ALTER TABLE Produtos MODIFY preco DECIMAL(10,2) NOT NULL;
ALTER TABLE Produtos RENAME COLUMN id_produtos TO id_produto;
DELETE FROM Produtos WHERE id_produto > 0;
ALTER TABLE Produtos AUTO_INCREMENT = 1;


CREATE TABLE Clientes(
	id_clientes INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(100) NOT NULL
);

CREATE TABLE Pedidos(
	id_pedidos INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL,
    
    fk_clientes INT,
    FOREIGN KEY(fk_clientes) REFERENCES Clientes(id_clientes)
);

DELETE FROM Pedidos WHERE id_pedidos > 0;
ALTER TABLE Pedidos AUTO_INCREMENT = 1;
ALTER TABLE Pedidos 
ADD CONSTRAINT uk_pedido_cliente UNIQUE (data_pedido, fk_clientes);

CREATE TABLE ItensPedidos(
	id_itenspedidos INT PRIMARY KEY AUTO_INCREMENT,
    produto VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL, -- quant x preco_unitario
    
    -- FK1
    fk_produto INT,
    FOREIGN KEY(fk_produto) REFERENCES Produtos(id_produto),
    
    -- FK2
    fk_pedidos INT,
    FOREIGN KEY(fk_pedidos) REFERENCES Pedidos(id_pedidos)
);

ALTER TABLE ItensPedidos DROP COLUMN produto;
ALTER TABLE ItensPedidos ADD COLUMN quantidade INT NOT NULL;
ALTER TABLE ItensPedidos RENAME COLUMN valor TO preco_unitario;


ALTER TABLE ItensPedidos RENAME COLUMN id_produtos TO fk_produtos;
ALTER TABLE ItensPedidos RENAME COLUMN id_pedidos TO fk_pedidos;
ALTER TABLE ItensPedidos MODIFY valor DECIMAL(10,2) NOT NULL;
ALTER TABLE ItensPedidos MODIFY valor_total DECIMAL(10,2) NOT NULL;


-- Valores das Categorias
INSERT INTO Categorias(id_categorias, categorias)
		VALUES(1, "Tortas Doces"),
			  (2, "Tortas Salgadas"),
              (3, "Bebidas");
              
              
-- Valores dos Produtos
INSERT INTO Produtos(fk_categorias, produtos, descricao, quantidade, preco)
		VALUES
			  -- Tortas Doces
			  (1, "Torta de Floresta Negra", "Camadas macias de bolo de chocolate com recheio cremoso de chantilly", 12, 18.00),
			  (1, "Torta de Limão", "Refrescante creme de limão e a doçura do merengue tostado por cima", 10, 15.00),
              (1, "Torta de Pudim", "Torta doce com a cremosidade inconfundível e finalizada com uma generosa calda de caramelo", 15, 16.50),
              
              -- Tortas Salgadas
              (2, "Torta de Carne com Banana da Terra", "Camadas definidas que revelam o dourado da banana", 15, 16.50),
              (2, "Torta de Frango com Quatro queijos", " recheio super cremoso de frango desfiado", 12, 16.50),
              (2, "Torta de Queijo e Presunto", "Massa leve e macia recheada com camadas fartas de presunto e queijo", 9, 16.50),
              
              -- Bebidas
              (3, "Suco de morango", "Leve e equilibrado entre o doce e o levemente ácido da fruta", 15, 8.50),
              (3, "Suco de Limão", "Uma bebida cítrica, refrescante e ácida", 12, 15.00),
              (3, "Água mineral", "Sem gás", 10, 5.00);
              
              UPDATE Produtos
              SET descricao = "Recheio super cremoso de frango desfiado"
              WHERE id_produto = 5;
              

-- Valores dos Clientes
INSERT INTO Clientes(id_clientes, nome, email, senha)
		VALUES
			  (1, "Maria Joaquina", "mariajoaquina@gmail.com", "123456"),
			  (2, "Luis Nathan", "luisnathan@gmail.com", "654321"),
			  (3, "Mystyna Santana", "mystynasantana@gmail.com", "789456");
              
INSERT INTO Pedidos(data_pedido, fk_clientes) 
		VALUES
			  ('2026-10-07', 1),
              ('2026-10-19', 2),
              ('2026-10-26', 3);
             
             UPDATE Pedidos 
			 SET data_pedido = '2026-10-07 14:30:00' 
			 WHERE id_pedidos = 1;

			 UPDATE Pedidos 
			 SET data_pedido = '2026-10-19 16:45:00' 
			 WHERE id_pedidos = 2;

			 UPDATE Pedidos 
			 SET data_pedido = '2026-10-26 12:30:00' 
			 WHERE id_pedidos = 3;
              
INSERT INTO ItensPedidos(fk_pedidos, fk_produto, preco_unitario, quantidade, valor_total)
			VALUES
				  (1, 2, 15.00, 2, 30.00),
                  (1, 7, 8.50, 1, 8.50),
                  (2, 3, 16.50, 2, 33.00),
                  (2, 8, 16.50, 1, 16.50),
                  (3, 5, 15.00, 1, 15.00);


SELECT * FROM Categorias;
-- Produtos
SELECT
	c.categorias AS nome_categoria,
	p.id_produto,
	p.produtos,
    p.descricao,
    p.quantidade,
    p.preco
    FROM Produtos p
    INNER JOIN Categorias c ON p.fk_categorias = c.id_categorias
    ORDER BY fk_categorias ASC, p.produtos ASC;
SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT
	p.id_pedidos,
    c.nome AS cliente,
    prod.produtos AS produto,
    ip.preco_unitario,
    ip.quantidade,
    ip.valor_total
    FROM ItensPedidos ip
    INNER JOIN Pedidos p ON ip.fk_pedidos = p.id_pedidos
    INNER JOIN Clientes c ON p.fk_clientes = c.id_clientes
    INNER JOIN Produtos prod ON ip.fk_produto = prod.id_produto
    ORDER BY p.id_pedidos;