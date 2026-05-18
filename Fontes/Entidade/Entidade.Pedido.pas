unit Entidade.Pedido;

interface

uses
  {Classes de Negócio}
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  [Table('pedido')]
  TPedido = class(TBaseModel)
  strict private
    FID: Integer;
    FData: TDateTime;
    FIdCliente: Integer;
    FValorTotal: Extended;
  public
    [DBField('id'), PK, Seq('seq_pedido')]
    property ID:         Integer   read FID         write FID;
    [DBField('data')]
    property Data:       TDateTime read FData       write FData;
    [DBField('id_cliente')]
    property IdCliente:  Integer   read FIdCliente  write FIdCliente;
    [DBField('valor_total')]
    property ValorTotal: Extended  read FValorTotal write FValorTotal;
  end;

implementation

end.
