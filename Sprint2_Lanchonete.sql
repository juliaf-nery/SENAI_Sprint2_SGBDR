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
    id_categorias INT,
   FOREIGN KEY(fk_categorias) REFERENCES Categorias(id_categorias)
);

ALTER TABLE Produtos MODIFY preco DECIMAL(10,2) NOT NULL;
ALTER TABLE Produtos RENAME COLUMN id_categorias TO fk_categorias;
ALTER TABLE Produtos RENAME COLUMN id_produtos TO id_produto;
ALTER TABLE Produtos RENAME COLUMN quantidade TO fatias;

CREATE TABLE Clientes(
	id_clientes INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(100) NOT NULL
);

CREATE TABLE Pedidos(
	id_pedidos INT PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL,
    
    id_clientes INT,
    FOREIGN KEY(fk_clientes) REFERENCES Clientes(id_clientes)
);

ALTER TABLE Pedidos RENAME COLUMN id_clientes TO fk_clientes;

CREATE TABLE ItensPedidos(
	id_itenspedidos INT PRIMARY KEY AUTO_INCREMENT,
    produto VARCHAR(100) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    
    -- FK1
    fk_produtos INT,
    FOREIGN KEY(fk_produtos) REFERENCES Produtos(id_produtos),
    
    -- FK2
    fk_pedidos INT,
    FOREIGN KEY(fk_pedidos) REFERENCES Pedidos(id_pedidos)
);

DROP TABLE ItensPedidos;
DROP TABLE Pedidos;


ALTER TABLE ItensPedidos RENAME COLUMN id_produtos TO fk_produtos;
ALTER TABLE ItensPedidos RENAME COLUMN id_pedidos TO fk_pedidos;
ALTER TABLE ItensPedidos MODIFY valor DECIMAL(10,2) NOT NULL;
ALTER TABLE ItensPedidos MODIFY valor_total DECIMAL(10,2) NOT NULL;

INSERT INTO Categorias(id_categorias, categorias)
		VALUES(1, "Tortas Doces"),
			  (2, "Tortas Salgadas"),
              (3, "Bebidas");
              
INSERT INTO Produtos(fk_categorias, id_produto, produtos, descricao, fatias, preco)
		VALUES
			  -- Tortas Doces
			  (1, 1, "Torta de Floresta Negra", "Camadas macias de bolo de chocolate com recheio cremoso de chantilly", 1, 18.00),
			  (2, 1, "Torta de Limão", "Refrescante creme de limão e a doçura do merengue tostado por cima", 1, 15.00),
              (3, 1, "Torta de Pudim", "Torta doce com a cremosidade inconfundível e finalizada com uma generosa calda de caramelo", 1, 16.50),
              
              -- Tortas Salgadas
              (4, 2, "Torta de Carne com Banana da Terra", "Camadas definidas que revelam o dourado da banana", 1, 16.50),
              (5, 2, "Torta de Frango com Quatro queijos", " recheio super cremoso de frango desfiado", 1, 16.50),
              (6, 2, "Torta de Queijo e Presunto", "Massa leve e macia recheada com camadas fartas de presunto e queijo", 1, 16.50),
              
              -- Bebidas
              (7, 3, "Soda italiana de Limão", "leve e extremamente refrescante, feita com a combinação de xarope de limão", 1, 8.50),
              (8, 3, "Milkshake de Nutella", "é uma bebida cremosa e gelada, feita com a combinação de sorvete, leite e o creme de avelã com cacau", 1, 15.00),
              (9, 3, "Água mineral", "Sem gás", 1, 5.00);
              
               UPDATE Produtos
               SET descricao = "Recheio super cremoso de frango desfiado com quatro queijos"
               WHERE id_produtos = 5;
             
               UPDATE Produtos
               SET descricao = "Leve e extremamente refrescante, feita com a combinação de xarope de limão"
               WHERE id_produtos = 7;
              
               UPDATE Produtos
               SET descricao = "Uma bebida cremosa e gelada, feita com a combinação de sorvete, leite e creme de avelã com cacau"
               WHERE id_produtos = 8;
              
INSERT INTO Clientes(id_cliente, nome, email, senha)
		VALUES
			  (1, "Maria Joaquina", "mariajoaquina@gmail.com", "123456"),
			  (2, "Luis Nathan", "luisnathan@gmail.com", "654321"),
			  (1, "Mystyna Santana", "mystynasantana@gmail.com", "789456");
              
             
              
              






















SELECT * FROM Categorias;
-- Produtos
SELECT
	c.categorias AS nome_categoria,
	p.id_produto,
	p.produtos,
    p.descricao,
    p.fatias,
    p.preco
    FROM Produtos p
    INNER JOIN Categorias c ON p.fk_categorias = c.id_categorias
    ORDER BY fk_categorias ASC, p.produtos ASC;
SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT * FROM ItensPedidos;



