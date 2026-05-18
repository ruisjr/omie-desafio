unit Entidade.Pedido_Item;

interface

uses
  {Classes de negócio}
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  TPedidoItem = class(TBaseModel)
  strict private
    FID: Integer;
    FTotal: Extended;
    FUnidade: String;
    FIdPedido: Integer;
    FIdProduto: Integer;
    FQuantidade: Extended;
    FValorUnitario: Extended;
  public
    [DBField('id'), PK, Seq('seq_produto')]
    property ID:            Integer  read FID            write FID;
    [DBField('total')]
    property Total:         Extended read FTotal         write FTotal;
    [DBField('unidade')]
    property Unidade:       String   read FUnidade       write FUnidade;
    [DBField('id_pedido'), FK]
    property IdPedido:      Integer  read FIdPedido      write FIdPedido;
    [DBField('id_produto'), FK]
    property IdProduto:     Integer  read FIdProduto     write FIdProduto;
    [DBField('quantidade')]
    property Quantidade:    Extended read FQuantidade    write FQuantidade;
    [DBField('valor_unitario')]
    property ValorUnitario: Extended read FValorUnitario write FValorUnitario;
  end;

implementation

end.
