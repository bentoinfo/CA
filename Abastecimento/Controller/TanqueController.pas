{*******************************************************************************
Title: Controle de Abastecimento                                                                 
Description: Controller relacionado à tabela [TANQUE] 
                                                                                                                             
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit TanqueController;

interface

uses
  Classes, DBXJSON, DSHTTP, Dialogs, SysUtils, DBClient, DB, System.Generics.Collections,
  Windows, Forms, Controller, Rtti, Atributos, TanqueVO, JSON;


type
  TTanqueController = class(TController)
  private
    class var FDataSet: TClientDataSet;
  public
    class procedure Consulta(pFiltro: String; pPagina: Integer);
    class function Insere(pTanque: TTanqueVO): Boolean;
    class function Altera(pTanque, pTanqueOld: TTanqueVO): Boolean;
    class function Exclui(pId: Integer): Boolean;
    //
    class function GetDataSet: TClientDataSet; override;
    class procedure SetDataSet(pDataSet: TClientDataSet); override;
    class function MethodCtx: String; override;

    class function Tanque(pFiltro: String; pPagina: Integer): TObjectList<TTanqueVO>;
    class function AcceptTanque(pObjeto: TTanqueVO): TObjectList<TTanqueVO>;
    class function UpdateTanque(pObjeto, pObjetoOld: TTanqueVO): Boolean;
    class function CancelTanque(pId: Integer): Boolean;
  end;

implementation

uses codeORM;

{$REGION 'Metodos do lado cliente'}
class procedure TTanqueController.Consulta(pFiltro: String; pPagina: Integer);
var
  Retorno: TObjectList<TTanqueVO>;
begin
  begin
    try
      Retorno := TObjectList<TTanqueVO>(Tanque(pFiltro,pPagina));
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TTanqueController.Insere(pTanque: TTanqueVO): Boolean;
var
  Retorno: TObjectList<TTanqueVO>;
begin
  begin
    Result := False;
    try
      Retorno := AcceptTanque(pTanque);
      if Assigned(Retorno) then
      begin
        Result := True;
      end;
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na inclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TTanqueController.Altera(pTanque, pTanqueOld: TTanqueVO): Boolean;
begin
  begin
    try
      Result := UpdateTanque(pTanque, pTanqueOld)
    except
       on E: Exception do
       begin
         Application.MessageBox(PChar('Ocorreu um erro na alteração do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);

         Result := False;
       end;
    end;
  end;
end;

class function TTanqueController.Exclui(pId: Integer): Boolean;
begin
  begin
    try
      Result := CancelTanque(pId);
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na exclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TTanqueController.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

class procedure TTanqueController.SetDataSet(pDataSet: TClientDataSet);
begin
  FDataSet := pDataSet;
end;

class function TTanqueController.MethodCtx: String;
begin
  Result := 'Tanque';
end;
{$ENDREGION}

{$REGION 'Metodos lado servidor'}
class function TTanqueController.Tanque(pFiltro: String;
  pPagina: Integer): TObjectList<TTanqueVO>;
begin
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TcodeORM.Consultar<TTanqueVO>(pFiltro, True, pPagina)
    else
      Result := TcodeORM.Consultar<TTanqueVO>(pFiltro, False, pPagina);
  except
    Result := nil;
  end;
end;

class function TTanqueController.AcceptTanque(
  pObjeto: TTanqueVO): TObjectList<TTanqueVO>;
var
  UltimoID:Integer;
begin
  try
    UltimoID := TcodeORM.Inserir(pObjeto);
    Result := Tanque('ID = ' + IntToStr(UltimoID), 0);
  except
    Result := nil;
  end;
end;

class function TTanqueController.UpdateTanque(pObjeto,
  pObjetoOld: TTanqueVO): Boolean;
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

class function TTanqueController.CancelTanque(pId: Integer): Boolean;
var
  pObjeto: TTanqueVO;
begin
  pObjeto := TTanqueVO.Create;
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
