inherited FGridBomba: TFGridBomba
  Caption = 'Cadastro de Bomba'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
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
