unit UGridAbastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaGrid, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  DBXCommon, codeORM, Biblioteca,
  AbastecimentoCabecalhoVO,
  AbastecimentoDetalheVO,
  AbastecimentoCabecalhoController,
  AbastecimentoDetalheController;

type
  TFGridAbastecimento = class(TFTelaGrid)
    procedure FormCreate(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
  private
    procedure DoInserir;
    procedure DoEditar;
    procedure GridLocalizar;
  public
    { Public declarations }
  end;

var
  FGridAbastecimento: TFGridAbastecimento;

implementation

{$R *.dfm}

uses UCadastroAbastecimento;

procedure TFGridAbastecimento.btnAlterarClick(Sender: TObject);
begin
  inherited;

  DoEditar;
end;

procedure TFGridAbastecimento.btnIncluirClick(Sender: TObject);
begin
  inherited;

  DoInserir;
end;

procedure TFGridAbastecimento.btnLocalizarClick(Sender: TObject);
begin
  inherited;

  GridLocalizar;
end;

procedure TFGridAbastecimento.DoEditar;
begin
  FCadastroAbastecimento := TFCadastroAbastecimento.Create(nil);
  try
    FCadastroAbastecimento.ID := FcdsGrid.FieldByName('ID').AsInteger;
    FCadastroAbastecimento.ShowModal;
  finally
    FreeAndNil(FCadastroAbastecimento);
  end;
end;

procedure TFGridAbastecimento.DoInserir;
begin
  FCadastroAbastecimento := TFCadastroAbastecimento.Create(nil);
  try
    FCadastroAbastecimento.ID := 0;
    FCadastroAbastecimento.ShowModal;
  finally
    FreeAndNil(FCadastroAbastecimento);
  end;
end;

procedure TFGridAbastecimento.FormCreate(Sender: TObject);
begin
  inherited;

  ConfiguraCDSFromVO(FcdsGrid, TAbastecimentoDetalheVO);
end;

procedure TFGridAbastecimento.GridLocalizar;
var
  DBXReader : TDBXReader;
  vSql      : string;
begin
  vSql := 'SELECT * FROM abastecimento_detalhe';

  DBXReader := TcodeORM.Consultar(vSql, '', -1);

  try
    FcdsGrid.EmptyDataSet;

    while DBXReader.Next do
    begin
      FcdsGrid.Append;

      FcdsGrid.FieldByName('ID').AsInteger                         := DBXReader.Value['ID'].AsInt32;
      FcdsGrid.FieldByName('ID_BOMBA').AsInteger                   := DBXReader.Value['ID_BOMBA'].AsInt32;
      FcdsGrid.FieldByName('VALOR_LITRO').AsExtended               := StrToFloatDef(DBXReader.Value['VALOR_LITRO'].AsString,0);
      FcdsGrid.FieldByName('QUANTIDADE_ABASTECIDA').AsExtended     := StrToFloatDef(DBXReader.Value['QUANTIDADE_ABASTECIDA'].AsString,0);
      FcdsGrid.FieldByName('TOTAL_ABASTECIDO').AsExtended          := StrToFloatDef(DBXReader.Value['TOTAL_ABASTECIDO'].AsString,0);
      FcdsGrid.FieldByName('IMPOSTO_TAXA').AsExtended              := StrToFloatDef(DBXReader.Value['IMPOSTO_TAXA'].AsString,0);
      FcdsGrid.FieldByName('IMPOSTO_VALOR').AsExtended             := StrToFloatDef(DBXReader.Value['IMPOSTO_VALOR'].AsString,0);

      FcdsGrid.Post;
    end;

  finally
    DBXReader.Free;
  end;
end;

end.
