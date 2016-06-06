unit UGridTanque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaGrid, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  DBXCommon, codeORM, Biblioteca, TanqueVO;

type
  TFGridTanque = class(TFTelaGrid)
    procedure FormCreate(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
  private
    procedure DoInserir;
    procedure DoEditar;
    procedure GridLocalizar;
  public
    { Public declarations }
  end;

var
  FGridTanque: TFGridTanque;

implementation

{$R *.dfm}

uses UCadastroTanque;

procedure TFGridTanque.btnAlterarClick(Sender: TObject);
begin
  inherited;

  DoEditar;
end;

procedure TFGridTanque.btnIncluirClick(Sender: TObject);
begin
  inherited;

  DoInserir;
end;

procedure TFGridTanque.btnLocalizarClick(Sender: TObject);
begin
  inherited;

  GridLocalizar;
end;

procedure TFGridTanque.DoEditar;
begin
  FCadastroTanque := TFCadastroTanque.Create(nil);
  try
    FCadastroTanque.ID := FcdsGrid.FieldByName('ID').AsInteger;
    FCadastroTanque.ShowModal;
  finally
    FreeAndNil(FCadastroTanque);
  end;
end;

procedure TFGridTanque.DoInserir;
begin
  FCadastroTanque := TFCadastroTanque.Create(nil);
  try
    FCadastroTanque.ID := 0;
    FCadastroTanque.ShowModal;
  finally
    FreeAndNil(FCadastroTanque);
  end;
end;

procedure TFGridTanque.FormCreate(Sender: TObject);
begin
  inherited;

  ConfiguraCDSFromVO(FcdsGrid, TTanqueVO);
end;

procedure TFGridTanque.GridLocalizar;
var
  DBXReader : TDBXReader;
  vSql      : string;
begin
  vSql := 'SELECT * FROM tanque';

  DBXReader := TcodeORM.Consultar(vSql, '', -1);

  try
    FcdsGrid.EmptyDataSet;

    while DBXReader.Next do
    begin
      FcdsGrid.Append;

      FcdsGrid.FieldByName('ID').AsInteger            := DBXReader.Value['ID'].AsInt32;
      FcdsGrid.FieldByName('DESCRICAO').AsString      := DBXReader.Value['DESCRICAO'].AsString;
      FcdsGrid.FieldByName('ID_COMBUSTIVEL').AsString := DBXReader.Value['ID_COMBUSTIVEL'].AsString;

      FcdsGrid.Post;
    end;

  finally
    DBXReader.Free;
  end;

end;

end.
