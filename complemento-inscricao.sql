-- ============================================================
-- COMPLEMENTO DO BANCO: tabela de inscrições (aluno x aula)
-- ============================================================
-- Por que isto é necessário?
-- No banco atual, a tabela "matricula" só identifica a pessoa
-- (número, tipo aluno/professor, ativa). Não existe nenhuma tabela
-- ligando um ALUNO a uma TURMA/AULA, nem guardando nota e frequência.
-- Sem isso, não dá para responder perguntas como "quantos alunos tem
-- na turma?" ou "qual a média do aluno?".
--
-- Esta tabela resolve o relacionamento N:N entre matrícula (aluno) e aulas.
-- Rode DEPOIS de create-table.sql e insert-values.sql.
-- Obrigatório para os SELECTs 8 e 9.
-- ============================================================

CREATE TABLE inscricao (
    id INT PRIMARY KEY,
    id_matricula INT NOT NULL,
    id_aula INT NOT NULL,
    nota_final DECIMAL(4,2),              -- NULL = nota ainda não lançada
    frequencia INT NOT NULL CHECK (frequencia BETWEEN 0 AND 100),
    situacao VARCHAR(20) NOT NULL
        CHECK (situacao IN ('Cursando', 'Aprovado', 'Reprovado', 'Trancado')),
    UNIQUE (id_matricula, id_aula),
    FOREIGN KEY (id_matricula) REFERENCES matricula(id),
    FOREIGN KEY (id_aula) REFERENCES aulas(id)
);

-- Regra usada nos dados: aprovado = nota >= 6 e frequência >= 75
-- Alunos: matrícula 1 (Ana), 2 (Bruno), 3 (Camila), 4 (Felipe, inativa), 5 (Gabriela)

INSERT INTO inscricao (id, id_matricula, id_aula, nota_final, frequencia, situacao) VALUES
-- Ana: turma 1 (Ciência da Computação, noturno)
(1,  1, 1,  8.5, 95, 'Aprovado'),
(2,  1, 2,  9.0, 92, 'Aprovado'),
(3,  1, 3,  7.0, 88, 'Aprovado'),
(4,  1, 10, 8.0, 90, 'Aprovado'),
-- Bruno: turma 1 (reprovado por nota, por frequência, e uma nota pendente)
(5,  2, 1,  5.5, 80, 'Reprovado'),
(6,  2, 2,  6.5, 70, 'Reprovado'),
(7,  2, 3,  7.5, 85, 'Aprovado'),
(8,  2, 10, NULL, 60, 'Cursando'),
-- Camila: turma 3 (ADS, noturno)
(9,  3, 5,  9.5, 98, 'Aprovado'),
-- Felipe (matrícula inativa): turma 5 (Engenharia de Software), trancou
(10, 4, 8,  NULL, 30, 'Trancado'),
(11, 4, 9,  NULL, 25, 'Trancado'),
(12, 4, 12, NULL, 20, 'Trancado'),
-- Gabriela: turma 4 (Administração, noturno)
(13, 5, 6,  6.0, 100, 'Aprovado'),
(14, 5, 7,  4.5, 90, 'Reprovado'),
(15, 5, 11, 7.0, 80, 'Aprovado');
