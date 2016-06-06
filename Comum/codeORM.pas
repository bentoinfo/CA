{ *******************************************************************************
Title: Controle de Abastecimento
Description: Framework ORM

@author Pedro Bento (bentoinfo@oi.com.br)
@version 1.0
*******************************************************************************}
unit codeORM;

interface

uses Atributos, Rtti, SysUtils, SQLExpr, TypInfo, DBXCommon, DBXJSON,
  JSonVO, DBXJSONReflect, Classes, Generics.Collections, JSON,
  Biblioteca;

type
  TcodeORM = class
  private
    class function FormatarFiltro(pFiltro: String): String;
    class function ValorPropriedadeObjeto(pObj: TObject; pCampo: String): Variant;
  public
    class function Inserir(pObjeto: TObject): Integer;

    class function Alterar(pObjeto: TObject): Boolean; overload;
    class function Alterar(pObjeto, pObjetoOld: TObject): Boolean; overload;

    class function Excluir(pObjeto: TObject): Boolean; overload;
    class function Excluir(pId: Integer; pObjeto: TObject; pMsgExcessao: String): Boolean; overload;

    class function Consultar<T: class>(pFiltro: String; pPagina: Integer): TJSONArray; overload;
    class function Consultar<T: class>(pFiltro: String; pPagina: Integer; pConsultaCompleta: Boolean): TJSONArray; overload;
    class function Consultar<T: class>(pFiltro: String; pConsultaCompleta: Boolean; pPagina: Integer = 0; pOrderBy : string = ''): TObjectList<T>; overload;
    class function Consultar<T: class>(pConsulta: String; pFiltro: String; pConsultaCompleta: Boolean; pPagina: Integer): TObjectList<T>; overload;
    class function Consultar(pConsulta: String; pFiltro: String; pPagina: Integer): TDBXReader; overload;
    class function Consultar<T: class>(pConsulta: String; pFiltro: String; pPagina: Integer): TJSONArray; overload;
    class function Consultar(pObjeto: TObject; pFiltro: String; pPagina: Integer; pOrderBy : string = ''): TDBXReader; overload;

   class function ConsultarUmObjeto<T: class>(pFiltro: String; pConsultaCompleta: Boolean; pOrderBy : string = ''): T;

   class procedure PopularObjetosRelacionados(pObj: TJSonVO);
   class procedure AnularObjetosRelacionados(pObj: TJSonVO);

    class function ComandoSQL(pConsulta: String): Boolean;

    class function SelectMax(pTabela: String; pFiltro: String): Integer;
    class function SelectMin(pTabela: String; pFiltro: String): Integer;
    class function SelectSun(pTabela, pFiltro, pCampo : String) : Extended;
  end;

var
  Conexao: TSQLConnection;
  Query: TSQLQuery;
  ConsultaCompleta: Boolean;

implementation

uses
  ConexaoBD,
  Constantes;

{ TcodeORM }

class function TcodeORM.FormatarFiltro(pFiltro: String): String;
begin
  Result := pFiltro;
  Result := StringReplace(Result, '*', '%', [rfReplaceAll]);
  Result := StringReplace(Result, '|', '/', [rfReplaceAll]);
  Result := StringReplace(Result, '\"', '"', [rfReplaceAll]);
end;

class function TcodeORM.ValorPropriedadeObjeto(pObj: TObject; pCampo: String): Variant;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Atributo: TCustomAttribute;
  Propriedade: TRttiProperty;
begin
  Result := 0;
  Contexto := TRttiContext.Create;
  try
    Tipo := Contexto.GetType(pObj.ClassType);

    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        // se está pesquisando pelo ID
        if Atributo is TId then
        begin
          if (Atributo as TId).NameField = pCampo then
          begin
            Result := Propriedade.GetValue(pObj).AsInteger;
          end;
        end;

        // se está pesquisando por outro campo
        if Atributo is TColumn then
        begin
          if (Atributo as TColumn).Name = pCampo then
          begin
            if (Propriedade.PropertyType.TypeKind in [tkInteger, tkInt64]) then
              Result := Propriedade.GetValue(pObj).AsInteger
            else if (Propriedade.PropertyType.TypeKind in [tkString, tkUString]) then
              Result := Propriedade.GetValue(pObj).AsString;
          end;
        end;
      end;
    end;
  finally
    Contexto.Free;
  end;
end;

class function TcodeORM.Inserir(pObjeto: TObject): Integer;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  ConsultaSQL, CamposSQL, ValoresSQL: String;
  UltimoID: Integer;
  Tabela: String;
  NomeTipo: String;
