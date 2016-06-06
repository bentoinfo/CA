object FRelAbastecimento: TFRelAbastecimento
  Left = 0
  Top = 0
  Caption = 'Relat'#243'rio Abastecimento'
  ClientHeight = 489
  ClientWidth = 809
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RLReport1: TRLReport
    Left = 0
    Top = 0
    Width = 794
    Height = 1123
    DataSource = DM.dsRelAbastecimento
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    object RLBand1: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 83
      BandType = btHeader
      object RLLabel1: TRLLabel
        Left = 216
        Top = 24
        Width = 259
        Height = 22
        Alignment = taCenter
        Caption = 'Relat'#243'rio de Abastecimento'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Data: TRLLabel
        Left = 7
        Top = 61
        Width = 33
        Height = 16
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Tanque: TRLLabel
        Left = 104
        Top = 61
        Width = 52
        Height = 16
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bomba: TRLLabel
        Left = 228
        Top = 61
        Width = 49
        Height = 16
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Total: TRLLabel
        Left = 367
        Top = 61
        Width = 36
        Height = 16
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object RLBand2: TRLBand
      Left = 38
      Top = 121
      Width = 718
      Height = 32
      object RLDBText1: TRLDBText
        Left = 9
        Top = 6
        Width = 31
        Height = 16
        DataField = 'Data'
        DataSource = DM.dsRelAbastecimento
        Text = ''
      end
      object RLDBText2: TRLDBText
        Left = 104
        Top = 8
        Width = 46
        Height = 16
        DataField = 'Tanque'
        DataSource = DM.dsRelAbastecimento
        Text = ''
      end
      object RLDBText3: TRLDBText
        Left = 228
        Top = 8
        Width = 45
        Height = 16
        DataField = 'Bomba'
        DataSource = DM.dsRelAbastecimento
        Text = ''
      end
      object RLDBText4: TRLDBText
        Left = 371
        Top = 10
        Width = 32
        Height = 16
        Alignment = taRightJustify
        DataField = 'Total'
        DataSource = DM.dsRelAbastecimento
        Text = ''
      end
    end
    object RLBand3: TRLBand
      Left = 38
      Top = 153
      Width = 718
      Height = 32
      BandType = btSummary
      object RLLabel2: TRLLabel
        Left = 290
        Top = 6
        Width = 36
        Height = 16
        Caption = 'Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLDBResult1: TRLDBResult
        Left = 332
        Top = 6
        Width = 71
        Height = 16
        Alignment = taRightJustify
        DataField = 'Total'
        DataSource = DM.dsRelAbastecimento
        Info = riSum
        Text = ''
      end
    end
  end
end
