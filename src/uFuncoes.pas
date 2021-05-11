unit uFuncoes;

interface

uses
   Windows, Classes, DBClient, uStringUtils, System.SysUtils;

type

{Records}
rTelefone = record
  Codigo   : Integer;
  Codigo_Cliente : Integer;
  Telefone : string;
  Contato  : string;
  procedure Limpar();
end;

rEndereco = record
  Codigo         : Integer;
  Codigo_Cliente : Integer;
  Logradouro     : string;
  Numero         : Integer;
  Cep            : Integer;
  Bairro         : string;
  Cidade         : string;
  Uf             : string;
  Pais           : string;
  procedure Limpar();
end;

rCliente = record
  Codigo         : Integer;
  Nome           : string;
  Cpf_Cnpj       : string;
  Rg_Ie          : string;
  Tipo_Pessoa    : string;
  Ativo          : string;
  Data_Cadastro  : TDateTime;
  procedure Limpar();
end;

Array_rTelefone  = array of rTelefone;
Array_rEndereco  = array of rEndereco;
Array_rCliente   = array of rCliente;

implementation

{ rTelefone }

procedure rTelefone.Limpar;
begin
  ZeroMemory(@Self, SizeOf(Self));
end;


{ rEndereco }

procedure rEndereco.Limpar;
begin
  ZeroMemory(@Self, SizeOf(Self));
end;

{ rCliente }

procedure rCliente.Limpar;
begin
  ZeroMemory(@Self, SizeOf(Self));
end;

end.
