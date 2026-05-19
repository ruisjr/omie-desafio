unit Core.Database.SQLMaker;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  {Classes de Negócio}
  ,Core.Database.DBRtti
  ,Core.Database.Criteria
  ,Core.Database.Interfaces;

type
  TSQLMaker<T: class> = class(TInterfacedObject, ISQLMaker<T>)
  strict private
    FSQL: TStringBuilder;
    FSQLCriteria: TStringBuilder;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    {class functions}
    class function New: ISQLMaker<T>;

    {functions}
    function Fields(out pFields: String): ISQLMaker<T>;
    function TableName(out pTableName: String): ISQLMaker<T>;
    function Where(pCriterion: TCriterion): ISQLMaker<T>;
    function Select: String;
    function Insert(pEntity: T): String;


    {procedures}
    procedure FreeMemory;
  end;

implementation

{TSQLMaker}

constructor TSQLMaker<T>.Create;
begin
  FSQL := TStringBuilder.Create;
  FSQLCriteria := TStringBuilder.Create;
  inherited Create;
end;

destructor TSQLMaker<T>.Destroy;
begin
  Self.FreeMemory;
  inherited;
end;

function TSQLMaker<T>.Fields(out pFields: String): ISQLMaker<T>;
begin
  Result := Self;
  pFields := TDBRtti<T>.New.Fields;
end;

procedure TSQLMaker<T>.FreeMemory;
begin
  FSQL.Clear;
  FSQLCriteria.Clear;

  FreeAndNil(FSQL);
  FreeAndNil(FSQLCriteria);
end;

function TSQLMaker<T>.Insert(pEntity: T): String;
begin
  FSQL.AppendLine(Format('INSERT INTO %s', [TDBRtti<T>.New.TableName]));
  FSQL.AppendLine(Format('(%s)', [TDBRtti<T>.New.Fields]));
  FSQL.Append(Format('VALUES(%s)', [TDBRtti<T>.New.Values(pEntity)]));

  Result := FSQL.ToString;
end;

class function TSQLMaker<T>.New: ISQLMaker<T>;
begin
  Result := Self.Create;
end;

function TSQLMaker<T>.Select: String;
begin
  FSQL.AppendLine('SELECT ');
  FSQL.AppendLine(TDBRtti<T>.New.Fields);
  FSQL.AppendLine(' FROM ');
  FSQL.AppendLine(TDBRtti<T>.New.TableName);
  if (FSQLCriteria.Length > 0) then
    FSQL.Append('WHERE ' + FSQLCriteria.ToString);

  Result := FSQL.ToString;
end;

function TSQLMaker<T>.TableName(out pTableName: String): ISQLMaker<T>;
begin
  Result := Self;
  pTableName := TDBRtti<T>.New.TableName;
end;

function TSQLMaker<T>.Where(pCriterion: TCriterion): ISQLMaker<T>;
begin
  Result := Self;
  if FSQLCriteria.Length > 0 then
    FSQLCriteria.Append(Format('AND %s %s %s', [pCriterion.Field, pCriterion.&Operator, TDBRtti<T>.ParseValueToString(pCriterion.Value)]))
  else
    FSQLCriteria.Append(Format('%s %s %s', [pCriterion.Field, pCriterion.&operator, TDBRtti<T>.ParseValueToString(pCriterion.Value)]))
end;

end.
