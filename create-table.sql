-- Tabelas Principais

CREATE TABLE pessoa (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE area_ensino (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE curso (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    horas_totais INT NOT NULL,
    id_area_ensino INT NOT NULL,
    disponivel BOOLEAN NOT NULL,
    FOREIGN KEY (id_area_ensino) REFERENCES area_ensino(id)
);

CREATE TABLE disciplina (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    horas_individuais INT NOT NULL,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES curso(id)
);

CREATE TABLE turma (
    id INT PRIMARY KEY,
    semestre INT NOT NULL,
    turno VARCHAR(20) NOT NULL,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES curso(id)
);

CREATE TABLE campus (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

CREATE TABLE sala (
    id INT PRIMARY KEY,
    id_campus INT NOT NULL,
    FOREIGN KEY (id_campus) REFERENCES campus(id)
);

-- Tabelas de Relacionamento

CREATE TABLE matricula (
    id INT PRIMARY KEY,
    numero_matricula BIGINT NOT NULL UNIQUE,
    tipo INT NOT NULL,
    ativa BOOLEAN NOT NULL,
    id_pessoa INT NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

CREATE TABLE aulas (
    id INT PRIMARY KEY,
    id_turma INT NOT NULL,
    id_sala INT NOT NULL,
    id_professor INT NOT NULL,
    id_disciplina INT NOT NULL,
    turno VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_turma) REFERENCES turma(id),
    FOREIGN KEY (id_sala) REFERENCES sala(id),
    FOREIGN KEY (id_professor) REFERENCES pessoa(id),
    FOREIGN KEY (id_disciplina) REFERENCES disciplina(id)
);