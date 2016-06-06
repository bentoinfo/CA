{*******************************************************************************
Title: Controle Combustivel                                                                 
Description:  VO  relacionado à tabela [TANQUE] 
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit TanqueVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect, SysUtils;

type
  [TEntity]
  [TTable('TANQUE')]
  TTanqueVO = class(TJsonVO)
  private
    FID: Integer;
    FID_COMBUSTIVEL: Integer;
    FDESCRICAO: String;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_COMBUSTIVEL','Id Combustivel',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdCombustivel: Integer  read FID_COMBUSTIVEL write FID_COMBUSTIVEL;
    [TColumn('DESCRICAO','Descricao',320,[ldGrid, ldLookup, ldCombobox], False)]
    property Descricao: String  read FDESCRICAO write FDESCRICAO;

  end;

implementation



end.
