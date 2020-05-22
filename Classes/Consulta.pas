unit Consulta;

interface
uses
    System.SysUtils, System.Types, System.UITypes,
    System.Classes, System.Variants,
    FMX.Grid, Utilitario, FireDAC.Comp.Client,
    unit_BancoDados, FMX.Dialogs;

type TConsulta = class
  private
    titulo:string;
    textosql:string;
    retorno: string;
    colunaRetorno:integer;
    utilitario : Tutilitario;
    consulta: TConsulta;
  public
    constructor create;
    destructor destroi;
    procedure setTitulo(titulo:string);
    function getTitulo:string;
    procedure setTextosql(textosql:string);
    function getTextosql:string;
    procedure setRetorno(retorno:string);
    function getRetorno:string;
    procedure getConsulta;
    procedure getConsultaToSg(var sgConsulta:TStringGrid);
    procedure setcolunaRetorno(colunaRetorno:integer);
    function getcolunaRetorno:integer;
    procedure setConsulta(consulta: TConsulta);
end;

implementation

{ TConsulta }

uses unit_Consulta;

constructor TConsulta.create;
begin
  Utilitario := Tutilitario.Create;
end;

destructor TConsulta.destroi;
begin
  FreeAndNil(utilitario);
end;

procedure TConsulta.getConsultaToSg(var sgConsulta:TStringGrid);
var
  qrConsulta: TFDQuery;
  coluna:TColumn;
  i:integer;
begin
  qrConsulta := TFDQuery.Create(nil);
  qrConsulta.Connection := dm_BancoDados.FDEscola;
  qrConsulta.Close;
  qrConsulta.SQL.Clear;
  qrConsulta.SQL.Add(self.getTextosql);

  try
  qrConsulta.Open;

  if (not qrConsulta.IsEmpty) then
    begin
      for i := 0 to qrConsulta.FieldCount - 1 do
        begin
          coluna := TColumn.Create(nil);
          coluna.Parent := sgConsulta;
          coluna.Header := qrConsulta.Fields[i].FieldName;
        end;

      utilitario.LimpaStringGrid(sgConsulta);
      qrConsulta.First;

      while (not qrConsulta.Eof) do
        begin
          if (sgConsulta.Cells[0,0] <> '') then
            sgConsulta.RowCount := sgConsulta.RowCount + 1;

          for i := 0 to qrConsulta.FieldCount - 1 do
            sgConsulta.Cells[i, sgConsulta.RowCount - 1] := qrConsulta.Fields[i].AsString;

          qrConsulta.Next;
        end;
    end;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;

  qrConsulta.Close;
  FreeAndNil(qrConsulta);
end;

function TConsulta.getcolunaRetorno: integer;
begin
  result := self.colunaRetorno;
end;

procedure TConsulta.getConsulta;
begin
  if (frm_Consulta = nil) then
   frm_Consulta := Tfrm_Consulta.Create(nil);
  frm_Consulta.setConsulta(self.consulta);
  frm_Consulta.Caption := self.getTitulo;

  self.getConsultaToSg(frm_Consulta.StGridConsulta);
  frm_consulta.edPalavraChave.Text := '';
  frm_consulta.StGridConsulta.Col := 0;
  frm_consulta.StGridConsultaHeaderClick(frm_Consulta.StGridConsulta.ColumnByIndex(0));
  frm_consulta.edPalavraChaveChangeTracking(frm_Consulta.edPalavraChave);
  frm_consulta.edPalavraChave.SetFocus;
  Utilitario.ajustaTamnhosg(frm_Consulta.StGridConsulta);

  if (frm_consulta.ShowModal = mrOk) then
    begin
      if (self.getcolunaRetorno < 0) then
        self.setRetorno(frm_consulta.StGridConsulta.Cells[frm_consulta.StGridConsulta.Col, frm_Consulta.StGridConsulta.Row])
      else
        self.setRetorno(frm_consulta.StGridConsulta.Cells[self.getcolunaRetorno, frm_Consulta.StGridConsulta.Row]);
    end
  else
    self.setRetorno('');

  FreeAndNil(frm_consulta);
end;

function TConsulta.getRetorno: string;
begin
  result := self.retorno;
end;

function TConsulta.getTextosql: string;
begin
  result := self.textosql;
end;

function TConsulta.getTitulo: string;
begin
  result := self.titulo;
end;

procedure TConsulta.setcolunaRetorno(colunaRetorno: integer);
begin
  self.colunaRetorno := colunaRetorno;
end;

procedure TConsulta.setConsulta(consulta: TConsulta);
begin
  self.consulta := consulta;
end;

procedure TConsulta.setRetorno(retorno: string);
begin
  self.retorno := retorno;
end;

procedure TConsulta.setTextosql(textosql: string);
begin
  self.textosql := textosql;
end;

procedure TConsulta.setTitulo(titulo: string);
begin
  self.titulo := titulo;
end;

end.
