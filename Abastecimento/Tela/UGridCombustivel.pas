unit UGridCombustivel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaGrid, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  DBXCommon, codeORM, Biblioteca, CombustivelVO;

type
  TFGridCombustivel = class(TFTelaGrid)
    procedure btnLocalizarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure DoInserir;
    procedure DoEditar;
    procedure GridLocalizar;
  public
    { Public declarations }
  end;

var
  FGridCombustivel: TFGridCombustivel;

implementation

{$R *.dfm}

uses UDM, UCadastroCombustivel;

{ TFGridCombustivel }

procedure TFGridCombustivel.btnAlterarClick(Sender: TObject);
begin
  inherited;

  DoEditar;
end;

procedure TFGridCombustivel.btnIncluirClick(Sender: TObject);
begin
  inherited;

  DoInserir;
end;

procedure TFGridCombustivel.btnLocalizarClick(Sender: TObject);
begin
  inherited;

  GridLocalizar;
end;

procedure TFGridCombustivel.DoEditar;
begin
  FCadastroCombustivel := TFCadastroCombustivel.Create(nil);
  try
    FCadastroCombustivel.ID := FcdsGrid.FieldByName('ID').AsInteger;
    FCadastroCombustivel.ShowModal;
  finally
    FreeAndNil(FCadastroCombustivel);
  end;
end;

procedure TFGridCombustivel.DoInserir;
begin
  FCadastroCombustivel := TFCadastroCombustivel.Create(nil);
  try
    FCadastroCombustivel.ID := 0;
    FCadastroCombustivel.ShowModal;
  finally
    FreeAndNil(FCadastroCombustivel);
  end;
end;

procedure TFGridCombustivel.FormCreate(Sender: TObject);
begin
  inherited;

  ConfiguraCDSFromVO(FcdsGrid, TCombustivelVO);
end;

procedure TFGridCombustivel.GridLocalizar;
var
  DBXReader : TDBXReader;
  vSql      : string;
begin
  vSql := 'SELECT * FROM combustivel';

  DBXReader := TcodeORM.Consultar(vSql, '', -1);

  try
    FcdsGrid.EmptyDataSet;

    while DBXReader.Next do
    begin
      FcdsGrid.Append;

      FcdsGrid.FieldByName('ID').AsInteger                 := DBXReader.Value['ID'].AsInt32;
      FcdsGrid.FieldByName('DESCRICAO').AsString           := DBXReader.Value['DESCRICAO'].AsString;
      FcdsGrid.FieldByName('TIPO_COMBUSTIVEL').AsString    := DBXReader.Value['TIPO_COMBUSTIVEL'].AsString;
      FcdsGrid.FieldByName('PRECO_CUSTO_LITRO').AsExtended := DBXReader.Value['PRECO_CUSTO_LITRO'].AsDouble;
      FcdsGrid.FieldByName('PRECO_VENDA_LITRO').AsExtended := DBXReader.Value['PRECO_VENDA_LITRO'].AsDouble;
      FcdsGrid.FieldByName('TAXA_IMPOSTO').AsExtended      := DBXReader.Value['TAXA_IMPOSTO'].AsDouble;

      FcdsGrid.Post;
    end;

  finally
    DBXReader.Free;
  end;
end;

end.