begin
  try
    FormatSettings.DecimalSeparator := '.';

    Contexto := TRttiContext.Create;
    Tipo := Contexto.GetType(pObjeto.ClassType);

    // localiza o nome da tabela
    for Atributo in Tipo.GetAttributes do
    begin
      if Atributo is TTable then
      begin
        ConsultaSQL := 'INSERT INTO ' + (Atributo as TTable).Name;
        Tabela := (Atributo as TTable).Name;
      end;
    end;

    // preenche os nomes dos campos e valores
    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        if Atributo is TColumn then
        begin
          if not(Atributo as TColumn).Transiente then
          begin
            if (Propriedade.PropertyType.TypeKind in [tkInteger, tkInt64]) then
            begin
              if (Propriedade.GetValue(pObjeto).AsInteger <> 0) then
              begin
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ',';
                ValoresSQL := ValoresSQL + Propriedade.GetValue(pObjeto).ToString + ',';
              end;
            end
            else if (Propriedade.PropertyType.TypeKind in [tkString, tkUString]) then
            begin
              if (Propriedade.GetValue(pObjeto).AsString <> '') then
              begin
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ',';
                ValoresSQL := ValoresSQL + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ',';
              end;
            end
            else if (Propriedade.PropertyType.TypeKind = tkFloat) then
            begin
              NomeTipo := LowerCase(Propriedade.PropertyType.Name);
              if NomeTipo = 'tdatetime' then
              begin
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ',';

                if Propriedade.GetValue(pObjeto).AsExtended > 0 then
                  ValoresSQL := ValoresSQL + QuotedStr(FormatDateTime('yyyy-mm-dd', Propriedade.GetValue(pObjeto).AsExtended)) + ','
                else
                  ValoresSQL := ValoresSQL + 'null,';
              end
              else
              begin
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ',';
                ValoresSQL := ValoresSQL + QuotedStr(FormatFloat('0.000000', Propriedade.GetValue(pObjeto).AsExtended)) + ',';
              end;
            end
            else
            begin
              CamposSQL := CamposSQL + (Atributo as TColumn).Name + ',';
              ValoresSQL := ValoresSQL + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ',';
            end;
          end;
        end;
      end;
    end;

    // retirando as vírgulas que sobraram no final
    Delete(CamposSQL, Length(CamposSQL), 1);
    Delete(ValoresSQL, Length(ValoresSQL), 1);

    ConsultaSQL := ConsultaSQL + '(' + CamposSQL + ') VALUES (' + ValoresSQL + ')';

    if TDBExpress.getBanco = 'Firebird' then
    begin
      ConsultaSQL := ConsultaSQL + ' RETURNING ID ';
    end;

    Query := TSQLQuery.Create(nil);
    try
      Query.SQLConnection := TDBExpress.getConexao;
      Query.sql.Text := ConsultaSQL;

      UltimoID := 0;
      if TDBExpress.getBanco = 'MySQL' then
      begin
        Query.ExecSQL();
        Query.sql.Text := 'select LAST_INSERT_ID() as id';
        Query.Open();
        UltimoID := Query.FieldByName('id').AsInteger;
      end
      else if TDBExpress.getBanco = 'Firebird' then
      begin
        Query.Open;
        UltimoID := Query.Fields[0].AsInteger;
      end
      else if TDBExpress.getBanco = 'Postgres' then
      begin
        Query.ExecSQL();
        Query.sql.Text := 'select Max(id) as id from ' + Tabela;
        Query.Open();
        UltimoID := Query.FieldByName('id').AsInteger;
      end
      else if TDBExpress.getBanco = 'MSSQL' then
      begin
        Query.ExecSQL();
        Query.sql.Text := 'select Max(id) as id from ' + Tabela;
        Query.Open();
        UltimoID := Query.FieldByName('id').AsInteger;
      end;
    finally
      Query.Close;
      Query.Free;
    end;

    Result := UltimoID;
  finally
    Contexto.Free;
    FormatSettings.DecimalSeparator := ',';
  end;
end;

class function TcodeORM.Alterar(pObjeto, pObjetoOld: TObject): Boolean;
var
  Contexto: TRttiContext;
  Tipo, TipoOld: TRttiType;
  Propriedade, PropriedadeOld: TRttiProperty;
  Atributo, AtributoOld: TCustomAttribute;
  ConsultaSQL, CamposSQL, FiltroSQL: String;
  NomeTipo: String;
  ValorNew, ValorOld: Variant;
  AchouValorOld: Boolean;
  NomeTabela: String;
  ExisteCamposAlterar: Boolean;
begin
  try
    FormatSettings.DecimalSeparator := '.';

    Contexto := TRttiContext.Create;
    Tipo := Contexto.GetType(pObjeto.ClassType);
    TipoOld := Contexto.GetType(pObjetoOld.ClassType);
    NomeTabela := '';

    // localiza o nome da tabela
    for Atributo in Tipo.GetAttributes do
    begin
      //Pedro - armazeno no nome da tabela em "NomeTabela"
      if Atributo is TTable then
      begin
        NomeTabela := Trim((Atributo as TTable).Name);
        ConsultaSQL := 'UPDATE ' + (Atributo as TTable).Name + ' SET ';
      end;
    end;

    // preenche os nomes dos campos e filtro
    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        if Atributo is TColumn then
        begin
          if not(Atributo as TColumn).Transiente then
          begin
            AchouValorOld := False;
            ValorNew := Propriedade.GetValue(pObjeto).ToString;

            // Compara os dois VOs e só considera para a consulta os campos que foram alterados
            for PropriedadeOld in TipoOld.GetProperties do
            begin
              for AtributoOld in PropriedadeOld.GetAttributes do
              begin
                if AtributoOld is TColumn then
                begin
                  if (AtributoOld as TColumn).Name = (Atributo as TColumn).Name then
                  begin
                    AchouValorOld := True;
                    ValorOld := Propriedade.GetValue(pObjetoOld).ToString;

                    // só continua a execução se o valor que subiu em NewVO for diferente do OldVO
                    if ((NomeTabela = 'PESSOA') and
                        ((Atributo as TColumn).Name = 'NOME')) or
                       (ValorNew <> ValorOld) then
                    begin

                      if (Propriedade.PropertyType.TypeKind in [tkInteger, tkInt64]) then
                      begin
                        if (Propriedade.GetValue(pObjeto).AsInteger <> 0) then
                          CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + Propriedade.GetValue(pObjeto).ToString + ','
                        else
                          CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + 'null' + ',';
                      end

                      else if (Propriedade.PropertyType.TypeKind in [tkString, tkUString]) then
                      begin
                        if (Propriedade.GetValue(pObjeto).AsString <> '') then
                          CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ','
                        else
                          CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + 'null' + ',';
                      end

                      else if (Propriedade.PropertyType.TypeKind = tkFloat) then
                      begin
                        if Propriedade.GetValue(pObjeto).AsExtended <> 0 then
                        begin
                          NomeTipo := LowerCase(Propriedade.PropertyType.Name);
                          if NomeTipo = 'tdatetime' then
                            CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Propriedade.GetValue(pObjeto).AsExtended)) + ','
                          else
                            CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(FormatFloat('0.000000', Propriedade.GetValue(pObjeto).AsExtended)) + ',';
                        end
                        else
                          CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + 'null' + ',';
                      end

                      else if Propriedade.GetValue(pObjeto).ToString <> '' then
                        CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ','
                      else
                        CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + 'null' + ',';

                    end;
                  end;
                end;
              end;
              // Quebra o for, pois já encontrou o valor Old correspondente
              if AchouValorOld then
                Break;
            end;

          end;
        end
        else if Atributo is TId then
          FiltroSQL := ' WHERE ' + (Atributo as TId).NameField + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString);
      end;
    end;

    //Pedro - Se CamposSQL = '' não teve alteração a ser aplicada
    ExisteCamposAlterar := CamposSQL <> '';

    Result := True;

    if Result then
    begin
      (* Pedro - 31/03/2014 - Só executa se teve campos a ser alterados *)
       if ExisteCamposAlterar then
       begin
         // retirando as vírgulas que sobraram no final
         Delete(CamposSQL, Length(CamposSQL), 1);
         ConsultaSQL := ConsultaSQL + CamposSQL + FiltroSQL;

         Conexao := TDBExpress.getConexao;
         Query   := TSQLQuery.Create(nil);

         try
           Query.SQLConnection := Conexao;
           Query.sql.Text      := ConsultaSQL;

           Query.ExecSQL();
         finally
           FreeAndNil(Query);
         end;

       end;
    end;
  finally
    Contexto.Free;
    FormatSettings.DecimalSeparator := ',';
  end;
