unit unit_Consulta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.ListBox, FMX.Layouts,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, FMX.Edit, FMX.Memo, Consulta,
  unit_Cadastro_Pessoas, DBClient, FireDAC.Comp.Client, StrUtils, unit_Tipo_Consultas;

type
  Tfrm_Consulta = class(TForm)
    Panel1: TPanel;
    edPalavraChave: TEdit;
    Label1: TLabel;
    Panel5: TPanel;
    Label6: TLabel;
    Panel2: TPanel;
    spVoltarPrincipal: TSpeedButton;
    StGridConsulta: TStringGrid;
    ImageControl1: TImageControl;
    SpBtAbrirRegistro: TSpeedButton;
    Label2: TLabel;
    LbCampoPesquisa: TLabel;
    procedure SpLimparConsultaClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure SpBtAbrirRegistroClick(Sender: TObject);
    procedure edPalavraChaveChangeTracking(Sender: TObject);
    procedure StGridConsultaHeaderClick(Column: TColumn);
    procedure StGridConsultaCellDblClick(const Column: TColumn; const Row: Integer);
  private
    iColPesq:integer;
  public
    consulta: TConsulta;
    procedure setiColPesq(iColPesq:integer);
    function getiColPesq:integer;
    procedure setConsulta(consulta: TConsulta);
  end;

var
  frm_Consulta: Tfrm_Consulta;

implementation

{$R *.fmx}

uses unit_BancoDados, Utilitario, Pessoa;

procedure Tfrm_Consulta.edPalavraChaveChangeTracking(Sender: TObject);
var
  i: Integer;
begin
  if edPalavraChave.Text <> '' then
    begin
      for i:= StGridConsulta.RowCount - 1 downto 0 do
        begin
          if (AnsiStartsStr(AnsiUpperCase(edPalavraChave.TexT), AnsiUpperCase(StGridConsulta.Cells[self.getiColPesq,i]))) then
            StGridConsulta.Row:= i;
        end;
    end
  else
    StGridConsulta.Row:= 0;
end;

function Tfrm_Consulta.getiColPesq: integer;
begin
  result := self.iColPesq;
end;

procedure Tfrm_Consulta.setConsulta(consulta: TConsulta);
begin
  self.consulta := consulta;
end;

procedure Tfrm_Consulta.setiColPesq(iColPesq: integer);
begin
  self.iColPesq := iColPesq;
end;

procedure Tfrm_Consulta.SpBtAbrirRegistroClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure Tfrm_Consulta.SpLimparConsultaClick(Sender: TObject);
begin
   self.consulta.Destroy();
end;

procedure Tfrm_Consulta.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

procedure Tfrm_Consulta.StGridConsultaCellDblClick(const Column: TColumn; const Row: Integer);
begin
  SpBtAbrirRegistroClick(SpBtAbrirRegistro);
end;

procedure Tfrm_Consulta.StGridConsultaHeaderClick(Column: TColumn);
begin
  self.setiColPesq(Column.Index);
  LbCampoPesquisa.Text := Column.Header;
  edPalavraChave.Text := '';
  edPalavraChave.SetFocus;
end;

end.
