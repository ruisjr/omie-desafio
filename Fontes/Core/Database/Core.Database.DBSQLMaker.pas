unit Core.Database.DBSQLMaker;

interface

uses
  Core.Database.Interfaces;

type
  TSQLMaker = class(TInterfacedObject, ISQLMaker)
  public
    function Fields: ISQLMaker;
    function TableName(out pTableName: String): ISQLMaker;
    function Select: String;
  end;

implementation

{ TSQLMaker }

function TSQLMaker.Fields: ISQLMaker;
begin
  Result := Self;

end;

function TSQLMaker.Select: String;
begin

end;

function TSQLMaker.TableName(out pTableName: String): ISQLMaker;
begin
  Result := Self;
end;

end.
