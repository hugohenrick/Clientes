unit uTelefone.BLL;

interface

uses uInterfacedObject, uFuncoes, DB, SysUtils, Windows, ACBrUtil, Dialogs;

  type

   ITelefone_Customer_BLL = interface(uInterfacedObject.IInterfacedObject)
   ['{7FCBBBB2-8F59-4749-9BD7-2A590D0798E1}']
    function obterRegistro(AValor : rTelefone): rTelefone; overload;
    function obterRegistro(ACodigo : Int64): rTelefone; overload;
    function obterLista(AValor: rTelefone): Array_rTelefone;
    procedure Incluir(AValor: rTelefone);
    procedure Excluir(AValor : rTelefone);
    procedure Alterar(AValor: rTelefone);
   end;

  TTelefone_Customer_BLL = class(uInterfacedObject.T_Tabela_SQL, ITelefone_Customer_BLL)
  private
  public
    function obterRegistro(AValor : rTelefone): rTelefone; overload;
    function obterRegistro(ACodigo : Int64): rTelefone; overload;
    function obterLista(AValor: rTelefone): Array_rTelefone;
    procedure Incluir(AValor: rTelefone);
    procedure Alterar(AValor: rTelefone);
    procedure Excluir(AValor : rTelefone);
  end;


implementation

uses uTelefone.DAO;


procedure TTelefone_Customer_BLL.Incluir(AValor: rTelefone);
var vTelefone_DAO : ITelefone_Customer_DAO;
begin
  vTelefone_DAO := TTelefone_Customer_DAO.Create(Self.fConexao);
  vTelefone_DAO.Incluir(AValor);
end;

procedure TTelefone_Customer_BLL.Alterar(AValor: rTelefone);
var vTelefone_DAO : ITelefone_Customer_DAO;
begin
  vTelefone_DAO := TTelefone_Customer_DAO.Create(Self.fConexao);
  vTelefone_DAO.Alterar(AValor);
end;

procedure TTelefone_Customer_BLL.Excluir(AValor : rTelefone);
var vTelefone_DAO : ITelefone_Customer_DAO;
begin
  vTelefone_DAO := TTelefone_Customer_DAO.Create(Self.fConexao);
  vTelefone_DAO.Excluir(AValor);
end;


function TTelefone_Customer_BLL.obterRegistro(AValor : rTelefone): rTelefone;
var vTelefone_DAO : ITelefone_Customer_DAO;
begin
  vTelefone_DAO := TTelefone_Customer_DAO.Create(Self.fConexao);
  Result := vTelefone_DAO.obterRegistro(AValor);
end;

function TTelefone_Customer_BLL.obterRegistro(ACodigo: Int64): rTelefone;
var vTelefone : rTelefone;
begin
  vTelefone.Limpar;
  vTelefone.Codigo := ACodigo;

  Result := Self.obterRegistro(vTelefone);
end;

function TTelefone_Customer_BLL.obterLista(AValor: rTelefone): Array_rTelefone;
var vTelefone_DAO : ITelefone_Customer_DAO;
begin
  vTelefone_DAO := TTelefone_Customer_DAO.Create(Self.fConexao);
  Result := vTelefone_DAO.obterLista(AValor);
end;

end.
