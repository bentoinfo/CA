unit Biblioteca;

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Windows,
  Inifiles, DBClient, DB, SqlExpr, DBXMySql, Grids, DBGrids,
  IdHashMessageDigest, Math, JSonVO, Rtti, TypInfo,
  IWSystem, DBXJSON, Atributos, StrUtils, Printers;

  //Constantes

  function ExtraiCamposFiltro(pFiltro: String): TStringList;

  procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
  procedure ConfiguraCDSFromVO(cds: TClientDataSet; VOClass: TClassJsonVO);

var
  InString: String;

implementation

function ExtraiCamposFiltro(pFiltro: String): TStringList;
var
  Campo, Filtro: String;
  i, Posicao: integer;
begin
  try
    Filtro := pFiltro;
    Result := TStringList.Create;
    i := 1;
    while i <= Length(Filtro) do
    begin
      if Copy(Filtro, i, 1) = '[' then
      begin
        Posicao := Pos(']', Filtro);
        Campo := Copy(Filtro, i, Posicao - i);
        Campo := StringReplace(Campo, '[', '', [rfReplaceAll]);
        Campo := StringReplace(Campo, ']', '', [rfReplaceAll]);
        Delete(Filtro, i, Posicao);
        i := 0;
        Result.add(Campo);
      end;
      inc(i);
    end;
  finally
  end;
end;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
  Assert(Assigned(Strings));
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.DelimitedText := Input;
end;

procedure ConfiguraCDSFromVO(cds: TClientDataSet; VOClass: TClassJsonVO);
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Propriedade: TRttiProperty;
  Atributo: TCustomAttribute;
  NomeTipo: string;

  function LengthAtributo(pColumn: Atributos.TColumn): integer;
  begin
    if pColumn.Length > 0 then
      Result := pColumn.Length
    else
      Result := 50;
  end;

begin
  try
    Contexto := TRttiContext.Create;
    Tipo := Contexto.GetType(VOClass);

    // Configura ClientDataset
    cds.Close;
    cds.FieldDefs.Clear;
    cds.IndexDefs.Clear;

    // Preenche os nomes dos campos do CDS
    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin
        if Atributo is TId then
        begin
          cds.FieldDefs.add('ID', ftInteger);
        end
        else if Atributo is Atributos.TColumn then
        begin
          if Propriedade.PropertyType.TypeKind in [tkString, tkUString] then
          begin
            cds.FieldDefs.add((Atributo as Atributos.TColumn).Name, ftString, LengthAtributo(Atributo as Atributos.TColumn));
          end
          else if Propriedade.PropertyType.TypeKind in [tkFloat] then
          begin
            NomeTipo := LowerCase(Propriedade.PropertyType.Name);
            if NomeTipo = 'tdatetime' then
              cds.FieldDefs.add((Atributo as Atributos.TColumn).Name, ftDateTime)
            else
              cds.FieldDefs.add((Atributo as Atributos.TColumn).Name, ftFloat);
          end
          else if Propriedade.PropertyType.TypeKind in [tkInt64, tkInteger] then
          begin
            cds.FieldDefs.add((Atributo as Atributos.TColumn).Name, ftInteger);
          end
          else if Propriedade.PropertyType.TypeKind in [tkEnumeration] then
          begin
            cds.FieldDefs.add((Atributo as TColumn).Name, ftBoolean);
          end;
        end;
      end;
    end;
    cds.CreateDataSet;

    for Propriedade in Tipo.GetProperties do
    begin
      for Atributo in Propriedade.GetAttributes do
      begin

        if Atributo is TColumn then
          NomeTipo := (Atributo as TColumn).Name;
        if Atributo is TId then
          NomeTipo := (Atributo as TId).NameField;

        if Atributo is TFormatter then
        begin
          // Máscaras
          if Propriedade.PropertyType.TypeKind in [tkInt64, tkInteger] then
            TNumericField(cds.FieldByName(NomeTipo)).DisplayFormat := (Atributo as Atributos.TFormatter).Formatter;
          if Propriedade.PropertyType.TypeKind in [tkFloat] then
            TNumericField(cds.FieldByName(NomeTipo)).DisplayFormat := (Atributo as Atributos.TFormatter).Formatter;
          if Propriedade.PropertyType.TypeKind in [tkString, tkUString] then
            TStringField(cds.FieldByName(NomeTipo)).EditMask := (Atributo as Atributos.TFormatter).Formatter;
          // Alinhamento
          TStringField(cds.FieldByName(NomeTipo)).Alignment := (Atributo as TFormatter).Alignment;
        end;
      end;
    end;

  finally
    Contexto.Free;
  end;
end;

end.

