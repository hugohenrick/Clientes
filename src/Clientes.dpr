program Clientes;

uses
  Vcl.Forms,
  uConsultaClientes in 'uConsultaClientes.pas' {frmConsultaClientes},
  dmConexao in 'dmConexao.pas' {dmConn: TDataModule},
  uInterfacedObject in 'uInterfacedObject.pas',
  uFuncoes in 'uFuncoes.pas',
  uTelefone.BLL in 'uTelefone.BLL.pas',
  uTelefone.DAO in 'uTelefone.DAO.pas',
  uEndereco.DAO in 'uEndereco.DAO.pas',
  uEndereco.BLL in 'uEndereco.BLL.pas',
  uCadastroCliente in 'uCadastroCliente.pas' {FrmCadastroCliente},
  uCadastroTelefones in 'uCadastroTelefones.pas' {FrmCadastroTelefone},
  uCliente.DAO in 'uCliente.DAO.pas',
  uCliente.BLL in 'uCliente.BLL.pas',
  uCadastroEnderecos in 'uCadastroEnderecos.pas' {frmCadastroEndereco};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmConsultaClientes, frmConsultaClientes);
  Application.CreateForm(TdmConn, dmConn);
  Application.CreateForm(TFrmCadastroCliente, FrmCadastroCliente);
  Application.CreateForm(TFrmCadastroTelefone, FrmCadastroTelefone);
  Application.CreateForm(TfrmCadastroEndereco, frmCadastroEndereco);
  Application.Run;
end.
