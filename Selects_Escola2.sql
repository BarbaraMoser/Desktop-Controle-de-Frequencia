select * from diario
where id_turma_materia = 2
and id_professor = 1
and data = '2020-05-15';


CREATE FUNCTION NETWORKDAYS(sd DATE, ed DATE)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
BEGIN
  RETURN (5 * (DATEDIFF(ed, sd) DIV 7) + MID('0123444401233334012222340111123400001234000123440', 7 * WEEKDAY(sd) + WEEKDAY(ed) + 1, 1))+1;
end;

select NETWORKDAYS('2020-02-10', '2020-05-21');


select * from turma where ID_TURMA = 1;

select turma.id_turma as id, turma.descricao as nome
from aluno_turma, turma, curso
where aluno_turma.ID_CURSO = 1
and aluno_turma.ID_TURMA = turma.ID_TURMA 
group by turma.ID_TURMA;


select turma.DESCRICAO as turma, turma.ID_TURMA as id_turma, aluno.ID_ALUNO as id_aluno, pessoa.NOME as aluno
from aluno_turma, turma, aluno, pessoa
where aluno_turma.ID_CURSO = 1
and aluno_turma.ID_TURMA = turma.ID_TURMA 
and aluno_turma.ID_ALUNO = aluno.ID_ALUNO 
and aluno.ID_PESSOA = pessoa.ID_PESSOA
group by aluno_turma.ID_ALUNO;




select pessoa.NOME, ma.NOME as MATERIA, 
(select sum(QTDE_AULAS_DIA) from diario d2 
where d2.ID_TURMA_MATERIA = aluno_turma_materia.ID_TURMA_MATERIA
and d2.`DATA` between '2020-03-01' and '2020-07-20') as QTDE_AULAS_DIA,
(select sum(QTDE_FALTAS) from diario d2 
where d2.ID_TURMA_MATERIA = aluno_turma_materia.ID_TURMA_MATERIA
and d2.`DATA` between '2020-03-01' and '2020-07-20') as QTDE_FALTAS
from diario, aluno_turma, aluno_turma_materia, aluno, pessoa, materia as ma
where aluno_turma.ID_TURMA = 1
and aluno_turma.ID_ALUNO = aluno.ID_ALUNO 
and aluno.ID_PESSOA = pessoa.ID_PESSOA
and aluno_turma_materia.ID_ALUNO_TURMA = aluno_turma.ID_ALUNO_TURMA 
and aluno_turma_materia.ID_MATERIA  = ma.ID_MATERIA 
group by MA.ID_MATERIA, aluno.ID_ALUNO  
order by pessoa.NOME, diario.`DATA`;



select * from diario 
where diario.`DATA` between '2020-05-19' and '2020-05-20';	



select * from aluno_turma where 
ID_ALUNO = 5
and ID_TURMA = 1
and ID_CURSO = 1;
