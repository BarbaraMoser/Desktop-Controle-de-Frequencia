unit unit_Cadastro_Periodo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.Layouts, FireDAC.Comp.Client;

type
  TUnitCadastroPeriodos = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    edNomePeriodo: TEdit;
    LbNovoPeriodo: TLabel;
    Panel4: TPanel;
    btnSalvar: TSpeedButton;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    ImageControl1: TImageControl;
    LbPeriodosCadastrados: TListBox;
    Label1: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
  private
    function getPeriodosCadastrados:TFDQuery;
  public
    { Public declarations }
  end;

var
  UnitCadastroPeriodos: TUnitCadastroPeriodos;

implementation

{$R *.fmx}

uses unit_BancoDados, Periodo, Utils;

procedure TUnitCadastroPeriodos.btnSalvarClick(Sender: TObject);
var
  periodo:TPeriodo;
  slDados:TStringList;
  periodos_salvos: TFDQuery;
begin
  slDados := TStringList.Create;
  slDados.Clear;
  slDados.Add('0');
  slDados.Add(edNomePeriodo.Text);

  periodo := TPeriodo.Create('periodo');
  periodo.estado := 0;
  periodo.insert(slDados);

  periodo.utilitario.LimpaTela(self);
  edNomePeriodo.SetFocus;
  periodo.Free;

  periodos_salvos := self.getPeriodosCadastrados();
  LbPeriodosCadastrados.Clear;

  while not periodos_salvos.Eof do
    begin
      LbPeriodosCadastrados.Items.Add(periodos_salvos.FieldByName('periodo').AsString);
      periodos_salvos.Next;
    end;
end;

procedure TUnitCadastroPeriodos.btnSalvarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
var
  utils: TUtils;
begin
  utils.validaCampoPreenchido(edNomePeriodo.Text, LbNovoPeriodo.Text);

  edNomePeriodo.SetFocus;
end;

procedure TUnitCadastroPeriodos.FormCreate(Sender: TObject);
var
  periodos: TFDQuery;
begin
  periodos := self.getPeriodosCadastrados();

  while not periodos.Eof do
    begin
      LbPeriodosCadastrados.Items.Add(periodos.FieldByName('periodo').AsString);
      periodos.Next;
    end;

  if LbPeriodosCadastrados.Count = 0 then
     LbPeriodosCadastrados.Items.Add('Não há Período cadastrado.')
end;

function TUnitCadastroPeriodos.getPeriodosCadastrados: TFDQuery;
var
  periodos: TFDQuery;
begin
  periodos := TFDQuery.Create(nil);
  periodos.Connection := dm_BancoDados.FDEscola;
  periodos.Close;
  periodos.SQL.Clear;
  periodos.SQL.Add('select * from periodo');

  try
    periodos.Open;
    result := periodos;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitCadastroPeriodos.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

end.
