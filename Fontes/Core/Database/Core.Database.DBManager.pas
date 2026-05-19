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
  ,Core.Database.SQLMaker
  ,Core.Database.Interfaces
  ,Core.Database.DBQueryPGAdapter
  ,Core.Entidade.CustomAttributes;

type
  TDBManager<T: class> = class(TInterfacedObject, IDBManager<T>)
  strict private
    FFields: String;
    FCriterion: TCriterion;
    FDBConnection: IDBConnection;
  public
    constructor Create(ADBConnection: IDBConnection); reintroduce;
    destructor Destroy; override;

    {procedures}
    procedure FreeMemory;
    procedure Insert(pEntity: T);

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
  LQuery: IDBQuery;
  LDataSet: TDataSet;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LDataSet := LQuery.ToDataSet(TSQLMaker<T>.New.Where(FCriterion).Select);
    Result := TDBRtti<T>.New.DataSetToEntityList(LDataSet);
  finally
    LQuery.FreeMemory;
  end;
end;

procedure TDBManager<T>.FreeMemory;
begin
  FDBConnection.FreeMemory;
end;

procedure TDBManager<T>.Insert(pEntity: T);
var
  LQuery: IDBQuery;
begin
  LQuery := FDBConnection.CreateQuery;
  try
    LQuery.ExecSQL(pEntity, TSQLMaker<T>.New.Insert(pEntity))
  finally
    LQuery.FreeMemory;
  end;
end;

function TDBManager<T>.Where(pCriteria: TCriterion): IDBManager<T>;
begin
  Result := Self;
  FCriterion := pCriteria;
end;

end.
