unit Controller;

interface

uses
  Classes, SysUtils, Forms, Windows, DB, DBClient, IWSystem,
  JSonVO, Rtti, Atributos, StrUtils, TypInfo, Generics.Collections,
  DBXJSON, JSON,
  SessaoUsuario, codeORM,
  Biblioteca;

type
  TController = class
  private
    class function MontaParametros(pParametros: array of String): String;
    class function UrlFormatada(pClassCtx, pMethodCtx: String): String;
  public
    class function Delete(pClassCtx, pMethodCtx: String; pParametros: array of String): String; overload;
    class function Delete(pMethodCtx: String; pParametros: array of String): String; overload;
    class function Delete(pParametros: array of String): String; overload;

    class procedure Get(pClassCtx, pMethodCtx: String; pParametros: array of String; pStreamResposta: TStringStream); overload;
    class procedure Get(pMethodCtx: String; pParametros: array of String; pStreamResposta: TStringStream); overload;
    class procedure Get(pParametros: array of String; pStreamResposta: TStringStream); overload;

    class procedure Post(pClassCtx, pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream); overload;
    class procedure Post(pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream); overload;
    class procedure Post(pParametros: array of String; pDataStream, pStreamResposta: TStringStream); overload;

    class procedure Put(pClassCtx, pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream); overload;
    class procedure Put(pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream); overload;
    class procedure Put(pParametros: array of String; pDataStream, pStreamResposta: TStringStream); overload;

    class function GetDataSet: TClientDataSet; virtual;
    class procedure SetDataSet(pDataSet: TClientDataSet); virtual;

    class function VO<O: class>(pId: Integer): O; overload;
    class function VO<O: class>(pCampo: String; pValor: String): O; overload;
    class function VO<O: class>(pFiltro: String): O; overload;

    class function DownloadArquivo(pArquivo: String; pModulo: String): String;
  protected
    class function Sessao: TSessaoUsuario;
    class function MethodCtx: String; virtual;

  (*  class procedure PopulaGrid<O: class>(pStreamResposta: TStringStream); overload;
    class procedure PopulaGrid<O: class>(pStreamResposta: TStringStream; pLimparDataSet: Boolean); overload;
    class procedure PopulaGrid<O: class>(pListaObjetos: TObjectList<O>); overload;
    class procedure PopulaGrid<O: class>(pListaObjetos: TObjectList<O>; pLimparDataSet: Boolean); overload;*)
  end;

  TClassController = class of TController;

implementation

//uses Conversor, AuditoriaVO, AuditoriaController;
{ TController }

{$REGION 'Excluir'}
class function TController.Delete(pClassCtx, pMethodCtx: String; pParametros: array of String): String;
var
  Url: String;
  ObjResposta: TJSONObject;
  ParResposta: TJSONPair;
  ArrayResposta: TJSONArray;
begin
 (* try
    try
      Url := UrlFormatada(pClassCtx, pMethodCtx) + MontaParametros(pParametros);

      Result := Sessao.HTTP.Delete(Url);

      // se o array que retornou contém um erro, gera uma exceção
      ObjResposta := TJSONObject.Create;
      ObjResposta.Parse(TEncoding.ASCII.GetBytes(Result), 0);
      ParResposta := ObjResposta.Get(0);
      ArrayResposta := TJSONArray(TJSONArray(ParResposta.JsonValue).Get(0));

      if ArrayResposta.ToString = '[true]' then
      begin
        Result := '{"result":[true]}';
      end
      else
      begin
        if ArrayResposta.Get(0).ToString = '"ERRO"' then
        begin
          raise Exception.Create(ArrayResposta.Get(1).ToString);
        end;
      end;
    except
      raise ;
    end;
  finally
    ObjResposta.Free;
  end;

  *)
end;

class function TController.Delete(pMethodCtx: String; pParametros: array of String): String;
begin
  Result := Delete(Self.ClassName, pMethodCtx, pParametros);
end;

class function TController.Delete(pParametros: array of String): String;
begin
  Result := Delete(MethodCtx, pParametros);
end;
{$ENDREGION}

