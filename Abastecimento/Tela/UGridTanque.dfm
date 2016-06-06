inherited FGridTanque: TFGridTanque
  Caption = 'Cadastro de Tanque'
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
