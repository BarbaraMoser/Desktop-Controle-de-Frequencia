unit unit_Tipo_Consultas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, unit_Cadastro_Pessoas, unit_Cadastro_Turmas,
  unit_Cadastro_Curso, unit_Cadastro_Materia, unit_Cadastro_Periodo,
  unit_Frequencia, unit_Cadastro_Contato, FireDAC.Comp.Client, Consulta;

type
  TUnitTipoConsultas = class(TForm)
    Panel1: TPanel;
    Panel5: TPanel;
    Label6: TLabel;
    Panel2: TPanel;
    SpbPessoas: TSpeedButton;
    Panel4: TPanel;
    Panel9: TPanel;
    SpbContatos: TSpeedButton;
    Panel10: TPanel;
    spVoltarPrincipal: TSpeedButton;
    Panel7: TPanel;
    SpbCursos: TSpeedButton;
    SpbTurmas: TSpeedButton;
    Panel3: TPanel;
    SpbFrequencias: TSpeedButton;
    procedure spVoltarPrincipalClick(Sender: TObject);
    procedure SpbPessoasClick(Sender: TObject);
    procedure SpbTurmasClick(Sender: TObject);
    procedure SpbCursosClick(Sender: TObject);
    procedure SpbContatosClick(Sender: TObject);
    procedure SpbFrequenciasClick(Sender: TObject);
  private
    consulta: TConsulta;
  public
    function getConsulta:TConsulta;
  end;

var
  UnitTipoConsultas: TUnitTipoConsultas;

implementation

{$R *.fmx}

uses unit_BancoDados, Pessoa, Turma, Curso, Contato, Foto, Cadastro;

function TUnitTipoConsultas.getConsulta: TConsulta;
begin
  result := self.consulta;
end;

procedure TUnitTipoConsultas.SpbContatosClick(Sender: TObject);
var
  consulta: TConsulta;
  contato: TContato;
  pessoa: TFDQuery;
  frm_cadastroContato: TUnitCadastroContatos;
begin
  try
    consulta:= TConsulta.create('contato');
    consulta.setTitulo('Consulta de Contatos');
    consulta.setTextosql('select id_contato ''C�digo'', pessoa.nome Nome, email Email, telefone Telefone, celular Celular from contato, pessoa where contato.id_pessoa = pessoa.id_pessoa and pessoa.ativo = 1');
    consulta.setcolunaRetorno(0);
    consulta.getConsulta;
    consulta.setConsulta(consulta);

    frm_cadastroContato := TUnitCadastroContatos.Create(Application);

    if (consulta.getRetorno <> '') then
    begin
      contato := TContato.Create('contato');
      contato.select(0,consulta.getRetorno);

      if (contato.isExiteSlvalores) then
        begin
          pessoa := frm_cadastroContato.buscarPessoaPorId(contato.getCampoFromListaValores(1));
          frm_cadastroContato.LbIdContato.Text := contato.getCampoFromListaValores(0);
          frm_cadastroContato.EdPesquisaPessoa.Enabled := False;
          frm_cadastroContato.cbPessoa.Items.Objects[frm_cadastroContato.cbPessoa.Items.Add(pessoa.FieldByName('nome').AsString)] := TObject(pessoa.FieldByName('id_pessoa').AsInteger);
          frm_cadastroContato.cbPessoa.ItemIndex := 0;
          frm_cadastroContato.edEmail.Text := contato.getCampoFromListaValores(2);
          frm_cadastroContato.EdTelefone.Text := contato.getCampoFromListaValores(3);
          frm_cadastroContato.EdCelular.Text := contato.getCampoFromListaValores(4);
        end
      else
        begin
          frm_cadastroContato.cbPessoa.Index := 0;
          frm_cadastroContato.edEmail.Text := '';
          frm_cadastroContato.EdTelefone.Text := '';
          frm_cadastroContato.EdCelular.Text := '';
        end;

      frm_cadastroContato.ShowModal;
    end;

  except
    ShowMessage('N�o h� registro para essa consulta.');
  end;
end;

procedure TUnitTipoConsultas.SpbCursosClick(Sender: TObject);
var
  consulta: TConsulta;
  curso: TCurso;
  frm_cadastroCurso: TUnitCadastroCursos;
begin
  try
    consulta:= TConsulta.create('curso');
    consulta.setTitulo('Consulta de Cursos');
    consulta.setTextosql('Select id_curso ''C�digo'', nome Nome from curso where ativo = 1 order by nome');
    consulta.setcolunaRetorno(0);
    consulta.getConsulta;
    self.consulta := consulta;

    frm_cadastroCurso := TUnitCadastroCursos.Create(Application);

    if (consulta.getRetorno <> '') then
    begin
      curso := TCurso.Create('curso');
      curso.select(0,consulta.getRetorno);

      if (curso.isExiteSlvalores) then
        begin
          frm_cadastroCurso.LbIdCurso.Text := curso.getCampoFromListaValores(0);
          frm_cadastroCurso.edNomeCurso.Text := curso.getCampoFromListaValores(1);
          frm_cadastroCurso.btnDeletar.Visible := True;
        end
      else
        begin
          frm_cadastroCurso.edNomeCurso.Text := '';
        end;

      frm_cadastroCurso.ShowModal;
    end;

  except
    ShowMessage('N�o h� registro para essa consulta.');
  end;