{$REGION 'Consultar'}
class procedure TController.Get(pClassCtx, pMethodCtx: String; pParametros: array of String; pStreamResposta: TStringStream);
var
  Url: String;
  ObjResposta: TJSONObject;
  ParResposta: TJSONPair;
  ArrayResposta: TJSONArray;
begin
  try
    try
      Url := UrlFormatada(pClassCtx, pMethodCtx) + MontaParametros(pParametros);
      Sessao.HTTP.Get(Url, pStreamResposta);

      // se o array que retornou contém um erro, gera uma exceção
      ObjResposta := TJSONObject.Create;
      ObjResposta.Parse(pStreamResposta.Bytes, 0);
      ParResposta := ObjResposta.Get(0);
      ArrayResposta := TJSONArray(TJSONArray(ParResposta.JsonValue).Get(0));
      if ArrayResposta.Size > 0 then
      begin
        if ArrayResposta.Get(0).ToString = '"ERRO"' then
        begin
          raise Exception.Create(ArrayResposta.Get(1).ToString);
        end;
      end;
    except
      raise ;
    end;
  finally
    ObjResposta.Free;
  end;
end;

class procedure TController.Get(pMethodCtx: String; pParametros: array of String; pStreamResposta: TStringStream);
begin
  Get(Self.ClassName, pMethodCtx, pParametros, pStreamResposta);
end;

class procedure TController.Get(pParametros: array of String; pStreamResposta: TStringStream);
begin
  Get(MethodCtx, pParametros, pStreamResposta);
end;
{$ENDREGION}

{$REGION 'Alterar'}
class procedure TController.Post(pClassCtx, pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream);
var
  Url: String;
  ObjResposta: TJSONObject;
  ParResposta: TJSONPair;
  ArrayResposta: TJSONArray;
begin
  try
    try
      Url := UrlFormatada(pClassCtx, pMethodCtx) + MontaParametros(pParametros);
      Sessao.HTTP.Post(Url, pDataStream, pStreamResposta);

      // se o array que retornou contém um erro, gera uma exceção
      ObjResposta := TJSONObject.Create;
      ObjResposta.Parse(pStreamResposta.Bytes, 0);
      ParResposta := ObjResposta.Get(0);
      ArrayResposta := TJSONArray(TJSONArray(ParResposta.JsonValue).Get(0));
      if ArrayResposta.Get(0).ToString = '"ERRO"' then
      begin
        raise Exception.Create(ArrayResposta.Get(1).ToString);
      end;
    except
      raise ;
    end;
  finally
    ObjResposta.Free;
  end;
end;

class procedure TController.Post(pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream);
begin
  Post(Self.ClassName, pMethodCtx, pParametros, pDataStream, pStreamResposta);
end;

class procedure TController.Post(pParametros: array of String; pDataStream, pStreamResposta: TStringStream);
begin
  Post(MethodCtx, pParametros, pDataStream, pStreamResposta);
end;
{$ENDREGION}

{$REGION 'Inserir'}
class procedure TController.Put(pClassCtx, pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream);
var
  Url: String;
  ObjResposta: TJSONObject;
  ParResposta: TJSONPair;
  ArrayResposta: TJSONArray;
begin
  try
    try
      Url := UrlFormatada(pClassCtx, pMethodCtx) + MontaParametros(pParametros);
      Sessao.HTTP.Put(Url, pDataStream, pStreamResposta);

      // se o array que retornou contém um erro, gera uma exceção
      ObjResposta := TJSONObject.Create;
      ObjResposta.Parse(pStreamResposta.Bytes, 0);
      ParResposta := ObjResposta.Get(0);
      ArrayResposta := TJSONArray(TJSONArray(ParResposta.JsonValue).Get(0));
      if ArrayResposta.Get(0).ToString = '"ERRO"' then
      begin
        raise Exception.Create(ArrayResposta.Get(1).ToString);
      end;
    except
      raise ;
    end;
  finally
    ObjResposta.Free;
  end;
end;

class procedure TController.Put(pMethodCtx: String; pParametros: array of String; pDataStream, pStreamResposta: TStringStream);
begin
  Put(Self.ClassName, pMethodCtx, pParametros, pDataStream, pStreamResposta);