end;

class function TcodeORM.Alterar(pObjeto: TObject): Boolean;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  ConsultaSQL, CamposSQL, FiltroSQL: String;
  NomeTipo: String;
  NomeTabela: String;
  IdPessoa: Integer;
  IdColaborador: Integer;
begin
  try
    FormatSettings.DecimalSeparator := '.';

    Contexto := TRttiContext.Create;
    Tipo := Contexto.GetType(pObjeto.ClassType);

    NomeTabela := '';

    // localiza o nome da tabela
    for Atributo in Tipo.GetAttributes do
    begin
      //Pedro - armazeno o nome da tabela em variavel
      if Atributo is TTable then
      begin
        NomeTabela := Trim((Atributo as TTable).Name);
        ConsultaSQL := 'UPDATE ' + (Atributo as TTable).Name + ' SET ';
      end;
    end;

    // preenche os nomes dos campos e filtro
    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        if Atributo is TColumn then
        begin
          if not(Atributo as TColumn).Transiente then
          begin

            if (Propriedade.PropertyType.TypeKind in [tkInteger, tkInt64]) then
            begin
              //Pedro - se tiver coluna ID_PESSOA guardo seu valor
              if (Atributo as TColumn).Name = 'ID_PESSOA' then
                IdPessoa := Propriedade.GetValue(pObjeto).AsInteger;

              //Pedro - se tiver coluna ID_COLABORADOR guardo seu valor
              if (Atributo as TColumn).Name = 'ID_COLABORADOR' then
                IdColaborador := Propriedade.GetValue(pObjeto).AsInteger;

              if (Propriedade.GetValue(pObjeto).AsInteger <> 0) then
                begin
                  CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + Propriedade.GetValue(pObjeto).ToString + ','
                end
              else if (Atributo as TColumn).Name = 'LANCAMENTO_CAIXA' then
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + Propriedade.GetValue(pObjeto).ToString + ','
              else
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + 'null' + ',';
            end

            else if (Propriedade.PropertyType.TypeKind in [tkString, tkUString]) then
            begin
              CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ','
             { if (Propriedade.GetValue(pObjeto).AsString <> '') then
              begin
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ','
              end;}
            end

            else if (Propriedade.PropertyType.TypeKind = tkFloat) then
            begin
              NomeTipo := LowerCase(Propriedade.PropertyType.Name);
              if NomeTipo = 'tdatetime' then
                begin
                  if Propriedade.GetValue(pObjeto).AsExtended <> 0 then
                    CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(FormatDateTime('yyyy-mm-dd', Propriedade.GetValue(pObjeto).AsExtended)) + ','
                  else
                    CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + 'null' + ',';
                end
              else
                CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(FormatFloat('0.000000', Propriedade.GetValue(pObjeto).AsExtended)) + ',';
            end

            else if Propriedade.GetValue(pObjeto).ToString <> '' then
            begin
              CamposSQL := CamposSQL + (Atributo as TColumn).Name + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString) + ','
            end;
          end;
        end
        else if Atributo is TId then
          FiltroSQL := ' WHERE ' + (Atributo as TId).NameField + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString);
      end;
    end;

    //Pedro - tratamento para ver se existe registro a ser alterado nessas tabelas
    if (NomeTabela = 'CLIENTE') or
       (NomeTabela = 'FORNECEDOR') or
       (NomeTabela = 'COLABORADOR') or
       (NomeTabela = 'VENDEDOR') then
    begin
      Query := TSQLQuery.Create(nil);
      try
        Query.SQLConnection := Conexao;

        if (NomeTabela = 'VENDEDOR') then
        begin
          FiltroSQL := ' WHERE ID_COLABORADOR = ' + IntToStr(IdColaborador);
          Query.sql.Text := 'SELECT ID_COLABORADOR FROM ' + NomeTabela + FiltroSQL;
        end
        else
        begin
          FiltroSQL := ' WHERE ID_PESSOA = ' + IntToStr(IdPessoa);
          Query.sql.Text := 'SELECT ID_PESSOA FROM ' + NomeTabela + FiltroSQL;
        end;

        Query.Open;

        Result := not Query.IsEmpty;

      finally
        FreeAndNil(Query);
      end;
    end
    else
      Result := True;

    // retirando as vírgulas que sobraram no final
    Delete(CamposSQL, Length(CamposSQL), 1);

    ConsultaSQL := ConsultaSQL + CamposSQL + FiltroSQL;

    if Result then
    begin
      Conexao             := TDBExpress.getConexao;
      Query               := TSQLQuery.Create(nil);
      Query.SQLConnection := Conexao;
      Query.sql.Text      := ConsultaSQL;

      try
        Query.ExecSQL();
      finally
        FreeAndNil(Query);
      end;
    end;
  finally
    Contexto.Free;
    FormatSettings.DecimalSeparator := ',';
  end;
