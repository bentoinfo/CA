inherited FCadastroTanque: TFCadastroTanque
  Caption = 'Tanque'
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel [0]
    Left = 24
    Top = 17
    Width = 11
    Height = 13
    Caption = 'ID'
  end
  object lbl2: TLabel [1]
    Left = 24
    Top = 73
    Width = 46
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object lbl3: TLabel [2]
    Left = 24
    Top = 137
    Width = 72
    Height = 13
    Caption = 'ID Combust'#237'vel'
  end
  inherited Panel1: TPanel
    TabOrder = 3
  end
  object edtID: TEdit
    Left = 24
    Top = 41
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    TabOrder = 0
  end
  object edtDescricao: TEdit
    Left = 24
    Top = 97
    Width = 416
    Height = 21
    TabOrder = 1
  end
  object edtIdCombustivel: TEdit
    Left = 24
    Top = 160
    Width = 121
    Height = 21
    TabOrder = 2
  end
end
