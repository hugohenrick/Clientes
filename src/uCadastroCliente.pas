unit uCadastroCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids;

type
  TFrmCadastroCliente = class(TForm)
    edtNome: TEdit;
    rgTipoPessoa: TRadioGroup;
    Label1: TLabel;
    rgAtivo: TRadioGroup;
    edtCPF_CNPJ: TEdit;
    lbCPF_CNPJ: TLabel;
    edtRG_IE: TEdit;
    lbRg_Ie: TLabel;
    dtCadastro: TDateTimePicker;
    Label4: TLabel;
    pgDados: TPageControl;
    tsEnderecos: TTabSheet;
    tsTelefones: TTabSheet;
    sbExcluirEndereco: TSpeedButton;
    sbAlteraEndereco: TSpeedButton;
    sbAdicionaEndereco: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    edtCodigo: TEdit;
    Label5: TLabel;
    sGridEnderecos: TStringGrid;
    sgridTelefones: TStringGrid;
    sbAdicionarTelefone: TSpeedButton;
    sbAlterarTelefone: TSpeedButton;
    sbExcluirTelefone: TSpeedButton;
    procedure sbAdicionarTelefoneClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbExcluirTelefoneClick(Sender: TObject);
    procedure sgridTelefonesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sbAlterarTelefoneClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sbAdicionaEnderecoClick(Sender: TObject);
    procedure sbAlteraEnderecoClick(Sender: TObject);
    procedure sGridEnderecosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure rgTipoPessoaClick(Sender: TObject);
    procedure sbExcluirEnderecoClick(Sender: TObject);
  private
    procedure Inserir;
    procedure Alterar;
    procedure ObeterDadosCliente(aCodigo : Integer);
    procedure ValidarDados;
    procedure ListaTelefone;
    procedure ListaEndereco;
    { Private declarations }
  public
    { Public declarations }
    vCodigo : Integer;
    vCodigo_Telefone, vCodigo_Endereco: string;
    procedure LimparDados;
  end;

var
  FrmCadastroCliente: TFrmCadastroCliente;

implementation

uses
  uCadastroTelefones, uCadastroEnderecos, dmConexao, uFuncoes, uCliente.BLL, uTelefone.BLL, uEndereco.BLL;

{$R *.dfm}

procedure TFrmCadastroCliente.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmCadastroCliente.Button2Click(Sender: TObject);
begin
  ValidarDados;

  if edtCodigo.Text = EmptyStr then
  begin
    Inserir;
    ObeterDadosCliente(vCodigo);
  end
  else
    Alterar;
end;

procedure TFrmCadastroCliente.FormShow(Sender: TObject);
begin
  ObeterDadosCliente(vCodigo);
  { Aumenta as colunas }
  sgridTelefones.ColWidths[0] := 50;
  sgridTelefones.ColWidths[1] := 100;
  sgridTelefones.ColWidths[2] := 150;

  sGridEnderecos.ColWidths[0] := 50;
  sGridEnderecos.ColWidths[1] := 100;
  sGridEnderecos.ColWidths[2] := 150;
  sGridEnderecos.ColWidths[3] := 50;
  sGridEnderecos.ColWidths[4] := 100;
  sGridEnderecos.ColWidths[5] := 100;
  sGridEnderecos.ColWidths[6] := 50;
  sGridEnderecos.ColWidths[7] := 80;

  {Criar as colunas }
  sgridTelefones.Cells[0,0] := 'Codigo';
  sgridTelefones.Cells[1,0] := 'Telefone';
  sgridTelefones.Cells[2,0] := 'Contato';

  sGridEnderecos.Cells[0,0] := 'Codigo';
  sGridEnderecos.Cells[1,0] := 'CEP';
  sGridEnderecos.Cells[2,0] := 'Logradouro';
  sGridEnderecos.Cells[3,0] := 'Numero';
  sGridEnderecos.Cells[4,0] := 'Cidade';
  sGridEnderecos.Cells[5,0] := 'Bairro';
  sGridEnderecos.Cells[6,0] := 'UF';
  sGridEnderecos.Cells[7,0] := 'Pais';

end;

procedure TFrmCadastroCliente.ObeterDadosCliente(aCodigo : Integer);
var
  vCliente: rCliente;
  vCliente_BLL: ICliente_Customer_BLL;
begin
  if aCodigo > 0 then
  begin
    vCliente.Limpar;
    vCliente.Codigo := aCodigo;
    try
      vCliente_BLL := TCliente_Customer_BLL.Create(dmConn.FDConn);
      vCliente := vCliente_BLL.obterRegistro(vCliente);

      edtCodigo.Text := vCliente.Codigo.ToString;
      edtNome.Text := vCliente.Nome;
      edtCPF_CNPJ.Text := vCliente.Cpf_Cnpj;
      edtRG_IE.Text := vCliente.Rg_Ie;
      dtCadastro.DateTime := vCliente.Data_Cadastro;
      edtNome.Text := vCliente.Nome;

      if vCliente.Tipo_Pessoa = 'F' then
        rgTipoPessoa.ItemIndex := 0
      else
        rgTipoPessoa.ItemIndex := 1;

      if vCliente.Ativo = 'S' then
        rgAtivo.ItemIndex := 0
      else
        rgAtivo.ItemIndex := 1;

      ListaTelefone;
      ListaEndereco;

    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
      end;
    end;
  end;
