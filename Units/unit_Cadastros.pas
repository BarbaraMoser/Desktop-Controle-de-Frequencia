unit unit_Cadastros;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, unit_Cadastro_Pessoas, unit_Cadastro_Turmas,
  unit_Cadastro_Curso, unit_Cadastro_Materia, unit_Cadastro_Periodo, unit_Cadastro_Contato;

type
  TUnitCadastros = class(TForm)
    Panel1: TPanel;
    Panel5: TPanel;
    Label6: TLabel;
    Panel2: TPanel;
    SpbPessoas: TSpeedButton;
    Panel3: TPanel;
    SpbContatos: TSpeedButton;
    Panel4: TPanel;
    SpbTurmas: TSpeedButton;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    SpbPeriodo: TSpeedButton;
    SpbCursos: TSpeedButton;
    SpbMateria: TSpeedButton;
    Panel10: TPanel;
    spVoltarPrincipal: TSpeedButton;
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure SpbPessoasClick(Sender: TObject);
    procedure SpbTurmasClick(Sender: TObject);
    procedure SpbCursosClick(Sender: TObject);
    procedure SpbMateriaClick(Sender: TObject);
    procedure SpbPeriodoClick(Sender: TObject);
    procedure SpbContatosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UnitCadastros: TUnitCadastros;

implementation

{$R *.fmx}

procedure TUnitCadastros.SpbContatosClick(Sender: TObject);
var
  cad_contato: TUnitCadastroContatos;
begin
  cad_contato := TUnitCadastroContatos.Create(Application);
  cad_contato.showmodal;
end;

procedure TUnitCadastros.SpbCursosClick(Sender: TObject);
var
  cad_curso: TUnitCadastroCursos;
begin
  cad_curso := TUnitCadastroCursos.Create(Application);
  cad_curso.showmodal;
end;

procedure TUnitCadastros.SpbMateriaClick(Sender: TObject);
var
  cad_materia: TUnitCadastroMateria;
begin
  cad_materia := TUnitCadastroMateria.Create(Application);
  cad_materia.showmodal;
end;

procedure TUnitCadastros.SpbPeriodoClick(Sender: TObject);
var
  cad_periodo: TUnitCadastroPeriodos;
begin
  cad_periodo := TUnitCadastroPeriodos.Create(Application);
  cad_periodo.showmodal;
end;

procedure TUnitCadastros.SpbPessoasClick(Sender: TObject);
var
  cad_pessoa: TUnitCadastroPessoas;
begin
  cad_pessoa := TUnitCadastroPessoas.Create(Application);
  cad_pessoa.showmodal;
end;

procedure TUnitCadastros.SpbTurmasClick(Sender: TObject);
var
  cad_turma: TUnitCadastroTurmas;
begin
  cad_turma := TUnitCadastroTurmas.Create(Application);
  cad_turma.showmodal;
end;

procedure TUnitCadastros.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

end.
