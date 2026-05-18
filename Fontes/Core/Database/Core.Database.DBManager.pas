unit Core.Database.DBManager;

interface

uses
  {Classes de Sistema}
   System.Rtti
  ,System.Classes
  ,System.SysUtils
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Database.DBRtti
  ,Core.Database.DBTypes
  ,Core.Database.Criteria
  ,Core.Database.Interfaces
  ,Core.Database.DBQueryPGAdapter
  ,Core.Entidade.CustomAttributes;

type
  TDBManager<T: class> = class(TInterfacedObject, IDBManager<T>)
  strict private
    FFields: String;
    FSQLCriteria: TStringBuilder;
    FDBConnection: IDBConnection;
  public
    constructor Create(ADBConnection: IDBConnection); reintroduce;
    destructor Destroy; override;

    {procedures}
    procedure FreeMemory;

    {functions}
    function Fields(AFields: string): IDBManager<T>;
    function Where(pCriteria: TCriterion): IDBManager<T>;

    function Find(Id: Integer): T;
    function FindAll: TObjectList<T>;
  end;

implementation

uses
  {Classes de Sistema}
   Data.DB
  {Classes de Negócio}
  ,Entidade.Pedido;

{ TDBManager }

constructor TDBManager<T>.Create(ADBConnection: IDBConnection);
begin
  FSQLCriteria := TStringBuilder.Create;

  FDBConnection := ADBConnection;
  FDBConnection.Connect;
  inherited Create;
end;

destructor TDBManager<T>.Destroy;
begin
  FreeMemory;
  inherited;
end;

function TDBManager<T>.Fields(AFields: string): IDBManager<T>;
begin
  FFields := AFields;
end;

function TDBManager<T>.Find(Id: Integer): T;
var
  LSQL: TStringBuilder;
  LQuery: IDBQuery;
  LDataSet: TDataSet;
begin
  LSQL := TStringBuilder.Create;
  try
    LSQL.AppendLine('SELECT ');
    if FFields.IsEmpty then
      LSQL.AppendLine(TDBRtti<T>.New.Fields);

    LSQL.AppendLine(' FROM ');
    LSQL.AppendLine(TDBRtti<T>.New.TableName);
    LSQL.AppendLine(' WHERE ');
    LSQL.AppendLine(Format('%s = %d', [TDBRtti<T>.New.WhereID, Id]));

    LQuery := FDBConnection.CreateQuery;
    try
      LDataSet := LQuery.ToDataSet(LSQL.ToString);
      Result := TDBRtti<T>.New.DataSetToEntity(LDataSet);
    finally
      LQuery.FreeMemory;
    end;
  finally
    LSQL.Clear;
    LSQL.Free;
  end;
end;

function TDBManager<T>.FindAll: TObjectList<T>;
var
  LSQL: TStringBuilder;
  LQuery: IDBQuery;
  LDataSet: TDataSet;
begin
  LSQL := TStringBuilder.Create;
  try
    LSQL.AppendLine('SELECT ');
    LSQL.AppendLine(TDBRtti<T>.New.Fields);
    LSQL.AppendLine(' FROM ');
    LSQL.AppendLine(TDBRtti<T>.New.TableName);
    LSQL.Append('WHERE ' + FSQLCriteria.ToString);

    LQuery := FDBConnection.CreateQuery;
    try
      LDataSet := LQuery.ToDataSet(LSQL.ToString);
      Result := TDBRtti<T>.New.DataSetToEntityList(LDataSet);
    finally
      LQuery.FreeMemory;
    end;
  finally
    FSQLCriteria.Clear;
    LSQL.Clear;
    LSQL.Free;
  end;
end;

procedure TDBManager<T>.FreeMemory;
begin
  FreeAndNil(FSQLCriteria);
  FDBConnection.FreeMemory;
end;

function TDBManager<T>.Where(pCriteria: TCriterion): IDBManager<T>;
begin
  Result := Self;
  if FSQLCriteria.Length > 0 then
    FSQLCriteria.Append(Format('AND %s %s %s', [pCriteria.Field, pCriteria.&Operator, TDBRtti<T>.ParseValueToString(pCriteria.Value)]))
  else
    FSQLCriteria.Append(Format('%s %s %s', [pCriteria.Field, pCriteria.&operator, TDBRtti<T>.ParseValueToString(pCriteria.Value)]))
end;

end.
