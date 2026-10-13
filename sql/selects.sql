-- ============================================================
-- ATIVIDADE SQL - SELECTS COM JOINS, AGREGAÇÕES E SUBQUERIES
-- ============================================================


-- ============================================================
-- SELECT 1
-- Ranking de professores por quantidade de disciplinas ministradas
-- Técnica: JOIN múltiplo + COUNT DISTINCT + STRING_AGG
-- ============================================================

SELECT
    p.nome                            AS professor,
    COUNT(DISTINCT a.id_disciplina)   AS total_disciplinas,
    COUNT(DISTINCT a.id_turma)        AS total_turmas,
    STRING_AGG(DISTINCT d.nome, ', ') AS disciplinas
FROM aulas a
JOIN pessoa     p ON p.id = a.id_professor
JOIN disciplina d ON d.id = a.id_disciplina
GROUP BY
    p.id,
    p.nome
ORDER BY
    total_disciplinas DESC;


-- ============================================================
-- SELECT 2
-- Auditoria: cursos cuja soma de horas das disciplinas
-- diverge da carga horária declarada no cadastro
-- Técnica: HAVING com cálculo + detecção de inconsistência
-- ============================================================

SELECT
    c.nome                          AS curso,
    c.horas_totais                  AS horas_declaradas,
    SUM(d.horas_individuais)        AS horas_somadas,
    SUM(d.horas_individuais)
        - c.horas_totais            AS diferenca
FROM curso      c
JOIN disciplina d ON d.id_curso = c.id
GROUP BY
    c.id,
    c.nome,
    c.horas_totais
HAVING
    SUM(d.horas_individuais) <> c.horas_totais
ORDER BY
    diferenca DESC;


-- ============================================================
-- SELECT 3
-- Campus mais movimentado: ranking por número de aulas realizadas
-- Técnica: JOIN em cadeia + contagem dupla (aulas e salas)
-- ============================================================

SELECT
    cam.nome                AS campus,
    cam.endereco,
    COUNT(a.id)             AS total_aulas,
    COUNT(DISTINCT s.id)    AS salas_utilizadas
FROM campus cam
JOIN sala  s ON s.id_campus = cam.id
JOIN aulas a ON a.id_sala   = s.id
GROUP BY
    cam.id,
    cam.nome,
    cam.endereco
ORDER BY
    total_aulas DESC;


-- ============================================================
-- SELECT 4
-- Área de ensino com maior diversidade de cursos e
-- maior carga horária acumulada
-- Técnica: LEFT JOIN + CASE WHEN dentro de COUNT + AVG
-- ============================================================

SELECT
    ae.nome                                          AS area_ensino,
    COUNT(c.id)                                      AS total_cursos,
    COUNT(CASE WHEN c.disponivel = TRUE THEN 1 END)  AS cursos_ativos,
    SUM(c.horas_totais)                              AS carga_horaria_acumulada,
    ROUND(AVG(c.horas_totais), 0)                    AS media_horas_por_curso
FROM area_ensino ae
LEFT JOIN curso c ON c.id_area_ensino = ae.id
GROUP BY
    ae.id,
    ae.nome
ORDER BY
    cursos_ativos          DESC,
    carga_horaria_acumulada DESC;


-- ============================================================
-- SELECT 5
-- PERGUNTA: Quais aulas estão alocadas na mesma sala e no mesmo
-- turno (possível conflito de agenda)? Mostre o campus, a sala,
-- as duas disciplinas, os professores, as turmas e o tipo de caso.
-- Técnica: SELF JOIN (aulas com ela mesma) + JOINs múltiplos
--          (campus, sala, disciplina, pessoa, turma) + CASE
-- Observação: a tabela aulas não tem dia da semana nem horário.
-- Por isso o resultado é um conflito POTENCIAL. Para confirmar,
-- faltaria criar em "aulas" as colunas dia_semana, hora_inicio e
-- hora_fim e incluir na condição do JOIN.
-- ============================================================

SELECT
    cam.nome            AS campus,
    s.id                AS sala,
    a1.turno            AS turno,
    a1.id               AS aula_a,
    d1.nome             AS disciplina_a,
    p1.nome             AS professor_a,
    t1.id               AS turma_a,
    a2.id               AS aula_b,
    d2.nome             AS disciplina_b,
    p2.nome             AS professor_b,
    t2.id               AS turma_b,
    CASE
        WHEN a1.id_professor = a2.id_professor
            THEN 'Mesmo professor nas duas aulas'
        WHEN a1.id_turma = a2.id_turma
            THEN 'Mesma turma com duas aulas na mesma sala'
        ELSE 'Turmas diferentes disputando a sala'
    END                 AS tipo_conflito
