unit PrgPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
   Model.Pedido
  ,Entidade.Pedido
  ,Entidade.Cliente
  ,Core.Database.Interfaces
  ,Core.Database.DBManager
  ,Core.Database.DBConnectionPGAdapter;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  LPedidoList: TObjectList<TPedido>;
  LModelPedido: TModelPedido;
  LPedido: TPedido;
  LManager: IDBManager<TPedido>;
  LDBConnection: IDBConnection;
begin
//  LModelPedido := TModelPedido.Create;
  LPedido := TPedido.Create;
  LDBConnection := TDBConnectionPGAdapter.Create;
  LManager := TDBManager<TPedido>.Create(LDBConnection);
  try
//    LPedidoList := LModelPedido.RetornaPedidosPorCliente(1);
    LPedido.Data := Now;
    LPedido.IdCliente := 1;
    LPedido.ValorTotal := 125.00;
    try
      LManager.Insert(LPedido);
    except
      on e: exception do
        showmessage('Ocorreu erro' + E.Message);
    end;
  finally
    if Assigned(LPedidoList) then
      FreeAndNil(LPedidoList);
    FreeAndNil(LModelPedido);
  end;
end;

end.
