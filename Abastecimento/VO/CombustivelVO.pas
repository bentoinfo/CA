{*******************************************************************************
Title: Controle Combustivel                                                                 
Description:  VO  relacionado à tabela [COMBUSTIVEL] 
@author Pedro Bento (bentoinfo@oi.com.br)                    
@version 1.0                                                                    
*******************************************************************************}
unit CombustivelVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect, SysUtils;

type
  [TEntity]
  [TTable('COMBUSTIVEL')]
  TCombustivelVO = class(TJsonVO)
  private
    FID: Integer;
    FDESCRICAO: String;
    FTIPO_COMBUSTIVEL: String;
    FPRECO_CUSTO_LITRO: Extended;
    FPRECO_VENDA_LITRO: Extended;
    FTAXA_IMPOSTO: Extended;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('DESCRICAO','Descricao',320,[ldGrid, ldLookup, ldCombobox], False)]
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    [TColumn('TIPO_COMBUSTIVEL','Tipo Combustivel',8,[ldGrid, ldLookup, ldCombobox], False)]
    property TipoCombustivel: String  read FTIPO_COMBUSTIVEL write FTIPO_COMBUSTIVEL;
    [TColumn('PRECO_CUSTO_LITRO','Preco Custo Litro',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property PrecoCustoLitro: Extended  read FPRECO_CUSTO_LITRO write FPRECO_CUSTO_LITRO;
    [TColumn('PRECO_VENDA_LITRO','Preco Venda Litro',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property PrecoVendaLitro: Extended  read FPRECO_VENDA_LITRO write FPRECO_VENDA_LITRO;
    [TColumn('TAXA_IMPOSTO','Taxa Imposto',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TaxaImposto: Extended  read FTAXA_IMPOSTO write FTAXA_IMPOSTO;

  end;

implementation



end.
