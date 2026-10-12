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
