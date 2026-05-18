unit Core.Database.Criteria;

interface

uses
  {Classes de Sistema}
   System.Rtti
  ,System.Classes
  ,System.SysUtils;

type
  TCriterion = record
    Field: string;
    Operator: String;
    Value: TValue;
  end;

  TCriteria = class
  public
    class function Equal(const AField: string; const AValue: TValue): TCriterion; static;
    class function GreaterThan(const AField: string; const AValue: TValue): TCriterion; static;
  end;

implementation


{ TCriteria }

class function TCriteria.Equal(const AField: string; const AValue: TValue): TCriterion;
begin
  Result.Field := AField;
  Result.Operator := '=';
  Result.Value := AValue;
end;

class function TCriteria.GreaterThan(const AField: string; const AValue: TValue): TCriterion;
begin
  Result.Field := AField;
  Result.Operator := '>';
  Result.Value := AValue;
end;

end.