FROM aulas a1
JOIN aulas      a2  ON a2.id_sala = a1.id_sala
                   AND a2.turno   = a1.turno
                   AND a2.id      > a1.id
JOIN sala       s   ON s.id   = a1.id_sala
JOIN campus     cam ON cam.id = s.id_campus
JOIN disciplina d1  ON d1.id  = a1.id_disciplina
JOIN disciplina d2  ON d2.id  = a2.id_disciplina
JOIN pessoa     p1  ON p1.id  = a1.id_professor
JOIN pessoa     p2  ON p2.id  = a2.id_professor
JOIN turma      t1  ON t1.id  = a1.id_turma
JOIN turma      t2  ON t2.id  = a2.id_turma
ORDER BY
    cam.nome,
    s.id,
    a1.id;


-- ============================================================
-- SELECT 6
-- PERGUNTA: Para cada turma de curso disponível, quantas disciplinas
-- da grade do curso já têm aula cadastrada? Mostre o percentual de
-- cobertura, as horas ofertadas, quantos professores e campi estão
-- envolvidos e classifique a situação da turma.
-- Técnica: LEFT JOIN (turmas sem aula continuam aparecendo) +
--          subquery correlacionada + COUNT DISTINCT + COALESCE +
--          NULLIF + CASE + WHERE + ORDER BY
-- ============================================================

SELECT
    t.id                                            AS turma,
    c.nome                                          AS curso,
    ae.nome                                         AS area_ensino,
    t.semestre,
    t.turno,
    COUNT(a.id)                                     AS aulas_cadastradas,
    COUNT(DISTINCT a.id_disciplina)                 AS disciplinas_ofertadas,
    (SELECT COUNT(*)
       FROM disciplina dc
      WHERE dc.id_curso = t.id_curso)               AS disciplinas_do_curso,
    ROUND(
        100.0 * COUNT(DISTINCT a.id_disciplina)
        / NULLIF((SELECT COUNT(*)
                    FROM disciplina dc
                   WHERE dc.id_curso = t.id_curso), 0)
    , 1)                                            AS pct_cobertura,
    COALESCE(SUM(d.horas_individuais), 0)           AS horas_ofertadas,
    COUNT(DISTINCT a.id_professor)                  AS professores,
    COUNT(DISTINCT s.id_campus)                     AS campi,
    CASE
        WHEN COUNT(a.id) = 0
            THEN 'SEM AULAS: turma criada, mas nada ofertado'
        WHEN COUNT(DISTINCT a.id_disciplina) <
             (SELECT COUNT(*) FROM disciplina dc
               WHERE dc.id_curso = t.id_curso)
            THEN 'GRADE INCOMPLETA'
        ELSE 'GRADE COMPLETA'
    END                                             AS situacao
FROM turma t
JOIN curso        c  ON c.id  = t.id_curso
JOIN area_ensino  ae ON ae.id = c.id_area_ensino
LEFT JOIN aulas       a ON a.id_turma = t.id
LEFT JOIN disciplina  d ON d.id       = a.id_disciplina
LEFT JOIN sala        s ON s.id       = a.id_sala
WHERE c.disponivel = TRUE
GROUP BY
    t.id,
    t.id_curso,
    c.nome,
    ae.nome,
    t.semestre,
    t.turno
ORDER BY
    pct_cobertura ASC,
    t.id;


-- ============================================================
-- SELECT 7
-- PERGUNTA: Os dados do banco respeitam as regras de negócio?
-- Quantas ocorrências existem em cada verificação de integridade?
-- Técnica: UNION ALL de várias consultas + subquery na cláusula FROM
--          + NOT EXISTS + LEFT JOIN ... IS NULL + LIKE + CASE
-- Leitura: ocorrencias = 0 significa OK. Os itens 06, 10 e 11 devem
-- retornar valores maiores que zero com os dados atuais.
-- ============================================================

SELECT
    verificacao,
    ocorrencias,
    CASE
        WHEN ocorrencias = 0                    THEN 'OK'
        WHEN verificacao LIKE '%informativo%'   THEN 'INFORMATIVO'
        ELSE 'ATENÇÃO'
    END AS resultado
