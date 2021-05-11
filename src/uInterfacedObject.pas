unit uInterfacedObject;

interface

uses SysUtils, Classes, Data.DB, ACBrUtil, uFuncoes, FireDAC.Comp.Client, FireDAC.Stan.Param, IdHashMessageDigest;

type
   IInterfacedObject = interface(IInterface)
   ['{07806B84-BA2A-4610-B13F-CB045FAB96B2}']
   end;

   TInterfacedObject_SQL = class(TInterfacedObject, IInterfacedObject)
   private

   protected
     fConexao: TFDConnection;

   public
     constructor Create(AConexao : TFDConnection); reintroduce;
     procedure FDQuery_Inicializar(var AFDQuery : TFDQuery);
   end;

   T_Tabela_SQL= class(TInterfacedObject_SQL, IInterfacedObject)
     strict private

     private

     protected

     public

       class function NovaConexao : TFDConnection;
   end;


implementation

constructor TInterfacedObject_SQL.Create(AConexao : TFDConnection);
begin
  inherited Create();

  FConexao := AConexao;
end;

procedure TInterfacedObject_SQL.FDQuery_Inicializar(var AFDQuery: TFDQuery);
begin
  AFDQuery := nil;
  AFDQuery := TFDQuery.Create(nil);
  AFDQuery.Connection := fConexao;
  AFDQuery.SQL.Clear;
end;

{ T_Tabela_SQL }

class function T_Tabela_SQL.NovaConexao: TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.Connected := True;
end;

end.
