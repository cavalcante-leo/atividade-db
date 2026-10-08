create table pessoa (
    id int primary key
    nome varchar(100) not null
    cpf varchar(100) not null,
    email varchar(100) not null
);

create table matricula (
    id int primary key
    numero_matricula bigint not null unique,
    tipo int not null,
    ativa boolean not null,
    id_pessoa int not null
    foreign key (id_pessoa)
    references pessoa(id_pessoa)
);

create table area_ensino (
    id int primary key
    nome varchar(100) not null
    descricao varchar(100), 
);

create table curso (
    id int primary key
    nome varchar(100) not null
    descricao varchar(100),
    horas_totais int not null, 
    id_area_ensino int not null,
    disponivel boolean not null,
    foreign key (id_area_ensino)
    references area_ensino(id)
);

create table disciplina (
    id int primary key
    nome varchar(100) not null
    descricao varchar(100),
    horas_individuais int not null, 
    id_curso int not null,
    foreign key (id_curso)
    references curso(id)
);

create table turma (
    id int primary key
    semestre int not null,
    turno varchar(100) not null, 
    id_curso int not null,
    foreign key (id_curso)
    references curso(id)
);

create table campus (
    id int primary key
    nome int not null,
    endereco varchar(100) not null
);

create table sala (
    id int primary key
    id_campus int not null,
    turno int not null,    
    foreign key (id_campus)
    references campus(id)
);


