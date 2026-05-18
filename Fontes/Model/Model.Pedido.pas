unit Model.Pedido;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  {Classes de Negócios}
  ,
  Entidade.Pedido;

type
  TModelPedido = class
  strict private

  public
    function RetornaPedidoPorId(const IdPedido: Integer): TPedido;
  end;

implementation

uses
   Core.Database.DBManager
  ,Core.Database.DBConnectionPGAdapter;

{ TModelPedido }

function TModelPedido.RetornaPedidoPorId(const IdPedido: Integer): TPedido;
var
  LManager: TDBManager;
  LConnection: TDBConnectionPGAdapter;
begin
  LConnection := TDBConnectionPGAdapter.Create;
  try
    LManager := TDBManager.Create(LConnection);
    try
      Result := LManager.Find<TPedido>(IdPedido);
    finally
      FreeAndNil(LManager);
    end;

  finally
    LConnection.FreeMemory;
  end;
end;

end.
