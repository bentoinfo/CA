{*******************************************************************************
Title: Controle Combustivel                                                                 
Description:  VO  relacionado à tabela [BOMBA] 
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit BombaVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect, SysUtils;

type
  [TEntity]
  [TTable('BOMBA')]
  TBombaVO = class(TJsonVO)
  private
    FID: Integer;
    FID_TANQUE: Integer;
    FDESCRICAO: String;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_TANQUE','Id Tanque',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdTanque: Integer  read FID_TANQUE write FID_TANQUE;
    [TColumn('DESCRICAO','Descricao',320,[ldGrid, ldLookup, ldCombobox], False)]
    property Descricao: String  read FDESCRICAO write FDESCRICAO;

  end;

implementation



end.
