unit uCadastroTelefones;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFrmCadastroTelefone = class(TForm)
    edtTelefone: TEdit;
    Label2: TLabel;
    edtContato: TEdit;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    edtCodigo: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Incluir;
    procedure Alterar;
    procedure ObeterDadosTelefone(aCodigo: Integer);
    { Private declarations }
  public
    { Public declarations }
    vCodigo, vCodigo_Cliente: Integer;
  end;

var
  FrmCadastroTelefone: TFrmCadastroTelefone;

implementation

uses
  uTelefone.BLL, dmConexao, uFuncoes;

{$R *.dfm}

procedure TFrmCadastroTelefone.Button1Click(Sender: TObject);
begin
//  ValidarDados;

  if edtCodigo.Text = EmptyStr then
    Incluir
  else
    Alterar;
end;

procedure TFrmCadastroTelefone.Button2Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmCadastroTelefone.FormShow(Sender: TObject);
begin
  ObeterDadosTelefone(vCodigo);
end;

procedure TFrmCadastroTelefone.Incluir;
var
  vTelefone: rTelefone;
  vTelefone_BLL: ITelefone_Customer_BLL;
begin
  vTelefone.Limpar;
  vTelefone.Codigo_Cliente := vCodigo_Cliente;
  vTelefone.Telefone := edtTelefone.Text;
  vTelefone.Contato := edtContato.Text;
  dmConn.FDConn.StartTransaction;
  try
    vTelefone_BLL := TTelefone_Customer_BLL.Create(dmConn.FDConn);
    vTelefone_BLL.Incluir(vTelefone);
    dmConn.FDConn.Commit;
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
  Self.Close;
end;

procedure TFrmCadastroTelefone.ObeterDadosTelefone(aCodigo: Integer);
var
  vTelefone: rTelefone;
  vTelefone_BLL: ITelefone_Customer_BLL;
begin
  if aCodigo > 0 then
  begin
    vTelefone.Limpar;
    vTelefone.Codigo := vCodigo;
    vTelefone_BLL := TTelefone_Customer_BLL.Create(dmConn.FDConn);
    vTelefone := vTelefone_BLL.obterRegistro(vTelefone);

    edtCodigo.Text := vTelefone.Codigo.ToString;
    edtTelefone.Text := vTelefone.Telefone;
    edtContato.Text := vTelefone.Contato;
  end;
end;

procedure TFrmCadastroTelefone.Alterar;
var
  vTelefone: rTelefone;
  vTelefone_BLL: ITelefone_Customer_BLL;
begin
  vTelefone.Limpar;
  vTelefone.Codigo := StrToInt(edtCodigo.Text);
  vTelefone.Telefone := edtTelefone.Text;
  vTelefone.Contato := edtContato.Text;
  dmConn.FDConn.StartTransaction;
  try
    vTelefone_BLL := TTelefone_Customer_BLL.Create(dmConn.FDConn);
    vTelefone_BLL.Alterar(vTelefone);
    dmConn.FDConn.Commit;
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
  Self.Close;
end;

end.
