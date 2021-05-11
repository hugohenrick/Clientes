object FrmCadastroTelefone: TFrmCadastroTelefone
  Left = 0
  Top = 0
  Caption = 'Telefone'
  ClientHeight = 81
  ClientWidth = 344
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
  object Label2: TLabel
    Left = 81
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Telefone'
  end
  object Label3: TLabel
    Left = 192
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Contato'
  end
  object Label1: TLabel
    Left = 5
    Top = 8
    Width = 33
    Height = 13
    Caption = 'Codigo'
  end
  object edtTelefone: TEdit
    Left = 81
    Top = 24
    Width = 105
    Height = 21
    TabOrder = 0
  end
  object edtContato: TEdit
    Left = 192
    Top = 24
    Width = 145
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 267
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 186
    Top = 51
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = Button2Click
  end
  object edtCodigo: TEdit
    Left = 5
    Top = 24
    Width = 70
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
end
