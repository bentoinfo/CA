{*******************************************************************************
Title: Controle Combustivel                                                                 
Description:  VO  relacionado à tabela [ABASTECIMENTO_CABECALHO] 
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit AbastecimentoCabecalhoVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect, SysUtils;

type
  [TEntity]
  [TTable('ABASTECIMENTO_CABECALHO')]
  TAbastecimentoCabecalhoVO = class(TJsonVO)
  private
    FID: Integer;
    FDATA_ABASTECIMENTO: TDateTime;
    FHORA_ABASTECIMENTO: String;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('DATA_ABASTECIMENTO','Data Abastecimento',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataAbastecimento: TDateTime  read FDATA_ABASTECIMENTO write FDATA_ABASTECIMENTO;
    [TColumn('HORA_ABASTECIMENTO','Hora Abastecimento',80,[ldGrid, ldLookup, ldCombobox], False)]
    property HoraAbastecimento: String  read FHORA_ABASTECIMENTO write FHORA_ABASTECIMENTO;

  end;

implementation



end.
