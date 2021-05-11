unit uEndereco.BLL;

interface

uses uInterfacedObject, uFuncoes, DB, SysUtils, Windows, ACBrUtil, Dialogs;

  type

   IEndereco_Customer_BLL = interface(uInterfacedObject.IInterfacedObject)
   ['{6B45B8E1-434B-4441-8816-BD12B4471C35}']
    function obterRegistro(AValor : rEndereco): rEndereco; overload;
    function obterRegistro(ACodigo : Int64): rEndereco; overload;
    procedure Incluir(AValor: rEndereco);
    procedure Excluir(AValor : rEndereco);
    procedure Alterar(AValor: rEndereco);
    function obterLista(AValor: rEndereco): Array_rEndereco;
   end;

  TEndereco_Customer_BLL = class(uInterfacedObject.T_Tabela_SQL, IEndereco_Customer_BLL)
  private
  public
    function obterRegistro(AValor : rEndereco): rEndereco; overload;
    function obterRegistro(ACodigo : Int64): rEndereco; overload;
    procedure Incluir(AValor: rEndereco);
    procedure Alterar(AValor: rEndereco);
    procedure Excluir(AValor : rEndereco);
    function obterLista(AValor: rEndereco): Array_rEndereco;
  end;


implementation

uses uEndereco.DAO;


procedure TEndereco_Customer_BLL.Incluir(AValor: rEndereco);
var vEndereco_DAO : IEndereco_Customer_DAO;
begin
  vEndereco_DAO := TEndereco_Customer_DAO.Create(Self.fConexao);
  vEndereco_DAO.Incluir(AValor);
end;

procedure TEndereco_Customer_BLL.Alterar(AValor: rEndereco);
var vEndereco_DAO : IEndereco_Customer_DAO;
begin
  vEndereco_DAO := TEndereco_Customer_DAO.Create(Self.fConexao);
  vEndereco_DAO.Alterar(AValor);
end;

procedure TEndereco_Customer_BLL.Excluir(AValor : rEndereco);
var vEndereco_DAO : IEndereco_Customer_DAO;
begin
  vEndereco_DAO := TEndereco_Customer_DAO.Create(Self.fConexao);
  vEndereco_DAO.Excluir(AValor);
end;


function TEndereco_Customer_BLL.obterRegistro(AValor : rEndereco): rEndereco;
var vEndereco_DAO : IEndereco_Customer_DAO;
begin
  vEndereco_DAO := TEndereco_Customer_DAO.Create(Self.fConexao);
  Result := vEndereco_DAO.obterRegistro(AValor);
end;

function TEndereco_Customer_BLL.obterLista(AValor: rEndereco): Array_rEndereco;
var vEndereco_DAO : IEndereco_Customer_DAO;
begin
  vEndereco_DAO := TEndereco_Customer_DAO.Create(Self.fConexao);
  Result := vEndereco_DAO.obterLista(AValor);
end;

function TEndereco_Customer_BLL.obterRegistro(ACodigo: Int64): rEndereco;
var vTelefone : rEndereco;
begin
  vTelefone.Limpar;
  vTelefone.Codigo := ACodigo;

  Result := Self.obterRegistro(vTelefone);
end;

end.
