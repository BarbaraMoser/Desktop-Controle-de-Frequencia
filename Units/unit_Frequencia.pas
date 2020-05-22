unit unit_Frequencia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid;

type
  TUnitConsultaFrequencia = class(TForm)
    Panel5: TPanel;
    Label6: TLabel;
    ImageControl1: TImageControl;
    Panel1: TPanel;
    StGridConsulta: TStringGrid;
    LbCampoPesquisa: TLabel;
    LbCurso: TLabel;
    cbCurso: TComboBox;
    CbTurma: TComboBox;
    LbTurma: TLabel;
    dtDataInicio: TDateEdit;
    dtDataFim: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    spVoltarPrincipal: TSpeedButton;
    BtBuscarAlunos: TButton;
    QTDE_FALTAS: TStringColumn;
    ALUNO: TStringColumn;
    FREQUENCIA_GERAL: TStringColumn;
    QTDE_AULAS_DIA: TStringColumn;
    LbWarningDados: TLabel;
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCursoChange(Sender: TObject);
    procedure BtBuscarAlunosClick(Sender: TObject);
    procedure dtDataFimChange(Sender: TObject);
  private
    procedure setCursos;
    procedure setTurmas(id_curso: string);
    procedure setAlunos(id_turma: string; data_inicio: string; data_fim: string; dias_uteis_turma: string);
    function calculaDiasUteisTurma(id_turma: string; data_inicio: string; data_fim: string): integer;
    function calculaFrequenciaGeral(dias_uteis: integer; qtde_faltas: integer): string;
    function buscarInfosTurma(id_turma: string): TFDQuery;
  public
    { Public declarations }
  end;

var
  UnitConsultaFrequencia: TUnitConsultaFrequencia;

implementation

{$R *.fmx}

uses unit_BancoDados, Contato, Pessoa, Utils, Utilitario;


procedure TUnitConsultaFrequencia.BtBuscarAlunosClick(Sender: TObject);
var
  turma_selecionada, data_inicio, data_fim, dias_uteis_turma: string;
begin
  turma_selecionada := IntToStr(Integer(CbTurma.Items.Objects[CbTurma.ItemIndex]));
  data_inicio := FormatDateTime('yyyy/MM/dd', StrToDate(dtDataInicio.Text));
  data_fim := FormatDateTime('yyyy/MM/dd', StrToDate(dtDataFim.Text));
  dias_uteis_turma := IntToStr(self.calculaDiasUteisTurma(turma_selecionada, data_inicio, data_fim));
  self.setAlunos(turma_selecionada, data_inicio, data_fim, dias_uteis_turma);
end;

function TUnitConsultaFrequencia.buscarInfosTurma(id_turma: string): TFDQuery;
var
  turma: TFDQuery;
begin
  turma := TFDQuery.Create(nil);
  turma.Connection := dm_BancoDados.FDEscola;
  turma.Close;
  turma.SQL.Clear;
  turma.SQL.Add('select * from turma where id_turma =' + id_turma);

  try
    turma.Open;
    result := turma;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;

end;

function TUnitConsultaFrequencia.calculaDiasUteisTurma(id_turma: string; data_inicio: string; data_fim: string): integer;
var
  dias_uteis_turma, turma: TFDQuery;
begin
  turma := self.buscarInfosTurma(id_turma);

  dias_uteis_turma := TFDQuery.Create(nil);
  dias_uteis_turma.Connection := dm_BancoDados.FDEscola;
  dias_uteis_turma.Close;
  dias_uteis_turma.SQL.Clear;
  dias_uteis_turma.SQL.Add('select NETWORKDAYS("' + data_inicio + '", "' + data_fim + '")');

  try
    dias_uteis_turma.Open();
    result := dias_uteis_turma.Fields[0].Value

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

function TUnitConsultaFrequencia.calculaFrequenciaGeral(dias_uteis, qtde_faltas: integer): string;
var
  qtde_aulas_uteis, frequencia: integer;
begin
  qtde_aulas_uteis := dias_uteis * 4;
  frequencia := ((qtde_aulas_uteis - qtde_faltas) * 100) div qtde_aulas_uteis;
  result := IntToStr(frequencia) + '%';
end;

procedure TUnitConsultaFrequencia.cbCursoChange(Sender: TObject);
var
  curso_selecionado: string;
begin
  curso_selecionado := IntToStr(Integer(cbCurso.Items.Objects[cbCurso.ItemIndex]));
  self.setTurmas(curso_selecionado);
end;

procedure TUnitConsultaFrequencia.dtDataFimChange(Sender: TObject);
begin
  if dtDataInicio.Date <= dtDataFim.Date then
    raise Exception.Create('A data fim deve ser maior que a data de início.')
