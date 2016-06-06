{ *******************************************************************************
Title: Controle de Abastecimento
Description: Conex�o DataBase

@author Pedro Bento (bentoinfo@oi.com.br)
@version 1.0
*******************************************************************************}
unit ConexaoBD;

interface

uses Classes, SQLExpr, WideStrings, DB, SysUtils, DBXMySql, DBXFirebird,
     DBXInterbase, DBXMsSQL, DBXOracle, DbxDb2, IWSystem;

type

  TDBExpress = class(TSQLConnection)
  private
    class var Banco: String;
    class var Conexao: TSQLConnection;
    class procedure ConfigurarConexao(var pConexao: TSQLConnection; pBD: String);
  public
    class procedure Conectar(BD: String);
    class procedure Desconectar;
    class function getConexao: TSQLConnection;
    class function getBanco: String;
  end;

implementation

class procedure TDBExpress.Conectar(BD: String);
begin
  if Assigned(Conexao) then
    Exit;

  Conexao := TSQLConnection.Create(nil);
  ConfigurarConexao(Conexao, BD);
  Conexao.KeepConnection := True;
  Conexao.AutoClone := False;
  Conexao.Connected := True;
  Banco := BD;
end;

class procedure TDBExpress.Desconectar;
begin
  if Assigned(Conexao) then
  begin
    Conexao.Connected := False;
    FreeAndNil(Conexao); //Pedro - 30/09/2014
  end;
end;

class function TDBExpress.getBanco: String;
begin
  Result := Banco;
end;

class function TDBExpress.getConexao: TSQLConnection;
begin

  Result := Conexao;
end;

class procedure TDBExpress.ConfigurarConexao(var pConexao: TSQLConnection; pBD: String);
var
  Arquivo: String;
  Parametros: TStrings;
begin
  if pBD = 'Oracle' then
  begin
    //carrega o arquivo de parametros (neste caso o do MySQL)
    Arquivo := gsAppPath + 'Oracle_DBExpress_conn.txt';

    Conexao.DriverName     := 'Oracle';
    Conexao.ConnectionName := 'OracleConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverORACLE';
    Conexao.LibraryName    := 'dbxora.dll';
    Conexao.VendorLib      := 'oci.dll';
  end
  else
  if pBD = 'MSSQL' then
  begin
    //carrega o arquivo de parametros (neste caso o do MySQL)
    Arquivo := gsAppPath + 'MSSQL_DBExpress_conn.txt';

    Conexao.DriverName     := 'MSSQL';
    Conexao.ConnectionName := 'MSSQLCONNECTION';
    Conexao.GetDriverFunc  := 'getSQLDriverMSSQL';
    Conexao.LibraryName    := 'dbxmss.dll';
    Conexao.VendorLib      := 'oledb';
  end
  else
  if pBD = 'Firebird' then
  begin
    //carrega o arquivo de parametros (neste caso o do MySQL)
    Arquivo := gsAppPath + 'Firebird_DBExpress_conn.txt';

    Conexao.DriverName     := 'Firebird';
    Conexao.ConnectionName := 'FBConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverINTERBASE';
    Conexao.LibraryName    := 'dbxfb.dll';
    Conexao.VendorLib      := 'fbclient.dll';
  end
  else
  if pBD = 'Interbase' then
  begin
    //carrega o arquivo de parametros (neste caso o do MySQL)
    Arquivo := gsAppPath + 'Interbase_DBExpress_conn.txt';

    Conexao.DriverName     := 'Interbase';
    Conexao.ConnectionName := 'IBConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverINTERBASE';
    Conexao.LibraryName    := 'dbxint.dll';
    Conexao.VendorLib      := 'gds32.dll';
  end
  else
  if pBD = 'MySQL' then
  begin
    //carrega o arquivo de parametros (neste caso o do MySQL)
    Arquivo := gsAppPath + 'MySQL_DBExpress_conn.txt';

    Conexao.DriverName     := 'MySQL';
    Conexao.ConnectionName := 'MySQLConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverMYSQL';
    Conexao.LibraryName    := 'dbxmys.dll';
    Conexao.VendorLib      := 'libmysql.dll';
  end
  else
  if pBD = 'DB2' then
  begin
    //carrega o arquivo de parametros (neste caso o do MySQL)
    Arquivo := gsAppPath + 'DB2_DBExpress_conn.txt';

    Conexao.DriverName     := 'Db2';
    Conexao.ConnectionName := 'DB2Connection';
    Conexao.GetDriverFunc  := 'getSQLDriverDB2';
    Conexao.LibraryName    := 'dbxdb2.dll';
    Conexao.VendorLib      := 'db2cli.dll';
  end
  else
  if pBD = 'Postgres' then
  begin
    //carrega o arquivo de parametros (neste caso o do Postgres)
    Arquivo := gsAppPath + 'Postgres_DBExpress_conn.txt';

    Conexao.DriverName     := 'DevartPostgreSQL';
    Conexao.ConnectionName := 'PostgreConnection';
    Conexao.GetDriverFunc  := 'getSQLDriverPostgreSQL';
    Conexao.LibraryName    := 'dbexppgsql40.dll';
    Conexao.VendorLib      := 'not used';
  end;

  //vari�vel para carregar os parametros do banco
  Parametros := TStringList.Create;
  try
    Parametros.LoadFromFile(Arquivo);
    Conexao.Params.Text := Parametros.Text;
  finally
    Parametros.Free;
  end;

  Conexao.LoginPrompt := False;
  Conexao.Name := 'Conexao';
end;

end.

