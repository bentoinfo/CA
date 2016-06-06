unit UTelaGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Datasnap.DBClient;

type
  TFTelaGrid = class(TForm)
    Grid: TDBGrid;
    Panel1: TPanel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnLocalizar: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  published
    FcdsGrid: TClientDataSet;
    FdsGrid: TDataSource;
  end;

var
  FTelaGrid: TFTelaGrid;

implementation

{$R *.dfm}

{ TFTelaGrid }

procedure TFTelaGrid.FormCreate(Sender: TObject);
begin
  FcdsGrid         := TClientDataSet.Create(Self);
  FdsGrid          := TDataSource.Create(Self);

  FdsGrid.DataSet := FcdsGrid;
  Grid.DataSource := FdsGrid;
end;

procedure TFTelaGrid.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FcdsGrid);
  FreeAndNil(FdsGrid);
end;

end.