end;

class function TcodeORM.Excluir(pObjeto: TObject): Boolean;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  ConsultaSQL: String;
  FiltroSQL: String;
  InfoRegistroExcluido: string;
  NomeTabela: string;
begin
  try
    Contexto := TRttiContext.Create;
    Tipo := Contexto.GetType(pObjeto.ClassType);

    NomeTabela      := '';

    // localiza o nome da tabela
    for Atributo in Tipo.GetAttributes do
    begin
      if Atributo is TTable then
      begin
        NomeTabela := (Atributo as TTable).Name;
        ConsultaSQL := 'DELETE FROM ' + (Atributo as TTable).Name;
      end;
    end;

    // preenche o filtro
    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        if Atributo is TId then
          FiltroSQL := ' WHERE ' + (Atributo as TId).NameField + ' = ' + QuotedStr(Propriedade.GetValue(pObjeto).ToString);
      end;
    end;

    ConsultaSQL := ConsultaSQL + FiltroSQL;

    Conexao := TDBExpress.getConexao;
    Query   := TSQLQuery.Create(nil);

    try
      Query.SQLConnection := Conexao;
      Query.sql.Text      := ConsultaSQL;

      Query.ExecSQL();

      Result := True;
    finally
      FreeAndNil(Query);
    end;

  finally
    Contexto.Free;
  end;
end;

class function TcodeORM.Consultar(pObjeto: TObject; pFiltro: String; pPagina: Integer;
                                  pOrderBy : string = ''): TDBXReader;
var
  Contexto    : TRttiContext;
  Tipo        : TRttiType;
  Atributo    : TCustomAttribute;
  Propriedade : TRttiProperty;
  ConsultaSQL,
  FiltroSQL,
  Campo,
  NomeTabelaPrincipal,
  Joins,
  vFiltro,
  vOrderBY       : String;
  DBXConnection  : TDBXConnection;
  DBXCommand     : TDBXCommand;
  DBXReader      : TDBXReader;
  CamposConsulta : TStringList;
  TabelasJoin    : TStringList; //Filtros em tabelas avô pra cima
  CamposJoin     : TStringList; //Filtros em tabelas avô pra cima
  i,
  j                  : Integer;
  ConsultaTransiente : Boolean;
