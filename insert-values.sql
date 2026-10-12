-- pessoa ( Alunos e professores)

INSERT INTO pessoa (id, nome, cpf, email) VALUES
(1, 'Ana Carolina Souza', '123.456.789-01', 'ana.souza@email.com'),
(2, 'Bruno Henrique Lima', '234.567.890-12', 'bruno.lima@email.com'),
(3, 'Camila Oliveira Santos', '345.678.901-23', 'camila.santos@email.com'),
(4, 'Daniel Ferreira Costa', '456.789.012-34', 'daniel.costa@email.com'),
(5, 'Eduarda Martins Rocha', '567.890.123-45', 'eduarda.rocha@email.com'),
(6, 'Felipe Almeida Ribeiro', '678.901.234-56', 'felipe.ribeiro@email.com'),
(7, 'Gabriela Mendes Alves', '789.012.345-67', 'gabriela.alves@email.com'),
(8, 'Henrique Barbosa Silva', '890.123.456-78', 'henrique.silva@email.com');

INSERT INTO area_ensino (id, nome, descricao) VALUES
(1, 'Tecnologia da Informação', 'Cursos voltados para desenvolvimento de software, dados e infraestrutura.'),
(2, 'Administração e Negócios', 'Cursos voltados para gestão, empreendedorismo e negócios.'),
(3, 'Engenharia', 'Cursos voltados para projetos, processos e soluções de engenharia.');

INSERT INTO curso (
    id, nome, descricao, horas_totais, id_area_ensino, disponivel
) VALUES
(1, 'Ciência da Computação', 'Formação em computação, algoritmos, sistemas e desenvolvimento de software.', 3200, 1, 1),
(2, 'Análise e Desenvolvimento de Sistemas', 'Formação em análise, projeto e desenvolvimento de sistemas.', 2000, 1, 1),
(3, 'Administração', 'Formação em gestão empresarial, finanças e estratégia.', 3000, 2, 1),
(4, 'Engenharia de Software', 'Formação em arquitetura, qualidade e processos de software.', 2800, 1, 1),
(5, 'Engenharia de Produção', 'Formação em gestão de operações, produtividade e processos industriais.', 3600, 3, 0);


INSERT INTO disciplina (
    id, nome, descricao, horas_individuais, id_curso
) VALUES
(1, 'Algoritmos e Programação', 'Introdução à lógica de programação e aos algoritmos.', 80, 1),
(2, 'Banco de Dados', 'Modelagem relacional, SQL e gerenciamento de dados.', 80, 1),
(3, 'Estruturas de Dados', 'Estudo de listas, pilhas, filas, árvores e algoritmos.', 80, 1),
(4, 'Desenvolvimento Web', 'Desenvolvimento de aplicações web e APIs.', 80, 2),
(5, 'Engenharia de Requisitos', 'Levantamento, análise e documentação de requisitos.', 60, 4),
(6, 'Gestão Financeira', 'Planejamento financeiro, custos e análise de investimentos.', 60, 3),
(7, 'Gestão de Projetos', 'Planejamento, execução e acompanhamento de projetos.', 60, 3),
(8, 'Qualidade de Software', 'Verificação, validação e testes de software.', 80, 4),
(9, 'Programação Orientada a Objetos', 'Classes, objetos, encapsulamento, herança e polimorfismo.', 80, 1),
(10, 'Sistemas de Informação', 'Sistemas de informação aplicados às organizações.', 60, 3),
(11, 'Arquitetura de Software', 'Padrões arquiteturais e organização de sistemas.', 80, 4);

-- turma (o campo semestre representa o semestre letivo)

INSERT INTO turma (id, semestre, turno, id_curso) VALUES
(1, 1, 'Noturno', 1),
(2, 2, 'Matutino', 1),
(3, 3, 'Noturno', 2),
(4, 4, 'Noturno', 3),
(5, 2, 'Matutino', 4),
(6, 1, 'Vespertino', 2);

INSERT INTO campus (id, nome, endereco) VALUES
(1, 'Campus Centro', 'Avenida Afonso Pena, 1000, Belo Horizonte - MG'),
(2, 'Campus Barreiro', 'Avenida Sinfrônio Brochado, 500, Belo Horizonte - MG'),
(3, 'Campus Contagem', 'Avenida João César de Oliveira, 2000, Contagem - MG');

INSERT INTO sala (id, id_campus) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 3),
(8, 3);

-- matricula 
-- tipo: 1 = aluno; 2 = professor
-- ativa: 1 = ativa; 0 = inativa

INSERT INTO matricula (
    id, numero_matricula, tipo, ativa, id_pessoa
) VALUES
(1, 202600001, 1, 1, 1),
(2, 202600002, 1, 1, 2),
(3, 202600003, 1, 1, 3),
(4, 202600004, 1, 0, 6),
(5, 202600005, 1, 1, 7),
(6, 202600101, 2, 1, 4),
(7, 202600102, 2, 1, 5),
(8, 202600103, 2, 1, 8);

-- aulas (id_professor referencia uma pessoa cadastrada e a disciplina deve pertencer ao curso da turma)

INSERT INTO aulas (
    id, id_turma, id_sala, id_professor, id_disciplina, turno
) VALUES
(1, 1, 1, 4, 1, 'Noturno'),
(2, 1, 2, 5, 2, 'Noturno'),
(3, 1, 3, 4, 3, 'Noturno'),
(4, 2, 1, 5, 9, 'Matutino'),
(5, 3, 4, 8, 4, 'Noturno'),
(6, 4, 5, 5, 6, 'Noturno'),
(7, 4, 6, 4, 7, 'Noturno'),
(8, 5, 7, 8, 5, 'Matutino'),
(9, 5, 8, 5, 8, 'Matutino'),
(10, 1, 2, 8, 9, 'Noturno'),
(11, 4, 5, 8, 10, 'Noturno'),
(12, 5, 7, 4, 11, 'Matutino');

