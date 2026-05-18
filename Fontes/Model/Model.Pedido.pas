unit Model.Pedido;

interface

uses
  {Classes de Sistema}
   System.SysUtils
  ,System.Generics.Collections
  {Classes de Negócios}
  ,
  Entidade.Pedido;

type
  TModelPedido = class
  strict private

  public
    function RetornaPedidoPorId(const IdPedido: Integer): TPedido;
    function RetornaPedidosPorCliente(const IdCliente: Integer): TObjectList<TPedido>;
  end;

implementation

uses
   Core.Database.Criteria
  ,Core.Database.DBManager
  ,Core.Database.DBConnectionPGAdapter;

{ TModelPedido }

function TModelPedido.RetornaPedidoPorId(const IdPedido: Integer): TPedido;
var
  LManager: TDBManager<TPedido>;
  LConnection: TDBConnectionPGAdapter;
begin
  LConnection := TDBConnectionPGAdapter.Create;
  try
    LManager := TDBManager<TPedido>.Create(LConnection);
    try
      Result := LManager.Find(IdPedido);
    finally
      FreeAndNil(LManager);
    end;

  finally
    LConnection.FreeMemory;
  end;
end;

function TModelPedido.RetornaPedidosPorCliente(const IdCliente: Integer): TObjectList<TPedido>;
var
  LManager: TDBManager<TPedido>;
  LConnection: TDBConnectionPGAdapter;
begin
  LConnection := TDBConnectionPGAdapter.Create;
  try
    LManager := TDBManager<TPedido>.Create(LConnection);
    try
      Result := LManager.Where(TCriteria.Equal('id_cliente', 1)).FindAll;
    finally
      LManager.Free;
    end;

  finally
    LConnection.FreeMemory;
  end;
end;

end.
