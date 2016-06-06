{*******************************************************************************
Title: Controle de Abastecimento                                                                 
Description: Controller relacionado à tabela [BOMBA] 
                                                                                                                             
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit BombaController;

interface

uses
  Classes, DBXJSON, DSHTTP, Dialogs, SysUtils, DBClient, DB, System.Generics.Collections,
  Windows, Forms, Controller, Rtti, Atributos, BombaVO, JSON;


type
  TBombaController = class(TController)
  private
    class var FDataSet: TClientDataSet;
  public
    class procedure Consulta(pFiltro: String; pPagina: Integer);
    class function Insere(pBomba: TBombaVO): Boolean;
    class function Altera(pBomba, pBombaOld: TBombaVO): Boolean;
    class function Exclui(pId: Integer): Boolean;
    //
    class function GetDataSet: TClientDataSet; override;
    class procedure SetDataSet(pDataSet: TClientDataSet); override;
    class function MethodCtx: String; override;

    class function Bomba(pFiltro: String; pPagina: Integer): TObjectList<TBombaVO>;
    class function AcceptBomba(pObjeto: TBombaVO): TObjectList<TBombaVO>;
    class function UpdateBomba(pObjeto, pObjetoOld: TBombaVO): Boolean;
    class function CancelBomba(pId: Integer): Boolean;
  end;

implementation

uses codeORM;

{$REGION 'Metodos do lado cliente'}
class procedure TBombaController.Consulta(pFiltro: String; pPagina: Integer);
var
  StreamResposta: TStringStream;
  Retorno: TObjectList<TBombaVO>;
begin
  begin
    try
      Retorno := TObjectList<TBombaVO>(Bomba(pFiltro,pPagina));
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TBombaController.Insere(pBomba: TBombaVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  jRegistro: TJSONArray;
  Retorno: TObjectList<TBombaVO>;
begin
  begin
    Result := False;
    try
      try
        Retorno := AcceptBomba(pBomba);
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

class function TBombaController.Altera(pBomba, pBombaOld: TBombaVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  ObjetosJson: TJSONArray;
begin
  begin
    try
      try
        Result := UpdateBomba(pBomba, pBombaOld)
      finally
      end;
     except
       on E: Exception do
         Application.MessageBox(PChar('Ocorreu um erro na alteração do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
     end;
  end;
end;

class function TBombaController.Exclui(pId: Integer): Boolean;
begin
  begin
    try
      Result := CancelBomba(pId);
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na exclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TBombaController.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

class procedure TBombaController.SetDataSet(pDataSet: TClientDataSet);
begin
  FDataSet := pDataSet;
end;

class function TBombaController.MethodCtx: String;
begin
  Result := 'Bomba';
end;
{$ENDREGION}

{$REGION 'Metodos lado servidor'}
class function TBombaController.Bomba(pFiltro: String;
  pPagina: Integer): TObjectList<TBombaVO>;
begin
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TcodeORM.Consultar<TBombaVO>(pFiltro, True, pPagina)
    else
      Result := TcodeORM.Consultar<TBombaVO>(pFiltro, False, pPagina);
  except
    Result := nil;
  end;
end;

class function TBombaController.AcceptBomba(
  pObjeto: TBombaVO): TObjectList<TBombaVO>;
var
  UltimoID:Integer;
begin
  try
    UltimoID := TcodeORM.Inserir(pObjeto);
    Result := Bomba('ID = ' + IntToStr(UltimoID), 0);
  except
    Result := nil;
  end;
end;

class function TBombaController.UpdateBomba(pObjeto,
  pObjetoOld: TBombaVO): Boolean;
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

class function TBombaController.CancelBomba(pId: Integer): Boolean;
var
  pObjeto: TBombaVO;
begin
  pObjeto := TBombaVO.Create;
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
