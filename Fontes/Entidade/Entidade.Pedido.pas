unit Entidade.Pedido;

interface

uses
  {Classes de Negócio}
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

// Força a geração de RTTI para TUDO nesta classe (Campos, Métodos, Propriedades)
  {$RTTI EXPLICIT METHODS([vcPrivate..vcPublished]) PROPERTIES([vcPrivate..vcPublished]) FIELDS([vcPrivate..vcPublished])}

type
  [Table('pedido')]
  TPedido = class(TBaseModel)
  strict private
    FID: Integer;
    FData: TDateTime;
    FValorTotal: Extended;
  public
    [DBField('id'), PK, Seq('seq_pedido')]
    property ID:         Integer   read FID         write FID;
    [DBField('data')]
    property Data:       TDateTime read FData       write FData;
    [DBField('valor_total')]
    property ValorTotal: Extended  read FValorTotal write FValorTotal;
  end;

implementation

end.
