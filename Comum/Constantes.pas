{ *******************************************************************************
  Description: Unit para armazenas as constantes do sistema

  @author Pedro Bento
  @version 1.1
  ******************************************************************************* }
unit Constantes;

interface

const
  // Formatter
  ftCnpj = '##.###.###/####-##;0;_';
  ftCpf = '###.###.###-##;0;_';
  ftCep = '##.###-####;0;_';
  ftTelefone = '(##)####-####;0;_';
  ftCelular = '(##)#####-####;0;_'; //Pedro - 07/02/2014
  ftInteiroComSeparador = '###,###,###';
  ftInteiroSemSeparador = '#########';
  ftFloatComSeparador = '###,###,##0.00';
  ftFloatSemSeparador = '0.00';
  ftZerosAEsquerda = '000000';
  ftZeroInvisivel = '#';

type

  TConstantes = class
  const
    QUANTIDADE_POR_PAGINA = 50;

    {$WRITEABLECONST ON}
    DECIMAIS_QUANTIDADE: Integer = 2;
    DECIMAIS_VALOR: Integer = 2;
    {$WRITEABLECONST OFF}
  end;

implementation

end.
