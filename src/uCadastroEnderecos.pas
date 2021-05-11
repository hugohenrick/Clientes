unit uCadastroEnderecos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, ACBrBase,
  ACBrSocket, ACBrCEP;

type
  TfrmCadastroEndereco = class(TForm)
    edtCEP: TEdit;
    Label1: TLabel;
    sbBuscaCEP: TSpeedButton;
    Label2: TLabel;
    edtLogradouro: TEdit;
    Label3: TLabel;
    edtNumero: TEdit;
    edtBairro: TEdit;
    Label4: TLabel;
    edtCidade: TEdit;
    Label5: TLabel;
    edtPais: TEdit;
    Label6: TLabel;
    edtUF: TEdit;
    Label7: TLabel;
    Button1: TButton;
    Button2: TButton;
    ACBrCEP1: TACBrCEP;
    edtCodigo: TEdit;
    Label8: TLabel;
    procedure sbBuscaCEPClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure Incluir;
    procedure Alterar;
    procedure ObeterDadosEndereco(aCodigo: Integer);
  public
    { Public declarations }
    vCodigo, vCodigo_Cliente: Integer;
  end;

var
  frmCadastroEndereco: TfrmCadastroEndereco;

implementation

uses
  uEndereco.BLL, uFuncoes, dmConexao, ACBrUtil;

{$R *.dfm}

procedure TfrmCadastroEndereco.Alterar;
var
  vEndereco: rEndereco;
  vEndereco_BLL: IEndereco_Customer_BLL;
begin
  vEndereco.Limpar;
  vEndereco.Codigo := vCodigo;
  vEndereco.Cep := StrToInt(OnlyNumber(edtCEP.Text));
  vEndereco.Logradouro := edtLogradouro.Text;
  vEndereco.Numero := StrToInt(edtNumero.Text);
  vEndereco.Bairro := edtBairro.Text;
  vEndereco.Cidade := edtCidade.Text;
  vEndereco.UF := edtUF.Text;
  vEndereco.Pais := edtPais.Text;

  dmConn.FDConn.StartTransaction;
  try
    vEndereco_BLL := TEndereco_Customer_BLL.Create(dmConn.FDConn);
    vEndereco_BLL.Alterar(vEndereco);
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

procedure TfrmCadastroEndereco.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmCadastroEndereco.Button2Click(Sender: TObject);
begin
  //ValidarDados;

  if edtCodigo.Text = EmptyStr then
    Incluir
  else
    Alterar;
end;

procedure TfrmCadastroEndereco.FormShow(Sender: TObject);
begin
  ObeterDadosEndereco(vCodigo);
end;

procedure TfrmCadastroEndereco.Incluir;
var
  vEndereco: rEndereco;
  vEndereco_BLL: IEndereco_Customer_BLL;
begin
  vEndereco.Limpar;
  vEndereco.Codigo_Cliente := vCodigo_Cliente;
  vEndereco.Cep := StrToInt(OnlyNumber(edtCEP.Text));
  vEndereco.Logradouro := edtLogradouro.Text;
  vEndereco.Numero := StrToInt(edtNumero.Text);
  vEndereco.Bairro := edtBairro.Text;
  vEndereco.Cidade := edtCidade.Text;
  vEndereco.UF := edtUF.Text;
  vEndereco.Pais := edtPais.Text;

  dmConn.FDConn.StartTransaction;
  try
    vEndereco_BLL := TEndereco_Customer_BLL.Create(dmConn.FDConn);
    vEndereco_BLL.Incluir(vEndereco);
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

procedure TfrmCadastroEndereco.ObeterDadosEndereco(aCodigo: Integer);
var
  vEndereco: rEndereco;
  vEndereco_BLL: IEndereco_Customer_BLL;
begin
  if aCodigo > 0 then
  begin
    vEndereco.Limpar;
    vEndereco.Codigo := vCodigo;
    vEndereco_BLL := TEndereco_Customer_BLL.Create(dmConn.FDConn);
    vEndereco := vEndereco_BLL.obterRegistro(vEndereco);

    edtCodigo.Text := vEndereco.Codigo.ToString;
    edtCEP.Text := vEndereco.Cep.ToString;
    edtLogradouro.Text := vEndereco.Logradouro;
    edtNumero.Text := vEndereco.Numero.ToString;
    edtBairro.Text := vEndereco.Bairro;
    edtCidade.Text := vEndereco.Cidade;
    edtUF.Text := vEndereco.Uf;
    edtPais.Text := vEndereco.Pais;
  end;

end;

procedure TfrmCadastroEndereco.sbBuscaCEPClick(Sender: TObject);
var
  i: Integer;
begin
  ACBrCEP1.BuscarPorCEP(edtCEP.Text);

  for I := 0 to ACBrCEP1.Enderecos.Count -1 do
  begiN
    edtCEP.Text          := ACBrCEP1.Enderecos[i].CEP;
    edtLogradouro.Text   := ACBrCEP1.Enderecos[i].Logradouro;
    edtCidade.Text       := ACBrCEP1.Enderecos[i].Municipio;
    edtUF.Text           := ACBrCEP1.Enderecos[i].UF;
    edtBairro.Text       := ACBrCEP1.Enderecos[i].Bairro;
  end;
end;

end.
