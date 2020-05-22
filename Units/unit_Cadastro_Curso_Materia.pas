unit unit_Cadastro_Curso_Materia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client, FMX.Layouts;

type
  TUnitCadastroCursoMaterias = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    LbNomeCurso: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    ImageControl1: TImageControl;
    LbMateria: TLabel;
    cbMateria: TComboBox;
    LbMateriaCurso: TListBox;
    BtMateriaCurso: TButton;
    CbCurso: TComboBox;
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtMateriaCursoClick(Sender: TObject);
    procedure BtMateriaCursoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
  private
    procedure setCursos;
    procedure setMaterias;
  public
    { Public declarations }
  end;

var
  UnitCadastroCursoMaterias: TUnitCadastroCursoMaterias;

implementation

{$R *.fmx}

uses unit_BancoDados, Curso, Curso_Materia;

procedure TUnitCadastroCursoMaterias.BtMateriaCursoClick(Sender: TObject);
var
  curso_materia: TCursoMateria;
  slDadosCursoMateria: TStringList;
begin
  LbMateriaCurso.Items.Objects[LbMateriaCurso.Items.Add(cbMateria.Selected.Text)] := TObject(IntToStr(Integer(cbMateria.Items.Objects[cbMateria.ItemIndex])));

  slDadosCursoMateria := TStringList.Create;
  slDadosCursoMateria.Clear;
  slDadosCursoMateria.Add('0');
  slDadosCursoMateria.Add(IntToStr(Integer(CbCurso.Items.Objects[CbCurso.ItemIndex])));
  slDadosCursoMateria.Add(IntToStr(Integer(cbMateria.Items.Objects[cbMateria.ItemIndex])));

  curso_materia := TCursoMateria.Create('curso_materia');
  curso_materia.estado := 0;
  curso_materia.insert(slDadosCursoMateria);
end;


procedure TUnitCadastroCursoMaterias.BtMateriaCursoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  if CbCurso.Items.Count = 0 then
    raise Exception.Create('� preciso selecionar um curso para poder adicionar mat�rias.');
end;

procedure TUnitCadastroCursoMaterias.FormCreate(Sender: TObject);
begin
  self.setCursos;
  self.setMaterias;

  if cbMateria.Items.Count = 0 then
    raise Exception.Create('N�o h� mat�rias cadastradas ainda.');
end;

procedure TUnitCadastroCursoMaterias.setCursos;
var
  curso: TFDQuery;
begin
  CbCurso.Clear;
  curso := TFDQuery.Create(nil);
  curso.Connection := dm_BancoDados.FDEscola;
  curso.Close;
  curso.SQL.Clear;
  curso.SQL.Add('select * from curso');

  try
    curso.Open;

    while not curso.Eof do
      begin
        CbCurso.Items.Objects[CbCurso.Items.Add(curso.FieldByName('nome').AsString)] := TObject(curso.FieldByName('id_curso').AsInteger);
        curso.Next;
      end;

  except
    on e:exception do
      begin
        ShowMessage(e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitCadastroCursoMaterias.setMaterias;
var
  materia: TFDQuery;
begin
  cbMateria.Clear;
  materia := TFDQuery.Create(nil);
  materia.Connection := dm_BancoDados.FDEscola;
  materia.Close;
  materia.SQL.Clear;
  materia.SQL.Add('select * from materia');

  try
    materia.Open;

    while not materia.Eof do
      begin
        cbMateria.Items.Objects[cbMateria.Items.Add(materia.FieldByName('nome').AsString)] := TObject(materia.FieldByName('id_materia').AsInteger);
        materia.Next;
      end;

  except
    on e:exception do
      begin
        ShowMessage(e.ToString);
        exit;
      end;
  end;
end;

procedure TUnitCadastroCursoMaterias.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

end.
