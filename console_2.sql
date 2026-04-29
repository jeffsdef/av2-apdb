-- Índices

-- buscar pedidos por cliente rapidamente
CREATE INDEX idx_pedidos_cliente ON pedidos(id_cliente);

-- filtrar produtos por categoria
CREATE INDEX idx_produtos_categoria ON produtos(categoria_produto);





-- Restrições

ALTER TABLE ITENS_PEDIDO
ADD CONSTRAINT check_preco_positivo CHECK (preco >= 0),
ADD CONSTRAINT check_frete_positivo CHECK (valor_frete >= 0);

ALTER TABLE pagamentos
ADD CONSTRAINT check_pagamento_positivo CHECK (valor_pagamento >= 0);

ALTER TABLE produtos
ADD CONSTRAINT check_peso_valido CHECK (peso_produto_g > 0),
ADD CONSTRAINT check_dimensoes_validas CHECK (comprimento_produto_cm > 0 AND altura_produto_cm > 0 AND largura_produto_cm > 0);

ALTER TABLE avaliacoes
ADD CONSTRAINT check_pontuacao_range CHECK (pontuacao BETWEEN 1 AND 5);