begin
  try
    try
      ConsultaTransiente := False;
      CamposConsulta := TStringList.Create;
      TabelasJoin := TStringList.Create;
      CamposJoin := TStringList.Create;
      Contexto := TRttiContext.Create;
      Tipo := Contexto.GetType(pObjeto.ClassType);

      // pega o nome da tabela principal
      for Atributo in Tipo.GetAttributes do
      begin
        if Atributo is TTable then
        begin
          NomeTabelaPrincipal := (Atributo as TTable).Name;
        end;
      end;

      // extrai os campos para consulta
      CamposConsulta := ExtraiCamposFiltro(pFiltro);

      // verifica se existem campos transientes na consulta
      for i := 0 to CamposConsulta.Count - 1 do
      begin
        Campo   := CamposConsulta[i];
        vFiltro := Campo;

        for Propriedade in Tipo.GetProperties do
        begin
          for Atributo in Propriedade.GetAttributes do
          begin
            if Atributo is TColumn then
            begin
              // se o campo que retornou na lista for transiente, pega o nome da tabela e marca a consulta como transiente
              if ((Atributo as TColumn).Name = Campo) and ((Atributo as TColumn).Transiente) then
              begin
                Campo := StringReplace(Campo, '.', '', [rfReplaceAll]);

                if ((Atributo as TColumn).CampoConsultaTransiente <> '') then
                  begin
                    ConsultaSQL := ConsultaSQL + ', ' + (Atributo as TColumn).CampoConsultaTransiente + ' AS ' + Campo;
                    pFiltro     := StringReplace(pFiltro, vFiltro, (Atributo as TColumn).CampoConsultaTransiente, [rfReplaceAll]);
                  end
                else
                  ConsultaSQL := ConsultaSQL + ', ' + (Atributo as TColumn).Name + ' AS ' + Campo;

                //se houver um "." no nome da tabela chama o método para
                if (Pos('.', (Atributo as TColumn).TableName) > 0) then
                begin
                  Split('.', (Atributo as TColumn).TableName, TabelasJoin);
                  Split('.', (Atributo as TColumn).LocalColumn, CamposJoin);
                  Joins := Joins + ' ' + 'LEFT JOIN ' + TabelasJoin[0] + ' ON ' + NomeTabelaPrincipal + '.' + CamposJoin[0] + ' = ' + TabelasJoin[0] + '.' + (Atributo as TColumn).ForeingColumn;
                  for j := 1 to TabelasJoin.Count - 1 do
                    Joins := Joins + ' ' + 'LEFT JOIN ' + TabelasJoin[j] + ' ON ' + TabelasJoin[j-1] + '.' + CamposJoin[j] + ' = ' + TabelasJoin[j] + '.' + (Atributo as TColumn).ForeingColumn;
                end
                else
                  Joins := Joins + ' ' + 'LEFT JOIN ' + (Atributo as TColumn).TableName + ' ON ' + NomeTabelaPrincipal + '.' + (Atributo as TColumn).LocalColumn + ' = ' + (Atributo as TColumn).TableName + '.' + (Atributo as TColumn).ForeingColumn;
                ConsultaTransiente := True;
              end;
            end;
          end;
        end;
      end;

      // monta o inicio da consulta
      if ConsultaTransiente then
      begin
        // consulta transiente
        for Atributo in Tipo.GetAttributes do
        begin
          if Atributo is TTable then
          begin
            if (TDBExpress.getBanco = 'Firebird') and (pPagina >= 0) then
            begin
              ConsultaSQL := 'SELECT first ' + IntToStr(TConstantes.QUANTIDADE_POR_PAGINA) + ' skip ' + IntToStr(pPagina) + ' ' + (Atributo as TTable).Name + '.*' + ConsultaSQL + ' From ' + (Atributo as TTable).Name + Joins;
            end
            else
            begin
              ConsultaSQL := 'SELECT ' + (Atributo as TTable).Name + '.*' + ConsultaSQL + ' FROM ' + (Atributo as TTable).Name + Joins;
            end;
          end;
        end;
      end
      else
      begin
        // consulta normal
        for Atributo in Tipo.GetAttributes do
        begin
          if Atributo is TTable then
          begin
            if (TDBExpress.getBanco = 'Firebird') and (pPagina >= 0) then
            begin
              ConsultaSQL := 'SELECT first ' + IntToStr(TConstantes.QUANTIDADE_POR_PAGINA) + ' skip ' + IntToStr(pPagina) + ' * FROM ' + (Atributo as TTable).Name;
            end
            else
            begin
              ConsultaSQL := 'SELECT * FROM ' + (Atributo as TTable).Name;
            end;
          end;
        end;
      end;

      if TDBExpress.getBanco = 'Postgres' then
      begin
        if pFiltro <> '' then
        begin
          // Não diferenciar letras maiúsculas de minúsculas e nem acentuadas de não acentuadas.
          // Código Adicionado e Alterado por Carlos Fitl
          pFiltro := StringReplace(pFiltro, 'LIKE', 'ILIKE', [rfReplaceAll]);
          pFiltro := StringReplace(pFiltro, '[', ' CAST(', [rfReplaceAll]);
          pFiltro := StringReplace(pFiltro, ']', ' as VARCHAR)',[rfReplaceAll]);
          pFiltro := StringReplace(pFiltro, '"', chr(39), [rfReplaceAll]);
          FiltroSQL := ' WHERE ' + FormatarFiltro(pFiltro);
        end;
      end

      // Código Adicionado por Fernando L Oliveira.
      else if TDBExpress.getBanco = 'Firebird' then
      begin
        if pFiltro <> '' then
        begin
          // Não diferenciar letras maiúsculas de minúsculas e nem acentuadas de não acentuadas.
          pFiltro := StringReplace(pFiltro, '[', ' CAST([', [rfReplaceAll]);
          pFiltro := StringReplace(pFiltro, ']', ' as TEXT)] COLLATE PT_BR ',[rfReplaceAll]);
          FiltroSQL := ' WHERE ' + FormatarFiltro(pFiltro);
        end;
      end

      else if pFiltro <> '' then
      begin
        FiltroSQL := ' WHERE ' + FormatarFiltro(pFiltro);
      end;

      if (pOrderBy <> '') then
        vOrderBY := ' order by ' + pOrderBy;

      ConsultaSQL := ConsultaSQL + FiltroSQL + vOrderBY;


      if (TDBExpress.getBanco = 'MySQL') and (pPagina >= 0) then
        ConsultaSQL := ConsultaSQL + ' limit ' + IntToStr(TConstantes.QUANTIDADE_POR_PAGINA) + ' offset ' + IntToStr(pPagina);

      // Retira os [] da consulta
      ConsultaSQL := StringReplace(ConsultaSQL, '[', '', [rfReplaceAll]);
      ConsultaSQL := StringReplace(ConsultaSQL, ']', '', [rfReplaceAll]);

      DBXConnection := TDBExpress.getConexao.DBXConnection;
      DBXCommand := DBXConnection.CreateCommand;
      DBXCommand.Text := ConsultaSQL;
      DBXCommand.Prepare;
      DBXReader := DBXCommand.ExecuteQuery;

      Result := DBXReader;
    except
      raise ;
    end;
  finally
    Contexto.Free;
    CamposConsulta.Free;
  end;
end;

class function TcodeORM.Consultar(pConsulta: String; pFiltro: String; pPagina: Integer): TDBXReader;
var
  FiltroSQL     : String;
  DBXConnection : TDBXConnection;
  DBXCommand    : TDBXCommand;
  DBXReader     : TDBXReader;
begin
  try
    try
      if TDBExpress.getBanco = 'Postgres' then
        begin
          if pFiltro <> '' then
          begin
            pFiltro := StringReplace(FormatarFiltro(pFiltro), '"', chr(39), [rfReplaceAll]);
            FiltroSQL := ' and ' + pFiltro;
          end;
        end
      else
        begin
          if pFiltro <> '' then
          begin
            pFiltro := FormatarFiltro(pFiltro);
            FiltroSQL := ' and ' + pFiltro;
          end;
        end;

      DBXConnection   := TDBExpress.getConexao.DBXConnection;
      DBXCommand      := DBXConnection.CreateCommand;
      DBXCommand.Text := pConsulta + FiltroSQL;

      if (TDBExpress.getBanco = 'MySQL') and (pPagina >= 0) then
        DBXCommand.Text := DBXCommand.Text + ' limit ' + IntToStr(TConstantes.QUANTIDADE_POR_PAGINA) + ' offset ' + IntToStr(pPagina);

      DBXCommand.Prepare;

      DBXReader := DBXCommand.ExecuteQuery;
      Result    := DBXReader;
    except
      raise ;
    end;
  finally

  end;