end;

procedure TUnitTipoConsultas.SpbFrequenciasClick(Sender: TObject);
var
  consulta_frequencia: TUnitConsultaFrequencia;
begin
  consulta_frequencia := TUnitConsultaFrequencia.Create(Application);
  consulta_frequencia.showmodal;
end;

procedure TUnitTipoConsultas.SpbPessoasClick(Sender: TObject);
var
  consulta: TConsulta;
  consulta_foto: TCadastro;
  pessoa: TPessoa;
  foto: TFoto;
  frm_cadastroPessoa: TUnitCadastroPessoas;
begin
  try
    consulta_foto := TCadastro.Create('foto');
    consulta:= TConsulta.create('pessoa');
    consulta.setTextosql('Select id_pessoa ''C�digo'', Nome Nome, Cpf Cpf, dt_nasc ''dt.Nasc.'' from pessoa where ativo = 1 order by nome');
    consulta.setcolunaRetorno(0);
    consulta.getConsulta;

    frm_cadastroPessoa := TUnitCadastroPessoas.Create(Application);

    if (consulta.getRetorno <> '') then
      begin
        pessoa := TPessoa.Create('pessoa');
        pessoa.select(0,consulta.getRetorno);

        if (pessoa.isExiteSlvalores) then
          begin
            consulta_foto.getImagem(StrToInt(pessoa.getCampoFromListaValores(0)), frm_cadastroPessoa.TIimagemPessoa);

            frm_cadastroPessoa.LbIdPessoa.Text := pessoa.getCampoFromListaValores(0);
            frm_cadastroPessoa.edNomeCompleto.Text := pessoa.getCampoFromListaValores(1);
            frm_cadastroPessoa.edCpf.Text := Pessoa.getCampoFromListaValores(2);
            frm_cadastroPessoa.dtDataNasc.Date := StrToDate(Pessoa.getCampoFromListaValores(3));
            frm_cadastroPessoa.cbTipoPessoa.ItemIndex := StrToInt(pessoa.getCampoFromListaValores(4));
            pessoa.estado := 1;
            frm_cadastroPessoa.btnDeletar.Visible := True;
          end
        else
          begin
            pessoa.estado := 0;
            frm_cadastroPessoa.edNomeCompleto.Text := '';
            frm_cadastroPessoa.edCpf.Text := '';
            frm_cadastroPessoa.dtDataNasc.Date := Date;
            frm_cadastroPessoa.cbTipoPessoa.Index := 0;
          end;

        frm_cadastroPessoa.ShowModal;
      end;

  except
    ShowMessage('N�o h� registro para essa consulta.');
  end;

end;

procedure TUnitTipoConsultas.SpbTurmasClick(Sender: TObject);
var
  turma: TTurma;
  consulta: TConsulta;
  frm_cadastroTurmas: TUnitCadastroTurmas;
begin
  try
    consulta:= TConsulta.create('turma');
    consulta.setTitulo('Consulta de Turmas');
    consulta.setTextosql('Select id_turma ''C�digo'', descricao ''Descri��o'', dt_ini ''Data In�cio'', dt_fim ''Data Fim'', semestre Semestre from turma where ativo = 1 order by semestre');
    consulta.setcolunaRetorno(0);
    consulta.getConsulta;
    self.consulta := consulta;

    frm_cadastroTurmas := TUnitCadastroTurmas.Create(Application);

    if (consulta.getRetorno <> '') then
    begin
      turma := TTurma.Create('turma');
      turma.select(0,consulta.getRetorno);

      if (turma.isExiteSlvalores) then
        begin
          frm_cadastroTurmas.LbIdTurma.Text := turma.getCampoFromListaValores(0);
          frm_cadastroTurmas.edDescricaoTurma.Text := turma.getCampoFromListaValores(1);
          frm_cadastroTurmas.DtInicioTurma.Date := StrToDate(turma.getCampoFromListaValores(2));
          frm_cadastroTurmas.DtFimTurma.Date := StrToDate(turma.getCampoFromListaValores(3));
          frm_cadastroTurmas.cbSemestre.ItemIndex := StrToInt(turma.getCampoFromListaValores(4));
          frm_cadastroTurmas.btnDeletar.Visible := True;
        end
      else
        begin
          frm_cadastroTurmas.edDescricaoTurma.Text := '';
          frm_cadastroTurmas.DtInicioTurma.Date := Date;
          frm_cadastroTurmas.DtFimTurma.Date := Date;
          frm_cadastroTurmas.cbSemestre.Index := 0;
        end;

      frm_cadastroTurmas.ShowModal;
    end;

  except
    ShowMessage('N�o h� registro para essa consulta.');
  end;
end;

procedure TUnitTipoConsultas.spVoltarPrincipalClick(Sender: TObject);
begin
  self.Close;
end;

end.
