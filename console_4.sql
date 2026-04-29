-- Usuário do BI

CREATE USER 'userBI'@'%' IDENTIFIED BY 's3nh4';
GRANT SELECT ON olist.* TO 'userBI'@'%';
FLUSH PRIVILEGES;

-- Consultas Estratégicas
-- 1. Total de vendas por vendedor:
SELECT v.id_vendedor,
SUM(i.preco) AS total_receita
FROM ITENS_PEDIDO i
JOIN vendedores v ON i.id_vendedor = v.id_vendedor
GROUP BY v.id_vendedor
ORDER BY total_receita DESC;

-- 2. Clientes que mais compraram na plataforma (TOP 10):
SELECT c.id_unico_cliente,
COUNT(DISTINCT p.id_pedido) AS total_pedidos,
SUM(i.preco) AS valor_total_gasto
FROM pedidos p
INNER JOIN CLIENTES c ON p.id_cliente = c.id_cliente
INNER JOIN ITENS_PEDIDO i ON p.id_pedido = i.id_pedido
WHERE p.data_compra BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59'
GROUP BY c.id_unico_cliente
ORDER BY valor_total_gasto DESC
LIMIT 10;

-- 3. Média de avaliações por loja:
SELECT v.id_vendedor,
ROUND(AVG(a.pontuacao), 2) AS media_avaliacao
FROM vendedores v
INNER JOIN ITENS_PEDIDO i ON v.id_vendedor = i.id_vendedor
INNER JOIN avaliacoes a ON i.id_pedido = a.id_pedido
GROUP BY v.id_vendedor, v.cidade_vendedor
ORDER BY media_avaliacao DESC;

-- 4. Todos os pedidos feitos em 2 datas:
SELECT p.id_pedido, c.id_cliente, p.status_pedido, p.data_compra,
SUM(pg.valor_pagamento) AS total_pago
FROM pedidos p
INNER JOIN CLIENTES c ON p.id_cliente = c.id_cliente
LEFT JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.data_compra BETWEEN '2017-05-01 00:00:00' AND '2017-05-31 23:59:59'
GROUP BY p.id_pedido, c.id_cliente, p.status_pedido, p.data_compra
ORDER BY p.data_compra DESC;

-- 5. Produtos mais vendidos num período (top 5):
SELECT i.id_produto, prod.categoria_produto,
COUNT(i.id_item_pedido) AS total_unidades_vendidas,
SUM(i.preco) AS receita_total_produto
FROM ITENS_PEDIDO i
INNER JOIN pedidos p ON i.id_pedido = p.id_pedido
INNER JOIN produtos prod ON i.id_produto = prod.id_produto
WHERE p.data_compra BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59'
GROUP BY i.id_produto, prod.categoria_produto
ORDER BY total_unidades_vendidas DESC
LIMIT 5;

-- 6. Pedidos com mais atrasos num período (Top 10):
SELECT p.id_pedido, p.data_estimada_entrega, p.data_entrega_cliente,
DATEDIFF(p.data_entrega_cliente, p.data_estimada_entrega) AS dias_de_atraso
FROM pedidos p
INNER JOIN CLIENTES c ON p.id_cliente = c.id_cliente
WHERE p.status_pedido = 'delivered'
AND p.data_entrega_cliente > p.data_estimada_entrega -- Garante que só mostre os atrasados
AND p.data_estimada_entrega BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59'
ORDER BY dias_de_atraso DESC
LIMIT 10;

-- 7. Clientes com maior valor em compras (top 10)
SELECT c.id_unico_cliente,
SUM(pg.valor_pagamento) AS valor_total_pago
FROM CLIENTES c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN pagamentos pg ON p.id_pedido = pg.id_pedido
WHERE p.status_pedido != 'canceled'
GROUP BY c.id_unico_cliente
ORDER BY valor_total_pago DESC
LIMIT 10;

-- 8. Tempo médio de entrega por estado:
SELECT c.estado_cliente,
COUNT(p.id_pedido) AS qtd_pedidos_entregues,
ROUND(AVG(DATEDIFF(p.data_entrega_cliente, p.data_envio_transportadora)), 2) AS media_dias_transporte
FROM pedidos p
INNER JOIN CLIENTES c ON p.id_cliente = c.id_cliente
WHERE p.status_pedido = 'delivered'
AND p.data_envio_transportadora IS NOT NULL
AND p.data_entrega_cliente IS NOT NULL
GROUP BY c.estado_cliente
ORDER BY media_dias_transporte ASC;