end;

class procedure TController.Put(pParametros: array of String; pDataStream, pStreamResposta: TStringStream);
begin
  Put(MethodCtx, pParametros, pDataStream, pStreamResposta);
end;
{$ENDREGION}

class function TController.GetDataSet: TClientDataSet;
begin
  Result := nil;
  // Implementar nas classes filhas
end;

class function TController.Sessao: TSessaoUsuario;
begin
  Result := TSessaoUsuario.Instance;
end;

class procedure TController.SetDataSet(pDataSet: TClientDataSet);
begin
  //
end;

class function TController.MontaParametros(pParametros: array of String): String;
var
  Parametro: String;
  I: Integer;
begin
  Result := '';

  for I := 0 to Length(pParametros) - 1 do
  begin
    Parametro := pParametros[I];
    // Inverte a barra, pois ela é o delimitador dos parâmetros no Rest
    Parametro := StringReplace(Parametro, '/', '|', [rfReplaceAll]);

    Parametro := StringReplace(Parametro, '\|', '/', [rfReplaceAll]);

    // Troca o "%" pelo "*"
    Parametro := StringReplace(Parametro, '%', '*', [rfReplaceAll]);

    // Troca o """ pelo "\""
    Parametro := StringReplace(Parametro, '"', '\"', [rfReplaceAll]);

    if Parametro <> '' then
    begin
      Result := Result + Parametro + '/';
    end;
  end;

  if Result <> '' then
  begin
    // Remove a última barra
    Result := Copy(Result, 1, Length(Result) - 1);
  end;
end;

class function TController.UrlFormatada(pClassCtx, pMethodCtx: String): String;
begin
  if Sessao.IdSessao = '' then
    raise Exception.Create('Sessão não criada.');

  Result := Sessao.Url + pClassCtx + '/' + pMethodCtx + '/' + Sessao.IdSessao + '/';
end;

class function TController.MethodCtx: String;
begin
  // Implementar nos controllers filhos
end;


