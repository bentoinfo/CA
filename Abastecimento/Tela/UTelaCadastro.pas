unit UTelaCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, StrUtils,
  JSonVO, Controller;

type
  TFTelaCadastro = class(TForm)
    Panel1: TPanel;
    btnGravar: TBitBtn;
    btnCancelar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FID: Integer;
  public
    FInsercao: Boolean;
    ObjetoVO: TJSonVO;
    ObjetoOldVO: TJSonVO;
    ObjetoController: TController;

    procedure LimparCampos;

    // Controles CRUD
    function DoInserir: Boolean; virtual;
    function DoEditar: Boolean; virtual;
    function DoCancelar: Boolean; virtual;
    function DoSalvar: Boolean; virtual;

    property ID: Integer read FID write FID;
  end;

var
  FTelaCadastro: TFTelaCadastro;

implementation

{$R *.dfm}

{ TFTelaCadastro }

procedure TFTelaCadastro.btnCancelarClick(Sender: TObject);
begin
  DoCancelar;
end;

procedure TFTelaCadastro.btnGravarClick(Sender: TObject);
begin
  DoSalvar;

  Close;
end;

function TFTelaCadastro.DoCancelar: Boolean;
begin
  Close;
end;

function TFTelaCadastro.DoEditar: Boolean;
begin
  LimparCampos;
end;

function TFTelaCadastro.DoInserir: Boolean;
begin
  LimparCampos;
end;

function TFTelaCadastro.DoSalvar: Boolean;
begin
  Close;
end;

procedure TFTelaCadastro.FormDestroy(Sender: TObject);
begin
  if Assigned(ObjetoController) then
    ObjetoController.Free;

  if Assigned(ObjetoVO) then
    FreeAndNil(ObjetoVO);

  if Assigned(ObjetoOldVO) then
    FreeAndNil(ObjetoOldVO);
end;

procedure TFTelaCadastro.FormShow(Sender: TObject);
begin
  FInsercao := ID = 0;

  Caption := 'Alterar';
  if FInsercao then
    Caption := 'Incluir';
end;

procedure TFTelaCadastro.LimparCampos;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if (Components[I] is TEdit) and ((Components[I] as TEdit).tag = 0) then
      (Components[I] as TEdit).Text := '';

    if (Components[I] is TMemo) and ((Components[I] as TMemo).tag = 0) then
      (Components[I] as TMemo).Lines.Clear;
  end;
end;

end.
