select * from turma, aluno_turma
where aluno_turma.id_curso = 1
and aluno_turma.id_turma = turma.id_turma
group by aluno_turma.id_turma;

select * from materia, curso_materia, aluno_turma
where aluno_turma.id_turma = 1
and aluno_turma.id_curso = curso_materia.id_curso
and curso_materia.id_materia = materia.id_materia
group by curso_materia.id_materia;

select aluno.ID_ALUNO, pessoa.NOME from aluno_turma, pessoa, aluno, aluno_turma_materia
where aluno_turma_materia.ID_MATERIA = 9
and aluno_turma.ID_ALUNO_TURMA = aluno_turma_materia.ID_ALUNO_TURMA
and aluno.ID_ALUNO = aluno_turma.ID_ALUNO 
and pessoa.ID_PESSOA = aluno.ID_PESSOA
group by aluno.ID_ALUNO; 


select aluno_turma_materia.ID_TURMA_MATERIA, professor.ID_PROFESSOR, pessoa.NOME from aluno_turma, pessoa, professor, aluno, aluno_turma_materia
where aluno_turma_materia.ID_MATERIA = 9
and professor.ID_PROFESSOR = 2
and aluno_turma.ID_ALUNO_TURMA = aluno_turma_materia.ID_ALUNO_TURMA
and aluno.ID_ALUNO = aluno_turma.ID_ALUNO
and pessoa.ID_PESSOA = aluno.ID_PESSOA
group by aluno.ID_ALUNO;

select * from pessoa, professor
where pessoa.id_pessoa = professor.id_pessoa;


select pr.ID_PROFESSOR as ID, pe.NOME as NOME from materia, pessoa as pe, professor as pr
where materia.ID_MATERIA = 2
and materia.ID_PROFESSOR = pr.ID_PROFESSOR 
and pe.id_pessoa = pr.id_pessoa;


SELECT LAST_INSERT_ID();

SET GLOBAL max_allowed_packet=1073741824;

ALTER TABLE aluno AUTO_INCREMENT = 1;
ALTER TABLE aluno_turma AUTO_INCREMENT = 1;
ALTER TABLE aluno_turma_materia AUTO_INCREMENT = 1;
ALTER TABLE contato AUTO_INCREMENT = 1;
ALTER TABLE curso AUTO_INCREMENT = 1;
ALTER TABLE curso_materia AUTO_INCREMENT = 1;
ALTER TABLE foto AUTO_INCREMENT = 1;
ALTER TABLE materia AUTO_INCREMENT = 1;
ALTER TABLE periodo AUTO_INCREMENT = 1;
ALTER TABLE pessoa AUTO_INCREMENT = 1;
ALTER TABLE professor AUTO_INCREMENT = 1;
ALTER TABLE turma AUTO_INCREMENT = 1;
ALTER TABLE diario AUTO_INCREMENT = 1;