(*
class procedure TController.PopulaGrid<O>(pStreamResposta: TStringStream; pLimparDataSet: Boolean);
var
  jItems: TJSONArray;
  jItem: TJSONValue;
  I: Integer;
  ObjetoVO: O;
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  Metodo: TRttiMethod;
  Params: TArray<TRttiParameter>;
  DataSetField: TField;
  DataSet: TClientDataSet;
  EncontrouConstrutor: Boolean;
  NomeDominio, ValorCampoDominio: String;
begin
  DataSet := GetDataSet;

  if not Assigned(DataSet) then
    Exit;

  jItems := TConversor.JSONArrayStreamToJSONArray(pStreamResposta);
  try
    DataSet.DisableControls;
    if pLimparDataset then
      DataSet.EmptyDataSet;

    try
      Contexto := TRttiContext.Create;
      Tipo := Contexto.GetType(TClass(O));

      for I := 0 to jItems.Size - 1 do
      begin
        jItem := jItems.Get(I);

        // Procura método construtor da classe
        EncontrouConstrutor := False;
        for Metodo in Tipo.GetMethods do
        begin
          if Metodo.Name = 'Create' then
          begin
            Params := Metodo.GetParameters;
            if Length(Params) = 1 then
            begin
              if Params[0].Name = 'pJsonValue' then
              begin
                EncontrouConstrutor := True;
                Break;
              end;
            end;
          end;
        end;

        // Se tiver encontrado o método contrutor da classe
        if EncontrouConstrutor then
          ObjetoVO := O(Metodo.Invoke(Tipo.AsInstance.MetaclassType, [jItem]).AsObject)
        else
          ObjetoVO := TJSonVO.JSONToObject<O>(jItem);
        try
          DataSet.Append;

          for Propriedade in Tipo.GetProperties do
          begin
            for Atributo in Propriedade.GetAttributes do
            begin
              if Atributo is TColumn then
              begin
                DataSetField := DataSet.FindField((Atributo as TColumn).Name);
                if Assigned(DataSetField) then
                begin
                  if Propriedade.PropertyType.TypeKind in [tkEnumeration] then
                    DataSetField.AsBoolean := Propriedade.GetValue(TObject(ObjetoVO)).AsBoolean
                  else
                    DataSetField.Value := Propriedade.GetValue(TObject(ObjetoVO)).AsVariant;

                  if DataSetField.DataType = ftDateTime then
                  begin
                    if DataSetField.AsDateTime = 0 then
                      DataSetField.Clear;
                  end;
                end;
              end
              else if Atributo is TId then
              begin
                DataSetField := DataSet.FindField((Atributo as TId).NameField);
                if Assigned(DataSetField) then
                begin
                  DataSetField.Value := Propriedade.GetValue(TObject(ObjetoVO)).AsVariant;
                end;
              end;

              // Domínios
              //Pedro - 20/06/2014
              if Atributo is TDomain then
              begin
                if Assigned(DataSetField) then
                begin
                  NomeDominio := (Atributo as TDomain).Name;
                  ValorCampoDominio := Dominios.Find(NomeDominio, DataSetField.Value);
                  DataSetField.Value := ValorCampoDominio;
                end;
              end
            end;
          end;
        finally
          TObject(ObjetoVO).Free;
        end;

        DataSet.Post;
      end;
    finally
      Contexto.Free;
    end;

    DataSet.Open;
    DataSet.First;
  finally
    jItems.Free;
    DataSet.EnableControls;
  end;
end;

class procedure TController.PopulaGrid<O>(pStreamResposta: TStringStream);
begin
  PopulaGrid<O>(pStreamResposta, True);
end;

class procedure TController.PopulaGrid<O>(pListaObjetos: TObjectList<O>; pLimparDataSet: Boolean);
var
  I: Integer;
  ObjetoVO: O;
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  Metodo: TRttiMethod;
  Params: TArray<TRttiParameter>;
  DataSetField: TField;
  DataSet: TClientDataSet;
  NomeDominio, ValorCampoDominio: String;
begin
  DataSet := GetDataSet;

  if not Assigned(DataSet) then
    Exit;

  try
    DataSet.DisableControls;
    if pLimparDataset then
      DataSet.EmptyDataSet;

    try
      Contexto := TRttiContext.Create;
      Tipo := Contexto.GetType(TClass(O));

      for I := 0 to pListaObjetos.Count - 1 do
      begin
        ObjetoVO := O(pListaObjetos[i]);

        try
          DataSet.Append;

          for Propriedade in Tipo.GetProperties do
          begin
            for Atributo in Propriedade.GetAttributes do
            begin
              if Atributo is TColumn then
              begin
                DataSetField := DataSet.FindField((Atributo as TColumn).Name);
                if Assigned(DataSetField) then
                begin
                  if Propriedade.PropertyType.TypeKind in [tkEnumeration] then
                    DataSetField.AsBoolean := Propriedade.GetValue(TObject(ObjetoVO)).AsBoolean
                  else
                    DataSetField.Value := Propriedade.GetValue(TObject(ObjetoVO)).AsVariant;

                  if DataSetField.DataType = ftDateTime then
                  begin
                    if DataSetField.AsDateTime = 0 then
                      DataSetField.Clear;
                  end;
                end;
              end
              else if Atributo is TId then
              begin
                DataSetField := DataSet.FindField((Atributo as TId).NameField);
                if Assigned(DataSetField) then
                begin
                  DataSetField.Value := Propriedade.GetValue(TObject(ObjetoVO)).AsVariant;
                end;
              end;

              // Domínios
              //Pedro - 20/06/2014
              if Atributo is TDomain then
              begin
                if Assigned(DataSetField) then
                begin
                  NomeDominio := (Atributo as TDomain).Name;
                  ValorCampoDominio := Dominios.Find(NomeDominio, DataSetField.Value);
                  DataSetField.Value := ValorCampoDominio;
                end;
              end
            end;
          end;
        finally
          TObject(ObjetoVO).Free;
        end;

        DataSet.Post;
      end;
    finally
      Contexto.Free;
    end;

    DataSet.Open;
    DataSet.First;
  finally
    DataSet.EnableControls;
  end;
end;

class procedure TController.PopulaGrid<O>(pListaObjetos: TObjectList<O>);
begin
  PopulaGrid<O>(pListaObjetos, True);
end;

*)

