unit Periodo;

interface

uses Cadastro;

type TPeriodo = class(TCadastro)
   private
    id: integer;
    periodo: String;
   public
    function get_id: integer;
    function get_periodo: String;
end;

implementation

{ TPeriodo }

function TPeriodo.get_id: integer;
begin
  result := self.id;
end;

function TPeriodo.get_periodo: String;
begin
  result := self.periodo;
end;

end.
