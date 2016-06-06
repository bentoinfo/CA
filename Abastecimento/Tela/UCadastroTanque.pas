unit UCadastroTanque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaCadastro, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, StrUtils,
  TanqueVO, TanqueController;

type
  TFCadastroTanque = class(TFTelaCadastro)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtID: TEdit;
    edtDescricao: TEdit;
    edtIdCombustivel: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    function DoEditar: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FCadastroTanque: TFCadastroTanque;

implementation

{$R *.dfm}

function TFCadastroTanque.DoEditar: Boolean;
begin
 inherited;

  ObjetoVO    := ObjetoController.VO<TTanqueVO>(ID);
  ObjetoOldVO := ObjetoController.VO<TTanqueVO>(ID);

  Result := Assigned(ObjetoVO);

  if Result then
  begin
    edtID.Text            := IntToStr(TTanqueVO(ObjetoVO).ID);
    edtDescricao.Text     := TTanqueVO(ObjetoVO).Descricao;
    edtIdCombustivel.Text := IntToStr(TTanqueVO(ObjetoVO).ID);
  end;
end;

function TFCadastroTanque.DoSalvar: Boolean;
var
  CombustivelController: TTanqueController;
begin
  TTanqueVO(ObjetoVO).Descricao     := edtDescricao.Text;
  TTanqueVO(ObjetoVO).IdCombustivel := StrToIntDef(edtIdCombustivel.Text,0);

  if FInsercao then
    Result := TTanqueController(ObjetoController).Insere(TTanqueVO(ObjetoVO))
  else
    Result := TTanqueController(ObjetoController).Altera(TTanqueVO(ObjetoVO),TTanqueVO(ObjetoOldVO));

  inherited;
end;

procedure TFCadastroTanque.FormShow(Sender: TObject);
begin
  inherited;

  if Assigned(ObjetoVO) then
    FreeAndNil(ObjetoVO);

  ObjetoVO := TTanqueVO.Create;

  if Assigned(ObjetoController) then
    FreeAndNil(ObjetoController);

  ObjetoController := TTanqueController.Create;

  if not FInsercao then
    DoEditar;
end;

end.