end;

procedure TFrmCadastroCliente.rgTipoPessoaClick(Sender: TObject);
begin
  if rgTipoPessoa.ItemIndex = 0 then
  begin
    lbCPF_CNPJ.Caption := 'CPF' ;
    lbRg_Ie.Caption := 'RG';
  end
  else begin
    lbCPF_CNPJ.Caption := 'CNPJ';
    lbRg_Ie.Caption := 'Ins. Estadual';
  end;
end;

procedure TFrmCadastroCliente.Inserir;
var
  vCliente: rCliente;
  vCliente_BLL: ICliente_Customer_BLL;
begin
  vCliente.Limpar;
  vCliente.Nome := edtNome.Text;
  vCliente.Cpf_Cnpj := edtCPF_CNPJ.Text;
  vCliente.Rg_Ie := edtRG_IE.Text;
  vCliente.Data_Cadastro := dtCadastro.DateTime;

  if rgTipoPessoa.ItemIndex = 0 then
    vCliente.Tipo_Pessoa := 'F'
  else
    vCliente.Tipo_Pessoa := 'J';

  if rgAtivo.ItemIndex = 0 then
    vCliente.Ativo := 'S'
  else
    vCliente.Ativo := 'N';

  dmConn.FDConn.StartTransaction;
  try
    vCliente_BLL := TCliente_Customer_BLL.Create(dmConn.FDConn);
    vCliente_BLL.Incluir(vCliente, vCodigo);
    dmConn.FDConn.Commit;

    ShowMessage('Cliente inserido com sucesso');
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmCadastroCliente.Alterar;
var
  vCliente: rCliente;
  vCliente_BLL: ICliente_Customer_BLL;
begin
  vCliente.Limpar;
  vCliente.Codigo := StrToInt(edtCodigo.Text);
  vCliente.Nome := edtNome.Text;
  vCliente.Cpf_Cnpj := edtCPF_CNPJ.Text;
  vCliente.Rg_Ie := edtRG_IE.Text;
  vCliente.Data_Cadastro := dtCadastro.DateTime;

  if rgTipoPessoa.ItemIndex = 0 then
    vCliente.Tipo_Pessoa := 'F'
  else
    vCliente.Tipo_Pessoa := 'J';

  if rgAtivo.ItemIndex = 0 then
    vCliente.Ativo := 'S'
  else
    vCliente.Ativo := 'N';

  dmConn.FDConn.StartTransaction;
  try
    vCliente_BLL := TCliente_Customer_BLL.Create(dmConn.FDConn);
    vCliente_BLL.Alterar(vCliente);
    dmConn.FDConn.Commit;

    ShowMessage('Cliente alterado com sucesso');
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmCadastroCliente.sbAdicionarTelefoneClick(Sender: TObject);
begin
  FrmCadastroTelefone.vCodigo_Cliente := vCodigo;
  FrmCadastroTelefone.ShowModal;
  ListaTelefone;
end;

procedure TFrmCadastroCliente.sbAlteraEnderecoClick(Sender: TObject);
begin
  frmCadastroEndereco.vCodigo := vCodigo_Endereco.ToInteger;
  frmCadastroEndereco.ShowModal;
  ListaEndereco;
end;

procedure TFrmCadastroCliente.sbAlterarTelefoneClick(Sender: TObject);
begin
  FrmCadastroTelefone.vCodigo := vCodigo_Telefone.ToInteger;
  FrmCadastroTelefone.ShowModal;
  ListaTelefone;
end;

procedure TFrmCadastroCliente.sbExcluirEnderecoClick(Sender: TObject);
var
  vEndereco_BLL: IEndereco_Customer_BLL;
  vEndereco: rEndereco;
begin
  vEndereco.Limpar;
  vEndereco.Codigo := vCodigo_Endereco.ToInteger;

  dmConn.FDConn.StartTransaction;
  try
    vEndereco_BLL := TEndereco_Customer_BLL.Create(dmConn.FDConn);
    vEndereco_BLL.Excluir(vEndereco);
    dmConn.FDConn.Commit;

    ShowMessage('Endereço excluido com sucesso!');

    ListaEndereco;
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmCadastroCliente.sbExcluirTelefoneClick(Sender: TObject);
var
  vTelefone_BLL: ITelefone_Customer_BLL;
  vTelefone: rTelefone;
