unit Cadastro;

interface
uses
    system.SysUtils, system.Classes, FireDAC.Comp.Client, unit_BancoDados,
    Utilitario, FMX.Dialogs, Vcl.imaging.jpeg, Data.DB, FMX.Objects;

type TCadastro = class
   private
      function getTextoInsert:String;
      function getTextoUpdate:String;

   public
     id: integer;
     estado: byte;
     Retorno: boolean;
     sTabela:String;
     qrCadastro: TFDQuery;
     slValores,
     slCampos,
     slTipos: TStringList;
     utilitario:Tutilitario;

     Constructor Create (sTabela: string); overload; virtual;
     Destructor Destroy; Override;
     function getTabela:String;
     function getCampoFromLista(i:integer):string;
     function getCampoFromListaValores(i:integer):string;
     function isExiteSlvalores:boolean;
     function getEstado:byte;

     function buscarUltimoIdInserido: string;
     procedure getCamposTipos;
     procedure insert(var slDados:TStringList);
     procedure select(icampo:integer; svalor:string);
     procedure update(var slDados:TStringList);
     procedure getImagem(id_pessoa:Integer; imagem:Timage);
     procedure setImgFoto(id_pessoa: Integer; sCaminho: string);
end;


implementation

{ TCadastro }

function TCadastro.buscarUltimoIdInserido: string;
var
  ultimo_id: TFDQuery;
  i:integer;
begin
  ultimo_id := TFDQuery.Create(nil);
  ultimo_id.Connection := dm_BancoDados.FDEscola;
  ultimo_id.Close;
  ultimo_id.SQL.Clear;
  ultimo_id.SQL.Add('SELECT LAST_INSERT_ID()');

  try
    ultimo_id.Open;

    for i := 0 to ultimo_id.FieldCount - 1 do
      result := ultimo_id.Fields[i].Value;
  except
    on e:exception do
      begin
        ShowMessage('Comando SQL n�o executado: ' + e.ToString);
        exit;
      end;
  end;

  ultimo_id.Close;
  FreeAndNil(ultimo_id);
end;

constructor TCadastro.Create(sTabela: string);
begin
  qrCadastro := TFDQuery.Create(dm_BancoDados);
  qrCadastro.Connection := dm_BancoDados.FDEscola;
  self.sTabela := sTabela;
  Retorno := false;
  slCampos := TStringList.Create;
  slTipos := TStringList.Create;
  slValores := TStringList.Create;
  self.getCamposTipos;
  utilitario := Tutilitario.Create;
end;

destructor TCadastro.Destroy;
begin
  inherited;
  qrCadastro.Close;
  qrCadastro.Free;
  FreeAndNil(slCampos);
  FreeAndNil(slTipos);
  FreeAndNil(slValores);
  FreeAndNil(utilitario);
end;


function TCadastro.getCampoFromLista(i: integer): string;
begin
  result := self.slCampos.Strings[i];
end;

function TCadastro.getCampoFromListaValores(i: integer): string;
begin
  result := self.slValores.Strings[i];
end;

