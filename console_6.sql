-- 7. Para garantir a auditoria dos dados pode-se usar as tabelas de logs alimentadas por TRIGGERS
-- A ideia é criar uma tabela centralizada que receba um registro sempre que um INSERT, DELETE e UPDATE ocorrerem.
-- Justificativas:
--      Mesmo que o dado seja alterado manualmente, as TRIIGERS sempre irão gravar no log;
--      É registrado o usuário do banco, o timestamp exato e o estado dos dados antes e depois da alteração;
--      Se o TRIGGER falhar a transação é interrompida;

-- Exemplo prático:
CREATE TABLE logs_auditoria (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    nome_tabela VARCHAR(50),
    acao VARCHAR(10),
    chave_primaria VARCHAR(50),
    usuario_banco VARCHAR(100),
    data_hora DATETIME DEFAULT NOW(),
    dados_antigos JSON,
    dados_novos JSON
);

--

DELIMITER $$

CREATE TRIGGER trg_auditoria_produtos_update
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    INSERT INTO logs_auditoria (
        nome_tabela,
        acao,
        chave_primaria,
        usuario_banco,
        dados_antigos,
        dados_novos
    )
    VALUES (
        'produtos',
        'UPDATE',
        OLD.id_produto,
        CURRENT_USER(),
        JSON_OBJECT(
            'categoria', OLD.categoria_produto,
            'peso', OLD.peso_produto_g

        ),
        JSON_OBJECT(
            'categoria', NEW.categoria_produto,
            'peso', NEW.peso_produto_g
        )
    );
END$$
DELIMITER ;

--
-- Testando:
UPDATE produtos
SET peso_produto_g = 2500, categoria_produto = 'eletronicos_premium'
WHERE id_produto = 'prod_teste_001';

SELECT * FROM logs_auditoria ORDER BY data_hora DESC;