class function TController.VO<O>(pId: Integer): O;
var
  StreamResposta: TStringStream;
  jItems: TJSONArray;
  jItem: TJSONValue;

  Contexto: TRttiContext;
  Tipo: TRttiType;
  Metodo: TRttiMethod;
  Params: TArray<TRttiParameter>;
  EncontrouConstrutor: Boolean;
begin
  try
    Result := TcodeORM.ConsultarUmObjeto<O>('ID=' + IntToStr(pId), True);
  except
    on E: Exception do
      Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
  end;
end;

class function TController.VO<O>(pCampo: String; pValor: String): O;
var
  StreamResposta: TStringStream;
  jItems: TJSONArray;
  jItem: TJSONValue;

  Contexto: TRttiContext;
  Tipo: TRttiType;
  Metodo: TRttiMethod;
  Params: TArray<TRttiParameter>;
  EncontrouConstrutor: Boolean;
begin
  try
    Result := TcodeORM.ConsultarUmObjeto<O>(pCampo + '=' + pValor, True);
  except
    on E: Exception do
      Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
  end;
end;

class function TController.VO<O>(pFiltro: String): O;
var
  StreamResposta: TStringStream;
  jItems: TJSONArray;
  jItem: TJSONValue;

  Contexto: TRttiContext;
  Tipo: TRttiType;
  Metodo: TRttiMethod;
  Params: TArray<TRttiParameter>;
  EncontrouConstrutor: Boolean;
