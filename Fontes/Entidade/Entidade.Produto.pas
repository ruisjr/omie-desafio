unit Entidade.Produto;

interface

uses
  {Classes de negócio}
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  [Table('produto')]
  TProduto = class(TBaseModel)
  strict private
    FID: Integer;
    FNome: Extended;
    FUnidade: Integer;
    FValorUnitario: Extended;
  public
    [DBField('id'), PK, Seq('seq_produto')]
    property ID:            Integer  read FID            write FID;
    [DBField('nome')]
    property Nome:          Extended read FNome          write FNome;
    [DBField('unidade'), FK]
    property Unidade:       Integer  read FUnidade       write FUnidade;
    [DBField('valor_unitario'), FK]
    property ValorUnitario: Extended read FValorUnitario write FValorUnitario;
  end;

implementation

end.
