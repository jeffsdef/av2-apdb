-- Materialized Views
-- Consulta escolhida:
-- 3. Média de avaliações por loja:
EXPLAIN ANALYZE
SELECT v.id_vendedor,
ROUND(AVG(a.pontuacao), 2) AS media_avaliacao
FROM vendedores v
INNER JOIN ITENS_PEDIDO i ON v.id_vendedor = i.id_vendedor
INNER JOIN avaliacoes a ON i.id_pedido = a.id_pedido
GROUP BY v.id_vendedor, v.cidade_vendedor
ORDER BY media_avaliacao DESC;

-- A consulta normal custou 2.04s

-- O MySQL não tem a função 'MATERIALIZED VIEW' nativa,
-- então criaremos uma tabela que terá os resultados pré-processados.
-- Comando da tabela nova:
CREATE TABLE mv_relatorio_vendedores (
    id_vendedor VARCHAR(50) PRIMARY KEY,
    cidade_vendedor VARCHAR(100),
    qtd_avaliacoes INT,
    media_avaliacao DECIMAL(3, 2),
    data_atualizacao DATETIME
); CREATE INDEX idx_mv_media ON mv_relatorio_vendedores(media_avaliacao);

-- Consulta nova (12,25ms):
EXPLAIN ANALYZE
SELECT id_vendedor, cidade_vendedor, qtd_avaliacoes, media_avaliacao
FROM mv_relatorio_vendedores
ORDER BY media_avaliacao DESC
LIMIT 100;

-- INSERT teste na tabela de origem:

INSERT INTO CLIENTES (id_cliente, id_unico_cliente, cep_cliente, cidade_cliente, estado_cliente)
VALUES ('cli_teste_001', 'uniq_001', '00000', 'Teste City', 'TS');

INSERT INTO vendedores (id_vendedor, cep_vendedor, cidade_vendedor, estado_vendedor)
VALUES ('vend_teste_001', '00000', 'Teste City', 'TS');

INSERT INTO produtos (id_produto, categoria_produto, peso_produto_g, comprimento_produto_cm, altura_produto_cm, largura_produto_cm)
VALUES ('prod_teste_001', 'outros', 500, 10, 10, 10);

INSERT INTO pedidos (id_pedido, id_cliente, status_pedido, data_compra)
VALUES ('ped_teste_001', 'cli_teste_001', 'delivered', NOW());

INSERT INTO ITENS_PEDIDO (id_pedido, id_item_pedido, id_produto, id_vendedor, preco, valor_frete)
VALUES ('ped_teste_001', 1, 'prod_teste_001', 'vend_teste_001', 100.00, 20.00);

INSERT INTO avaliacoes (id_avaliacao, id_pedido, pontuacao, titulo_comentario, data_criacao)
VALUES ('av_teste_001', 'ped_teste_001', 5, 'Otimo vendedor', NOW());

-- SELECT na view
SELECT * FROM mv_relatorio_vendedores
WHERE id_vendedor = 'vend_teste_001';

-- A nova avaliação não apareceu, pois a nova tabela criada (mv_relatorio_vendedores) é uma tabela física e não uma view.
-- Ou seja, seria como se a tabela fosse uma "fotografia" e não se atualiza sozinha quando os dados da tabela original mudam.
-- Para resolver seria necessário forçar um REFRESH na view materializada,
-- limpando a tabela antiga usando "TRUNCATE TABLE" e recarregando com os dados atualizados.