end;

class function TcodeORM.Consultar<T>(pFiltro: String; pConsultaCompleta: Boolean; pPagina: Integer = 0; pOrderBy : string = ''): TObjectList<T>;
var
  DBXReader: TDBXReader;
  ObjConsulta: TObject;
  Obj: T;
begin
  ConsultaCompleta := pConsultaCompleta;
  Result := TObjectList<T>.Create;
  ObjConsulta := TClass(T).Create;
  try
    DBXReader := Consultar(ObjConsulta, pFiltro, pPagina, pOrderBy);
    try
      while DBXReader.Next do
      begin
        Obj := TGenericVO<T>.FromDBXReader(DBXReader);
        if ConsultaCompleta then
        begin
          try
            PopularObjetosRelacionados(TJSonVO(Obj));
          finally
          end;
        end;
        Result.Add(Obj);
      end;
    finally
      DBXReader.Free;
    end;
  finally
    ObjConsulta.Free;
  end;
end;

class function TcodeORM.Consultar<T>(pConsulta, pFiltro: String; pPagina: Integer): TJSONArray;
var
  FiltroSQL: String;
  DBXConnection: TDBXConnection;
  DBXCommand: TDBXCommand;
  DBXReader: TDBXReader;
  Obj: T;
begin
  Result := TJSONArray.Create;

  pFiltro := FormatarFiltro(pFiltro);

  if pFiltro <> '' then
    FiltroSQL := ' WHERE ' + pFiltro;

  try
    DBXConnection := TDBExpress.getConexao.DBXConnection;
    DBXCommand := DBXConnection.CreateCommand;
    DBXCommand.Text := pConsulta + FiltroSQL;
    DBXCommand.Prepare;
    DBXReader := DBXCommand.ExecuteQuery;

    while DBXReader.Next do
    begin
      Obj := TGenericVO<T>.FromDBXReader(DBXReader);
      try
        Result.AddElement(TJSonVO.ObjectToJSON<T>(Obj));
      finally
        TObject(Obj).Free;
      end;
    end;
  finally
    DBXCommand.Free;
    DBXReader.Free;
  end;
end;

class function TcodeORM.Consultar<T>(pConsulta: String; pFiltro: String; pConsultaCompleta: Boolean; pPagina: Integer): TObjectList<T>;
var
  FiltroSQL: String;
  DBXConnection: TDBXConnection;
  DBXCommand: TDBXCommand;
  DBXReader: TDBXReader;
  Obj: T;
begin
  try
    ConsultaCompleta := pConsultaCompleta;
    Result := TObjectList<T>.Create;

    try
      if TDBExpress.getBanco = 'Postgres' then
      begin
        if pFiltro <> '' then
        begin
          pFiltro := StringReplace(FormatarFiltro(pFiltro), '"', chr(39), [rfReplaceAll]);
          FiltroSQL := ' and ' + pFiltro;
        end;
      end
      else
      begin
        if pFiltro <> '' then
        begin
          pFiltro := FormatarFiltro(pFiltro);
          FiltroSQL := ' and ' + pFiltro;
        end;
      end;

      DBXConnection := TDBExpress.getConexao.DBXConnection;
      DBXCommand := DBXConnection.CreateCommand;
      DBXCommand.Text := pConsulta + FiltroSQL;
      DBXCommand.Prepare;
      DBXReader := DBXCommand.ExecuteQuery;

      try
        while DBXReader.Next do
        begin
          Obj := TGenericVO<T>.FromDBXReader(DBXReader);
          if ConsultaCompleta then
          begin
            try
              PopularObjetosRelacionados(TJSonVO(Obj));
            finally
            end;
          end;
          Result.Add(Obj);
        end;
      finally
        DBXReader.Free;
      end;

    except
      raise ;
    end;
  finally

  end;
end;

class function TcodeORM.Consultar<T>(pFiltro: String; pPagina: Integer): TJSONArray;
var
  ObjConsulta: TObject;
  Obj: T;
  DBXReader: TDBXReader;
begin
  Result := TJSONArray.Create;
  ObjConsulta := TClass(T).Create;
  try
    try
      DBXReader := Consultar(ObjConsulta, pFiltro, pPagina);
      try
        while DBXReader.Next do
        begin
          Obj := TGenericVO<T>.FromDBXReader(DBXReader);
          try
            PopularObjetosRelacionados(TJSonVO(Obj));
            Result.AddElement(TJSonVO(Obj).ToJSON);
          finally
            TObject(Obj).Free;
          end;
        end;
      finally
        DBXReader.Free;
      end;
    except
      raise ;
    end;
  finally
    ObjConsulta.Free;
  end;
end;

class function TcodeORM.Consultar<T>(pFiltro: String; pPagina: Integer; pConsultaCompleta: Boolean): TJSONArray;
var
  ObjConsulta: TObject;
  Obj: T;
  DBXReader: TDBXReader;
begin
  ConsultaCompleta := pConsultaCompleta;
  Result := TJSONArray.Create;
  ObjConsulta := TClass(T).Create;
  try
    try
      DBXReader := Consultar(ObjConsulta, pFiltro, pPagina);
      try
        while DBXReader.Next do
        begin
          Obj := TGenericVO<T>.FromDBXReader(DBXReader);
          try
            PopularObjetosRelacionados(TJSonVO(Obj));
            TJSonVO(Obj).ToJSON;
            if not ConsultaCompleta then
              AnularObjetosRelacionados(TJSonVO(Obj));
            Result.AddElement(TJSonVO(Obj).ToJSON);
          finally
            TObject(Obj).Free;
          end;
        end;
      finally
        DBXReader.Free;
      end;
    except
      raise ;
    end;
  finally
    ObjConsulta.Free;
  end;