FROM (
    SELECT '01. Aulas com disciplina de outro curso (diferente do curso da turma)' AS verificacao,
           COUNT(*) AS ocorrencias
    FROM aulas a
    JOIN turma      t ON t.id = a.id_turma
    JOIN disciplina d ON d.id = a.id_disciplina
    WHERE d.id_curso <> t.id_curso

    UNION ALL
    SELECT '02. Aulas com turno diferente do turno da turma',
           COUNT(*)
    FROM aulas a
    JOIN turma t ON t.id = a.id_turma
    WHERE a.turno <> t.turno

    UNION ALL
    SELECT '03. Professores em aulas sem matrícula de professor ativa',
           COUNT(DISTINCT a.id_professor)
    FROM aulas a
    WHERE NOT EXISTS (
        SELECT 1
        FROM matricula m
        WHERE m.id_pessoa = a.id_professor
          AND m.tipo  = 2
          AND m.ativa = 1
    )

    UNION ALL
    SELECT '04. Pessoas cadastradas sem nenhuma matrícula',
           COUNT(*)
    FROM pessoa p
    LEFT JOIN matricula m ON m.id_pessoa = p.id
    WHERE m.id IS NULL

    UNION ALL
    SELECT '05. Cursos disponíveis sem nenhuma turma',
           COUNT(*)
    FROM curso c
    WHERE c.disponivel = TRUE
      AND NOT EXISTS (SELECT 1 FROM turma t WHERE t.id_curso = c.id)

    UNION ALL
    SELECT '06. Turmas sem nenhuma aula cadastrada',
           COUNT(*)
    FROM turma t
    LEFT JOIN aulas a ON a.id_turma = t.id
    WHERE a.id IS NULL

    UNION ALL
    SELECT '07. Cursos indisponíveis que possuem turmas',
           COUNT(DISTINCT c.id)
    FROM curso c
    JOIN turma t ON t.id_curso = c.id
    WHERE c.disponivel = FALSE

    UNION ALL
    SELECT '08. CPFs fora do padrão 000.000.000-00',
           COUNT(*)
    FROM pessoa
    WHERE cpf NOT LIKE '___.___.___-__'

    UNION ALL
    SELECT '09. E-mails fora do formato nome@dominio.ext',
           COUNT(*)
    FROM pessoa
    WHERE email NOT LIKE '%_@_%._%'

    UNION ALL
    SELECT '10. Matrículas de aluno inativas (informativo)',
           COUNT(*)
    FROM matricula
    WHERE tipo = 1
      AND ativa = 0

    UNION ALL
    SELECT '11. Pares de aulas na mesma sala e turno (ver SELECT 5)',
           COUNT(*)
    FROM aulas a1
    JOIN aulas a2 ON a2.id_sala = a1.id_sala
                 AND a2.turno   = a1.turno
                 AND a2.id      > a1.id
) AS checagens
ORDER BY
    ocorrencias DESC,
    verificacao;


-- ============================================================
-- SELECT 8   (REQUER complemento-inscricao.sql)
-- PERGUNTA: Como está o desempenho de cada turma? Mostre curso e
-- área, quantidade de alunos, média das notas, taxa de aprovação,
-- reprovações, trancamentos, notas pendentes, frequência média,
-- diferença para a média geral da instituição e uma classificação.
-- Considere apenas turmas com pelo menos 3 inscrições.
-- Técnica: subquery na cláusula FROM (tabela derivada) + JOINs em
--          cadeia + COUNT DISTINCT + AVG + SUM(CASE) + NULLIF +
--          HAVING + subquery escalar + BETWEEN + CASE
-- O que falta no banco atual: tabela inscricao (aluno x aula) com
-- nota, frequência e situação, que não existe em create-table.sql.
-- ============================================================

SELECT
    r.turma,
    r.curso,
    r.area_ensino,
    r.turno,
    r.alunos,
    r.inscricoes,
    r.notas_lancadas,
    r.media_notas,
    r.dif_media_geral,
    r.taxa_aprovacao,
    r.reprovacoes,
    r.trancamentos,
    r.em_andamento,
    r.freq_media,
    CASE
        WHEN r.taxa_aprovacao IS NULL            THEN 'SEM AVALIAÇÕES CONCLUÍDAS'
        WHEN r.taxa_aprovacao BETWEEN 0 AND 59.9 THEN 'CRÍTICA'
        WHEN r.taxa_aprovacao BETWEEN 60 AND 79.9 THEN 'ATENÇÃO'
        ELSE 'SAUDÁVEL'
    END AS classificacao
