program prEscola;

uses
  System.StartUpCopy,
  FMX.Forms,
  unit_Principal in '..\Units\unit_Principal.pas' {form_Principal},
  unit_BancoDados in '..\Units\unit_BancoDados.pas' {dm_BancoDados: TDataModule},
  Cadastro in '..\Classes\Cadastro.pas',
  Aluno in '..\Classes\Aluno.pas',
  Pessoa in '..\Classes\Pessoa.pas',
  Utilitario in '..\Classes\Utilitario.pas',
  Consulta in '..\Classes\Consulta.pas',
  unit_Consulta in '..\Units\unit_Consulta.pas' {frm_Consulta},
  unit_Cadastro_Pessoas in '..\Units\unit_Cadastro_Pessoas.pas' {UnitCadastroPessoas},
  unit_Cadastros in '..\Units\unit_Cadastros.pas' {UnitCadastros},
  unit_Cadastro_Turmas in '..\Units\unit_Cadastro_Turmas.pas',
  Turma in '..\Classes\Turma.pas',
  unit_Cadastro_Curso in '..\Units\unit_Cadastro_Curso.pas' {UnitCadastroCursos},
  Contato in '..\Classes\Contato.pas',
  Curso in '..\Classes\Curso.pas',
  Periodo in '..\Classes\Periodo.pas',
  Materia in '..\Classes\Materia.pas',
  unit_Cadastro_Materia in '..\Units\unit_Cadastro_Materia.pas',
  unit_Cadastro_Periodo in '..\Units\unit_Cadastro_Periodo.pas' {UnitCadastroPeriodos},
  unit_Cadastro_Contato in '..\Units\unit_Cadastro_Contato.pas' {UnitCadastroContatos},
  Professor in '..\Classes\Professor.pas',
  Foto in '..\Classes\Foto.pas',
  Curso_Materia in '..\Classes\Curso_Materia.pas',
  unit_Cadastro_Curso_Materia in '..\Units\unit_Cadastro_Curso_Materia.pas',
  unit_Cadastro_Aluno_Turma in '..\Units\unit_Cadastro_Aluno_Turma.pas' {UnitCadastroAlunoTurma},
  Aluno_Turma in '..\Classes\Aluno_Turma.pas',
  Diario in '..\Classes\Diario.pas',
  unit_Cadastro_Diario in '..\Units\unit_Cadastro_Diario.pas',
  unit_Tipo_Consultas in '..\Units\unit_Tipo_Consultas.pas' {UnitTipoConsultas},
  Aluno_Turma_Materia in '..\Classes\Aluno_Turma_Materia.pas',
  Utils in '..\Classes\Utils.pas',
  unit_Registro_Frequencia in '..\Units\unit_Registro_Frequencia.pas' {UnitRegistroFrequencia},
  unit_Frequencia in '..\Units\unit_Frequencia.pas' {UnitConsultaFrequencia};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tform_Principal, form_Principal);
  Application.CreateForm(Tdm_BancoDados, dm_BancoDados);
  Application.CreateForm(TUnitCadastroPessoas, UnitCadastroPessoas);
  Application.CreateForm(TUnitCadastros, UnitCadastros);
  Application.CreateForm(TUnitCadastroCursos, UnitCadastroCursos);
  Application.CreateForm(TUnitCadastroContatos, UnitCadastroContatos);
  Application.CreateForm(TUnitRegistroFrequencia, UnitRegistroFrequencia);
  Application.CreateForm(TUnitConsultaFrequencia, UnitConsultaFrequencia);
  Application.Run;
end.
