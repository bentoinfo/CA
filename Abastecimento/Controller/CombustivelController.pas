{*******************************************************************************
Title: Controle de Abastecimento                                                                 
Description: Controller relacionado à tabela [COMBUSTIVEL] 
                                                                                                                             
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit CombustivelController;

interface

uses
  Classes, DBXJSON, DSHTTP, Dialogs, SysUtils, DBClient, DB, System.Generics.Collections,
  Windows, Forms, Controller, Rtti, Atributos, CombustivelVO, JSON;


type
  TCombustivelController = class(TController)
  private
    class var FDataSet: TClientDataSet;
  public
    class procedure Consulta(pFiltro: String; pPagina: Integer);
    class function Insere(pCombustivel: TCombustivelVO): Boolean;
    class function Altera(pCombustivel, pCombustivelOld: TCombustivelVO): Boolean;
    class function Exclui(pId: Integer): Boolean;
    //
    class function GetDataSet: TClientDataSet; override;
    class procedure SetDataSet(pDataSet: TClientDataSet); override;
    class function MethodCtx: String; override;

    class function Combustivel(pFiltro: String; pPagina: Integer): TObjectList<TCombustivelVO>;
    class function AcceptCombustivel(pObjeto: TCombustivelVO): TObjectList<TCombustivelVO>;
    class function UpdateCombustivel(pObjeto, pObjetoOld: TCombustivelVO): Boolean;
    class function CancelCombustivel(pId: Integer): Boolean;
  end;

implementation

uses codeORM;

{$REGION 'Metodos do lado cliente'}
class procedure TCombustivelController.Consulta(pFiltro: String; pPagina: Integer);
var
  StreamResposta: TStringStream;
  Retorno: TObjectList<TCombustivelVO>;
begin
  begin
    try
      Retorno := TObjectList<TCombustivelVO>(Combustivel(pFiltro,pPagina));
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TCombustivelController.Insere(pCombustivel: TCombustivelVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  jRegistro: TJSONArray;
  Retorno: TObjectList<TCombustivelVO>;
begin
  begin
    Result := False;
    try
      try
        Retorno := AcceptCombustivel(pCombustivel);
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

class function TCombustivelController.Altera(pCombustivel, pCombustivelOld: TCombustivelVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  ObjetosJson: TJSONArray;
begin
  begin
    try
      try
        Result := UpdateCombustivel(pCombustivel, pCombustivelOld)
      finally
      end;
     except
       on E: Exception do
         Application.MessageBox(PChar('Ocorreu um erro na alteração do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
     end;
  end;
end;

class function TCombustivelController.Exclui(pId: Integer): Boolean;
begin
  begin
    try
      Result := CancelCombustivel(pId);
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na exclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TCombustivelController.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

class procedure TCombustivelController.SetDataSet(pDataSet: TClientDataSet);
begin
  FDataSet := pDataSet;
end;

class function TCombustivelController.MethodCtx: String;
begin
  Result := 'Combustivel';
end;
{$ENDREGION}

{$REGION 'Metodos lado servidor'}
class function TCombustivelController.Combustivel(pFiltro: String;
  pPagina: Integer): TObjectList<TCombustivelVO>;
begin
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TcodeORM.Consultar<TCombustivelVO>(pFiltro, True, pPagina)
    else
      Result := TcodeORM.Consultar<TCombustivelVO>(pFiltro, False, pPagina);
  except
    Result := nil;
  end;
end;

class function TCombustivelController.AcceptCombustivel(
  pObjeto: TCombustivelVO): TObjectList<TCombustivelVO>;
var
  UltimoID:Integer;
begin
  try
    UltimoID := TcodeORM.Inserir(pObjeto);
    Result := Combustivel('ID = ' + IntToStr(UltimoID), 0);
  except
    Result := nil;
  end;
end;

class function TCombustivelController.UpdateCombustivel(pObjeto,
  pObjetoOld: TCombustivelVO): Boolean;
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

class function TCombustivelController.CancelCombustivel(pId: Integer): Boolean;
var
  pObjeto: TCombustivelVO;
begin
  pObjeto := TCombustivelVO.Create;
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
