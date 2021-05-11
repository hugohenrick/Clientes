unit uEndereco.DAO;

interface

uses uInterfacedObject, uFuncoes, DB, SysUtils, Windows, ACBrUtil, Dialogs, FireDAC.Comp.Client, FireDAC.Stan.Param;

  type

   IEndereco_Customer_DAO = interface(uInterfacedObject.IInterfacedObject)
     function obterRegistro(AValor : rEndereco): rEndereco;
     procedure Incluir(AValor: rEndereco);
     procedure Alterar(AValor: rEndereco);
     procedure Excluir(AValor : rEndereco);
     function obterLista(AValor: rEndereco): Array_rEndereco;
   end;

  TEndereco_Customer_DAO = class(uInterfacedObject.T_Tabela_SQL, IEndereco_Customer_DAO)
  private
    function DataSet_Para_Record(ADataSet: TDataSet): rEndereco;

  public
    procedure Incluir(AValor: rEndereco);
    procedure Alterar(AValor: rEndereco);
    function obterRegistro(AValor : rEndereco): rEndereco;
    procedure Excluir(AValor : rEndereco);
    function obterLista(AValor: rEndereco): Array_rEndereco;
  end;


implementation


procedure TEndereco_Customer_DAO.Incluir(AValor : rEndereco);
var vFDQuery : TFDQuery;
begin
  try
    try
      Self.FDQuery_Inicializar(vFDQuery);
      vFDQuery.SQL.Add('INSERT INTO ENDERECO ('
                                        + ' LOGRADOURO'
                                        + ', NUMERO'
                                        + ', CEP'
                                        + ', BAIRRO'
                                        + ', CIDADE'
                                        + ', UF'
                                        + ', PAIS'
                                        + ', CODIGO_CLIENTE'
                                        + ')'
                     + 'VALUES( '
                                        + ' :LOGRADOURO'
                                        + ', :NUMERO'
                                        + ', :CEP'
                                        + ', :BAIRRO'
                                        + ', :CIDADE'
                                        + ', :UF'
                                        + ', :PAIS'
                                        + ', :CODIGO_CLIENTE'
                                        +  ')');

      vFDQuery.ParamByName('LOGRADOURO').AsString := AValor.Logradouro;
      vFDQuery.ParamByName('NUMERO').AsLargeInt := AValor.Numero;
      vFDQuery.ParamByName('CEP').AsLargeInt := AValor.Cep;
      vFDQuery.ParamByName('BAIRRO').AsString := AValor.Bairro;
      vFDQuery.ParamByName('CIDADE').AsString := AValor.Cidade;
      vFDQuery.ParamByName('UF').AsString := AValor.Uf;
      vFDQuery.ParamByName('PAIS').AsString := AValor.Pais;
      vFDQuery.ParamByName('CODIGO_CLIENTE').AsInteger := AValor.Codigo_Cliente;
      vFDQuery.ExecSQL;

    finally
      vFDQuery.Close;
      FreeAndNil(vFDQuery);
    end;
  except
    raise;
  end;
end;

procedure TEndereco_Customer_DAO.Alterar(AValor : rEndereco);
var vFDQuery : TFDQuery;
begin
  try
    try
      Self.FDQuery_Inicializar(vFDQuery);
      vFDQuery.SQL.Add('UPDATE ENDERECO SET'
                                      + ' LOGRADOURO = :LOGRADOURO,'
                                      + ' NUMERO = :NUMERO,'
                                      + ' CEP = :CEP,'
                                      + ' BAIRRO = :BAIRRO,'
                                      + ' CIDADE = :CIDADE,'
                                      + ' UF = :UF,'
                                      + ' PAIS = :PAIS');

      vFDQuery.SQL.Add('WHERE CODIGO = :CODIGO');

      vFDQuery.ParamByName('CODIGO').AsLargeInt := AValor.Codigo;
      vFDQuery.ParamByName('LOGRADOURO').AsString := AValor.Logradouro;
      vFDQuery.ParamByName('NUMERO').AsLargeInt := AValor.Numero;
      vFDQuery.ParamByName('CEP').AsLargeInt := AValor.Cep;
      vFDQuery.ParamByName('BAIRRO').AsString := AValor.Bairro;
      vFDQuery.ParamByName('CIDADE').AsString := AValor.Cidade;
      vFDQuery.ParamByName('UF').AsString := AValor.Uf;
      vFDQuery.ParamByName('PAIS').AsString := AValor.Pais;
      vFDQuery.ExecSQL;
    finally
      vFDQuery.Close;
      FreeAndNil(vFDQuery);
    end;
  except
    raise;
  end;
