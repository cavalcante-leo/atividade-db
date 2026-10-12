# Banco de Dados — Gestão Acadêmica

Atividade de Banco de Dados: modelagem e consultas SQL para o tema **Gestão Acadêmica** (alunos, disciplinas, turmas e matrículas), seguindo o mesmo formato do exercício da "Loja Fictícia" feito em sala.

Para o detalhamento completo (modelo, dicionário de dados, perguntas e resultados), veja a [documentação](DOCUMENTACAO.md).

## O que o banco representa

Uma instituição de ensino com cursos, disciplinas, turmas, professores, alunos e a estrutura física onde as aulas acontecem.

- Um **curso** pertence a uma **área de ensino** e possui **disciplinas** e **turmas**.
- Uma **aula** é a oferta de uma disciplina para uma turma, ministrada por um professor em uma sala.
- **Alunos e professores** são registros da tabela `pessoa`; o papel de cada um é definido pela `matricula` (tipo 1 = aluno, tipo 2 = professor).
- A tabela `inscricao` liga o aluno às aulas que ele cursa, com nota, frequência e situação.

## Arquivos

| Arquivo | Conteúdo | Responsável |
|---|---|---|
| `create-table.sql` | `CREATE TABLE` das tabelas principais e de relacionamento | Leandro |
| `insert-values.sql` | `INSERT` com os dados de exemplo | Miguel |
| `complemento-inscricao.sql` | Tabela `inscricao` (aluno x aula) e seus dados de exemplo | Grupo |
| `SELECT.sql` | Consultas 1 a 4 | Marcos |
| `SELECT-novos.sql` | Consultas 5 a 9 | — |
| `DOCUMENTACAO.md` | Documentação da atividade | — |

## Como executar (DB Browser for SQLite)

1. Crie um banco novo, por exemplo `gestao_academica.db`.
2. Abra a aba **Executar SQL** e rode, **nesta ordem**, o conteúdo de cada arquivo:
   1. `create-table.sql`
   2. `insert-values.sql`
   3. `complemento-inscricao.sql`
3. Clique em **Gravar alterações**.
4. Abra `SELECT.sql` e `SELECT-novos.sql` e execute **uma consulta por vez** (selecione somente o trecho de um SELECT e execute).

> Os SELECTs 8 e 9 dependem do `complemento-inscricao.sql`. Sem ele, retornam erro de tabela inexistente.

## Consultas

| Nº | Pergunta resumida |
|---|---|
| 1 | Ranking de professores por quantidade de disciplinas |
| 2 | Cursos cuja soma de horas das disciplinas diverge da carga horária declarada |
| 3 | Campus mais movimentado |
| 4 | Área de ensino com mais cursos e maior carga horária |
| 5 | Aulas na mesma sala e turno (possível conflito de agenda) |
| 6 | Cobertura da grade de cada turma |
| 7 | Painel de integridade dos dados |
| 8 | Desempenho por turma |
| 9 | Alunos ativos abaixo da média geral |

## Integrantes

- Leandro — `CREATE TABLE` e repositório
- Miguel — `INSERT`
- Marcos — SELECTs 1 a 4 e apresentação
- (seu nome) — SELECTs 5 a 9, documentação e README
