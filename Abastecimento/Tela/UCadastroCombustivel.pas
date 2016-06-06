unit UCadastroCombustivel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaCadastro, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Data.DB, Vcl.Mask, Vcl.DBCtrls, StrUtils,
  CombustivelVO, CombustivelController;

type
  TFCadastroCombustivel = class(TFTelaCadastro)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    cbTipoCombustivel: TComboBox;
    edtID: TEdit;
    edtDescricao: TEdit;
    edtImposto: TEdit;
    edtPrecoCusto: TEdit;
    edtPrecoVenda: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    function DoEditar: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FCadastroCombustivel: TFCadastroCombustivel;

implementation

{$R *.dfm}

{ TFCadastroCombustivel }

function TFCadastroCombustivel.DoEditar: Boolean;
begin
  inherited;

  ObjetoVO    := ObjetoController.VO<TCombustivelVO>(ID);
  ObjetoOldVO := ObjetoController.VO<TCombustivelVO>(ID);

  Result := Assigned(ObjetoVO);

  if Result then
  begin
    edtID.Text                  := IntToStr(TCombustivelVO(ObjetoVO).ID);
    edtDescricao.Text           := TCombustivelVO(ObjetoVO).Descricao;
    cbTipoCombustivel.ItemIndex := StrToInt(IfThen(TCombustivelVO(ObjetoVO).TipoCombustivel = 'G','0','1'));
    edtPrecoCusto.Text          := FloatToStr(TCombustivelVO(ObjetoVO).PrecoCustoLitro);
    edtPrecoVenda.Text          := FloatToStr(TCombustivelVO(ObjetoVO).PrecoVendaLitro);
    edtImposto.Text             := FloatToStr(TCombustivelVO(ObjetoVO).TaxaImposto);
  end;
end;

function TFCadastroCombustivel.DoSalvar: Boolean;
var
  CombustivelController: TCombustivelController;
begin
  TCombustivelVO(ObjetoVO).Descricao       := edtDescricao.Text;
  TCombustivelVO(ObjetoVO).TipoCombustivel := IfThen(cbTipoCombustivel.ItemIndex = 0,'G','D');
  TCombustivelVO(ObjetoVO).PrecoCustoLitro := StrToFloatDef(edtPrecoCusto.Text,0);
  TCombustivelVO(ObjetoVO).PrecoVendaLitro := StrToFloatDef(edtPrecoVenda.Text,0);
  TCombustivelVO(ObjetoVO).TaxaImposto     := StrToFloatDef(edtImposto.Text,0);

  if FInsercao then
    Result := TCombustivelController(ObjetoController).Insere(TCombustivelVO(ObjetoVO))
  else
    Result := TCombustivelController(ObjetoController).Altera(TCombustivelVO(ObjetoVO),TCombustivelVO(ObjetoOldVO));

  inherited;
end;

procedure TFCadastroCombustivel.FormShow(Sender: TObject);
begin
  inherited;

  if Assigned(ObjetoVO) then
    FreeAndNil(ObjetoVO);

  ObjetoVO := TCombustivelVO.Create;

  if Assigned(ObjetoController) then
    FreeAndNil(ObjetoController);

  ObjetoController := TCombustivelController.Create;

  if not FInsercao then
    DoEditar;
end;

end.
