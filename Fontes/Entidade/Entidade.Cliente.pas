unit Entidade.Cliente;

interface

uses
  {Classes de negócio}
   Core.Entidade.ModelBase
  ,Core.Entidade.CustomAttributes;

type
  [Table('cliente')]
  TCliente = class(TBaseModel)
  strict private
    FID: Integer;
    FNome: String;
  public
    [DBField('id'), PK, Seq('seq_cliente')]
    property ID:   Integer read FID   write FID;
    [DBField('nome')]
    property Nome: String  read FNome write FNome;
  end;

implementation

end.
