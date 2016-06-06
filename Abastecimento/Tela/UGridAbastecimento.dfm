inherited FGridAbastecimento: TFGridAbastecimento
  Caption = 'Abastecimento'
  ClientHeight = 499
  ClientWidth = 1053
  ExplicitWidth = 1059
  ExplicitHeight = 527
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TDBGrid
    Width = 1053
    Height = 431
  end
  inherited Panel1: TPanel
    Width = 1053
    inherited btnIncluir: TBitBtn
      OnClick = btnIncluirClick
    end
    inherited btnAlterar: TBitBtn
      OnClick = btnAlterarClick
    end
    inherited btnLocalizar: TBitBtn
      OnClick = btnLocalizarClick
    end
  end
end
