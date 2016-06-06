inherited FCadastroAbastecimento: TFCadastroAbastecimento
  Caption = 'Cadastro Abastecimento'
  ClientWidth = 713
  Font.Height = -15
  OnClose = FormClose
  ExplicitWidth = 719
  PixelsPerInch = 96
  TextHeight = 18
  object lbl2: TLabel [0]
    Left = 152
    Top = 134
    Width = 107
    Height = 18
    Caption = 'Quantidade/Litro'
  end
  object lbl3: TLabel [1]
    Left = 279
    Top = 134
    Width = 108
    Height = 18
    Caption = 'Total Abastecido'
  end
  object lbl4: TLabel [2]
    Left = 25
    Top = 134
    Width = 85
    Height = 18
    Caption = 'Valor do Litro'
  end
  object lbl5: TLabel [3]
    Left = 24
    Top = 5
    Width = 16
    Height = 18
    Caption = 'ID'
  end
  object lbl6: TLabel [4]
    Left = 24
    Top = 67
    Width = 122
    Height = 18
    Caption = 'Selecione a bomba'
  end
  object lbl1: TLabel [5]
    Left = 25
    Top = 190
    Width = 75
    Height = 18
    Caption = 'Imposto %'
  end
  object lbl7: TLabel [6]
    Left = 152
    Top = 190
    Width = 77
    Height = 18
    Caption = 'Imposto R$'
  end
  inherited Panel1: TPanel
    Width = 713
    TabOrder = 9
    inherited btnGravar: TBitBtn
      Left = 382
      ExplicitLeft = 382
    end
    inherited btnCancelar: TBitBtn
      Left = 535
      ExplicitLeft = 535
    end
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
  object edtValorLitro: TEdit
    Left = 25
    Top = 152
    Width = 121
    Height = 26
    TabOrder = 5
  end
  object edtQuantidadeAbastecida: TEdit
    Left = 152
    Top = 152
    Width = 121
    Height = 26
    TabOrder = 6
    OnExit = edtQuantidadeAbastecidaExit
  end
  object edtTotalAbastecido: TEdit
    Left = 279
    Top = 152
    Width = 121
    Height = 26
    TabOrder = 7
  end
  object edtIdBomba: TEdit
    Left = 24
    Top = 88
    Width = 65
    Height = 26
    TabStop = False
    Enabled = False
    TabOrder = 3
  end
  object edtImpostoTaxa: TEdit
    Left = 25
    Top = 208
    Width = 121
    Height = 26
    TabOrder = 8
  end
  object edtImpostoValor: TEdit
    Left = 152
    Top = 208
    Width = 121
    Height = 26
    TabOrder = 10
  end
  object dtpDataCadastro: TDateTimePicker
    Left = 448
    Top = 24
    Width = 121
    Height = 26
    Date = 42527.624960462960000000
    Time = 42527.624960462960000000
    Enabled = False
    TabOrder = 1
    TabStop = False
  end
  object dtpHoraCadastro: TDateTimePicker
    Left = 575
    Top = 24
    Width = 121
    Height = 26
    Date = 42527.624960462960000000
    Time = 42527.624960462960000000
    Enabled = False
    Kind = dtkTime
    TabOrder = 2
    TabStop = False
  end
  object cbxBomba: TDBLookupComboBox
    Left = 91
    Top = 88
    Width = 393
    Height = 26
    KeyField = 'ID'
    ListField = 'DESCRICAO'
    ListSource = dsBomba
    TabOrder = 4
    OnClick = cbxBombaClick
  end
  object qryBomba: TSQLQuery
    Params = <>
    SQL.Strings = (
      'SELECT '
      '  BO.ID,'
      '  BO.DESCRICAO,'
      '  TQ.ID_COMBUSTIVEL,'
      '  CO.TIPO_COMBUSTIVEL,'
      '  CO.PRECO_VENDA_LITRO,'
      '  CO.TAXA_IMPOSTO '
      'FROM '
      '  bomba BO'
      '  JOIN tanque      TQ ON BO.ID = TQ.ID = BO.ID_TANQUE'
      '  JOIN combustivel CO ON TQ.ID_COMBUSTIVEL = CO.`ID`'
      'ORDER BY'
      '  BO.DESCRICAO')
    Left = 672
    Top = 296
  end
  object dspBomba: TDataSetProvider
    DataSet = qryBomba
    Left = 616
    Top = 296
  end
  object cdsBomba: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspBomba'
    Left = 560
    Top = 296
  end
  object dsBomba: TDataSource
    DataSet = cdsBomba
    Left = 512
    Top = 296
  end
end
