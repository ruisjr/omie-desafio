unit Core.Database.DBConnectionPGAdapter;

interface

uses
{Classes de sistema}
   Data.DB
  ,Vcl.Forms
  ,FireDAC.DatS
  ,FireDAC.DApt
  ,FireDAC.Phys
  ,System.IniFiles
  ,System.SyncObjs
  ,System.SysUtils
  ,FireDAC.UI.Intf
  ,FireDAC.Phys.PG
  ,FireDAC.Stan.Def
  ,FireDAC.DApt.Intf
  ,FireDAC.Stan.Intf
  ,FireDAC.Phys.Intf
  ,FireDAC.Stan.Pool
  ,FireDAC.VCLUI.Wait
  ,FireDAC.Stan.Param
  ,FireDAC.Stan.Async
  ,FireDAC.Stan.Error
  ,FireDAC.Phys.PGDef
  ,FireDAC.Stan.Option
  ,Firedac.Comp.Client
  ,FireDAC.Comp.DataSet
  {Classes de Negócio}
  ,Core.Global
  ,Core.Database.Interfaces
  ,Core.Database.DBQueryPGAdapter;

type
  TDBConnectionPGAdapter = class(TInterfacedObject, IDBConnection)
  strict private
    FLink: TFDPhysPGDriverLink;
    FAppName: String;
    FConnection: TFDConnection;

    procedure LoadConfig;
  public
    {Construtores e Destrutores}
    constructor Create;
    destructor Destroy; override;

    {Class Functions}
    procedure FreeMemory;
  protected
    {Functions}
    function CreateQuery: IDBQuery;
    function IsConnected: Boolean;
    function InTransaction: Boolean;

    {Procedures}
    procedure Connect;
    procedure Disconnect;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;
  end;

implementation


{ TDBConnectionAdapter }

procedure TDBConnectionPGAdapter.CommitTransaction;
begin
  FConnection.Commit;
end;

procedure TDBConnectionPGAdapter.Connect;
begin
  try
    FConnection.Connected := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('The connection to the database could not be opened.'+#13#10 + E.Message);
    end;
  end;
end;

constructor TDBConnectionPGAdapter.Create;
begin
  FAppName := cAppName;
  LoadConfig;
end;

function TDBConnectionPGAdapter.CreateQuery: IDBQuery;
begin
  Result := TDBQueryPGAdapter.Create(Self.FConnection);
end;

destructor TDBConnectionPGAdapter.Destroy;
begin
  Self.FreeMemory;
  inherited;
end;

procedure TDBConnectionPGAdapter.Disconnect;
begin
  if (FConnection.Connected) then
  begin
    try
      FConnection.Connected := False;
    except
      on E : Exception do
      begin
        raise Exception.Create('The connection to the database could not be closed.' + #13#10 + E.Message);
      end;
    end;
  end;
end;

procedure TDBConnectionPGAdapter.FreeMemory;
begin
  FreeAndNil(FLink);
  FreeAndNil(FConnection);
end;

function TDBConnectionPGAdapter.InTransaction: Boolean;
begin
  Result := FConnection.InTransaction;
end;

function TDBConnectionPGAdapter.IsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

procedure TDBConnectionPGAdapter.LoadConfig;
var
  LPath: String;
  LArqIni: TIniFile;
  LMessage: String;
begin
  try
    LPath := StringReplace(ExtractFilePath(Application.ExeName), cDirectoryExec+'\', '', [rfReplaceAll]) + 'Drivers\FDConnectionDefs.ini';
    LArqIni := TIniFile.Create(LPath);
    try
      FLink := TFDPhysPGDriverLink.Create(nil);
      FLink.Release;
      FLink.VendorLib := StringReplace(ExtractFilePath(Application.ExeName), cDirectoryExec+'\', '', [rfReplaceAll]) + 'Lib\libpq.dll';

      FConnection := TFDConnection.Create(nil);

      FConnection.DriverName        := LArqIni.ReadString(FAppName, 'DriverID', 'PG');
      FConnection.ConnectionName    := FAppName;
      FConnection.LoginPrompt       := True;
      FConnection.Name              := 'Conn' + FAppName;

      with (TFDPhysPGConnectionDefParams(FConnection.Params)) do
      begin
        Port            := LArqIni.ReadInteger(FAppName, 'Port',      5432);
        Server          := LArqIni.ReadString(FAppName,  'Server',    'localhost');
        DriverID        := LArqIni.ReadString(FAppName,  'DriverID',  '');
        Database        := LArqIni.ReadString(FAppName,  'Database',  '');
        Password        := LArqIni.ReadString(FAppName,  'Password',  'postgres');
        UserName        := LArqIni.ReadString(FAppName,  'User_Name', 'postgres');
        LoginTimeout    := LArqIni.ReadInteger(FAppName, 'Timeout',   30);
        ApplicationName := FAppName;
        CharacterSet    := csUTF8;
      end;

      FConnection.Params.UserName := LArqIni.ReadString(FAppName, 'User_Name', 'postgres');
      FConnection.Params.Password := LArqIni.ReadString(FAppName, 'Password',  'postgres');
    finally
      FreeAndNil(LArqIni);
    end;
  except
    on E: Exception do
    begin
      LMessage := Format('%s | %s #13#10. The application will be finalized.', [Self.ClassName, E.Message]);
      raise Exception.Create('The database connection data could not be loaded.' + #13#10 + E.Message);
    end;
  end;
end;

procedure TDBConnectionPGAdapter.RollBackTransaction;
begin
  FConnection.Rollback;
end;

procedure TDBConnectionPGAdapter.StartTransaction;
begin
  FConnection.StartTransaction;
end;

end.
