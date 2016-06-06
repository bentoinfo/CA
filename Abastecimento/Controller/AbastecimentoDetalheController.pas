{*******************************************************************************
Title: Controle de Abastecimento                                                                 
Description: Controller relacionado à tabela [ABASTECIMENTO_DETALHE] 
                                                                                                                             
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit AbastecimentoDetalheController;

interface

uses
  Classes, DBXJSON, DSHTTP, Dialogs, SysUtils, DBClient, DB, System.Generics.Collections,
  Windows, Forms, Controller, Rtti, Atributos, AbastecimentoDetalheVO, JSON;


type
  TAbastecimentoDetalheController = class(TController)
  private
    class var FDataSet: TClientDataSet;
  public
    class procedure Consulta(pFiltro: String; pPagina: Integer);
    class function Insere(pAbastecimentoDetalhe: TAbastecimentoDetalheVO): Boolean;
    class function Altera(pAbastecimentoDetalhe, pAbastecimentoDetalheOld: TAbastecimentoDetalheVO): Boolean;
    class function Exclui(pId: Integer): Boolean;
    //
    class function GetDataSet: TClientDataSet; override;
    class procedure SetDataSet(pDataSet: TClientDataSet); override;
    class function MethodCtx: String; override;

    class function AbastecimentoDetalhe(pFiltro: String; pPagina: Integer): TObjectList<TAbastecimentoDetalheVO>;
    class function AcceptAbastecimentoDetalhe(pObjeto: TAbastecimentoDetalheVO): TObjectList<TAbastecimentoDetalheVO>;
    class function UpdateAbastecimentoDetalhe(pObjeto, pObjetoOld: TAbastecimentoDetalheVO): Boolean;
    class function CancelAbastecimentoDetalhe(pId: Integer): Boolean;
  end;

implementation

uses codeORM;

{$REGION 'Metodos do lado cliente'}
class procedure TAbastecimentoDetalheController.Consulta(pFiltro: String; pPagina: Integer);
var
  StreamResposta: TStringStream;
  Retorno: TObjectList<TAbastecimentoDetalheVO>;
begin
  begin
    try
      Retorno := TObjectList<TAbastecimentoDetalheVO>(AbastecimentoDetalhe(pFiltro,pPagina));
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TAbastecimentoDetalheController.Insere(pAbastecimentoDetalhe: TAbastecimentoDetalheVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  jRegistro: TJSONArray;
  Retorno: TObjectList<TAbastecimentoDetalheVO>;
begin
  begin
    Result := False;
    try
      try
        Retorno := AcceptAbastecimentoDetalhe(pAbastecimentoDetalhe);
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

class function TAbastecimentoDetalheController.Altera(pAbastecimentoDetalhe, pAbastecimentoDetalheOld: TAbastecimentoDetalheVO): Boolean;
var
  DataStream: TStringStream;
  StreamResposta: TStringStream;
  ObjetosJson: TJSONArray;
begin
  begin
    try
      try
        Result := UpdateAbastecimentoDetalhe(pAbastecimentoDetalhe, pAbastecimentoDetalheOld)
      finally
      end;
     except
       on E: Exception do
         Application.MessageBox(PChar('Ocorreu um erro na alteração do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
     end;
  end;
end;

class function TAbastecimentoDetalheController.Exclui(pId: Integer): Boolean;
begin
  begin
    try
      Result := CancelAbastecimentoDetalhe(pId);
    except
      on E: Exception do
        Application.MessageBox(PChar('Ocorreu um erro na exclusão do registro. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  end;
end;

class function TAbastecimentoDetalheController.GetDataSet: TClientDataSet;
begin
  Result := FDataSet;
end;

class procedure TAbastecimentoDetalheController.SetDataSet(pDataSet: TClientDataSet);
begin
  FDataSet := pDataSet;
end;

class function TAbastecimentoDetalheController.MethodCtx: String;
begin
  Result := 'AbastecimentoDetalhe';
end;
{$ENDREGION}

{$REGION 'Metodos lado servidor'}
class function TAbastecimentoDetalheController.AbastecimentoDetalhe(pFiltro: String;
  pPagina: Integer): TObjectList<TAbastecimentoDetalheVO>;
begin
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TcodeORM.Consultar<TAbastecimentoDetalheVO>(pFiltro, True, pPagina)
    else
      Result := TcodeORM.Consultar<TAbastecimentoDetalheVO>(pFiltro, False, pPagina);
  except
    Result := nil;
  end;
end;

class function TAbastecimentoDetalheController.AcceptAbastecimentoDetalhe(
  pObjeto: TAbastecimentoDetalheVO): TObjectList<TAbastecimentoDetalheVO>;
var
  UltimoID:Integer;
begin
  try
    UltimoID := TcodeORM.Inserir(pObjeto);
    Result := AbastecimentoDetalhe('ID = ' + IntToStr(UltimoID), 0);
  except
    Result := nil;
  end;
end;

class function TAbastecimentoDetalheController.UpdateAbastecimentoDetalhe(pObjeto,
  pObjetoOld: TAbastecimentoDetalheVO): Boolean;
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

class function TAbastecimentoDetalheController.CancelAbastecimentoDetalhe(pId: Integer): Boolean;
var
  pObjeto: TAbastecimentoDetalheVO;
begin
  pObjeto := TAbastecimentoDetalheVO.Create;
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