end;

class function TcodeORM.ConsultarUmObjeto<T>(pFiltro: String; pConsultaCompleta: Boolean; pOrderBy : string = ''): T;
var
  DBXReader: TDBXReader;
  ObjConsulta: TObject;
  Obj: T;
begin
  ConsultaCompleta := pConsultaCompleta;
  ObjConsulta := TClass(T).Create;
  try
    DBXReader := Consultar(ObjConsulta, pFiltro, -1, pOrderBy);
    try
      if DBXReader.Next then
      begin
        Obj := TGenericVO<T>.FromDBXReader(DBXReader);
        if ConsultaCompleta then
        begin
          try
            PopularObjetosRelacionados(TJSonVO(Obj));
          finally
          end;
        end;
        Result := Obj;
      end
      else
        Result := Nil;
    finally
      DBXReader.Free;
    end;
  finally
    ObjConsulta.Free;
  end;
end;


class function TcodeORM.Excluir(pId: Integer; pObjeto: TObject; pMsgExcessao: String): Boolean;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  ConsultaSQL, FiltroSQL: String;
  lConteudo: string;
  lNomeTabela: string;
begin
  try
    lNomeTabela := '';
    lConteudo   := 'Houve um erro na insersão do registro de tabelas relacionadas.';

    Contexto := TRttiContext.Create;
    Tipo := Contexto.GetType(pObjeto.ClassType);

    // localiza o nome da tabela
    for Atributo in Tipo.GetAttributes do
    begin
      if Atributo is TTable then
      begin
        lNomeTabela := (Atributo as TTable).Name;

        ConsultaSQL := 'DELETE FROM ' + lNomeTabela;

        lConteudo := lConteudo + #13#10#13#10 + 'Nome tabela: ' + lNomeTabela;
      end;
    end;

    // preenche o filtro
    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        if Atributo is TId then
        begin
          FiltroSQL := ' WHERE ' + (Atributo as TId).NameField + ' = ' + QuotedStr(IntToStr(pId));

          lConteudo := lConteudo + #13#10 + 'Id Excluído: ' + IntToStr(pId);
        end;
      end;
    end;

    lConteudo := lConteudo + #13#10#13#10 + pMsgExcessao;

    ConsultaSQL := ConsultaSQL + FiltroSQL;

    Conexao := TDBExpress.getConexao;
    Query   := TSQLQuery.Create(nil);

    try
      Query.SQLConnection := Conexao;
      Query.sql.Text      := ConsultaSQL;

      Query.ExecSQL();

      Result := True;
    finally
      FreeAndNil(Query);
    end;

  finally
    Contexto.Free;

  end;
end;

class procedure TcodeORM.PopularObjetosRelacionados(pObj: TJSonVO);
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Atributo: TCustomAttribute;
  Propriedade: TRttiProperty;
  NomeTipoObj: String;
  NomeClasseObj: String;
  UnMarshal: TJSONUnMarshal;
  i: Integer;
  Obj: TJSonVO;
  ItemLista: TJSonVO;
  DBXReader: TDBXReader;
  Lista: TObjectList<TJsonVO>;
begin
  Contexto := TRttiContext.Create;
  try
    Tipo := Contexto.GetType(pObj.ClassType);

    // Percorre propriedades
    for Propriedade in Tipo.GetProperties do
    begin
      // Percorre atributos
      for Atributo in Propriedade.GetAttributes do
      begin

        // Verifica se o atributo é um atributo de associação para muitos
        if Atributo is TManyValuedAssociation then
        begin
          // Se for uma consulta completa, carrega as listas
          if ConsultaCompleta then
          begin
            // Se a propriedade for uma classe
            if Propriedade.PropertyType.TypeKind = tkClass then
            begin
              NomeTipoObj := Propriedade.PropertyType.Name;
              if (Pos('TList', NomeTipoObj) > 0) or (Pos('TObjectList', NomeTipoObj) > 0) then
              begin
                // Captura o tipo de classe da lista (TList<Unit.TNomeClasse>)
                i := Pos('<', NomeTipoObj);
                NomeClasseObj := Copy(NomeTipoObj, i + 1, Length(NomeTipoObj) - 1 - i);

                // Usa o UnMarshal para criar o objeto
                UnMarshal := TJSONUnMarshal.Create;
                try
                  // Cria objeto temporário
                  Obj := UnMarshal.ObjectInstance(Contexto, NomeClasseObj) as TJSonVO;
                  if Assigned(Obj) then
                  begin
                    Lista := TObjectList<TJsonVO>(Propriedade.GetValue(pObj).AsObject);

                    // Se a lista tiver sido instanciada
                    if Assigned(Lista) then
                    begin
                      // Consulta a lista de objetos
                      DBXReader := Consultar(Obj, (Atributo as TManyValuedAssociation).ForeingColumn + ' = ' + QuotedStr( String( ValorPropriedadeObjeto(pObj, (Atributo as TManyValuedAssociation).LocalColumn))), -1);
                      try
                        while DBXReader.Next do
                        begin
                          // Cria nova instância do objeto temporário
                          ItemLista := Obj.NewInstance as TJSonVO;
                          // Popula Objeto
                          ItemLista := VOFromDBXReader(ItemLista, DBXReader);
                          // Inclui objeto na lista
                          Lista.Add(ItemLista);

                          // se o campo estiver anotado para pegar as demais relações, continua populando os objetos
                          if (Atributo as TManyValuedAssociation).GetRelations then
                          begin
                            PopularObjetosRelacionados(ItemLista);
                          end
                        end;
                      finally
                        DBXReader.Free;
                      end;
                    end;
                    // Destroi objeto temporário
                    Obj.Free;
                  end;
                finally
                  UnMarshal.Free;
                end;
              end;
            end;
          end;
        end

        // Verifica se o atributo é um atributo de associação para uma classe
        else if Atributo is TAssociation then
        begin
          // Se a propriedade for uma classe
          if Propriedade.PropertyType.TypeKind = tkClass then
          begin
            // Captura o tipo de classe da lista (Unit.TNomeClasse)
            NomeClasseObj := Propriedade.PropertyType.QualifiedName;

            // Verifica se o objeto já está instanciado
            Obj := Propriedade.GetValue(pObj).AsObject as TJSonVO;
            // Se ele não estiver instanciado
            if not Assigned(Obj) then
            begin
              // Usa o UnMarshal para criar o objeto
              UnMarshal := TJSONUnMarshal.Create;
              try
                // Cria objeto
                Obj := UnMarshal.ObjectInstance(Contexto, NomeClasseObj) as TJSonVO;
              finally
                UnMarshal.Free;
              end;
            end;

            // Se conseguiu capturar uma instância do objeto, popula...
            if Assigned(Obj) then
            begin
              // Consulta o objeto relacionado
              DBXReader := Consultar(Obj, (Atributo as TAssociation).ForeingColumn + ' = ' + QuotedStr( String( ValorPropriedadeObjeto(pObj, (Atributo as TAssociation).LocalColumn))), 0);
              try
                if DBXReader.Next then
                begin
                  // Popula Objeto
                  Obj := VOFromDBXReader(Obj, DBXReader);
                  // Inclui objeto no objeto principal
                  Propriedade.SetValue(pObj, Obj);
                  // se o campo estiver anotado para pegar as demais relações, continua populando os objetos
                  if (Atributo as TAssociation).GetRelations then
                  begin
                    PopularObjetosRelacionados(TJSonVO(Obj));
                  end
                  // senão, anula objetos relacionados
                  else
                  begin
                    AnularObjetosRelacionados(TJSonVO(Obj));
                  end;
                end;
              finally
                DBXReader.Free;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    Contexto.Free;
 end;
