program CA;

uses
  Vcl.Forms,
  UMenu in 'Tela\UMenu.pas' {FMenu},
  UDM in 'UDM.pas' {DM: TDataModule},
  UTelaGrid in 'Tela\UTelaGrid.pas' {FTelaGrid},
  UTelaCadastro in 'Tela\UTelaCadastro.pas' {FTelaCadastro},
  UGridCombustivel in 'Tela\UGridCombustivel.pas' {FGridCombustivel},
  UCadastroCombustivel in 'Tela\UCadastroCombustivel.pas' {FCadastroCombustivel},
  Atributos in '..\Comum\Atributos.pas',
  CombustivelController in 'Controller\CombustivelController.pas',
  Controller in '..\Comum\Controller\Controller.pas',
  SessaoUsuario in '..\Comum\SessaoUsuario.pas',
  ConexaoBD in '..\Comum\ConexaoBD.pas',
  Biblioteca in '..\Comum\Biblioteca.pas',
  codeORM in '..\Comum\codeORM.pas',
  AbastecimentoCabecalhoController in 'Controller\AbastecimentoCabecalhoController.pas',
  AbastecimentoDetalheController in 'Controller\AbastecimentoDetalheController.pas',
  BombaController in 'Controller\BombaController.pas',
  TanqueController in 'Controller\TanqueController.pas',
  UGridBomba in 'Tela\UGridBomba.pas' {FGridBomba},
  UCadastroBomba in 'Tela\UCadastroBomba.pas' {FCadastroBomba},
  UCadastroTanque in 'Tela\UCadastroTanque.pas' {FCadastroTanque},
  UGridTanque in 'Tela\UGridTanque.pas' {FGridTanque},
  UGridAbastecimento in 'Tela\UGridAbastecimento.pas' {FGridAbastecimento},
  UCadastroAbastecimento in 'Tela\UCadastroAbastecimento.pas' {FCadastroAbastecimento},
  URelAbastecimento in 'Tela\URelAbastecimento.pas' {FRelAbastecimento},
  Constantes in '..\Comum\Constantes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMenu, FMenu);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFTelaGrid, FTelaGrid);
  Application.CreateForm(TFTelaCadastro, FTelaCadastro);
  Application.CreateForm(TFRelAbastecimento, FRelAbastecimento);
  Application.Run;
end.
