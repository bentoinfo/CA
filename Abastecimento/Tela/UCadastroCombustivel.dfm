inherited FCadastroCombustivel: TFCadastroCombustivel
  Caption = 'Combust'#237'vel'
  Font.Height = -15
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel [0]
    Left = 24
    Top = 57
    Width = 62
    Height = 18
    Caption = 'Descri'#231#227'o'
  end
  object Label2: TLabel [1]
    Left = 457
    Top = 57
    Width = 111
    Height = 18
    Caption = 'Tipo Combust'#237'vel'
  end
  object Label3: TLabel [2]
    Left = 186
    Top = 120
    Width = 78
    Height = 18
    Caption = 'Pre'#231'o Custo'
  end
  object Label4: TLabel [3]
    Left = 348
    Top = 120
    Width = 82
    Height = 18
    Caption = 'Pre'#231'o Venda'
  end
  object Label5: TLabel [4]
    Left = 24
    Top = 120
    Width = 75
    Height = 18
    Caption = 'Imposto %'
  end
  object Label6: TLabel [5]
    Left = 24
    Top = 1
    Width = 16
    Height = 18
    Caption = 'ID'
  end
  inherited Panel1: TPanel
    TabOrder = 6
    inherited btnGravar: TBitBtn
      Left = 433
      Anchors = [akTop, akRight]
      ExplicitLeft = 433
    end
    inherited btnCancelar: TBitBtn
      Left = 586
      Anchors = [akTop, akRight]
      ExplicitLeft = 586
    end
  end
  object cbTipoCombustivel: TComboBox
    Left = 457
    Top = 81
    Width = 121
    Height = 26
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      'Gasolina'
      'Diesel')
  end
  object edtID: TEdit
    Left = 24
    Top = 24
    Width = 121
    Height = 26
    TabStop = False
    Enabled = False
    TabOrder = 0
  end
  object edtDescricao: TEdit
    Left = 24
    Top = 81
    Width = 416
    Height = 26
    TabOrder = 1
  end
  object edtImposto: TEdit
    Left = 24
    Top = 144
    Width = 121
    Height = 26
    TabOrder = 3
  end
  object edtPrecoCusto: TEdit
    Left = 186
    Top = 144
    Width = 121
    Height = 26
    TabOrder = 4
  end
  object edtPrecoVenda: TEdit
    Left = 348
    Top = 144
    Width = 121
    Height = 26
    TabOrder = 5
  end
end
