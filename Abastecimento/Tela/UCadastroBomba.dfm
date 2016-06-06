inherited FCadastroBomba: TFCadastroBomba
  Caption = 'Bomba'
  Font.Height = -15
  PixelsPerInch = 96
  TextHeight = 18
  object lbl1: TLabel [0]
    Left = 24
    Top = 17
    Width = 16
    Height = 18
    Caption = 'ID'
  end
  object lbl2: TLabel [1]
    Left = 24
    Top = 73
    Width = 62
    Height = 18
    Caption = 'Descri'#231#227'o'
  end
  object lbl3: TLabel [2]
    Left = 24
    Top = 137
    Width = 71
    Height = 18
    Caption = 'ID Tanque'
  end
  inherited Panel1: TPanel
    TabOrder = 3
  end
  object edtID: TEdit
    Left = 24
    Top = 41
    Width = 121
    Height = 26
    Enabled = False
    TabOrder = 0
  end
  object edtDescricao: TEdit
    Left = 24
    Top = 97
    Width = 416
    Height = 26
    TabOrder = 1
  end
  object edtIdTanque: TEdit
    Left = 24
    Top = 160
    Width = 121
    Height = 26
    TabOrder = 2
  end
end
