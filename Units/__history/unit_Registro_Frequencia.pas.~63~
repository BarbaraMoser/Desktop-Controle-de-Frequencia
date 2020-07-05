unit unit_Registro_Frequencia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client, FMX.Layouts;

type
  TUnitRegistroFrequencia = class(TForm)
    Panel1: TPanel;
    Panel4: TPanel;
    btnSalvar: TSpeedButton;
    spVoltarPrincipal: TSpeedButton;
    LbData: TLabel;
    LbAluno: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    EdQtdeAulaDia: TEdit;
    EdQtdeFaltasDia: TEdit;
    LbWarning: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
  private
    procedure salvarFrequencia;
    function verificarFrequenciaBanco: TFDQuery;
  public
    aluno: string;
    data: string;
    id_turma_aluno: string;
    id_professor: string;
    procedure setDados(id_aluno_turma: string; id_professor: string;  aluno: string; data: string);
  end;

var
  UnitRegistroFrequencia: TUnitRegistroFrequencia;

implementation

{$R *.fmx}

uses unit_BancoDados, Materia, Periodo, Utils, Diario;

procedure TUnitRegistroFrequencia.btnSalvarClick(Sender: TObject);
begin
  self.salvarFrequencia;

  self.Close;
end;


procedure TUnitRegistroFrequencia.salvarFrequencia;
var
  diario: TDiario;
  slDados:TStringList;
  frequencia_salva: TFDQuery;
begin
  frequencia_salva := self.verificarFrequenciaBanco;

  diario := TDiario.Create('diario');
  slDados := TStringList.Create;
  slDados.Clear;

  if frequencia_salva.IsEmpty then
    begin
      slDados.Add('0');
      slDados.Add(self.id_turma_aluno);
      slDados.Add(self.id_professor);
      slDados.Add(self.data);
      slDados.Add(EdQtdeAulaDia.Text);
      slDados.Add(EdQtdeFaltasDia.Text);

      diario.insert(slDados);
      ShowMessage('A frequencia foi registrada com sucesso!');
    end
  else
    begin
      slDados.Add(frequencia_salva.FieldByName('id_diario').AsString);
      slDados.Add(self.id_turma_aluno);
      slDados.Add(self.id_professor);
      slDados.Add(self.data);
      slDados.Add(EdQtdeAulaDia.Text);
      slDados.Add(EdQtdeFaltasDia.Text);

      diario.update(slDados);

      ShowMessage('A frequencia foi atualizada com sucesso!');
    end;

  diario.Free;
  slDados.Free;
  frequencia_salva.Free;
end;

procedure TUnitRegistroFrequencia.setDados(id_aluno_turma: string; id_professor: string; aluno, data: string);
var
  frequencia_salva: TFDQuery;
begin
  self.id_turma_aluno := id_aluno_turma;
  self.id_professor := id_professor;
  self.aluno := aluno;
  self.data := data;

  frequencia_salva := self.verificarFrequenciaBanco;

  if not frequencia_salva.IsEmpty then
    begin
      EdQtdeAulaDia.Text := frequencia_salva.FieldByName('qtde_aulas_dia').AsString;
      EdQtdeFaltasDia.Text := frequencia_salva.FieldByName('qtde_faltas').AsString;
      LbWarning.Visible := True
    end
  else
    LbWarning.Visible := False;

  LbData.Text := data;
  LbAluno.Text := aluno;

end;

procedure TUnitRegistroFrequencia.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

function TUnitRegistroFrequencia.verificarFrequenciaBanco: TFDQuery;
var
  diario: TFDQuery;
begin
  diario := TFDQuery.Create(nil);
  diario.Connection := dm_BancoDados.FDEscola;
  diario.Close;
  diario.SQL.Clear;
  diario.SQL.Add('select * from diario');
  diario.SQL.Add('where id_turma_materia = ' + self.id_turma_aluno);
  diario.SQL.Add('and id_professor = ' + self.id_professor);
  diario.SQL.Add('and data = "' + FormatDateTime('yyyy/MM/dd', StrToDate(self.data)) + '"');
  diario.Open;

  result := diario;
end;

end.