end;

function TEndereco_Customer_DAO.DataSet_Para_Record(ADataSet : TDataSet ) : rEndereco;
var vField : TField;
    lNomeColuna : string;

  function existeColuna(ANomeColuna : string) : Boolean;
  begin
    lNomeColuna := ANomeColuna;
    vField := ADataSet.FindField(ANomeColuna);
    Result := Assigned(vField);
  end;

begin
  ZeroMemory(@Result, SizeOf(Result));

  if not ADataSet.IsEmpty then
  begin
    try
      if existeColuna('CODIGO') then
        Result.Codigo := vField.AsLargeInt;

      if existeColuna('CODIGO_CLIENTE') then
        Result.Codigo_Cliente := vField.AsLargeInt;

      if existeColuna('LOGRADOURO') then
        Result.Logradouro := vField.AsString;

      if existeColuna('NUMERO') then
        Result.Numero := vField.AsInteger;

      if existeColuna('CEP') then
        Result.Cep := vField.AsInteger;

      if existeColuna('BAIRRO') then
        Result.Bairro := vField.AsString;

      if existeColuna('CIDADE') then
        Result.Cidade := vField.AsString;

      if existeColuna('UF') then
        Result.Uf := vField.AsString;

      if existeColuna('Pais') then
        Result.Pais := vField.AsString;
    except
      on e: Exception do
      begin
        raise Exception.Create('Campo com erro na conversão: ' + lNomeColuna + ' Erro: ' + e.Message);
      end;
    end;
  end;
end;

procedure TEndereco_Customer_DAO.Excluir(AValor : rEndereco);
var vQuery : TFDQuery;
begin
  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('DELETE FROM ENDERECO WHERE 1=1');

    if ( AValor.Codigo > 0 ) then
    begin
      vQuery.SQL.Add('  AND CODIGO = :CODIGO'  );
      vQuery.ParamByName('CODIGO').AsLargeInt := AValor.Codigo;
    end;

    if ( AValor.Codigo_Cliente > 0 ) then
    begin
      vQuery.SQL.Add('  AND CODIGO_CLIENTE = :CODIGO_CLIENTE'  );
      vQuery.ParamByName('CODIGO_CLIENTE').AsLargeInt := AValor.Codigo_Cliente;
    end;

    vQuery.Execute;
  finally
    vQuery.Close;
    FreeAndNil(vQuery);
  end;
end;

function TEndereco_Customer_DAO.obterRegistro(AValor: rEndereco): rEndereco;
var vQuery : TFDQuery;
begin
  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('SELECT * FROM ENDERECO WHERE 1=1');

    if ( AValor.Codigo > 0 ) then
    begin
      vQuery.SQL.Add('  AND CODIGO = :CODIGO'  );
      vQuery.ParamByName('CODIGO').AsLargeInt := AValor.Codigo;
    end;

    vQuery.Open;
    Result.Limpar;

    if not vQuery.IsEmpty then
      Result := Self.DataSet_Para_Record(vQuery);
  finally
    vQuery.Close;
    FreeAndNil(vQuery);
  end;
end;

function TEndereco_Customer_DAO.obterLista(AValor: rEndereco): Array_rEndereco;
var vQuery : TFDQuery;
    i : Integer;
begin
  {Limpando retorno}
  ZeroMemory(@Result, SizeOf(Result));

  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('SELECT * FROM ENDERECO WHERE 1=1');

    if AValor.Codigo_Cliente > 0 then
    begin
      vQuery.SQL.Add('AND CODIGO_CLIENTE = :CODIGO_CLIENTE ');
      vQuery.ParamByName('CODIGO_CLIENTE').AsInteger := AValor.Codigo_Cliente;
    end;

    vQuery.Open;

    {Alterando o tamanho do Array}
    SetLength(Result, vQuery.RecordCount);

    while not vQuery.Eof do
    begin
      I := vQuery.RecNo - 1;
      Result[I] := Self.DataSet_Para_Record(vQuery);

      vQuery.Next;
    end;
  finally
    vQuery.Close;
    FreeAndNil(vQuery);
  end;
end;

end.
