unit uCliente.BLL;

interface

uses uInterfacedObject, uFuncoes, DB, SysUtils, Windows, ACBrUtil, Dialogs;

  type

   ICliente_Customer_BLL = interface(uInterfacedObject.IInterfacedObject)
   ['{E4BC8255-1768-444A-A916-1CBBAFC371EC}']
    function obterRegistro(AValor : rCliente): rCliente; overload;
    function obterRegistro(ACodigo : Int64): rCliente; overload;
    function obterLista(AValor: rCliente): Array_rCliente;
    procedure Incluir(AValor: rCliente; var aCodigo : Integer);
    procedure Alterar(AValor: rCliente);
    procedure Excluir(AValor : rCliente);
   end;

  TCliente_Customer_BLL = class(uInterfacedObject.T_Tabela_SQL, ICliente_Customer_BLL)
  private
  public
    function obterRegistro(AValor : rCliente): rCliente; overload;
    function obterRegistro(ACodigo : Int64): rCliente; overload;
    procedure Incluir(AValor: rCliente; var aCodigo : Integer);
    procedure Alterar(AValor: rCliente);
    procedure Excluir(AValor : rCliente);
    function obterLista(AValor: rCliente): Array_rCliente;
  end;


implementation

uses uCliente.DAO;


procedure TCliente_Customer_BLL.Incluir(AValor: rCliente; var aCodigo : Integer);
var vCliente_DAO : ICliente_Customer_DAO;
begin
  vCliente_DAO := TCliente_Customer_DAO.Create(Self.fConexao);
  vCliente_DAO.Incluir(AValor, aCodigo);
end;

procedure TCliente_Customer_BLL.Alterar(AValor: rCliente);
var vCliente_DAO : ICliente_Customer_DAO;
begin
  vCliente_DAO := TCliente_Customer_DAO.Create(Self.fConexao);
  vCliente_DAO.Alterar(AValor);
end;

procedure TCliente_Customer_BLL.Excluir(AValor : rCliente);
var vCliente_DAO : ICliente_Customer_DAO;
begin
  vCliente_DAO := TCliente_Customer_DAO.Create(Self.fConexao);
  vCliente_DAO.Excluir(AValor);
end;


function TCliente_Customer_BLL.obterRegistro(AValor : rCliente): rCliente;
var vCliente_DAO : ICliente_Customer_DAO;
begin
  vCliente_DAO := TCliente_Customer_DAO.Create(Self.fConexao);
  Result := vCliente_DAO.obterRegistro(AValor);
end;

function TCliente_Customer_BLL.obterRegistro(ACodigo: Int64): rCliente;
var vCliente : rCliente;
begin
  vCliente.Limpar;
  vCliente.Codigo := ACodigo;

  Result := Self.obterRegistro(vCliente);
end;

function TCliente_Customer_BLL.obterLista(AValor: rCliente): Array_rCliente;
var vCliente_DAO : ICliente_Customer_DAO;
begin
  vCliente_DAO := TCliente_Customer_DAO.Create(Self.fConexao);
  Result := vCliente_DAO.obterLista(AValor);
end;

end.
