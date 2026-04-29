-- Foreign Keys

ALTER TABLE pedidos
ADD CONSTRAINT fk_pedidos_cliente
FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ITENS_PEDIDO
ADD CONSTRAINT fk_itens_pedido
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ITENS_PEDIDO
ADD CONSTRAINT fk_itens_produto
FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE ITENS_PEDIDO
ADD CONSTRAINT fk_itens_vendedor
FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE pagamentos
ADD CONSTRAINT fk_pagamentos_pedido
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE avaliacoes
ADD CONSTRAINT fk_avaliacoes_pedido
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE produtos
ADD CONSTRAINT fk_produtos_categoria
FOREIGN KEY (categoria_produto) REFERENCES traducao_categorias(categoria_produto)
ON DELETE SET NULL
ON UPDATE CASCADE;