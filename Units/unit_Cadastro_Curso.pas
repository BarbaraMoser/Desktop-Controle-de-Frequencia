unit unit_Cadastro_Curso;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client, FMX.Layouts, unit_Cadastro_Curso_Materia;

type
  TUnitCadastroCursos = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    edNomeCurso: TEdit;
    LbNomeCurso: TLabel;
    Panel4: TPanel;
    btnSalvar: TSpeedButton;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    ImageControl1: TImageControl;
    Label1: TLabel;
    Label2: TLabel;
    BtAdicionarMateriasCurso: TButton;
    btnDeletar: TSpeedButton;
    LbIdCurso: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure BtAdicionarMateriasCursoClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnSalvarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function verificarCursoBanco(id_curso: String): TFDQuery;

  end;

var
  UnitCadastroCursos: TUnitCadastroCursos;

implementation

{$R *.fmx}

uses unit_BancoDados, Curso, Curso_Materia, Utils;

procedure TUnitCadastroCursos.BtAdicionarMateriasCursoClick(Sender: TObject);
var
  cad_materia_curso: TUnitCadastroCursoMaterias;
begin
  cad_materia_curso := TUnitCadastroCursoMaterias.Create(Application);
  cad_materia_curso.showmodal;
end;

procedure TUnitCadastroCursos.btnDeletarClick(Sender: TObject);
var
  curso:TCurso;
  slDadosCurso:TStringList;
begin
  slDadosCurso := TStringList.Create;
  slDadosCurso.Clear;
  slDadosCurso.Add(LbIdCurso.Text);
  slDadosCurso.Add(edNomeCurso.Text);
  slDadosCurso.Add('0');

  curso := TCurso.Create('curso');
  curso.update(slDadosCurso);

  curso.utilitario.LimpaTela(self);
  edNomeCurso.SetFocus;
  ShowMessage('O cadastro foi deletado com sucesso!');
  curso.Free;
end;

procedure TUnitCadastroCursos.btnSalvarClick(Sender: TObject);
var
  curso:TCurso;
  slDados:TStringList;
begin
  slDados := TStringList.Create;
  slDados.Clear;
  curso := TCurso.Create('curso');

  if (self.verificarCursoBanco(LbIdCurso.Text).IsEmpty) then
    begin
      slDados.Add('0');
      slDados.Add(edNomeCurso.Text);
      slDados.Add('1');

      curso.insert(slDados);
      ShowMessage('O cadastro foi adicionado com sucesso!');
    end
  else
    begin
      slDados.Add(LbIdCurso.Text);
      slDados.Add(edNomeCurso.Text);
      slDados.Add('1');

      curso.update(slDados);
      ShowMessage('O cadastro foi atualizado com sucesso!');
    end;

  curso.utilitario.LimpaTela(self);
  edNomeCurso.SetFocus;
  curso.Free;
end;


procedure TUnitCadastroCursos.btnSalvarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
var
  utils: TUtils;
begin
  utils.validaCampoPreenchido(edNomeCurso.Text, LbNomeCurso.Text);

  edNomeCurso.SetFocus;
end;

procedure TUnitCadastroCursos.FormCreate(Sender: TObject);
begin
  self.edNomeCurso.SetFocus;
end;

procedure TUnitCadastroCursos.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

function TUnitCadastroCursos.verificarCursoBanco(id_curso: String): TFDQuery;
var
  consulta_curso: TFDQuery;
begin
  consulta_curso := TFDQuery.Create(nil);
  consulta_curso.Connection := dm_BancoDados.FDEscola;
  consulta_curso.Close;
  consulta_curso.SQL.Clear;
  consulta_curso.SQL.Add('select * from curso');
  consulta_curso.SQL.Add('where id_curso');
  consulta_curso.SQL.Add('= "' + id_curso + '" and ativo = 1');
  consulta_curso.Open;

  result := consulta_curso;
end;

end.
