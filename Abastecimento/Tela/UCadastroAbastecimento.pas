unit UCadastroAbastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaCadastro, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  Biblioteca,
  AbastecimentoCabecalhoVO,
  AbastecimentoDetalheVO,
  AbastecimentoCabecalhoController,
  AbastecimentoDetalheController,
  BombaVO, BombaController, Data.DB, Datasnap.DBClient, Vcl.DBCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.FMTBcd, Data.SqlExpr,
  ConexaoBD, Datasnap.Provider;

type
  TFCadastroAbastecimento = class(TFTelaCadastro)
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    edtID: TEdit;
    edtValorLitro: TEdit;
    edtQuantidadeAbastecida: TEdit;
    edtTotalAbastecido: TEdit;
    edtIdBomba: TEdit;
    lbl6: TLabel;
    edtImpostoTaxa: TEdit;
    edtImpostoValor: TEdit;
    lbl1: TLabel;
    lbl7: TLabel;
    dtpDataCadastro: TDateTimePicker;
    dtpHoraCadastro: TDateTimePicker;
    cbxBomba: TDBLookupComboBox;
    qryBomba: TSQLQuery;
    dspBomba: TDataSetProvider;
    cdsBomba: TClientDataSet;
    dsBomba: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure cbxBombaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtQuantidadeAbastecidaExit(Sender: TObject);
  private
    procedure PopularComboboxBomba;
    procedure CalcularAbastecimento;
  public
    function DoEditar: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FCadastroAbastecimento: TFCadastroAbastecimento;

implementation

{$R *.dfm}

procedure TFCadastroAbastecimento.CalcularAbastecimento;
var
  lValorLitro,
  lQuantidade,
  lTotal: Extended;

  lTaxaImposto,
  lValorImposto: Extended;
begin
  lValorLitro := StrToFloatDef(edtValorLitro.Text,0);
  lQuantidade := StrToFloatDef(edtQuantidadeAbastecida.Text,0);

  lTotal := lValorLitro * lQuantidade;

  lTaxaImposto  := StrToFloatDef(edtImpostoTaxa.Text,0) / 100;
  lValorImposto := lTotal * lTaxaImposto;

  edtTotalAbastecido.Text := FloatToStrF(lTotal,ffNumber,6,2);
  edtImpostoValor.Text    := FloatToStrF(lValorImposto,ffNumber,6,2);
end;

procedure TFCadastroAbastecimento.cbxBombaClick(Sender: TObject);
begin
  edtIdBomba.Text     := cbxBomba.KeyValue;
  edtValorLitro.Text  := FloatToStrF(cdsBomba.FieldByName('PRECO_VENDA_LITRO').AsExtended,ffNumber,6,2);
  edtImpostoTaxa.Text := FloatToStrF(cdsBomba.FieldByName('TAXA_IMPOSTO').AsExtended,ffNumber,6,2);

  edtQuantidadeAbastecida.SetFocus;
end;

function TFCadastroAbastecimento.DoEditar: Boolean;
begin
  inherited;

  ObjetoVO    := ObjetoController.VO<TAbastecimentoDetalheVO>(ID);
  ObjetoOldVO := ObjetoController.VO<TAbastecimentoDetalheVO>(ID);

  Result := Assigned(ObjetoVO);

  if Result then
  begin
    edtID.Text                   := IntToStr(TAbastecimentoDetalheVO(ObjetoVO).ID);
    edtIdBomba.Text              := IntToStr(TAbastecimentoDetalheVO(ObjetoVO).IdBomba);
    edtValorLitro.Text           := FloatToStr(TAbastecimentoDetalheVO(ObjetoVO).ValorLitro);
    edtQuantidadeAbastecida.Text := FloatToStr(TAbastecimentoDetalheVO(ObjetoVO).QuantidadeAbastecida);
    edtTotalAbastecido.Text      := FloatToStr(TAbastecimentoDetalheVO(ObjetoVO).TotalAbastecido);
    edtImpostoTaxa.Text          := FloatToStr(TAbastecimentoDetalheVO(ObjetoVO).ImpostoTaxa);
    edtImpostoValor.Text         := FloatToStr(TAbastecimentoDetalheVO(ObjetoVO).ImpostoValor);
    dtpDataCadastro.Date         := TAbastecimentoDetalheVO(ObjetoVO).DataAbastecimento;
    {TODO: Pedro - Alterar VO para String}
//    dtpHoraCadastro.Time         := StrToTimeDef(TAbastecimentoDetalheVO(ObjetoVO).HoraAbastecimento,0);
  end;
end;

function TFCadastroAbastecimento.DoSalvar: Boolean;
var
  AbastecimentoDetalhe: TAbastecimentoDetalheController;
begin
  TAbastecimentoDetalheVO(ObjetoVO).IdBomba              := StrToInt(edtIdBomba.Text);
  TAbastecimentoDetalheVO(ObjetoVO).ValorLitro           := StrToFloatDef(edtValorLitro.Text,0);
  TAbastecimentoDetalheVO(ObjetoVO).QuantidadeAbastecida := StrToFloatDef(edtQuantidadeAbastecida.Text,0);
  TAbastecimentoDetalheVO(ObjetoVO).TotalAbastecido      := StrToFloatDef(edtTotalAbastecido.Text,0);
  TAbastecimentoDetalheVO(ObjetoVO).ImpostoTaxa          := StrToFloatDef(edtImpostoTaxa.Text,0);
  TAbastecimentoDetalheVO(ObjetoVO).ImpostoValor         := StrToFloatDef(edtImpostoValor.Text,0);
  TAbastecimentoDetalheVO(ObjetoVO).DataAbastecimento    := dtpDataCadastro.Date;
  {TODO: Pedro - Alterar VO para String}
//  TAbastecimentoDetalheVO(ObjetoVO).HoraAbastecimento    := TimeToStr(dtpHoraCadastro.Time);

  if FInsercao then
    Result := TAbastecimentoDetalheController(ObjetoController).Insere(TAbastecimentoDetalheVO(ObjetoVO))
  else
    Result := TAbastecimentoDetalheController(ObjetoController).Altera(TAbastecimentoDetalheVO(ObjetoVO),TAbastecimentoDetalheVO(ObjetoOldVO));

  inherited;

end;

procedure TFCadastroAbastecimento.edtQuantidadeAbastecidaExit(Sender: TObject);
begin
  CalcularAbastecimento;
end;

procedure TFCadastroAbastecimento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cdsBomba.Close;

  inherited;
end;

procedure TFCadastroAbastecimento.FormShow(Sender: TObject);
begin
  inherited;

  if Assigned(ObjetoVO) then
    FreeAndNil(ObjetoVO);

  ObjetoVO := TAbastecimentoDetalheVO.Create;

  if Assigned(ObjetoController) then
    FreeAndNil(ObjetoController);

  ObjetoController := TAbastecimentoDetalheController.Create;

  PopularComboboxBomba;

  if not FInsercao then
    DoEditar
  else
  begin
    dtpDataCadastro.Date := Now;
    dtpHoraCadastro.Time := Now;
  end;
end;

procedure TFCadastroAbastecimento.PopularComboboxBomba;
begin
  qryBomba.SQLConnection := TDBExpress.getConexao;

  cdsBomba.Close;
  cdsBomba.Open;
end;

end.
