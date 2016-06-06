unit SessaoUsuario;

interface

uses Classes, DSHTTP, Forms, Windows, IniFiles, SysUtils,
  Generics.Collections, Datasnap.DSHTTPClient,
  IndyPeerImpl;

type
  TSessaoUsuario = class
  private
    FHttp: TDSHTTP;
    FUrl: String;
    FIdSessao: String;
    FIdEmpresa: Integer;
    FCamadas: Integer;
    FIntuitManager: Boolean;

    class var FInstance: TSessaoUsuario;
  public
    constructor Create;
    destructor Destroy; override;

    class function Instance: TSessaoUsuario;

    property HTTP: TDSHTTP read FHttp;
    property URL: String read FUrl;
    property IdSessao: String read FIdSessao;
    property IdEmpresa: Integer read FIdEmpresa write FIdEmpresa;
    property Camadas: Integer read FCamadas write FCamadas;
    property IntuitManager: Boolean read FIntuitManager write FIntuitManager;
  end;

implementation

{ TSessaoUsuario }

constructor TSessaoUsuario.Create;
var
  Ini: TIniFile;
  Servidor: String;
  Porta: Integer;
begin
  inherited Create;

  FHttp := TDSHTTP.Create;

  Servidor := 'localhost';
  Porta    := 8080;
  Camadas  := 2;
  FUrl     := 'http://'+Servidor+':'+IntToStr(Porta)+'/datasnap/restCODE/';
end;

destructor TSessaoUsuario.Destroy;
begin
  FHttp.Free;

  inherited;
end;

class function TSessaoUsuario.Instance: TSessaoUsuario;
begin
  if not Assigned(FInstance) then
    FInstance := TSessaoUsuario.Create;

  Result := FInstance;
end;

end.
