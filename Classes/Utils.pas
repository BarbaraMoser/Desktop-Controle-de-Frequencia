unit Utils;

interface
uses
    system.SysUtils, system.Classes, FMX.Dialogs, FMX.Objects, FMX.DateTimeCtrls;

type TUtils = class
   private
    function calculoCpf(cpf: String): boolean;
    function verificaEmail(email: String): boolean;
   public
     id: integer;
     procedure verificaCpf(cpf: String);
     procedure validaCampoPreenchido(valor: String; nome_campo: String);
     procedure verificarDataNascimento(data: TDateTime; campo: TDateEdit);
     procedure validaEmail(email: String);
end;


implementation

{ TCadastro }



{ TUtils }


procedure TUtils.verificaCpf(cpf: String);
begin
  if self.calculoCpf(cpf) = False then
    raise Exception.Create('CPF inv�lido')
end;

function TUtils.verificaEmail(email: String): boolean;
const
  CaraEsp: array[1..40] of string[1] =
  ( '!','#','$','%','�','&','*',
  '(',')','+','=','�','�','�','�','�',
  '�','�','�','`','�','�',',',';',':',
  '<','>','~','^','?','/','','|','[',']','{','}',
  '�','�','�');
var
  i,cont   : integer;
begin
  Result := True;
  cont := 0;
  if email <> '' then
    if (Pos('@', email)<>0) and (Pos('.', email)<>0) then
    begin
      if (Pos('@', email)=1) or (Pos('@', email)= Length(email)) or (Pos('.', email)=1) or (Pos('.', email)= Length(email)) or (Pos(' ', email)<>0) then
        Result := False
      else
        if (abs(Pos('@', email) - Pos('.', email)) = 1) then
          Result := False
        else
          begin
            for i := 1 to 40 do
              if Pos(CaraEsp[i], email)<>0 then
                Result := False;
            for i := 1 to length(email) do
            begin
              if email[i] = '@' then
                cont := cont + 1;
              if (email[i] = '.') and (email[i+1] = '.') then
                Result := false;
            end;

            if (cont >=2) or ( email[length(email)]= '.' )
              or ( email[1]= '.' ) or ( email[1]= '_' )
              or ( email[1]= '-' )  then
                Result := false;

            if (abs(Pos('@', email) - Pos('com', email)) = 1) then

            if (abs(Pos('@', email) - Pos('-', email)) = 1) then
              Result := False;

            if (abs(Pos('@', email) - Pos('_', email)) = 1) then
              Result := False;
          end;
    end
    else
      Result := False;
end;

procedure TUtils.verificarDataNascimento(data: TDateTime; campo: TDateEdit);
begin
  if data >= now then
    campo.IsEmpty := True;
    raise Exception.Create('Data de Nascimento incorreta.')
end;

procedure TUtils.validaCampoPreenchido(valor, nome_campo: String);
var
  valor_sem_espa�o: String;
begin
  valor_sem_espa�o := StringReplace(valor, ' ', EmptyStr, [rfReplaceAll]);

  if (valor.IsEmpty) or (valor_sem_espa�o.IsEmpty) then
    raise Exception.Create(format('O campo %s deve ser preenchido corretamente.',[nome_campo]))
end;

procedure TUtils.validaEmail(email: String);
begin
  if self.verificaEmail(email) = False then
    raise Exception.Create('O email deve ser v�lido.')
end;

function TUtils.calculoCpf(cpf: String): boolean;
var
  dig10, dig11: string;
  s, i, r, peso: integer;
begin
// length - retorna o tamanho da string (CPF � um n�mero formado por 11 d�gitos)
  if ((CPF = '00000000000') or (CPF = '11111111111') or
      (CPF = '22222222222') or (CPF = '33333333333') or
      (CPF = '44444444444') or (CPF = '55555555555') or
      (CPF = '66666666666') or (CPF = '77777777777') or
      (CPF = '88888888888') or (CPF = '99999999999') or
      (length(CPF) <> 11))
     then
     begin
        result := false;
        exit;
     end;

  try
{ *-- C�lculo do 1o. Digito Verificador --* }
    s := 0;
    peso := 10;

    for i := 1 to 9 do
      begin
        s := s + (StrToInt(CPF[i]) * peso);
        peso := peso - 1;
      end;

    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      str(r:1, dig10);

{ *-- C�lculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;

    for i := 1 to 10 do
      begin
        s := s + (StrToInt(CPF[i]) * peso);
        peso := peso - 1;
      end;

    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig11 := '0'
    else
      str(r:1, dig11);

{ Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig10 = CPF[10]) and (dig11 = CPF[11])) then
      result := true
    else
      result := false;
  except
    result := false
  end;
end;

end.
