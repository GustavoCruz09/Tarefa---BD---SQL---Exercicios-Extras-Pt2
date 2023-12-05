CREATE DATABASE TarefaBD_EX_07
go
Use TarefaBD_EX_07

-- Criação da tabela Clientes
CREATE TABLE Cliente (
    rg VARCHAR(20),
    CPF VARCHAR(11),
    Nome VARCHAR(50),
    Logradouro VARCHAR(50),
    Numero INT
	Primary Key(rg)
);

-- Inserção de dados na tabela
INSERT INTO Cliente (rg, CPF, Nome, Logradouro, Numero) VALUES
    ('29531844', '34519878040', 'Luiz André', 'R. Astorga', 500),
    ('13514996x', '84984285630', 'Maria Luiza', 'R. Piauí', 174),
    ('121985541', '23354997310', 'Ana Barbara', 'Av. Jaceguai', 1141),
    ('23987746x', '43587669920', 'Marcos Alberto', 'R. Quinze', 22);


go

-- Criação da tabela Pedido
CREATE TABLE Pedido (
    NotaFiscal INT,
    Valor DECIMAL(10, 2),
    Data DATE,
    RG_Cliente VARCHAR(20),
	Primary Key (NotaFiscal),
    FOREIGN KEY (RG_Cliente) REFERENCES Cliente(rg)
);

-- Inserção de dados na tabela
INSERT INTO Pedido (NotaFiscal, Valor, Data, RG_Cliente) VALUES
    (1001, 754.00, '2018-04-01', '121985541'),
    (1002, 350.00, '2018-04-02', '121985541'),
    (1003, 30.00, '2018-04-02', '29531844'),
    (1004, 1500.00, '2018-04-03', '13514996x');

go

-- Criação da tabela Fornecedor
CREATE TABLE Fornecedor (
    Codigo INT,
    Nome VARCHAR(50),
    Logradouro VARCHAR(100),
    Numero INT,
    Pais VARCHAR(3),
    Area INT,
    Telefone BIGINT,
    CNPJ VARCHAR(14),
    Cidade VARCHAR(50),
    Transporte VARCHAR(50),
    Moeda VARCHAR(3)
	Primary Key(Codigo)
);

-- Inserção de dados na tabela
INSERT INTO Fornecedor (Codigo, Nome, Logradouro, Numero, Pais, Area, Telefone, CNPJ, Cidade, Transporte, Moeda) VALUES
    (1, 'Clone', 'Av. Nações Unidas, 12000', 12000, 'BR', 55, 1141487000, NULL, 'São Paulo', NULL, 'R$'),
    (2, 'Logitech', '28th Street, 100', 100, 'USA', 1, 2127695100, NULL, NULL, 'Avião', 'US$'),
    (3, 'LG', 'Rod. Castello Branco', NULL, 'BR', 55, 800664400, '4159978100001', 'Sorocaba', NULL, 'R$'),
    (4, 'PcChips', 'Ponte da Amizade', NULL, 'PY', 595, NULL, NULL, NULL, 'Navio', 'US$');

select * from Fornecedor


go

-- Criação da tabela Mercadoria
CREATE TABLE Mercadoria (
    Codigo INT,
    Descricao VARCHAR(50),
    Preco DECIMAL(10, 2),
    Qtd INT,
    Cod_Fornecedor INT
    FOREIGN KEY (Cod_Fornecedor) REFERENCES Fornecedor(Codigo)
);

-- Inserção de dados na tabela
INSERT INTO Mercadoria (Codigo, Descricao, Preco, Qtd, Cod_Fornecedor) VALUES
    (10, 'Mouse', 24.00, 30, 1),
    (11, 'Teclado', 50.00, 20, 1),
    (12, 'Cx. De Som', 30.00, 8, 2),
    (13, 'Monitor 17', 350.00, 4, 3),
    (14, 'Notebook', 1500.00, 7, 4);

select * from Mercadoria

