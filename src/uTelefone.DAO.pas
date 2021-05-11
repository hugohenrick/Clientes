unit uTelefone.DAO;

interface

uses uInterfacedObject, uFuncoes, DB, SysUtils, Windows, ACBrUtil, Dialogs, FireDAC.Comp.Client, FireDAC.Stan.Param;

  type

   ITelefone_Customer_DAO = interface(uInterfacedObject.IInterfacedObject)
     function obterRegistro(AValor : rTelefone): rTelefone;
     function obterLista(AValor: rTelefone): Array_rTelefone;
     procedure Incluir(AValor: rTelefone);
     procedure Alterar(AValor: rTelefone);
     procedure Excluir(AValor : rTelefone);
   end;

  TTelefone_Customer_DAO = class(uInterfacedObject.T_Tabela_SQL, ITelefone_Customer_DAO)
  private
    function DataSet_Para_Record(ADataSet: TDataSet): rTelefone;

  public
    procedure Incluir(AValor: rTelefone);
    procedure Alterar(AValor: rTelefone);
    function obterRegistro(AValor : rTelefone): rTelefone;
    procedure Excluir(AValor : rTelefone);
    function obterLista(AValor: rTelefone): Array_rTelefone;
  end;


implementation


procedure TTelefone_Customer_DAO.Incluir(AValor : rTelefone);
var vFDQuery : TFDQuery;
begin
  try
    try
      Self.FDQuery_Inicializar(vFDQuery);
      vFDQuery.SQL.Add('INSERT INTO TELEFONE ('
                                        + ' TELEFONE'
                                       + ', CONTATO'
                                       + ', CODIGO_CLIENTE'
                                       + ')'
                     + 'VALUES( '
                                        + ' :TELEFONE'
                                       + ', :CONTATO'
                                       + ', :CODIGO_CLIENTE'
                                       +  ')');

      vFDQuery.ParamByName('TELEFONE').AsString := AValor.Telefone;
      vFDQuery.ParamByName('CONTATO').AsString := AValor.Contato;
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

procedure TTelefone_Customer_DAO.Alterar(AValor : rTelefone);
var vFDQuery : TFDQuery;
begin
  try
    try
      Self.FDQuery_Inicializar(vFDQuery);
      vFDQuery.SQL.Add('UPDATE TELEFONE SET'
                                      + ' TELEFONE = :TELEFONE,'
                                      + ' CONTATO = :CONTATO');
      vFDQuery.SQL.Add('WHERE CODIGO = :CODIGO');

      vFDQuery.ParamByName('TELEFONE').AsString := AValor.Telefone;
      vFDQuery.ParamByName('CONTATO').AsString := AValor.Contato;
      vFDQuery.ParamByName('CODIGO').AsInteger := AValor.Codigo;
      vFDQuery.ExecSQL;
    finally
      vFDQuery.Close;
      FreeAndNil(vFDQuery);
    end;
  except
    raise;
  end;
end;

function TTelefone_Customer_DAO.DataSet_Para_Record(ADataSet : TDataSet ) : rTelefone;
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

      if existeColuna('TELEFONE') then
        Result.Telefone := vField.AsString;

      if existeColuna('CONTATO') then
        Result.Contato := vField.AsString;
    except
      on e: Exception do
      begin
        raise Exception.Create('Campo com erro na conversão: ' + lNomeColuna + ' Erro: ' + e.Message);
      end;
    end;
  end;
end;

procedure TTelefone_Customer_DAO.Excluir(AValor : rTelefone);
var vQuery : TFDQuery;
begin
  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('DELETE FROM TELEFONE WHERE 1=1');

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

function TTelefone_Customer_DAO.obterRegistro(AValor: rTelefone): rTelefone;
var vQuery : TFDQuery;
begin
  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('SELECT * FROM TELEFONE WHERE 1=1');

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

function TTelefone_Customer_DAO.obterLista(AValor: rTelefone): Array_rTelefone;
var vQuery : TFDQuery;
    i : Integer;
begin
  {Limpando retorno}
  ZeroMemory(@Result, SizeOf(Result));

  Self.FDQuery_Inicializar(vQuery);
  try
    vQuery.SQL.Add('SELECT * FROM TELEFONE WHERE 1=1');

    if AValor.Codigo_Cliente > 0 then
    begin
      vQuery.SQL.Add('AND CODIGO_CLIENTE = :CODIGO_CLIENTE ');
      vQuery.ParamByName('CODIGO_CLIENTE').AsInteger := AValor.Codigo_Cliente;
    end;

    if not AValor.Telefone.IsEmpty then
    begin
      vQuery.SQL.Add('AND TELEFONE = :TELEFONE ');
      vQuery.ParamByName('TELEFONE').AsString := AValor.Telefone;
    end;

    if not AValor.Contato.IsEmpty then
    begin
      vQuery.SQL.Add('AND CONTATO = :CONTATO ');
      vQuery.ParamByName('CONTATO').AsString := AValor.Contato;
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
