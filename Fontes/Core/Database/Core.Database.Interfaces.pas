unit COre.Database.Interfaces;

interface

uses
  {Classes de Sistema}
   Data.DB
  ,System.Rtti
  ,System.Generics.Collections
  {Classes de Negócio}
  ,Core.Database.DBTypes;

type
  IDBQuery = interface;

  IDBConnection = interface
    ['{738E4764-41E6-47A3-9CC7-E7D316BDD14C}']
    procedure Connect;
    procedure Disconnect;
    procedure FreeMemory;
    procedure StartTransaction;
    procedure CommitTransaction;
    procedure RollBackTransaction;

    function CreateQuery: IDBQuery;
    function IsConnected: Boolean;
    function InTransaction: Boolean;
  end;

  ICriteria = interface
    ['{008E3EC0-5650-42D8-B223-C2367ED4318A}']
    function Criteria: ICriteria;
    function AddAnd(ACriteria: string): ICriteria;
    function AddOr(ACriteria: string): ICriteria;
    function AddLike(ACriteria: string): ICriteria;
    function AddOrder(ACriteria: string): ICriteria;
    function AddGroup(ACriteria: string): ICriteria;
  end;

  IDBManager = interface
    ['{F756E559-5E2E-4653-BE5F-CC158A63A4EC}']
    function CreateCriteria: ICriteria;
    function Fields(AFields: string): IDBManager;
    function Where(const pConditional: String; const pOperatorType: TOperatorType; const pValue: TValue): IDBManager;
    function WhereAnd(const pConditional: String; const pOperatorType: TOperatorType; const pValue: TValue): IDBManager;
  end;

  IDBRtti<T: class> = interface
    ['{C7B611F6-D3B4-4AE4-80CF-B1BB30B3C976}']
    function Fields: String;
    function TableName: String;
    function DataSetToEntity(pDataSet: TDataSet): T;
    function DataSetToEntityList(pDataSet: TDataSet): TObjectList<T>;
  end;

  ISQLMaker = interface
    ['{3E278934-A4A1-4945-A12B-62C9DBEB70E2}']
    function Fields: ISQLMaker;
    function TableName(out pTableName: String): ISQLMaker;
    function Select: String;
  end;

  IDBQuery = interface
    ['{16C23FD0-A2FA-498B-A566-164C7D8F964E}']
    function ToDataSet(pSQL: String): TDataSet;

    procedure FreeMemory;
  end;

implementation

end.
