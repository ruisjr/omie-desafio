unit Core.Database.DBRtti;

interface

uses
  {Classes de Sistema}
   Data.DB
  ,System.Rtti
  ,System.Classes
  ,System.TypInfo
  ,System.SysUtils
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Database.RttiHelper
  ,Core.Database.Interfaces
  ,Core.Entidade.CustomAttributes;

type
  TDBRtti<T: class> = class(TInterfacedObject, IDBRtti<T>)
  strict private
    function _CreateObjectByName(pEntity: T): T;
    function _GetValueProperty(pEntity: T; pProperty: TRttiProperty; pField: TField): TValue;
  public
    constructor Create; reintroduce;

    class function New: TDBRtti<T>;
    function Fields: String;
    function TableName: String;
    function WhereID: String;

    function DataSetToEntity(pDataSet: TDataSet): T;
    function DataSetToEntityList(pDataSet: TDataSet): TObjectList<T>;
  end;

implementation

{ TDBRtti }

constructor TDBRtti<T>.Create;
begin
  inherited Create;
end;

function TDBRtti<T>.DataSetToEntity(pDataSet: TDataSet): T;
var
  LValue: TValue;
  LField : TField;
  LCtxRtti: TRttiContext;
  LTypRtti: TRttiType;
  LprpRtti: TRttiProperty;
begin
  Result := _CreateObjectByName(TObject(TypeInfo(T)));

  pDataSet.First;
  while not pDataSet.Eof do
  begin
    LCtxRtti := TRttiContext.Create;
    try
      for LField in pDataSet.Fields do
      begin
        LTypRtti := LCtxRtti.GetType(TypeInfo(T));
        for LprpRtti in LTypRtti.GetProperties do
        begin
          if LPrpRtti.Has<DBField> then
          begin
            LValue := Self._GetValueProperty(TObject(TypeInfo(T)), LPrpRtti, LField);
            if LValue.IsEmpty then
              Continue;

            LPrpRtti.SetValue(Pointer(Result), LValue);
          end;
        end;
      end;
    finally
      LCtxRtti.Free;
    end;
    pDataSet.Next;
  end;
  pDataSet.First;
end;

function TDBRtti<T>.DataSetToEntityList(pDataSet: TDataSet): TObjectList<T>;
var
  LValue: TValue;
  LField: TField;
  LCtxRtti: TRttiContext;
  LPrpRtti: TRttiProperty;
  LRttiInstance: TRttiInstanceType;
begin
  Result := TObjectList<T>.Create;

  while not pDataSet.Eof do
  begin
    Result.Add(_CreateObjectByName(TObject(TypeInfo(T))));
    LCtxRtti := TRttiContext.Create;
    try
      for LField in pDataSet.Fields do
      begin
        for LPrpRtti in LCtxRtti.GetType(TypeInfo(T)).GetProperties do
        begin
          if LPrpRtti.Has<DBField> then
          begin
            LValue := Self._GetValueProperty(TObject(TypeInfo(T)), LPrpRtti, LField);
            if LValue.IsEmpty then
              Continue;

            LPrpRtti.SetValue(Pointer(Result[Pred(Result.Count)]),LValue );
          end;
        end;
      end;
    finally
      LCtxRtti.Free;
    end;
    pDataSet.Next;
  end;
  pDataSet.Close;
end;

function TDBRtti<T>.Fields: String;
var
  LFields: TStringList;
  LCtxRtti: TRttiContext;
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
  LAttRtti: TCustomAttribute;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LFields := TStringList.Create;
    try
      LFields.Delimiter := ',';
      LFields.StrictDelimiter := True;

      LTypRtti := LCtxRtti.GetType(TObject(TypeInfo(T)));
      for LPrpRtti in LTypRtti.GetProperties do
      begin
        if LPrpRtti.Has<DBField> then
          LFields.Add(LPrpRtti.GetAttribute<DBField>.Name);
      end;
      Result := LFields.DelimitedText;
    finally
      FreeAndNil(LFields);
    end;
  finally
    LCtxRtti.Free;
  end;
end;

class function TDBRtti<T>.New: TDBRtti<T>;
begin
  Result := Self.Create;
end;

function TDBRtti<T>.TableName: String;
var
  LTypRtti: TRttiType;
  LCtxRtti: TRttiContext;
begin
  Result := EmptyStr;
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(TypeInfo(T));
    if LTypRtti.Has<Table> then
      Result := LTypRtti.GetAttribute<Table>.Name;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>.WhereID: String;
var
  LTypRtti: TRttiType;
  LPrpRtti: TRttiProperty;
  LCtxRtti: TRttiContext;
begin
  LCtxRtti := TRttiContext.Create;
  try
    LTypRtti := LCtxRtti.GetType(T);
    if LTypRtti.Has<PK> then
    begin
      LPrpRtti := LTypRtti.GetProperty<PK>;
      Result := LPrpRtti.FieldName;
    end;
  finally
    LCtxRtti.Free;
  end;
end;

function TDBRtti<T>._CreateObjectByName(pEntity: T): T;
var
  LType: TRttiInstanceType;
  LContext: TRttiContext;
  LMethod: TRttiMethod;
begin
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(T) as TRttiInstanceType;
    LMethod := LType.GetMethod('Create');

    if Assigned(LMethod) then
      Result := LMethod.Invoke(LType.MetaclassType, []).AsObject as T
    else
      raise Exception.Create('Construtor "Create" sem parâmetros não encontrado para ' + LType.Name);
  finally
    LContext.Free;
  end;
end;

function TDBRtti<T>._GetValueProperty(pEntity: T; pProperty: TRttiProperty; pField: TField): TValue;
begin
  Result := nil;
  if LowerCase(pProperty.GetAttribute<DBField>.Name) = LowerCase(pField.DisplayName) then
  begin
    pField.DisplayLabel := pProperty.DisplayName;
    case pProperty.PropertyType.TypeKind of
      tkUnknown, tkString, tkWChar, tkLString, tkWString, tkUString:
        Result := pField.AsString;
      tkInteger, tkInt64:
        Result := pField.AsInteger;
      tkChar: ;
      tkEnumeration:
      begin
        if (pProperty.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(Boolean)) then
          Result := pField.AsBoolean
        else
          Result := pField.AsString;
      end;
      tkFloat:
      begin
        if ((pProperty.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDate)) or
            (pProperty.GetValue(Pointer(pEntity)).TypeInfo = TypeInfo(TDateTime))) then
          Result := pField.AsDateTime
        else
          Result := pField.AsFloat;
      end;
      tkSet: ;
      tkClass: ;
      tkMethod: ;
      tkVariant: ;
      tkArray: ;
      tkRecord: ;
      tkInterface: ;
      tkDynArray: ;
      tkClassRef: ;
      tkPointer: ;
      tkProcedure: ;
    end;
  end;
end;

end.
