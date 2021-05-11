object dmConn: TdmConn
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 270
  Width = 357
  object FDConn: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 64
    Top = 80
  end
end
