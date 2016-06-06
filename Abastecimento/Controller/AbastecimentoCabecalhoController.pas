{*******************************************************************************
Title: Controle de Abastecimento                                                                 
Description: Controller relacionado à tabela [ABASTECIMENTO_CABECALHO] 
                                                                                                                             
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit AbastecimentoCabecalhoController;

interface

uses
  Classes, DBXJSON, DSHTTP, Dialogs, SysUtils, DBClient, DB, System.Generics.Collections,
  Windows, Forms, Controller, Rtti, Atributos, AbastecimentoCabecalhoVO, JSON;


type
  TAbastecimentoCabecalhoController = class(TController)
  private
    class var FDataSet: TClientDataSet;
  public
    class procedure Consulta(pFiltro: String; pPagina: Integer);
    class function Insere(pAbastecimentoCabecalho: TAbastecimentoCabecalhoVO): Boolean;
    class function Altera(pAbastecimentoCabecalho, pAbastecimentoCabecalhoOld: TAbastecimentoCabecalhoVO): Boolean;
    class function Exclui(pId: Integer): Boolean;
    //
    class function GetDataSet: TClientDataSet; override;
    class procedure SetDataSet(pDataSet: TClientDataSet); override;
    class function MethodCtx: String; override;

    class function AbastecimentoCabecalho(pFiltro: String; pPagina: Integer): TObjectList<TAbastecimentoCabecalhoVO>;
    class function AcceptAbastecimentoCabecalho(pObjeto: TAbastecimentoCabecalhoVO): TObjectList<TAbastecimentoCabecalhoVO>;
    class function UpdateAbastecimentoCabecalho(pObjeto, pObjetoOld: TAbastecimentoCabecalhoVO): Boolean;
    class function CancelAbastecimentoCabecalho(pId: Integer): Boolean;
  end;

implementation

uses codeORM;

{$REGION 'Metodos do lado cliente'}
class procedure TAbastecimentoCabecalhoController.Consulta(pFiltro: String; pPagina: Integer);
var
  StreamResposta: TStringStream;
  Retorno: TObjectList<TAbastecimentoCabecalhoVO>;
begin
  begin
    try
      Retorno := TObjectList<TAbastecimentoCabecalhoVO>(AbastecimentoCabecalho(pFiltro,pPagina));
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TAbastecimentoCabecalhoController.Insere(pAbastecimentoCabecalho: TAbastecimentoCabecalhoVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  jRegistro: TJSONArray;
  Retorno: TObjectList<TAbastecimentoCabecalhoVO>;
begin
  begin
    Result := False;
    try
      try
        Retorno := AcceptAbastecimentoCabecalho(pAbastecimentoCabecalho);
        if Assigned(Retorno) then
        begin
          Result := True;
        end;
      finally
      end;
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na inclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TAbastecimentoCabecalhoController.Altera(pAbastecimentoCabecalho, pAbastecimentoCabecalhoOld: TAbastecimentoCabecalhoVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  ObjetosJson: TJSONArray;
begin
  begin
    try
      try
        Result := UpdateAbastecimentoCabecalho(pAbastecimentoCabecalho, pAbastecimentoCabecalhoOld)
      finally
      end;
     except
       on E: Exception do
         Application.MessageBox(PChar('Ocorreu um erro na alteração do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
     end;
  end;
end;

class function TAbastecimentoCabecalhoController.Exclui(pId: Integer): Boolean;
begin
  begin
    try
      Result := CancelAbastecimentoCabecalho(pId);
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na exclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TAbastecimentoCabecalhoController.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

class procedure TAbastecimentoCabecalhoController.SetDataSet(pDataSet: TClientDataSet);
begin
  FDataSet := pDataSet;
end;

class function TAbastecimentoCabecalhoController.MethodCtx: String;
begin
  Result := 'AbastecimentoCabecalho';
end;
{$ENDREGION}

{$REGION 'Metodos lado servidor'}
class function TAbastecimentoCabecalhoController.AbastecimentoCabecalho(pFiltro: String;
  pPagina: Integer): TObjectList<TAbastecimentoCabecalhoVO>;
begin
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TcodeORM.Consultar<TAbastecimentoCabecalhoVO>(pFiltro, True, pPagina)
    else
      Result := TcodeORM.Consultar<TAbastecimentoCabecalhoVO>(pFiltro, False, pPagina);
  except
    Result := nil;
  end;
end;

class function TAbastecimentoCabecalhoController.AcceptAbastecimentoCabecalho(
  pObjeto: TAbastecimentoCabecalhoVO): TObjectList<TAbastecimentoCabecalhoVO>;
var
  UltimoID:Integer;
begin
  try
    UltimoID := TcodeORM.Inserir(pObjeto);
    Result := AbastecimentoCabecalho('ID = ' + IntToStr(UltimoID), 0);
  except
    Result := nil;
  end;
end;

class function TAbastecimentoCabecalhoController.UpdateAbastecimentoCabecalho(pObjeto,
  pObjetoOld: TAbastecimentoCabecalhoVO): Boolean;
begin
  try
    try
      Result := TcodeORM.Alterar(pObjeto, pObjetoOld);
    except
      Result := False;
    end;
  finally
  end;
end;

class function TAbastecimentoCabecalhoController.CancelAbastecimentoCabecalho(pId: Integer): Boolean;
var
  pObjeto: TAbastecimentoCabecalhoVO;
begin
  pObjeto := TAbastecimentoCabecalhoVO.Create;
  try
    pObjeto.Id := pId;
    try
      Result := TcodeORM.Excluir(pObjeto);
    except
      Result := False;
    end;
  finally
    pObjeto.Free;
  end;
end;
{$ENDREGION}

end.