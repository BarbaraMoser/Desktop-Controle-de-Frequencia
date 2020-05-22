unit unit_Cadastro_Aluno_Turma;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client, FMX.Layouts;

type
  TUnitCadastroAlunoTurma = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    LbNomeCurso: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    ImageControl1: TImageControl;
    LbMateria: TLabel;
    cbTurma: TComboBox;
    LbAlunoTurma: TListBox;
    BtAlunoTurma: TButton;
    CbCursoTurma: TComboBox;
    Label1: TLabel;
    CbAlunoTurma: TComboBox;
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtAlunoTurmaClick(Sender: TObject);
    procedure CbCursoTurmaChange(Sender: TObject);
  private
    procedure setCurso;
    procedure setTurma;
    procedure setAluno;
  public
    procedure gravarAlunoTurmaMateria(id_aluno_turma: String);
  end;

var
  UnitCadastroAlunoTurma: TUnitCadastroAlunoTurma;

implementation

{$R *.fmx}

uses unit_BancoDados, Curso, Aluno_Turma, Aluno_Turma_Materia, Cadastro;

procedure TUnitCadastroAlunoTurma.BtAlunoTurmaClick(Sender: TObject);
var
  aluno_turma: TAlunoTurma;
  aluno_selecionado: TFDQuery;
  slDadosAlunoTurma: TStringList;
  busca_id: TCadastro;
begin
  LbAlunoTurma.Items.Objects[LbAlunoTurma.Items.Add(CbAlunoTurma.Selected.Text)] := TObject(IntToStr(Integer(CbAlunoTurma.Items.Objects[CbAlunoTurma.ItemIndex])));

  aluno_selecionado := TFDQuery.Create(nil);
  aluno_selecionado.Connection := dm_BancoDados.FDEscola;
  aluno_selecionado.Close;
  aluno_selecionado.SQL.Clear;
  aluno_selecionado.SQL.Add('select id_aluno from aluno');
  aluno_selecionado.SQL.Add('where id_pessoa = ' + IntToStr(Integer(CbAlunoTurma.Items.Objects[CbAlunoTurma.ItemIndex])));
  aluno_selecionado.Open;

  slDadosAlunoTurma := TStringList.Create;
  slDadosAlunoTurma.Clear;
  slDadosAlunoTurma.Add('0');
  slDadosAlunoTurma.Add(aluno_selecionado.FieldByName('id_aluno').AsString);
  slDadosAlunoTurma.Add(IntToStr(Integer(cbTurma.Items.Objects[cbTurma.ItemIndex])));
  slDadosAlunoTurma.Add(IntToStr(Integer(CbCursoTurma.Items.Objects[CbCursoTurma.ItemIndex])));

  aluno_turma := TAlunoTurma.Create('aluno_turma');
  aluno_turma.estado := 0;
  aluno_turma.insert(slDadosAlunoTurma);

  self.gravarAlunoTurmaMateria(busca_id.buscarUltimoIdInserido);
end;


procedure TUnitCadastroAlunoTurma.CbCursoTurmaChange(Sender: TObject);
begin
  LbAlunoTurma.Clear;
end;

procedure TUnitCadastroAlunoTurma.FormCreate(Sender: TObject);
begin
  self.setCurso;
  self.setTurma;
  self.setAluno;

  if CbCursoTurma.Count = 0 then
    raise Exception.Create('N�o h� curso cadastrado ainda.');

  if cbTurma.Count = 0 then
    raise Exception.Create('N�o h� turmas cadastradas ainda.');

  if CbAlunoTurma.Count = 0 then
    raise Exception.Create('N�o h� alunos cadastrados ainda.');
end;

procedure TUnitCadastroAlunoTurma.gravarAlunoTurmaMateria(id_aluno_turma: String);
var
  aluno_turma_materia: TAlunoTurmaMateria;
  aluno_materia: TFDQuery;
  slDados: TStringList;
begin
  aluno_materia := TFDQuery.Create(nil);
  aluno_materia.Connection := dm_BancoDados.FDEscola;
  aluno_materia.Close;
  aluno_materia.SQL.Clear;
  aluno_materia.SQL.Add('select id_aluno_turma, id_materia from aluno_turma, curso_materia');
  aluno_materia.SQL.Add('where aluno_turma.ID_CURSO = curso_materia.ID_CURSO');
  aluno_materia.SQL.Add('and aluno_turma.ID_ALUNO_TURMA = ' + id_aluno_turma);
  aluno_materia.Open;

  while (not aluno_materia.Eof) do
    begin
      slDados := TStringList.Create;
      slDados.Clear;
      slDados.Add('0');
      slDados.Add(aluno_materia.FieldByName('id_aluno_turma').AsString);
      slDados.Add(aluno_materia.FieldByName('id_materia').AsString);

      aluno_turma_materia := TAlunoTurmaMateria.Create('aluno_turma_materia');
      aluno_turma_materia.insert(slDados);

      aluno_materia.Next;
    end;

  aluno_materia.Close;
  FreeAndNil(aluno_materia);
end;

procedure TUnitCadastroAlunoTurma.setAluno;
var
  aluno: TFDQuery;
begin
  CbAlunoTurma.Clear;
  aluno := TFDQuery.Create(nil);
  aluno.Connection := dm_BancoDados.FDEscola;
  aluno.Close;
  aluno.SQL.Clear;
  aluno.SQL.Add('select * from pessoa');
  aluno.SQL.Add('where tipo_pessoa = 2');

  try
    aluno.Open;

    while not aluno.Eof do
      begin
        CbAlunoTurma.Items.Objects[CbAlunoTurma.Items.Add(aluno.FieldByName('nome').AsString)] := TObject(aluno.FieldByName('id_pessoa').AsInteger);
        aluno.Next;
      end;

  except
    on e:exception do
     begin
          ShowMessage('Comando SQL n�o executado: ' + e.ToString);
          exit;
     end;
  end;
end;

procedure TUnitCadastroAlunoTurma.setCurso;
var
  curso: TFDQuery;
begin
  CbCursoTurma.Clear;
  curso := TFDQuery.Create(nil);
  curso.Connection := dm_BancoDados.FDEscola;
  curso.Close;
  curso.SQL.Clear;
  curso.SQL.Add('select * from curso');

  try
    curso.Open;

    while not curso.Eof do
      begin
        CbCursoTurma.Items.Objects[CbCursoTurma.Items.Add(curso.FieldByName('nome').AsString)] := TObject(curso.FieldByName('id_curso').AsInteger);
        curso.Next;
      end;

  except
    on e:exception do
     begin
          ShowMessage('Comando SQL n�o executado: ' + e.ToString);
          exit;
     end;
  end;
end;

procedure TUnitCadastroAlunoTurma.setTurma;
var
  turma: TFDQuery;
begin
  cbTurma.Clear;
  turma := TFDQuery.Create(nil);
  turma.Connection := dm_BancoDados.FDEscola;
  turma.Close;
  turma.SQL.Clear;
  turma.SQL.Add('select * from turma');

  try
    turma.Open;

    while not turma.Eof do
      begin
        cbTurma.Items.Objects[cbTurma.Items.Add(turma.FieldByName('descricao').AsString)] := TObject(turma.FieldByName('id_turma').AsInteger);
        turma.Next;
      end;

  except
    on e:exception do
     begin
          ShowMessage('Comando SQL n�o executado: ' + e.ToString);
          exit;
     end;
  end;
end;

procedure TUnitCadastroAlunoTurma.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

end.
