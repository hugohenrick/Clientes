unit uCliente.DAO;

interface

uses uInterfacedObject, uFuncoes, DB, SysUtils, Windows, ACBrUtil, Dialogs, FireDAC.Comp.Client, FireDAC.Stan.Param;

  type

   ICliente_Customer_DAO = interface(uInterfacedObject.IInterfacedObject)
     function obterRegistro(AValor : rCliente): rCliente;
     function obterLista(AValor: rCliente): Array_rCliente;
     procedure Incluir(AValor: rCliente; var aCodigo : Integer);
     procedure Alterar(AValor: rCliente);
     procedure Excluir(AValor : rCliente);
   end;

  TCliente_Customer_DAO = class(uInterfacedObject.T_Tabela_SQL, ICliente_Customer_DAO)
  private
    function DataSet_Para_Record(ADataSet: TDataSet): rCliente;

  public
    procedure Incluir(AValor: rCliente; var aCodigo : Integer);
    procedure Alterar(AValor: rCliente);
    function obterRegistro(AValor : rCliente): rCliente;
    procedure Excluir(AValor : rCliente);
    function obterLista(AValor: rCliente): Array_rCliente;
  end;


implementation


procedure TCliente_Customer_DAO.Incluir(AValor : rCliente; var aCodigo : Integer);
var vFDQuery : TFDQuery;
begin
  try
    try
      Self.FDQuery_Inicializar(vFDQuery);
      vFDQuery.SQL.Add('SELECT COUNT(*) AS CONTADOR FROM CLIENTE WHERE CPF_CNPJ = :CPF_CNPJ');
      vFDQuery.ParamByName('CPF_CNPJ').AsString := AValor.Cpf_Cnpj;
      vFDQuery.Open;

      if vFDQuery.FieldByName('CONTADOR').AsInteger > 0 then
        raise Exception.Create('CPF ou CNPJ já cadastrado.');

      Self.FDQuery_Inicializar(vFDQuery);

      vFDQuery.SQL.Add('INSERT INTO CLIENTE ('
                                        + ' NOME'
                                        + ', CPF_CNPJ'
                                        + ', RG_IE'
                                        + ', TIPO_PESSOA'
                                        + ', DATA_CADASTRO'
                                        + ', ATIVO'
                                        + ')'
                     + 'VALUES( '
                                        + ' :NOME'
                                        + ', :CPF_CNPJ'
                                        + ', :RG_IE'
                                        + ', :TIPO_PESSOA'
                                        + ', :DATA_CADASTRO'
                                        + ', :ATIVO'
                                        +  ')');

      vFDQuery.ParamByName('NOME').AsString := AValor.Nome;
      vFDQuery.ParamByName('CPF_CNPJ').AsString := AValor.Cpf_Cnpj;
      vFDQuery.ParamByName('RG_IE').AsString := AValor.Rg_Ie;
      vFDQuery.ParamByName('TIPO_PESSOA').AsString := AValor.Tipo_Pessoa;
      vFDQuery.ParamByName('DATA_CADASTRO').AsDateTime := AValor.Data_Cadastro;
      vFDQuery.ParamByName('ATIVO').AsString := AValor.Ativo;
      vFDQuery.ExecSQL;

      aCodigo := fConexao.GetLastAutoGenValue('');

    finally
      vFDQuery.Close;
      FreeAndNil(vFDQuery);
    end;
  except
    raise;
  end;
end;

procedure TCliente_Customer_DAO.Alterar(AValor : rCliente);
var vFDQuery : TFDQuery;
begin
  try
    try
      Self.FDQuery_Inicializar(vFDQuery);
      vFDQuery.SQL.Add('UPDATE CLIENTE SET'
                                      + ' NOME = :NOME,'
                                      + ' CPF_CNPJ = :CPF_CNPJ,'
                                      + ' RG_IE = :RG_IE,'
                                      + ' TIPO_PESSOA = :TIPO_PESSOA,'
                                      + ' DATA_CADASTRO = :DATA_CADASTRO,'
                                      + ' ATIVO = :ATIVO');

      vFDQuery.SQL.Add('WHERE CODIGO = :CODIGO');

      vFDQuery.ParamByName('CODIGO').AsLargeInt := AValor.Codigo;
       vFDQuery.ParamByName('NOME').AsString := AValor.Nome;
      vFDQuery.ParamByName('CPF_CNPJ').AsString := AValor.Cpf_Cnpj;
      vFDQuery.ParamByName('RG_IE').AsString := AValor.Rg_Ie;
      vFDQuery.ParamByName('TIPO_PESSOA').AsString := AValor.Tipo_Pessoa;
      vFDQuery.ParamByName('DATA_CADASTRO').AsDateTime := AValor.Data_Cadastro;
      vFDQuery.ParamByName('ATIVO').AsString := AValor.Ativo;
      vFDQuery.ExecSQL;
    finally
      vFDQuery.Close;
      FreeAndNil(vFDQuery);
    end;
  except
    raise;
  end;
end;

function TCliente_Customer_DAO.DataSet_Para_Record(ADataSet : TDataSet ) : rCliente;
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

      if existeColuna('NOME') then
        Result.Nome := vField.AsString;

      if existeColuna('CPF_CNPJ') then
        Result.Cpf_Cnpj := vField.AsString;

      if existeColuna('RG_IE') then
        Result.Rg_Ie := vField.AsString;

      if existeColuna('TIPO_PESSOA') then
        Result.Tipo_Pessoa := vField.AsString;

      if existeColuna('DATA_CADASTRO') then
        Result.Data_Cadastro := vField.AsDateTime;

      if existeColuna('ATIVO') then
        Result.Ativo := vField.AsString;

    except
      on e: Exception do
      begin
        raise Exception.Create('Campo com erro na conversão: ' + lNomeColuna + ' Erro: ' + e.Message);
      end;
    end;
  end;
end;

procedure TCliente_Customer_DAO.Excluir(AValor : rCliente);
var vQuery : TFDQuery;
begin
  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('DELETE FROM CLIENTE ');
    vQuery.SQL.Add('WHERE CODIGO = :CODIGO'  );
    vQuery.ParamByName('CODIGO').AsLargeInt := AValor.Codigo;
    vQuery.Execute;
  finally
    vQuery.Close;
    FreeAndNil(vQuery);
  end;
end;

function TCliente_Customer_DAO.obterRegistro(AValor: rCliente): rCliente;
var vQuery : TFDQuery;
begin
  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('SELECT * FROM CLIENTE WHERE 1=1');

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

function TCliente_Customer_DAO.obterLista(AValor: rCliente): Array_rCliente;
var vQuery : TFDQuery;
    i : Integer;
begin
  {Limpando retorno}
  ZeroMemory(@Result, SizeOf(Result));

  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('SELECT * FROM CLIENTE WHERE 1=1');

    if not AValor.Nome.IsEmpty then
      vQuery.SQL.Add('AND NOME LIKE ''%' +AValor.Nome + '%'' ');

    if not AValor.Ativo.IsEmpty then
    begin
      vQuery.SQL.Add('AND ATIVO = :ATIVO ');
      vQuery.ParamByName('ATIVO').AsString := AValor.Ativo;
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
