unit unit_Cadastro_Contato;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.Controls.Presentation,
  FireDAC.Comp.Client;

type
  TUnitCadastroContatos = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    edEmail: TEdit;
    LbEmail: TLabel;
    Panel4: TPanel;
    btnSalvar: TSpeedButton;
    Panel5: TPanel;
    Label6: TLabel;
    spVoltarPrincipal: TSpeedButton;
    ImageControl1: TImageControl;
    LbPeriodo: TLabel;
    cbPessoa: TComboBox;
    EdTelefone: TEdit;
    LbTelefone: TLabel;
    EdCelular: TEdit;
    LbCelular: TLabel;
    LbPesquisaPessoa: TLabel;
    EdPesquisaPessoa: TEdit;
    SpBtPesquisarPessoa: TSpeedButton;
    LbIdContato: TLabel;
    procedure btnSalvarClick(Sender: TObject);
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure SpBtPesquisarPessoaClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure EdTelefoneCanFocus(Sender: TObject; var ACanFocus: Boolean);
    procedure btnSalvarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
  private
    { Private declarations }
  public
    function verificarContatoBanco(id_contato: String): TFDQuery;
    procedure buscarPessoaPorNome;
    function buscarPessoaPorId(id_pessoa: String):TFDQuery;
  end;

var
  UnitCadastroContatos: TUnitCadastroContatos;

implementation

{$R *.fmx}

uses unit_BancoDados, Contato, Pessoa, Utils;

procedure TUnitCadastroContatos.btnDeletarClick(Sender: TObject);
var
  contato:TContato;
  slDadosContato:TStringList;
begin
  slDadosContato.Add(LbIdContato.Text);
  slDadosContato.Add(IntToStr(Integer(cbPessoa.Items.Objects[cbPessoa.ItemIndex])));
  slDadosContato.Add(edEmail.Text);
  slDadosContato.Add(EdTelefone.Text);
  slDadosContato.Add(EdCelular.Text);

  contato := TContato.Create('curso');
  contato.update(slDadosContato);

  contato.utilitario.LimpaTela(self);
  edEmail.SetFocus;
  ShowMessage('O cadastro foi deletado com sucesso!');
  contato.Free;
  self.Close;
end;

procedure TUnitCadastroContatos.btnSalvarClick(Sender: TObject);
var
  contato:TContato;
  slDados:TStringList;
begin
  slDados := TStringList.Create;
  slDados.Clear;

  contato := TContato.Create('contato');

  if (self.verificarContatoBanco(LbIdContato.Text).IsEmpty) then
    begin
      slDados.Add('0');
      slDados.Add(IntToStr(Integer(cbPessoa.Items.Objects[cbPessoa.ItemIndex])));
      slDados.Add(edEmail.Text);
      slDados.Add(EdTelefone.Text);
      slDados.Add(EdCelular.Text);

      contato.insert(slDados);
      ShowMessage('O cadastro foi adicionado com sucesso!');
    end
  else
    begin
      slDados.Add(LbIdContato.Text);
      slDados.Add(IntToStr(Integer(cbPessoa.Items.Objects[cbPessoa.ItemIndex])));
      slDados.Add(edEmail.Text);
      slDados.Add(EdTelefone.Text);
      slDados.Add(EdCelular.Text);

      contato.update(slDados);
      ShowMessage('O cadastro foi atualizado com sucesso!');
    end;

  contato.utilitario.LimpaTela(self);
  edEmail.SetFocus;
  contato.Free;
end;

procedure TUnitCadastroContatos.btnSalvarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  if ((edEmail.Text.IsEmpty) and (EdTelefone.Text.IsEmpty)) or ((edEmail.Text.IsEmpty) and (EdCelular.Text.IsEmpty)) then
    raise Exception.Create('Informe pelo menos um contato.');
end;

function TUnitCadastroContatos.buscarPessoaPorId(id_pessoa: String):TFDQuery;
var
  pessoas: TFDQuery;
  pessoa: TPessoa;
begin
  cbPessoa.Clear;
  pessoas := TFDQuery.Create(nil);
  pessoas.Connection := dm_BancoDados.FDEscola;
  pessoas.Close;
  pessoas.SQL.Clear;
  pessoas.SQL.Add('select * from pessoa');
  pessoas.SQL.Add('where id_pessoa = ' + id_pessoa);

  try
    pessoas.Open;

    result := pessoas;

  except
    on e:exception do
     begin
          ShowMessage('Comando SQL não executado: ' + e.ToString);
          exit;
     end;
  end;
end;

procedure TUnitCadastroContatos.buscarPessoaPorNome;
var
  pessoas: TFDQuery;
  pessoa: TPessoa;
begin
  cbPessoa.Clear;
  pessoas := TFDQuery.Create(nil);
  pessoas.Connection := dm_BancoDados.FDEscola;
  pessoas.Close;
  pessoas.SQL.Clear;
  pessoas.SQL.Add('select * from pessoa');
  pessoas.SQL.Add('where nome ');
  pessoas.SQL.Add('like "%' + EdPesquisaPessoa.Text + '%"');

  try
    pessoas.Open;
    while not pessoas.Eof do
      begin
        cbPessoa.Items.Objects[cbPessoa.Items.Add(pessoas.FieldByName('nome').AsString)] := TObject(pessoas.FieldByName('id_pessoa').AsInteger);
        cbPessoa.ItemIndex := 0;
        pessoas.Next;
      end;

  except
    on e:exception do
     begin
          ShowMessage('Comando SQL não executado: ' + e.ToString);
          exit;
     end;
  end;
end;

procedure TUnitCadastroContatos.EdTelefoneCanFocus(Sender: TObject;
  var ACanFocus: Boolean);
var
  utils: TUtils;
begin
  if not edEmail.Text.IsEmpty then
    utils.validaEmail(edEmail.Text);

  edEmail.SetFocus;
end;

procedure TUnitCadastroContatos.SpBtPesquisarPessoaClick(Sender: TObject);
begin
  self.buscarPessoaPorNome;
end;

procedure TUnitCadastroContatos.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

function TUnitCadastroContatos.verificarContatoBanco(id_contato: String): TFDQuery;
var
  consulta_contato: TFDQuery;
begin
  consulta_contato := TFDQuery.Create(nil);
  consulta_contato.Connection := dm_BancoDados.FDEscola;
  consulta_contato.Close;
  consulta_contato.SQL.Clear;
  consulta_contato.SQL.Add('select * from contato, pessoa');
  consulta_contato.SQL.Add('where contato.id_contato');
  consulta_contato.SQL.Add('= "' + id_contato + '"');
  consulta_contato.SQL.Add('and contato.id_pessoa = pessoa.id_pessoa');
  consulta_contato.SQL.Add('and pessoa.ativo = 1');
  consulta_contato.Open;

  result := consulta_contato;
end;

end.
