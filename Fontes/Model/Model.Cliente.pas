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
  ,Core.Database.DBConnectionPGAdapter;

{ TModelCliente }

function TModelCliente.RetornarClientePorID(const IdCliente: Integer): TCliente;
var
  LManager: TDBManager<TCliente>;
  LConnection: TDBConnectionPGAdapter;
begin
  LConnection := TDBConnectionPGAdapter.Create;
  try
    LManager := TDBManager<TCliente>.Create(LConnection);
    try
      Result := LManager.Find(IdCliente);
    finally
      FreeAndNil(LManager);
    end;

  finally
    LConnection.FreeMemory;
  end;
end;

end.
