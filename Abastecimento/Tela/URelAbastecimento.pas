unit URelAbastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport;

type
  TFRelAbastecimento = class(TForm)
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    RLLabel1: TRLLabel;
    RLBand2: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLBand3: TRLBand;
    RLLabel2: TRLLabel;
    RLDBResult1: TRLDBResult;
    Data: TRLLabel;
    Tanque: TRLLabel;
    Bomba: TRLLabel;
    Total: TRLLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRelAbastecimento: TFRelAbastecimento;

implementation

{$R *.dfm}

uses UDM;

end.
