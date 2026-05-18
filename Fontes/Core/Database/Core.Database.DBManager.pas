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
  TDBManager = class(TInterfacedObject, IDBManager)
  strict private
    FFields: String;
    FCriteria: TCriteria;
    FDBConnection: IDBConnection;
  public
    constructor Create(ADBConnection: IDBConnection); reintroduce;
    destructor Destroy; override;

    function CreateCriteria: ICriteria;
    function Criteria: ICriteria;

    function Fields(AFields: string): IDBManager;
    function Where(const pConditional: String; const pOperatorType: TOperatorType; const pValue: TValue): IDBManager;
    function WhereAnd(const pConditional: String; const pOperatorType: TOperatorType; const pValue: TValue): IDBManager;

    function Find<T: class>(Id: Integer): T;
    function FindAll<T: class>: TObjectList<T>;
  end;

implementation

uses
  {Classes de Sistema}
   Data.DB
  {Classes de Negócio}
  ,Entidade.Pedido;

{ TDBManager }

constructor TDBManager.Create(ADBConnection: IDBConnection);
begin
  FDBConnection := ADBConnection;
  FDBConnection.Connect;
  inherited Create;
end;

function TDBManager.CreateCriteria: ICriteria;
begin
  if not Assigned(FCriteria) then
    FCriteria := TCriteria.Create;
  Result := FCriteria;
end;

function TDBManager.Criteria: ICriteria;
begin
  if not Assigned(FCriteria) then
    FCriteria := TCriteria(Self.CreateCriteria);

  Result := FCriteria;
end;

destructor TDBManager.Destroy;
begin
  FreeAndNil(FCriteria);
  inherited;
end;

function TDBManager.Fields(AFields: string): IDBManager;
begin
  FFields := AFields;
end;

function TDBManager.Find<T>(Id: Integer): T;
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

function TDBManager.FindAll<T>: TObjectList<T>;
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

    LQuery := FDBConnection.CreateQuery;
    try
      LDataSet := LQuery.ToDataSet(LSQL.ToString);
      Result := TDBRtti<T>.New.DataSetToEntityList(LDataSet);
    finally
      LQuery.FreeMemory;
    end;
  finally
    LSQL.Clear;
    LSQL.Free;
  end;
end;

function TDBManager.Where(const pConditional: String; const pOperatorType: TOperatorType; const pValue: TValue): IDBManager;
begin

end;

function TDBManager.WhereAnd(const pConditional: String; const pOperatorType: TOperatorType; const pValue: TValue): IDBManager;
begin

end;

end.
