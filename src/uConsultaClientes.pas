unit uConsultaClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, uFuncoes;

type
  TfrmConsultaClientes = class(TForm)
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    edtNome: TEdit;
    Label1: TLabel;
    Button4: TButton;
    cbAtivo: TComboBox;
    Label2: TLabel;
    Button2: TButton;
    Button1: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure ListaClientes(vCliente: rCliente);
    { Private declarations }
  public
    { Public declarations }
    vCodigo : string;
  end;

var
  frmConsultaClientes: TfrmConsultaClientes;

implementation

uses
  uCadastroCliente, uCliente.BLL, uTelefone.BLL, uEndereco.BLL, dmConexao;

{$R *.dfm}

procedure TfrmConsultaClientes.Button1Click(Sender: TObject);
var vCliente: rCliente;
begin
  if vCodigo.IsEmpty then
  begin
    ShowMessage('Selecione um registro!');
    Abort;
  end;

  FrmCadastroCliente.vCodigo := vCodigo.ToInteger;
  FrmCadastroCliente.ShowModal;

  ListaClientes(vCliente);
end;

procedure TfrmConsultaClientes.Button2Click(Sender: TObject);
var
  vCliente_BLL: ICliente_Customer_BLL;
  vCliente: rCliente;
  vEndereco_BLL: IEndereco_Customer_BLL;
  vEndereco: rEndereco;
  vTelefone_BLL: ITelefone_Customer_BLL;
  vTelefone: rTelefone;
begin
  vEndereco.Limpar;
  vEndereco.Codigo_Cliente := vCodigo.ToInteger;

  vTelefone.Limpar;
  vTelefone.Codigo_Cliente := vCodigo.ToInteger;

  vCliente.Limpar;
  vCliente.Codigo := vCodigo.ToInteger;

  dmConn.FDConn.StartTransaction;
  try
    vEndereco_BLL := TEndereco_Customer_BLL.Create(dmConn.FDConn);
    vEndereco_BLL.Excluir(vEndereco);

    vTelefone_BLL := TTelefone_Customer_BLL.Create(dmConn.FDConn);
    vTelefone_BLL.Excluir(vTelefone);

    vCliente_BLL := TCliente_Customer_BLL.Create(dmConn.FDConn);
    vCliente_BLL.Excluir(vCliente);

    dmConn.FDConn.Commit;

    ShowMessage('Cliente excluido com sucesso!');

    vCliente.Limpar;
    ListaClientes(vCliente);
  except
    on E: Exception do
    begin
      dmConn.FDConn.Rollback;
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmConsultaClientes.Button3Click(Sender: TObject);
var vCliente: rCliente;
begin
  FrmCadastroCliente.vCodigo := 0;
  FrmCadastroCliente.LimparDados;
  FrmCadastroCliente.ShowModal;
  ListaClientes(vCliente);
end;

procedure TfrmConsultaClientes.Button4Click(Sender: TObject);
var vCliente: rCliente;
begin
  vCliente.Limpar;
  vCliente.Nome := edtNome.Text;

  if cbAtivo.ItemIndex = 1 then
    vCliente.Ativo := 'S'
  else if cbAtivo.ItemIndex = 2 then
    vCliente.Ativo := 'N';

  ListaClientes(vCliente);
end;

procedure TfrmConsultaClientes.FormShow(Sender: TObject);
var vCliente: rCliente;
begin
  { Aumenta as colunas }
  StringGrid1.ColWidths[0] := 50;
  StringGrid1.ColWidths[1] := 150;
  StringGrid1.ColWidths[2] := 100;
  StringGrid1.ColWidths[3] := 100;
  StringGrid1.ColWidths[4] := 50;
  StringGrid1.ColWidths[5] := 100;
  StringGrid1.ColWidths[6] := 50;

  {Criar as colunas }
  StringGrid1.Cells[0,0] := 'Codigo';
  StringGrid1.Cells[1,0] := 'Nome';
  StringGrid1.Cells[2,0] := 'CPF/CNPJ';
  StringGrid1.Cells[3,0] := 'RG/IE';
  StringGrid1.Cells[4,0] := 'Tipo';
  StringGrid1.Cells[5,0] := 'Data Cadastro';
  StringGrid1.Cells[6,0] := 'Ativo';

  ListaClientes(vCliente);
end;

procedure TfrmConsultaClientes.ListaClientes(vCliente: rCliente);
var
  Linha: Integer;
  vCliente_BLL: ICliente_Customer_BLL;
  vCliente_Lista: Array_rCliente;
  I: Integer;
begin
  Linha := 1;
  {Limpa a grid}
   StringGrid1.RowCount := 1;

  try
    vCliente_BLL := TCliente_Customer_BLL.Create(dmConn.FDConn);
    vCliente_Lista := vCliente_BLL.obterLista(vCliente);
    for I := 0 to Length(vCliente_Lista) - 1 do
    begin
      if StringGrid1.RowCount <= Linha then
        StringGrid1.RowCount := StringGrid1.RowCount + 1;
      StringGrid1.Cells[0, Linha] := vCliente_Lista[I].Codigo.ToString;
      StringGrid1.Cells[1, Linha] := vCliente_Lista[I].Nome;
      StringGrid1.Cells[2, Linha] := vCliente_Lista[I].Cpf_Cnpj;
      StringGrid1.Cells[3, Linha] := vCliente_Lista[I].Rg_Ie;
      StringGrid1.Cells[4, Linha] := vCliente_Lista[I].Tipo_Pessoa;
      StringGrid1.Cells[5, Linha] := DateToStr(vCliente_Lista[I].Data_Cadastro);
      StringGrid1.Cells[6, Linha] := vCliente_Lista[I].Ativo;
      Linha := Linha + 1;
    end;

    StringGrid1.Refresh;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmConsultaClientes.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  {Captura o codigo da linha}
  vCodigo := StringGrid1.Cells[0, Arow];
end;

end.
