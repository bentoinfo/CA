unit UMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.Ribbon, Vcl.PlatformDefaultStyleActnCtrls, System.Actions, Vcl.ActnList,
  Vcl.RibbonLunaStyleActnCtrls, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.RibbonSilverStyleActnCtrls, System.ImageList;

type
  TFMenu = class(TForm)
    rbnMenu: TRibbon;
    ActionManager: TActionManager;
    rbnAbastecimento: TRibbonPage;
    rgAbastecimento: TRibbonGroup;
    rbnCadastros: TRibbonPage;
    rgRelatorios: TRibbonGroup;
    rgCombustivel: TRibbonGroup;
    stbMenu: TStatusBar;
    actionCombustivel: TAction;
    actionBomba: TAction;
    actionTangue: TAction;
    actionEmpresa: TAction;
    actionAbastecer: TAction;
    actionRelAbastecimento: TAction;
    imagemRibbon: TImageList;
    procedure actionCombustivelExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actionBombaExecute(Sender: TObject);
    procedure actionTangueExecute(Sender: TObject);
    procedure actionAbastecerExecute(Sender: TObject);
    procedure actionRelAbastecimentoExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMenu: TFMenu;

implementation

{$R *.dfm}

uses UCadastroCombustivel, UGridCombustivel, ConexaoBD, UGridBomba, UGridTanque,
  UGridAbastecimento, URelAbastecimento, UDM;

procedure TFMenu.actionAbastecerExecute(Sender: TObject);
begin
  FGridAbastecimento := TFGridAbastecimento.Create(nil);
  try
    FGridAbastecimento.ShowModal;
  finally
    FreeAndNil(FGridAbastecimento);
  end;
end;

procedure TFMenu.actionBombaExecute(Sender: TObject);
begin
  FGridBomba := TFGridBomba.Create(nil);
  try
    FGridBomba.ShowModal;
  finally
    FreeAndNil(FGridBomba);
  end;
end;

procedure TFMenu.actionCombustivelExecute(Sender: TObject);
begin
  FGridCombustivel := TFGridCombustivel.Create(nil);
  try
    FGridCombustivel.ShowModal;
  finally
    FreeAndNil(FGridCombustivel);
  end;
end;

procedure TFMenu.actionRelAbastecimentoExecute(Sender: TObject);
begin
  Dm.qryRelAbastecimento.SQLConnection := TDBExpress.getConexao;

  Dm.cdsRelAbastecimento.Close;
  Dm.cdsRelAbastecimento.Open;

  FRelAbastecimento.RLReport1.Preview();
end;

procedure TFMenu.actionTangueExecute(Sender: TObject);
begin
   FGridTanque := TFGridTanque.Create(nil);
  try
    FGridTanque.ShowModal;
  finally
    FreeAndNil(FGridTanque);
  end;
end;

procedure TFMenu.FormCreate(Sender: TObject);
begin
  TDBExpress.Conectar('MySQL');
end;

procedure TFMenu.FormDestroy(Sender: TObject);
begin
   TDBExpress.Desconectar;
end;

end.
