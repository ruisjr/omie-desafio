unit Model.Cliente;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  {Classes de Negócio}
  ,Entidade.Cliente;

type
  TModelCliente = class
  strict private
  public
    function RetornarClientePorID(const IdCliente: Integer): TCliente;
  end;

implementation

uses
   Core.Database.DBManager
  ,Core.Database.Interfaces
  ,Core.Database.DBConnectionPGAdapter;

{ TModelCliente }

function TModelCliente.RetornarClientePorID(const IdCliente: Integer): TCliente;
var
  LManager: IDBManager<TCliente>;
  LConnection: TDBConnectionPGAdapter;
begin
  LConnection := TDBConnectionPGAdapter.Create;
  try
    LManager := TDBManager<TCliente>.Create(LConnection);
    try
      Result := LManager.Find(IdCliente);
    finally
      LManager.FreeMemory
    end;

  finally
    LConnection.FreeMemory;
  end;
end;

end.
