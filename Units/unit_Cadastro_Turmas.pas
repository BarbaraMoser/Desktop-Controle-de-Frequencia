unit unit_Cadastro_Turmas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  unit_Cadastro_Aluno_Turma, FireDAC.Comp.Client;

type
  TUnitCadastroTurmas = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    edDescricaoTurma: TEdit;
    LbDescricao: TLabel;
    LbDataInicio: TLabel;
    DtFimTurma: TDateEdit;
    LbDataFim: TLabel;
    cbSemestre: TComboBox;
    LbSemestre: TLabel;
    Panel4: TPanel;
    btnSalvar: TSpeedButton;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    DtInicioTurma: TDateEdit;
    ImageControl1: TImageControl;
    BtAdicionarMateriasCurso: TButton;
    btnDeletar: TSpeedButton;
    LbIdTurma: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure BtAdicionarMateriasCursoClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure DtInicioTurmaCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbSemestreCanFocus(Sender: TObject; var ACanFocus: Boolean);
  private
    { Private declarations }
  public
    function verificarTurmaBanco(id_turma: String): TFDQuery;
  end;

var
  UnitCadastroTurmas: TUnitCadastroTurmas;

implementation

{$R *.fmx}

uses unit_BancoDados, Turma, Utils;

procedure TUnitCadastroTurmas.BtAdicionarMateriasCursoClick(Sender: TObject);
var
  cad_alunos_turma: TUnitCadastroAlunoTurma;
begin
  cad_alunos_turma := TUnitCadastroAlunoTurma.Create(Application);
  cad_alunos_turma.showmodal;
end;


procedure TUnitCadastroTurmas.btnDeletarClick(Sender: TObject);
var
  turma:TTurma;
  slDadosTurma:TStringList;
begin
  slDadosTurma := TStringList.Create;
  slDadosTurma.Clear;
  slDadosTurma.Add(LbIdTurma.Text);
  slDadosTurma.Add(edDescricaoTurma.Text);
  slDadosTurma.Add(DateToStr(DtInicioTurma.Date));
  slDadosTurma.Add(DateToStr(DtFimTurma.Date));
  slDadosTurma.Add(IntToStr(cbSemestre.ItemIndex));
  slDadosTurma.Add('0');

  turma := TTurma.Create('turma');
  turma.update(slDadosTurma);

  turma.utilitario.LimpaTela(self);
  edDescricaoTurma.SetFocus;
  ShowMessage('O cadastro foi deletado com sucesso!');
  turma.Free;
end;

procedure TUnitCadastroTurmas.btnSalvarClick(Sender: TObject);
var
  turma:TTurma;
  slDados:TStringList;
begin
  if cbSemestre.ItemIndex = 0 then
    raise Exception.Create('É preciso selecionar um Semestre.');

  slDados := TStringList.Create;
  slDados.Clear;
  turma := TTurma.Create('turma');

  if (self.verificarTurmaBanco(LbIdTurma.Text).IsEmpty) then
    begin
      slDados.Add('0');
      slDados.Add(edDescricaoTurma.Text);
      slDados.Add(DateToStr(DtInicioTurma.Date));
      slDados.Add(DateToStr(DtFimTurma.Date));
      slDados.Add(IntToStr(cbSemestre.ItemIndex));
      slDados.Add('1');

      ShowMessage('O cadastro foi inserido com sucesso!');
      turma.insert(slDados);
    end
  else
    begin
      slDados.Add(LbIdTurma.Text);
      slDados.Add(edDescricaoTurma.Text);
      slDados.Add(DateToStr(DtInicioTurma.Date));
      slDados.Add(DateToStr(DtFimTurma.Date));
      slDados.Add(IntToStr(cbSemestre.ItemIndex));
      slDados.Add('1');

      ShowMessage('O cadastro foi atualizado com sucesso!');
      turma.update(slDados);
    end;

  turma.utilitario.LimpaTela(self);
  edDescricaoTurma.SetFocus;
  turma.Free;
end;

procedure TUnitCadastroTurmas.cbSemestreCanFocus(Sender: TObject;
  var ACanFocus: Boolean);
var
  utils: TUtils;
begin
  utils.validarDatas(DtInicioTurma.Date, DtFimTurma.Date, DtFimTurma);
end;

procedure TUnitCadastroTurmas.DtInicioTurmaCanFocus(Sender: TObject; var ACanFocus: Boolean);
var
  utils: TUtils;
begin
  utils.validaCampoPreenchido(edDescricaoTurma.Text, LbDescricao.Text);

  edDescricaoTurma.SetFocus;
end;

procedure TUnitCadastroTurmas.FormCreate(Sender: TObject);
begin
  DtInicioTurma.Data := now;
  DtFimTurma.Data := now + 1;
  cbSemestre.ItemIndex := 0;
end;

procedure TUnitCadastroTurmas.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

function TUnitCadastroTurmas.verificarTurmaBanco(id_turma: String): TFDQuery;
var
  consulta_turma: TFDQuery;
begin
  consulta_turma := TFDQuery.Create(nil);
  consulta_turma.Connection := dm_BancoDados.FDEscola;
  consulta_turma.Close;
  consulta_turma.SQL.Clear;
  consulta_turma.SQL.Add('select * from turma');
  consulta_turma.SQL.Add('where id_turma');
  consulta_turma.SQL.Add('= "' + id_turma + '" and ativo = 1');
  consulta_turma.Open;

  result := consulta_turma;;
end;

end.
