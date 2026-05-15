unit Core.Database.Criteria;

interface

uses
  {Classes de Sistema}
   System.Classes
  ,System.SysUtils
  {Classes de Negócio}
  ,Core.Database.Interfaces;

type
  TCriteria = class(TInterfacedObject, ICriteria)
  strict private
    FAddOR,
    FAddAnd,
    FAddLike,
    AddFOrder,
    FAddGroup: TStringList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    function Criteria: ICriteria;
    function AddAnd(ACriteria: string): ICriteria;
    function AddOr(ACriteria: string): ICriteria;
    function AddLike(ACriteria: string): ICriteria;
    function AddOrder(ACriteria: string): ICriteria;
    function AddGroup(ACriteria: string): ICriteria;

    function Select: String;
  end;

implementation

{ TCriteria }

function TCriteria.AddAnd(ACriteria: string): ICriteria;
begin
  FAddAnd.Add(ACriteria);
end;

function TCriteria.AddGroup(ACriteria: string): ICriteria;
begin
  FAddGroup.Add(ACriteria);
end;

function TCriteria.AddLike(ACriteria: string): ICriteria;
begin
  FAddLike.Add(ACriteria);
end;

function TCriteria.AddOr(ACriteria: String): ICriteria;
begin

end;

function TCriteria.AddOrder(ACriteria: string): ICriteria;
begin
  FAddOr.Add(ACriteria);
end;

constructor TCriteria.Create;
begin
  FAddOR := TStringList.Create;
  FAddAnd := TStringList.Create;
  FAddLike := TStringList.Create;
  AddFOrder := TStringList.Create;
  FAddGroup := TStringList.Create;

  FAddAnd.Delimiter := '|';
  FAddAnd.StrictDelimiter := True;

  inherited Create;
end;

function TCriteria.Criteria: ICriteria;
begin
  Result := Self;
end;

destructor TCriteria.Destroy;
begin
  FreeAndNil(FAddOR);
  FreeAndNil(FAddAnd);
  FreeAndNil(FAddLike);
  FreeAndNil(AddFOrder);
  FreeAndNil(FAddGroup);
  inherited;
end;

function TCriteria.Select: String;
begin
  Result := 'WHERE ' + StringReplace(FAddAnd.DelimitedText, '|', ' AND ', [rfReplaceAll]);
end;

end.
