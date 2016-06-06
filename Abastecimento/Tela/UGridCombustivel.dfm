inherited FGridCombustivel: TFGridCombustivel
  Caption = 'Cadastro de Combust'#237'vel'
  ClientHeight = 503
  ClientWidth = 1018
  ExplicitWidth = 1024
  ExplicitHeight = 531
  PixelsPerInch = 96
  TextHeight = 13
  inherited Grid: TDBGrid
    Width = 1018
    Height = 435
  end
  inherited Panel1: TPanel
    Width = 1018
    ExplicitWidth = 1018
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
