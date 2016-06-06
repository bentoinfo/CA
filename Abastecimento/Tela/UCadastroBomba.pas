unit UCadastroBomba;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UTelaCadastro, Vcl.StdCtrls, StrUtils,
  Vcl.Buttons, Vcl.ExtCtrls,
  BombaVO, BombaController;

type
  TFCadastroBomba = class(TFTelaCadastro)
    edtID: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edtDescricao: TEdit;
    edtIdTanque: TEdit;
    lbl3: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    function DoEditar: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FCadastroBomba: TFCadastroBomba;

implementation

{$R *.dfm}

function TFCadastroBomba.DoEditar: Boolean;
begin
  ObjetoVO    := ObjetoController.VO<TBombaVO>(ID);
  ObjetoOldVO := ObjetoController.VO<TBombaVO>(ID);

  Result := Assigned(ObjetoVO);

  if Result then
  begin
    edtID.Text        := IntToStr(TBombaVO(ObjetoVO).ID);
    edtDescricao.Text := TBombaVO(ObjetoVO).Descricao;
    edtIdTanque.Text  := IntToStr(TBombaVO(ObjetoVO).IdTanque);
  end;
end;

function TFCadastroBomba.DoSalvar: Boolean;
var
  BombaController: TBombaController;
begin
  TBombaVO(ObjetoVO).Descricao := edtDescricao.Text;
  try
    TBombaVO(ObjetoVO).IdTanque  := StrToInt(edtIdTanque.Text);
  except
    ShowMessage('Informe o ID do tanque.');
    edtIdTanque.SetFocus;
  end;

  if FInsercao then
    Result := TBombaController(ObjetoController).Insere(TBombaVO(ObjetoVO))
  else
    Result := TBombaController(ObjetoController).Altera(TBombaVO(ObjetoVO),TBombaVO(ObjetoOldVO));
end;

procedure TFCadastroBomba.FormShow(Sender: TObject);
begin
  inherited;

  if Assigned(ObjetoVO) then
    FreeAndNil(ObjetoVO);

  ObjetoVO := TBombaVO.Create;

  if Assigned(ObjetoController) then
    FreeAndNil(ObjetoController);

  ObjetoController := TBombaController.Create;

  if not FInsercao then
    DoEditar;
end;

end.
