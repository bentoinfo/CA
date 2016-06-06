{*******************************************************************************
Title: Controle Combustivel                                                                 
Description:  VO  relacionado à tabela [ABASTECIMENTO_DETALHE] 
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit AbastecimentoDetalheVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect, SysUtils;

type
  [TEntity]
  [TTable('ABASTECIMENTO_DETALHE')]
  TAbastecimentoDetalheVO = class(TJsonVO)
  private
    FID: Integer;
    FID_BOMBA: Integer;
    FVALOR_LITRO: Extended;
    FQUANTIDADE_ABASTECIDA: Extended;
    FTOTAL_ABASTECIDO: Extended;
    FIMPOSTO_TAXA: Extended;
    FIMPOSTO_VALOR: Extended;
    FDATA_ABASTECIMENTO: TDateTime;
    FHORA_ABASTECIMENTO: String;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('ID_BOMBA','Id Bomba',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdBomba: Integer  read FID_BOMBA write FID_BOMBA;
    [TColumn('VALOR_LITRO','Valor Litro',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorLitro: Extended  read FVALOR_LITRO write FVALOR_LITRO;
    [TColumn('QUANTIDADE_ABASTECIDA','Quantidade Abastecida',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property QuantidadeAbastecida: Extended  read FQUANTIDADE_ABASTECIDA write FQUANTIDADE_ABASTECIDA;
    [TColumn('TOTAL_ABASTECIDO','Total Abastecido',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TotalAbastecido: Extended  read FTOTAL_ABASTECIDO write FTOTAL_ABASTECIDO;
    [TColumn('IMPOSTO_TAXA','Imposto Taxa',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ImpostoTaxa: Extended  read FIMPOSTO_TAXA write FIMPOSTO_TAXA;
    [TColumn('IMPOSTO_VALOR','Imposto Valor',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ImpostoValor: Extended  read FIMPOSTO_VALOR write FIMPOSTO_VALOR;
    [TColumn('DATA_ABASTECIMENTO','Data Abastecimento',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataAbastecimento: TDateTime  read FDATA_ABASTECIMENTO write FDATA_ABASTECIMENTO;
    [TColumn('HORA_ABASTECIMENTO','Hora Abastecimento',80,[ldGrid, ldLookup, ldCombobox], False)]
    property HoraAbastecimento: String  read FHORA_ABASTECIMENTO write FHORA_ABASTECIMENTO;

  end;

implementation



end.