begin
  vTelefone.Limpar;
  vTelefone.Codigo := vCodigo_Telefone.ToInteger;

  dmConn.FDConn.StartTransaction;
  try
    vTelefone_BLL := TTelefone_Customer_BLL.Create(dmConn.FDConn);
    vTelefone_BLL.Excluir(vTelefone);
    dmConn.FDConn.Commit;

    ShowMessage('Telefone excluido com sucesso!');

    ListaTelefone;
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmCadastroCliente.sGridEnderecosSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  vCodigo_Endereco := sGridEnderecos.Cells[0, Arow];
end;

procedure TFrmCadastroCliente.sgridTelefonesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  vCodigo_Telefone := sgridTelefones.Cells[0, Arow];
end;

procedure TFrmCadastroCliente.sbAdicionaEnderecoClick(Sender: TObject);
begin
  frmCadastroEndereco.vCodigo_Cliente := vCodigo;
  frmCadastroEndereco.ShowModal;
  ListaEndereco;
end;

procedure TFrmCadastroCliente.ValidarDados;
begin
  if edtNome.Text = EmptyStr then
  begin
    ShowMessage('Campo Nome Obrigatório!');
    Abort;
  end;

  if edtCPF_CNPJ.Text = EmptyStr then
  begin
    ShowMessage('Campo CPF/CNPJ Obrigatório!');
    Abort;
  end;

  if edtRG_IE.Text = EmptyStr then
  begin
    ShowMessage('Campo RG/IE Obrigatório!');
    Abort;
  end;
end;

procedure TFrmCadastroCliente.LimparDados;
begin
  edtCodigo.Text := EmptyStr;
  edtNome.Text := EmptyStr;
  edtCPF_CNPJ.Text := EmptyStr;
  edtRG_IE.Text := EmptyStr;
  dtCadastro.DateTime := Now;
  edtNome.Text := EmptyStr;
  sGridEnderecos.RowCount := 1;
  sgridTelefones.RowCount := 1;
end;

procedure TFrmCadastroCliente.ListaEndereco;
var
  Linha: Integer;
  vEndereco_BLL: IEndereco_Customer_BLL;
  vEndereco_Lista: Array_rEndereco;
  vEndereco : rEndereco;
  I: Integer;
begin
  Linha := 1;
  {Limpa a grid}
   sGridEnderecos.RowCount := 1;
  try
    vEndereco.Limpar;
    vEndereco.Codigo_Cliente := vCodigo;

    vEndereco_BLL := TEndereco_Customer_BLL.Create(dmConn.FDConn);
    vEndereco_Lista := vEndereco_BLL.obterLista(vEndereco);

    for I := 0 to Length(vEndereco_Lista) - 1 do
    begin
      if sGridEnderecos.RowCount <= Linha then
        sGridEnderecos.RowCount := sGridEnderecos.RowCount + 1;

      sGridEnderecos.Cells[0, Linha] := vEndereco_Lista[I].Codigo.ToString;
      sGridEnderecos.Cells[1, Linha] := vEndereco_Lista[I].Cep.ToString;
      sGridEnderecos.Cells[2, Linha] := vEndereco_Lista[I].Logradouro;
      sGridEnderecos.Cells[3, Linha] := vEndereco_Lista[I].Numero.ToString;
      sGridEnderecos.Cells[4, Linha] := vEndereco_Lista[I].Cidade;
      sGridEnderecos.Cells[5, Linha] := vEndereco_Lista[I].Bairro;
      sGridEnderecos.Cells[6, Linha] := vEndereco_Lista[I].UF;
      sGridEnderecos.Cells[7, Linha] := vEndereco_Lista[I].Pais;
      Linha := Linha + 1;
    end;

    sGridEnderecos.Refresh;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFrmCadastroCliente.ListaTelefone;
var
  Linha: Integer;
  vTelefone_BLL: ITelefone_Customer_BLL;
  vTelefone_Lista: Array_rTelefone;
  vTelefone : rTelefone;
  I: Integer;
begin
  Linha := 1;
  {Limpa a grid}
   sgridTelefones.RowCount := 1;
  try
    vTelefone.Limpar;
    vTelefone.Codigo_Cliente := vCodigo;

    vTelefone_BLL := TTelefone_Customer_BLL.Create(dmConn.FDConn);
    vTelefone_Lista := vTelefone_BLL.obterLista(vTelefone);

    for I := 0 to Length(vTelefone_Lista) - 1 do
    begin
      if sgridTelefones.RowCount <= Linha then
        sgridTelefones.RowCount := sgridTelefones.RowCount + 1;

      sgridTelefones.Cells[0, Linha] := vTelefone_Lista[I].Codigo.ToString;
      sgridTelefones.Cells[1, Linha] := vTelefone_Lista[I].Telefone;
      sgridTelefones.Cells[2, Linha] := vTelefone_Lista[I].Contato;
      Linha := Linha + 1;
    end;

    sGridEnderecos.Refresh;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;

end;

end.
