unit Pessoa;

interface
uses Cadastro;

type TPessoa = class(TCadastro)
   private
    id: integer;
    nome: string;
    cpf: string;
    dt_nasc: TDateTime;
    tipo_pessoa: integer;
   public
    procedure set_id(id:integer);
    procedure set_nome(nome:string);
    procedure set_cpf(cpf:string);
    procedure set_dt_nasc(dt_nasc:TDateTime);
    procedure set_tipo_pessoa(tipo_pessoa:integer);
    function get_id: integer;
    function get_nome: string;
    function get_cpf: string;
    function get_dt_nasc: TDateTime;
    function get_tipo_pessoa: integer;
end;

implementation

{ TPessoa }

function TPessoa.get_cpf: string;
begin
  result := self.cpf;
end;

function TPessoa.get_dt_nasc: TDateTime;
begin
  result := self.dt_nasc;
end;

function TPessoa.get_id: integer;
begin
  result := self.id;
end;

function TPessoa.get_nome: string;
begin
  result := self.nome;
end;

function TPessoa.get_tipo_pessoa: integer;
begin
  result := self.tipo_pessoa;
end;

procedure TPessoa.set_cpf(cpf: string);
begin
  self.cpf := cpf;
end;

procedure TPessoa.set_dt_nasc(dt_nasc: TDateTime);
begin
  self.dt_nasc := dt_nasc;
end;

procedure TPessoa.set_id(id: integer);
begin
  self.id := id;
end;

procedure TPessoa.set_nome(nome: string);
begin
  self.nome := nome;
end;

procedure TPessoa.set_tipo_pessoa(tipo_pessoa: integer);
begin
  self.tipo_pessoa := tipo_pessoa;
end;

end.