FROM (
    SELECT
        t.id                                              AS turma,
        c.nome                                            AS curso,
        ae.nome                                           AS area_ensino,
        t.turno                                           AS turno,
        COUNT(DISTINCT i.id_matricula)                    AS alunos,
        COUNT(i.id)                                       AS inscricoes,
        COUNT(i.nota_final)                               AS notas_lancadas,
        ROUND(AVG(i.nota_final), 2)                       AS media_notas,
        ROUND(AVG(i.nota_final)
              - (SELECT AVG(nota_final) FROM inscricao), 2) AS dif_media_geral,
        ROUND(
            100.0 * SUM(CASE WHEN i.situacao = 'Aprovado' THEN 1 ELSE 0 END)
            / NULLIF(COUNT(CASE WHEN i.situacao IN ('Aprovado', 'Reprovado')
                                THEN 1 END), 0)
        , 1)                                              AS taxa_aprovacao,
        SUM(CASE WHEN i.situacao = 'Reprovado' THEN 1 ELSE 0 END) AS reprovacoes,
        SUM(CASE WHEN i.situacao = 'Trancado'  THEN 1 ELSE 0 END) AS trancamentos,
        SUM(CASE WHEN i.situacao = 'Cursando'  THEN 1 ELSE 0 END) AS em_andamento,
        ROUND(AVG(i.frequencia), 1)                       AS freq_media
    FROM inscricao i
    JOIN matricula    m  ON m.id  = i.id_matricula AND m.tipo = 1
    JOIN aulas        a  ON a.id  = i.id_aula
    JOIN turma        t  ON t.id  = a.id_turma
    JOIN curso        c  ON c.id  = t.id_curso
    JOIN area_ensino  ae ON ae.id = c.id_area_ensino
    GROUP BY
        t.id,
        c.nome,
        ae.nome,
        t.turno
    HAVING COUNT(i.id) >= 3
) AS r
ORDER BY
    r.taxa_aprovacao DESC,
    r.turma;


-- ============================================================
-- SELECT 9   (REQUER complemento-inscricao.sql)
-- PERGUNTA: Quais alunos com matrícula ativa estão com média abaixo
-- da média geral da instituição? Mostre curso, quantidade de turmas,
-- disciplinas, horas cursadas, professores e campi diferentes,
-- média, frequência, reprovações e a situação geral do aluno.
-- Técnica: JOIN de 8 tabelas + subquery escalar no HAVING e no SELECT
--          + COUNT DISTINCT + SUM + AVG + MIN + CASE + LIMIT
-- O que falta no banco atual: tabela inscricao (aluno x aula).
-- Sem ela não existe como saber quais aulas cada aluno cursa.
-- ============================================================

SELECT
    m.numero_matricula,
    p.nome                                              AS aluno,
    c.nome                                              AS curso,
    COUNT(DISTINCT t.id)                                AS turmas,
    COUNT(DISTINCT d.id)                                AS disciplinas,
    SUM(d.horas_individuais)                            AS horas_cursadas,
    COUNT(DISTINCT a.id_professor)                      AS professores,
    COUNT(DISTINCT s.id_campus)                         AS campi,
    ROUND(AVG(i.nota_final), 2)                         AS media_aluno,
    (SELECT ROUND(AVG(nota_final), 2) FROM inscricao)   AS media_geral,
    MIN(i.nota_final)                                   AS menor_nota,
    ROUND(AVG(i.frequencia), 1)                         AS freq_media,
    SUM(CASE WHEN i.situacao = 'Reprovado' THEN 1 ELSE 0 END) AS reprovacoes,
    CASE
        WHEN SUM(CASE WHEN i.situacao = 'Reprovado' THEN 1 ELSE 0 END) >= 2
            THEN 'RISCO ALTO'
        WHEN SUM(CASE WHEN i.situacao = 'Reprovado' THEN 1 ELSE 0 END) = 1
            THEN 'RISCO MÉDIO'
        ELSE 'ACOMPANHAR'
    END                                                 AS situacao_geral
FROM inscricao i
JOIN matricula   m ON m.id = i.id_matricula
JOIN pessoa      p ON p.id = m.id_pessoa
JOIN aulas       a ON a.id = i.id_aula
JOIN turma       t ON t.id = a.id_turma
JOIN curso       c ON c.id = t.id_curso
JOIN disciplina  d ON d.id = a.id_disciplina
JOIN sala        s ON s.id = a.id_sala
WHERE m.tipo  = 1
  AND m.ativa = 1
GROUP BY
    m.id,
    m.numero_matricula,
    p.nome,
    c.nome
HAVING AVG(i.nota_final) < (SELECT AVG(nota_final) FROM inscricao)
ORDER BY
    media_aluno ASC,
    p.nome
LIMIT 10;
