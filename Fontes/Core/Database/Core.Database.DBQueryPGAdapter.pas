unit Core.Database.DBQueryPGAdapter;

interface

uses
  {Classes de Sistema}
   Data.DB
  ,System.SysUtils
  ,FireDac.Stan.Param
  ,FireDAC.Stan.Option
  ,FireDAC.Comp.Client
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Database.DBRtti
  ,Core.Database.Interfaces;

type
  TDBQueryPGAdapter = class(TInterfacedObject, IDBQuery)
  strict private
    FQuery: TFDQuery;
  public
    constructor Create(AConnection: TFDConnection); reintroduce;
    destructor Destroy; override;

    {Procedures}
    procedure FreeMemory;
    procedure ExecSQL(pEntity: TObject; pSQL: String);
    procedure FillParameter(pEntity: TObject; pModeInsert: Boolean = False);

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

procedure TDBQueryPGAdapter.ExecSQL(pEntity: TObject; pSQL: String);
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(pSQL);
  Self.FillParameter(pEntity, pSQL.StartsWith('INSERT'));
  FQuery.Prepare;
  FQuery.ExecSQL;
end;

procedure TDBQueryPGAdapter.FillParameter(pEntity: TObject; pModeInsert: Boolean);
var
  LKey: String;
  LDictionaryFields: TDictionary<String, Variant>;
  LDictionaryTypeFields: TDictionary<String, TFieldType>;
  LFieldType: TFieldType;
begin
  LDictionaryFields := TDBRtti<TObject>.New.DictionaryFields(pEntity);
  LDictionaryTypeFields := TDBRtti<TObject>.New.DictionaryTypeFields(pEntity);
  try
    for LKey in LDictionaryFields.Keys do
    begin
      if FQuery.Params.FindParam(LKey) <> nil then
      begin
        if LDictionaryTypeFields.TryGetValue(LKey, LFieldType ) then
        begin
          if (LFieldType = ftOraClob) then
          begin
            FQuery.Params.ParamByName(LKey).ParamType := ptOutPut;
            if pModeInsert then
              FQuery.Params.ParamByName(LKey).ParamType := ptInput
          end;
          FQuery.Params.ParamByName(LKey).DataType := LFieldType;
        end;

        FQuery.Params.ParamByName(LKey).Value := LDictionaryFields.Items[LKey];
      end;
    end;
  finally
    FreeAndNil(LDictionaryFields);
    FreeAndNil(LDictionaryTypeFields);
  end;
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
