unit unit_Cadastro_Materia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client, FMX.Layouts;

type
  TUnitCadastroMateria = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    edNomeMateria: TEdit;
    LbNomeMateria: TLabel;
    Panel4: TPanel;
    btnSalvar: TSpeedButton;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    ImageControl1: TImageControl;
    LbPeriodo: TLabel;
    cbPeriodo: TComboBox;
    LbMateriaSalvas: TListBox;
    Label1: TLabel;
    LbProfessorMateria: TLabel;
    CbProfessorPeriodo: TComboBox;
    procedure btnSalvarClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure edNomeMateriaCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    function getMateriasCadastradas: TFDQuery;
    procedure setPeriodos;
    procedure setProfessor;
    procedure setMateriasSalvas;
  public
    procedure validarPeriodoSelecionado;
  end;

var
  UnitCadastroMateria: TUnitCadastroMateria;

implementation

{$R *.fmx}

uses unit_BancoDados, Materia, Periodo, Utils;

procedure TUnitCadastroMateria.btnSalvarClick(Sender: TObject);
var
  materia:TMateria;
  slDados:TStringList;
  i, periodo:integer;
begin
  self.validarPeriodoSelecionado;

  slDados := TStringList.Create;
  slDados.Clear;
  slDados.Add('0');
  slDados.Add(IntToStr(Integer(cbPeriodo.Items.Objects[cbPeriodo.ItemIndex])));
  slDados.Add(IntToStr(Integer(CbProfessorPeriodo.Items.Objects[CbProfessorPeriodo.ItemIndex])));
  slDados.Add(edNomeMateria.Text);

  materia := TMateria.Create('materia');
  materia.estado := 0;
  materia.insert(slDados);

  self.setMateriasSalvas;

  materia.utilitario.LimpaTela(self);
  materia.Free;
end;

procedure TUnitCadastroMateria.edNomeMateriaCanFocus(Sender: TObject;
  var ACanFocus: Boolean);
begin
  if cbPeriodo.ItemIndex = 0 then
    raise Exception.Create('É preciso selecionar um período.');
  if CbProfessorPeriodo.ItemIndex = 0 then
    raise Exception.Create('É preciso selecionar um professor.');
end;

procedure TUnitCadastroMateria.FormCreate(Sender: TObject);
begin
  self.setPeriodos;
  self.setProfessor;
  self.setMateriasSalvas;

//  if cbPeriodo.Items.Count = 0 then
//    raise Exception.Create('Não há períodos cadastrados ainda.');
end;

function TUnitCadastroMateria.getMateriasCadastradas: TFDQuery;
var
  materias: TFDQuery;
begin
  materias := TFDQuery.Create(nil);
  materias.Connection := dm_BancoDados.FDEscola;
  materias.Close;
  materias.SQL.Clear;
  materias.SQL.Add('select * from materia');

  try
    materias.Open;
    result := materias;

  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitCadastroMateria.setMateriasSalvas;
var
  materias_salvas: TFDQuery;
begin
  materias_salvas := self.getMateriasCadastradas();
  self.LbMateriaSalvas.Clear;

  while not materias_salvas.Eof do
    begin
      self.LbMateriaSalvas.Items.Add(materias_salvas.FieldByName('nome').AsString);
      materias_salvas.Next;
    end;

  if LbMateriaSalvas.Count = 0 then
    LbMateriaSalvas.Items.Add('Não há Matéria cadastrada.')
end;

procedure TUnitCadastroMateria.setPeriodos;
var
  periodos: TFDQuery;
begin
  cbPeriodo.Clear;
  periodos := TFDQuery.Create(nil);
  periodos.Connection := dm_BancoDados.FDEscola;
  periodos.Close;
  periodos.SQL.Clear;
  periodos.SQL.Add('select * from periodo');

  try
    periodos.Open;
    cbPeriodo.Items.Add('Selecione o período');

    while not periodos.Eof do
      begin
        cbPeriodo.Items.Objects[cbPeriodo.Items.Add(periodos.FieldByName('periodo').AsString)] := TObject(periodos.FieldByName('id_periodo').AsInteger);
        periodos.Next;
      end;

    cbPeriodo.ItemIndex := 0;
  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitCadastroMateria.setProfessor;
var
  professores: TFDQuery;
begin
  CbProfessorPeriodo.Clear;
  professores := TFDQuery.Create(nil);
  professores.Connection := dm_BancoDados.FDEscola;
  professores.Close;
  professores.SQL.Clear;
  professores.SQL.Add('select * from pessoa, professor');
  professores.SQL.Add('where pessoa.id_pessoa = professor.id_pessoa');


  try
    professores.Open;
    CbProfessorPeriodo.Items.Add('Selecione o professor');

    while not professores.Eof do
      begin
        CbProfessorPeriodo.Items.Objects[CbProfessorPeriodo.Items.Add(professores.FieldByName('nome').AsString)] := TObject(professores.FieldByName('id_professor').AsInteger);
        professores.Next;
      end;

    CbProfessorPeriodo.ItemIndex := 0;
  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitCadastroMateria.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

procedure TUnitCadastroMateria.validarPeriodoSelecionado;
var
  utils: TUtils;
begin
  utils.validaCampoPreenchido(edNomeMateria.Text, LbNomeMateria.Text);
end;

end.
