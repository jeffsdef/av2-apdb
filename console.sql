-- Criação de tabelas (dados inseridos a partir de importação)

create database olist; use olist;

CREATE TABLE CLIENTES (
    id_cliente VARCHAR(50) PRIMARY KEY,
    id_unico_cliente VARCHAR(50),
    cep_cliente VARCHAR(5),
    cidade_cliente VARCHAR(100),
    estado_cliente VARCHAR(2)
);

CREATE TABLE localizacao (
    cep_prefixo VARCHAR(5),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    cidade VARCHAR(100),
    estado VARCHAR(2)
);

CREATE TABLE ITENS_PEDIDO (
    id_pedido VARCHAR(50),
    id_item_pedido INT,
    id_produto VARCHAR(50),
    id_vendedor VARCHAR(50),
    data_limite_envio DATETIME,
    preco DECIMAL(10, 2),
    valor_frete DECIMAL(10, 2),
    PRIMARY KEY (id_pedido, id_item_pedido)
);

CREATE TABLE pagamentos (
    id_pedido VARCHAR(50),
    sequencial_pagamento INT,
    tipo_pagamento VARCHAR(20),
    parcelas_pagamento INT,
    valor_pagamento DECIMAL(10, 2),
    PRIMARY KEY (id_pedido, sequencial_pagamento)
);

CREATE TABLE avaliacoes (
    id_avaliacao VARCHAR(50),
    id_pedido VARCHAR(50),
    pontuacao INT,
    titulo_comentario VARCHAR(100),
    mensagem_comentario TEXT,
    data_criacao DATETIME,
    data_resposta DATETIME,
    PRIMARY KEY (id_avaliacao, id_pedido)
);

CREATE TABLE pedidos (
    id_pedido VARCHAR(50) PRIMARY KEY,
    id_cliente VARCHAR(50),
    status_pedido VARCHAR(50),
    data_compra DATETIME,
    data_aprovacao DATETIME,
    data_envio_transportadora DATETIME,
    data_entrega_cliente DATETIME,
    data_estimada_entrega DATETIME
);

CREATE TABLE produtos (
    id_produto VARCHAR(50) PRIMARY KEY,
    categoria_produto VARCHAR(100),
    comprimento_nome_produto INT,
    comprimento_descricao_produto INT,
    qtd_fotos_produto INT,
    peso_produto_g INT,
    comprimento_produto_cm INT,
    altura_produto_cm INT,
    largura_produto_cm INT
);

CREATE TABLE vendedores (
    id_vendedor VARCHAR(50) PRIMARY KEY,
    cep_vendedor VARCHAR(5),
    cidade_vendedor VARCHAR(100),
    estado_vendedor VARCHAR(2)
);

CREATE TABLE traducao_categorias (
    categoria_produto VARCHAR(100) PRIMARY KEY,
    categoria_produto_ingles VARCHAR(100)
);