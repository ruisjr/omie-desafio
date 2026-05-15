unit Core.Database.DBQueryPGAdapter;

interface

uses
  {Classes de Sistema}
   Data.DB
  ,System.SysUtils
  ,FireDac.Stan.Param
  ,FireDAC.Stan.Option
  ,FireDAC.Comp.Client
  {Classes de Negócio}
 , Core.Database.Interfaces;

type
  TDBQueryPGAdapter = class(TInterfacedObject, IDBQuery)
  strict private
    FQuery: TFDQuery;
  public
    constructor Create(AConnection: TFDConnection); reintroduce;
    destructor Destroy; override;

    {Procedures}
    procedure FreeMemory;

    {Functions}
    function ToDataSet(pSQL: String): TDataSet;
  end;

implementation

{ TDBQuery }

constructor TDBQueryPGAdapter.Create(AConnection: TFDConnection);
begin
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := AConnection;
  inherited Create;
end;

destructor TDBQueryPGAdapter.Destroy;
begin
  Self.FreeMemory;
  inherited;
end;

procedure TDBQueryPGAdapter.FreeMemory;
begin
  FreeAndNil(FQuery);
end;

function TDBQueryPGAdapter.ToDataSet(pSQL: String): TDataSet;
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(pSQL);
  FQuery.Prepare;

  FQuery.Open;
  Result := TDataSet(FQuery);
end;

end.