Select 
	CASE
		When Numero IS NOT NULL Then 
			Logradouro + ' ' + CAST(Numero as Varchar(7)) + ' ' + Pais
		Else
			Logradouro + ' ' + Pais
		END as Endereco
From Fornecedor 

Select 
	SUBSTRING(CPF, 1, 3) + '.' + SUBSTRING(CPF, 4, 3) + '.' + SUBSTRING(CPF, 7, 3) + '-' + SUBSTRING(CPF, 10, 2) as CPF,
	CASE
		WHEN LEN(rg) = 8 THEN 
			SUBsTRING(rg, 1, 7) + '-' + SUBSTRING(rg, 8, 8)
		ELSE
			SUBsTRING(rg, 1, 8) + '-' + SUBSTRING(rg, 9, 9)
	END as RG
From Cliente

SELECT Valor * 0.90 as VALOR FROM Pedido Where NotaFiscal = 1003

SELECT Valor * 0.95 as VALOR FROM Pedido WHERE Valor > 700

SELECT m.Preco * 1.2 as Valor, Descricao
FROM  Mercadoria m
Where m.Qtd < 10

UPDATE Mercadoria
	SET Preco = Preco * 1.2
WHERE Qtd < 10

Select p.Data, p.Valor, p.RG_Cliente
From Pedido p, Cliente c
Where p.RG_Cliente = '29531844'

SELECT c.CPF, c.Nome, c.Logradouro + ' '+ CAST(c.Numero as Varchar(7)) as Endereco  FROM Cliente c, Pedido p
Where p.RG_Cliente = c.rg AND p.NotaFiscal = 1004

SELECT f.Pais, f.Transporte
 FROM Fornecedor f, Mercadoria m
 Where m.Cod_Fornecedor = f.Codigo
	And m.Descricao = 'Cx. De Som'

SELECT m.Descricao as Nome, m.Qtd
FROM Mercadoria m, Fornecedor f
Where m.Cod_Fornecedor = f.Codigo
	And f.Nome = 'Clone'

Select
	CASE
		When f.Numero IS NOT NULL Then 
			f.Logradouro + ' ' + CAST(f.Numero as Varchar(7)) + ' ' + f.Pais
		Else
			f.Logradouro + ' ' + f.Pais
	END as Endereco,
	CASE
		WHEN f.Pais != 'BR' THEN
			'('+CAST(SUBSTRING(f.Telefone, 1, 2) as Varchar(10)) +')' + CAST(SUBSTRING(f.Telefone, 3, 6) as Varchar(10))+ '-' + CAST(SUBSTRING(f.Telefone, 7, 10) as Varchar(10))
		ELSE
			CAST(SUBSTRING(f.Telefone, 1, 4) as Varchar(10)) + '-' + CAST(SUBSTRING(f.Telefone, 5, 10) as Varchar(10))
	END as Telefone
From Fornecedor f, Mercadoria m
WHERE m.Cod_Fornecedor = f.Codigo
	AND m.Descricao = 'Monitor 17'

Select f.Moeda
From Fornecedor f, Mercadoria m
Where m.Cod_Fornecedor = f.Codigo
	AND m.Descricao = 'Notebook'

SELECT
    NotaFiscal,
    Data,
    DATEDIFF(DAY, Data, '2019-02-03') AS DiasDesdePedido,
    CASE
        WHEN DATEDIFF(DAY, Data, '2019-02-03') > 180 THEN 'Pedido Antigo'
        ELSE 'Pedido Recente'
    END AS StatusPedido
FROM Pedido

SELECT
    c.Nome AS NomeCliente,
    COUNT(p.NotaFiscal) AS QuantidadePedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.RG = p.RG_Cliente
GROUP BY c.Nome

Select c.rg, c.CPF, c.Nome, c.Logradouro + ' ' + cast(c.Numero as varchar(7)) as Endereco
From Cliente c
LEFT JOIN Pedido p ON c.RG = p.RG_Cliente
WHERE p.RG_Cliente IS NULL