begin
  try
    Result := TcodeORM.ConsultarUmObjeto<O>(pFiltro, True);
  except
    on E: Exception do
      Application.MessageBox(PChar('Ocorreu um erro durante a consulta. Informe a mensagem ao Administrador do sistema.' + #13 + #13 + E.Message), 'Erro do sistema', MB_OK + MB_ICONERROR);
  end;
end;

class function TController.DownloadArquivo(pArquivo: String; pModulo: String): String;
var
  ArquivoStream, StreamResposta: TStringStream;
  ArrayStringsArquivo: TStringList;
  ArquivoBytes: Tbytes;
  I: Integer;
  ObjResposta: TJSONObject;
  ParResposta: TJSONPair;
  ArrayResposta: TJSONArray;
  ArquivoBytesString, TipoArquivo: String;

  function DownloadArquivo_Local: TStringStream;
  var
    i: Integer;
    Arquivo, BytesArquivo: String;
  begin
    (* Pedro - 16/062014
       Método igual do servidor 3 camadas para ser usado em 2 camadas.  *)
    try
      try
        Result := TStringStream.Create;

        ArquivoStream := TStringStream.Create;

        if pModulo = 'GED' then
          Arquivo := StringReplace(pArquivo,'|','\',[rfReplaceAll])
        else if pModulo = 'PRODUTO' then
          Arquivo := gsAppPath + 'Arquivos\Produtos\' + pArquivo
        else if pModulo = 'SPED' then
          Arquivo := gsAppPath + 'Arquivos\Sped\' + pArquivo
        else if pModulo = 'SINTEGRA' then
          Arquivo := gsAppPath + 'Arquivos\Sintegra\' + pArquivo
        else if pModulo = 'CONTRATOS' then
          Arquivo := gsAppPath + 'Arquivos\Contratos\' + pArquivo
        else if pModulo = 'CONTRATOS_TEMPLATE' then
          Arquivo := gsAppPath + 'Arquivos\Contratos\Templates\' + pArquivo;

        if FileExists(Arquivo) then
        begin
          ArquivoStream.LoadFromFile(Arquivo);

          BytesArquivo := '';

          // laço pra pegar os bytes do arquivo ou imagem
          for i := 0 to ArquivoStream.Size - 1 do
          begin
            BytesArquivo := BytesArquivo + IntToStr(ArquivoStream.Bytes[i]) + ', ';
          end;
          // Tira a ultima virgula
          System.Delete(BytesArquivo, Length(BytesArquivo) - 1, 2);

          TipoArquivo := ExtractFileExt(pArquivo);

          Result := ArquivoStream;
        end
        else
        begin
           result.Clear;
        end;
      except
        result.Clear;
      end;
    finally
    end;
  end;

begin
  Result := '';

  if Sessao.Camadas = 3 then
  begin
    try
      try
        StreamResposta := TStringStream.Create;
        ArquivoStream := TStringStream.Create;

        Get('TDownloadArquivoController', 'DownloadArquivo', [pArquivo, pModulo], StreamResposta);

        ObjResposta := TJSONObject.Create;
        ObjResposta.Parse(StreamResposta.Bytes, 0);
        ParResposta := ObjResposta.Get(0);
        ArrayResposta := TJSONArray(TJSONArray(ParResposta.JsonValue).Get(0));

        if ArrayResposta.Get(0).ToString <> '"RESPOSTA"' then
        begin
          // na posicao zero temos o arquivo enviado
          ArquivoBytesString := (ArrayResposta as TJSONArray).Get(0).ToString;
          // retira as aspas do JSON
          System.Delete(ArquivoBytesString, Length(ArquivoBytesString), 1);
          System.Delete(ArquivoBytesString, 1, 1);

          // na posicao um temos o tipo de arquivo enviado
          TipoArquivo := (ArrayResposta as TJSONArray).Get(1).ToString;
          // retira as aspas do JSON
          System.Delete(TipoArquivo, Length(TipoArquivo), 1);
          System.Delete(TipoArquivo, 1, 1);

          // salva o arquivo enviado em disco de forma temporaria
          ArrayStringsArquivo := TStringList.Create;
          Split(',', ArquivoBytesString, ArrayStringsArquivo);

          SetLength(ArquivoBytes, ArrayStringsArquivo.Count);

          for I := 0 to ArrayStringsArquivo.Count - 1 do
          begin
            ArquivoBytes[I] := StrToInt(ArrayStringsArquivo[I]);
          end;
          ArquivoStream := TStringStream.Create(ArquivoBytes);
          ArquivoStream.SaveToFile(gsAppPath + 'temp' + TipoArquivo);

          Result := gsAppPath + 'temp' + TipoArquivo;
        end;
      except
        Result := '';
      end;
    finally
      if Assigned(StreamResposta) then
        StreamResposta.Free;
      if Assigned(ArquivoStream) then
        ArquivoStream.Free;
      if Assigned(ArrayStringsArquivo) then
        ArrayStringsArquivo := Nil;
      if Assigned(ObjResposta) then
        ObjResposta.Free;
    end;
  end
  else
  begin
    try
      try
        ArquivoStream := TStringStream.Create;
        ArquivoStream := DownloadArquivo_Local;

        if ArquivoStream.Size > 0 then
        begin
          ArquivoBytesString := '';
          for i := 0 to ArquivoStream.Size - 1 do
          begin
            ArquivoBytesString := ArquivoBytesString + IntToStr(ArquivoStream.Bytes[i]) + ', ';
          end;

          // salva o arquivo enviado em disco de forma temporaria
          ArrayStringsArquivo := TStringList.Create;
          Split(',', ArquivoBytesString, ArrayStringsArquivo);

          SetLength(ArquivoBytes, ArrayStringsArquivo.Count);

          for I := 0 to ArrayStringsArquivo.Count - 1 do
          begin
            ArquivoBytes[I] := StrToInt(ArrayStringsArquivo[I]);
          end;

          ArquivoStream := TStringStream.Create(ArquivoBytes);
          ArquivoStream.SaveToFile(gsAppPath + 'temp' + TipoArquivo);

          Result := gsAppPath + 'temp' + TipoArquivo;
        end;
      except
        Result := '';
      end;
    finally
      if Assigned(StreamResposta) then
        StreamResposta.Free;
      if Assigned(ArquivoStream) then
        ArquivoStream.Free;
      if Assigned(ArrayStringsArquivo) then
        ArrayStringsArquivo := Nil;
    end;
  end;
end;

end.
