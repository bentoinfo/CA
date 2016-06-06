object DM: TDM
  OldCreateOrder = False
  Height = 405
  Width = 623
  object dsRelAbastecimento: TDataSource
    DataSet = cdsRelAbastecimento
    Left = 391
    Top = 39
  end
  object cdsRelAbastecimento: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspRelAbastecimento'
    Left = 287
    Top = 39
  end
  object dspRelAbastecimento: TDataSetProvider
    DataSet = qryRelAbastecimento
    Left = 167
    Top = 39
  end
  object qryRelAbastecimento: TSQLQuery
    Params = <>
    SQL.Strings = (
      'SELECT '
      '  ab.`DATA_ABASTECIMENTO` as Data,'
      '  tq.`DESCRICAO` as Tanque,'
      '  bo.`DESCRICAO` as Bomba,'
      '  SUM(ab.`TOTAL_ABASTECIDO`) as Total'
      'FROM'
      '  abastecimento_detalhe ab'
      '  join bomba bo on ab.`ID_BOMBA` = bo.`ID`'
      '  join tanque tq on bo.`ID_TANQUE` = tq.ID '
      ' GROUP BY'
      '  ab.`DATA_ABASTECIMENTO`,'
      '  tq.`DESCRICAO`,'
      '  bo.`DESCRICAO` '
      ' ORDER BY'
      '  ab.`DATA_ABASTECIMENTO`')
    Left = 55
    Top = 39
  end
end