end;

procedure TUnitConsultaFrequencia.FormCreate(Sender: TObject);
begin
  self.setCursos;
end;

procedure TUnitConsultaFrequencia.setAlunos(id_turma: string; data_inicio: string; data_fim: string; dias_uteis_turma: string);
var
  alunos_diario: TFDQuery;
  utilitario: Tutilitario;
  i:integer;
  coluna: TColumn;
begin
  utilitario := Tutilitario.Create;

  alunos_diario := TFDQuery.Create(nil);
  alunos_diario.Connection := dm_BancoDados.FDEscola;
  alunos_diario.Close;
  alunos_diario.SQL.Clear;
  alunos_diario.SQL.Add('select sum(QTDE_AULAS_DIA) as QTDE_AULAS_DIA, sum(QTDE_FALTAS) as QTDE_FALTAS, pessoa.NOME as aluno');
  alunos_diario.SQL.Add('from aluno_turma, aluno_turma_materia, diario, aluno, pessoa');
  alunos_diario.SQL.Add('where aluno_turma.ID_TURMA =' + id_turma);
  alunos_diario.SQL.Add('and aluno_turma.ID_ALUNO = aluno.ID_ALUNO');
  alunos_diario.SQL.Add('and aluno.ID_PESSOA = pessoa.ID_PESSOA');
  alunos_diario.SQL.Add('and aluno_turma_materia.ID_ALUNO_TURMA = aluno_turma.ID_ALUNO_TURMA');
  alunos_diario.SQL.Add('and diario.ID_TURMA_MATERIA = aluno_turma_materia.ID_TURMA_MATERIA');
  alunos_diario.SQL.Add('and diario.`DATA` between "' + data_inicio + '" and "' + data_fim + '"');
  alunos_diario.SQL.Add('group by aluno.ID_ALUNO');
  alunos_diario.SQL.Add('order by pessoa.NOME');


  try
    alunos_diario.Open;

    if alunos_diario.IsEmpty then
      ShowMessage('Não há registros para esse filtro.');

    while not alunos_diario.Eof do
      begin
        utilitario.LimpaStringGrid(StGridConsulta);
        alunos_diario.First;

        while (not alunos_diario.Eof) do
          begin
            if (StGridConsulta.Cells[0,0] <> '') then
              StGridConsulta.RowCount := StGridConsulta.RowCount + 1;

            for i := 0 to alunos_diario.FieldCount -1 do
              StGridConsulta.Cells[i, StGridConsulta.RowCount -1] := alunos_diario.Fields[i].AsString;

            StGridConsulta.Cells[alunos_diario.FieldCount, StGridConsulta.RowCount -1] := self.calculaFrequenciaGeral(StrToInt(dias_uteis_turma), alunos_diario.FieldByName('QTDE_FALTAS').AsInteger);

            alunos_diario.Next;
          end;
      end;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitConsultaFrequencia.setCursos;
var
  cursos: TFDQuery;
begin
  cbCurso.Clear;
  cbCurso.Items.Add('Selecione o Curso');
  cbCurso.ItemIndex := 0;

  cursos := TFDQuery.Create(nil);
  cursos.Connection := dm_BancoDados.FDEscola;
  cursos.Close;
  cursos.SQL.Clear;
  cursos.SQL.Add('select * from curso');

  try
    cursos.Open;

    while not cursos.Eof do
      begin
        cbCurso.Items.Objects[cbCurso.Items.Add(cursos.FieldByName('nome').AsString)] := TObject(cursos.FieldByName('id_curso').AsInteger);
        cursos.Next;
      end;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitConsultaFrequencia.setTurmas(id_curso: string);
var
  turmas: TFDQuery;
begin
  CbTurma.Clear;
  CbTurma.Items.Add('Selecione a Turma');
  CbTurma.ItemIndex := 0;

  turmas := TFDQuery.Create(nil);
  turmas.Connection := dm_BancoDados.FDEscola;
  turmas.Close;
  turmas.SQL.Clear;
  turmas.SQL.Add('select turma.id_turma as id, turma.descricao as nome');
  turmas.SQL.Add('from aluno_turma, turma, curso');
  turmas.SQL.Add('where aluno_turma.ID_CURSO =' + id_curso);
  turmas.SQL.Add('and aluno_turma.ID_TURMA = turma.ID_TURMA');
  turmas.SQL.Add('group by turma.ID_TURMA');


  try
    turmas.Open;

    while not turmas.Eof do
      begin
        CbTurma.Items.Objects[CbTurma.Items.Add(turmas.FieldByName('nome').AsString)] := TObject(turmas.FieldByName('id').AsInteger);
        turmas.Next;
      end;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitConsultaFrequencia.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

end.