end;

class procedure TcodeORM.AnularObjetosRelacionados(pObj: TJSonVO);
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Atributo: TCustomAttribute;
  Propriedade: TRttiProperty;
begin
  Contexto := TRttiContext.Create;
  try
    Tipo := Contexto.GetType(pObj.ClassType);

    // Percorre propriedades
    for Propriedade in Tipo.GetProperties do
    begin
      // Percorre atributos
      for Atributo in Propriedade.GetAttributes do
      begin
        // Verifica se o atributo é um atributo de associação para muitos
        if Atributo is TManyValuedAssociation then
        begin
          Propriedade.SetValue(pObj, nil);
        end
        // Verifica se o atributo é um atributo de associação para uma classe
        else if Atributo is TAssociation then
        begin
          Propriedade.SetValue(pObj, nil);
        end;
      end;
    end;
  finally
    Contexto.Free;
  end;
end;

class function TcodeORM.ComandoSQL(pConsulta: String): Boolean;
begin
  try
    Conexao := TDBExpress.getConexao;
    Query   := TSQLQuery.Create(nil);

    try
      Query.SQLConnection := Conexao;
      Query.sql.Text      := pConsulta;

      Query.ExecSQL();

      Result := True;
    finally
      FreeAndNil(Query);
    end;

  except
    Result := False;
  end;
end;

class function TcodeORM.SelectMax(pTabela: String; pFiltro: String): Integer;
var
  ConsultaSQL: String;
begin
  ConsultaSQL := 'SELECT MAX(ID) AS MAXIMO FROM ' + pTabela;
  if pFiltro <> '' then
    ConsultaSQL := ConsultaSQL + ' WHERE ' + pFiltro;
  try
    Conexao := TDBExpress.getConexao;
    Query   := TSQLQuery.Create(nil);

    try
      Query.SQLConnection := Conexao;
      Query.sql.Text      := ConsultaSQL;

      Query.Open;

      if Query.RecordCount > 0 then
        Result := Query.FieldByName('MAXIMO').AsInteger
      else
        Result := -1;
    finally
      FreeAndNil(Query);
    end;

  except
    Result := -1;
  end;
end;

class function TcodeORM.SelectMin(pTabela: String; pFiltro: String): Integer;
var
  ConsultaSQL: String;
begin
  ConsultaSQL := 'SELECT MIN(ID) AS MINIMO FROM ' + pTabela;
  if pFiltro <> '' then
    ConsultaSQL := ConsultaSQL + ' WHERE ' + pFiltro;
  try
    Conexao := TDBExpress.getConexao;
    Query   := TSQLQuery.Create(nil);

    try
      Query.SQLConnection := Conexao;
      Query.sql.Text      := ConsultaSQL;

      Query.Open;

      if Query.RecordCount > 0 then
        Result := Query.FieldByName('MINIMO').AsInteger
      else
        Result := -1;
    finally
      FreeAndNil(Query);
    end;

  except
    Result := -1;
  end;
end;

class function TcodeORM.SelectSun(pTabela, pFiltro, pCampo: String): Extended;
var
  ConsultaSQL : String;
begin
  ConsultaSQL := 'SELECT SUM('+pCampo+') AS SOMA FROM ' + pTabela;

  if (pFiltro <> '') then
    ConsultaSQL := ConsultaSQL + ' WHERE ' + pFiltro;

  try
    Conexao := TDBExpress.getConexao;
    Query   := TSQLQuery.Create(nil);

    try
      Query.SQLConnection := Conexao;
      Query.sql.Text      := ConsultaSQL;

      Query.Open;

      if (Query.RecordCount > 0) then
        Result := Query.FieldByName('SOMA').AsFloat
      else
        Result := 0;

    finally
      FreeAndNil(Query);
    end;

  except
    Result := 0;
  end;
end;

end.
