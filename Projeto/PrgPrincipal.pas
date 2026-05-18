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
  ,Entidade.Cliente;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  LPedido: TObjectList<TPedido>;
  LModelPedido: TModelPedido;
begin
  LModelPedido := TModelPedido.Create;
  try
    LPedido := LModelPedido.RetornaPedidosPorCliente(1);
  finally
    if Assigned(LPedido) then
      FreeAndNil(LPedido);
    FreeAndNil(LModelPedido);
  end;
end;

end.
