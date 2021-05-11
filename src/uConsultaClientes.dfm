object frmConsultaClientes: TfrmConsultaClientes
  Left = 0
  Top = 0
  Caption = 'Lista Clientes'
  ClientHeight = 350
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 519
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 670
    object Label1: TLabel
      Left = 6
      Top = 3
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object Label2: TLabel
      Left = 231
      Top = 3
      Width = 25
      Height = 13
      Caption = 'Ativo'
    end
    object edtNome: TEdit
      Left = 6
      Top = 22
      Width = 219
      Height = 21
      TabOrder = 0
    end
    object Button4: TButton
      Left = 335
      Top = 20
      Width = 82
      Height = 25
      Caption = 'Pesquisar'
      TabOrder = 1
      OnClick = Button4Click
    end
    object cbAtivo: TComboBox
      Left = 231
      Top = 22
      Width = 98
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = 'Todos'
      Items.Strings = (
        'Todos'
        'Sim'
        'N'#227'o')
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 55
    Width = 516
    Height = 256
    Align = alCustom
    ColCount = 7
    FixedCols = 0
    RowCount = 2
    TabOrder = 1
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      64
      64
      64
      64
      64
      64
      64)
    RowHeights = (
      24
      24)
  end
  object Button2: TButton
    Left = 441
    Top = 317
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 360
    Top = 317
    Width = 75
    Height = 25
    Caption = 'Alterar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 279
    Top = 317
    Width = 75
    Height = 25
    Caption = 'Incluir'
    TabOrder = 4
    OnClick = Button3Click
  end
end
