unit UGridBomba;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaGrid, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  DBXCommon, codeORM, Biblioteca, BombaVO;

type
  TFGridBomba = class(TFTelaGrid)
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DoInserir;
    procedure DoEditar;
    procedure GridLocalizar;
  public
    { Public declarations }
  end;

var
  FGridBomba: TFGridBomba;

implementation

{$R *.dfm}

uses UCadastroBomba;

{ TFGridBomba }

procedure TFGridBomba.btnAlterarClick(Sender: TObject);
begin
  inherited;

  DoEditar;
end;

procedure TFGridBomba.btnIncluirClick(Sender: TObject);
begin
  inherited;

  DoInserir;
end;

procedure TFGridBomba.btnLocalizarClick(Sender: TObject);
begin
  inherited;

  GridLocalizar;
end;

procedure TFGridBomba.DoEditar;
begin
  FCadastroBomba := TFCadastroBomba.Create(nil);
  try
    FCadastroBomba.ID := FcdsGrid.FieldByName('ID').AsInteger;
    FCadastroBomba.ShowModal;
  finally
    FreeAndNil(FCadastroBomba);
  end;
end;

procedure TFGridBomba.DoInserir;
begin
  FCadastroBomba := TFCadastroBomba.Create(nil);
  try
    FCadastroBomba.ID := 0;
    FCadastroBomba.ShowModal;
  finally
    FreeAndNil(FCadastroBomba);
  end;
end;

procedure TFGridBomba.FormCreate(Sender: TObject);
begin
  inherited;

  ConfiguraCDSFromVO(FcdsGrid, TBombaVO);
end;

procedure TFGridBomba.GridLocalizar;
var
  DBXReader : TDBXReader;
  vSql      : string;
begin
  vSql := 'SELECT * FROM bomba';

  DBXReader := TcodeORM.Consultar(vSql, '', -1);

  try
    FcdsGrid.EmptyDataSet;

    while DBXReader.Next do
    begin
      FcdsGrid.Append;

      FcdsGrid.FieldByName('ID').AsInteger       := DBXReader.Value['ID'].AsInt32;
      FcdsGrid.FieldByName('DESCRICAO').AsString := DBXReader.Value['DESCRICAO'].AsString;
      FcdsGrid.FieldByName('ID_TANQUE').AsString := DBXReader.Value['ID_TANQUE'].AsString;

      FcdsGrid.Post;
    end;

  finally
    DBXReader.Free;
  end;
end;

end.