procedure TCadastro.getCamposTipos;
begin
  slCampos.Clear;
  slTipos.Clear;
  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add(Format('desc %s', [self.sTabela]));

  try
    qrCadastro.Open;
  except
    on E:Exception do
      raise Exception.CreateFmt('N�o foi poss�vel executar opera��o no Banco.' + #10#13 + '%s', [E.Message]);
  end;

  if not qrCadastro.IsEmpty then
    begin
      qrCadastro.First;
        while (not qrCadastro.Eof) do
          begin
            slCampos.Add(qrCadastro.Fields[0].AsString);
            slTipos.Add(qrCadastro.Fields[1].AsString);

            qrCadastro.Next;
          end;
    end;
end;

function TCadastro.getEstado: byte;
begin
  result := Self.estado;
end;

procedure TCadastro.getImagem(id_pessoa: Integer; imagem: Timage);
var
   logo: TStream;
begin
  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add('select foto from foto');
  qrCadastro.SQL.Add(Format('where (id_pessoa = %d)',[id_pessoa]));

  try
    qrCadastro.Open;

    if (not qrCadastro.IsEmpty) then
      begin
        logo := qrCadastro.CreateBlobStream(qrCadastro.Fields[0], bmRead);
        imagem.Bitmap.LoadFromStream(logo);
        logo.Free;
      end;
  except
    on e:exception do
      begin
        raise Exception.CreateFmt('N�o foi poss�vel executar opera��o no Banco.' + #10#13 + '%s', [E.Message]);
      end;
  end;
end;

function TCadastro.getTabela: String;
begin
  result := self.sTabela;
end;

function TCadastro.getTextoInsert: String;
var
  i, indice_inicio:integer;
begin
  indice_inicio := 1;
  result := format ('insert into %s values (0, ', [self.sTabela]);

  for i := indice_inicio to self.slCampos.Count - 1 do
    begin
      result := result + ':' + slCampos.Strings[i];

      if (i < self.slCampos.Count - 1) then
        result := result + ','
      else
        result := result + ')';
    end;
end;

function TCadastro.getTextoUpdate: String;
var
  i: integer;
begin
  result := format ('update %s set ', [self.sTabela]);

  for i := 1 to self.slCampos.Count - 1 do
    begin
      result := result + slCampos.Strings[i] + ' = :' + slCampos.Strings[i];

      if (i < self.slCampos.Count - 1) then
        result := result + ',';
    end;
end;


procedure TCadastro.insert(var slDados:TStringList);
var
   i, indice_inicio:integer;
   sSql:String;
begin
  sSql := self.getTextoInsert;
  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add(sSql);

  for i := 1 to self.slTipos.Count - 1 do
    begin
      if (pos('int' , self.slTipos.Strings[i]) > 0) or (pos('tinvint' , self.slTipos.Strings[i]) > 0) then
       qrCadastro.Params[i-1].AsInteger := StrToInt(slDados.Strings[i])
      else if (pos('varchar' , self.slTipos.Strings[i]) > 0) then
       qrCadastro.Params[i-1].AsString := slDados.Strings[i]
      else if (pos('date' , self.slTipos.Strings[i]) > 0) then
       qrCadastro.Params[i-1].AsDate := StrToDate(slDados.Strings[i]);
    end;

  try
    qrCadastro.ExecSQL;

  except
    on E:Exception do
      raise Exception.CreateFmt('N�o foi poss�vel executar opera��o no Banco.' + #10#13 + '%s', [E.Message]);
  end;
end;

function TCadastro.isExiteSlvalores: boolean;
begin
  result := self.slValores.Count > 0;
end;

procedure TCadastro.select(icampo: integer; svalor: string);
var
   i:integer;
begin
  self.slValores.Clear;
  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add(Format('select * from %s where (%s = :valor)', [self.getTabela, self.getCampoFromLista(icampo)]));
  qrCadastro.Params[0].Value := svalor;

  try
    qrCadastro.Open;
    if (not qrCadastro.IsEmpty) then
      begin
        for i := 0 to qrCadastro.FieldCount - 1 do
          self.slValores.Add(qrCadastro.Fields[i].AsString);
      end;
  except
    on E:Exception do
      raise Exception.CreateFmt('N�o foi poss�vel executar opera��o no Banco.' + #10#13 + '%s', [E.Message]);
  end;
end;

procedure TCadastro.setImgFoto(id_pessoa: Integer; sCaminho: string);
var
  img: TStream;
  iCodImg:Integer;
  iTipo:Byte;
begin
  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add(format('Select id_foto from foto where (id_pessoa = %d)', [id_pessoa]));

  try
    qrCadastro.Open;

    if (not qrCadastro.IsEmpty) then
      begin
        iCodImg := qrCadastro.Fields[0].AsInteger;
        iTipo := 2;
      end
    else
      iTipo:= 1;
  except
    iTipo := 1;
  end;

  if (sCaminho <> '') then
    img := TFileStream.Create(sCaminho, fmOpenRead);

  qrCadastro.Close;
  qrCadastro.SQL.Clear;

  if (iTipo = 1) then
    begin
      qrCadastro.SQL.Add('insert into foto values');
      qrCadastro.SQL.Add('(0, :pessoa, :imagem)');

      qrCadastro.Params[0].AsInteger := id_pessoa;
      qrCadastro.Params[1].LoadFromStream(img, ftBlob);
    end
  else
    if (iTipo = 2) then
      begin
        qrCadastro.SQL.Add('update foto');
        qrCadastro.SQL.Add('set foto = :foto where (id_foto = :id_foto)');

        qrCadastro.Params[0].LoadFromStream(img, ftBlob);
        qrCadastro.Params[1].AsInteger := iCodImg;
      end;

  try
    qrCadastro.ExecSQL;
  except
    on e:exception do
      raise Exception.CreateFmt('N�o foi poss�vel executar opera��o no Banco.' + #10#13 + '%s', [E.Message]);
  end;

  if (sCaminho <> '') then
    img.Free;
end;

procedure TCadastro.update(var slDados: TStringList);
var
  i:integer;
  sSql:String;
begin
  sSql := self.getTextoUpdate +
  Format(' where (' + slCampos.Strings[0] + ' =  %s)', [slDados.Strings[0]]);

  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add(sSql);

  for i := 1 to self.slTipos.Count - 1 do
    begin
      if (pos('int' , self.slTipos.Strings[i]) > 0) or (pos('tinvint' , self.slTipos.Strings[i]) > 0) then
        qrCadastro.Params[i-1].AsInteger := StrToInt(slDados.Strings[i])
      else if (pos('varchar' , self.slTipos.Strings[i]) > 0) then qrCadastro.Params[i-1].AsString := slDados.Strings[i]
      else if (pos('date' , self.slTipos.Strings[i]) > 0) then
        qrCadastro.Params[i-1].AsDate := StrToDate(slDados.Strings[i]);
    end;

  try
    qrCadastro.ExecSQL;

  except
    on E:Exception do
      raise Exception.CreateFmt('N�o foi poss�vel executar opera��o no Banco.' + #10#13 + '%s', [E.Message]);
  end;
end;

end.
