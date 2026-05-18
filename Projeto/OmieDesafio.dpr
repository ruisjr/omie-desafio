program OmieDesafio;

uses
  Vcl.Forms,
  PrgPrincipal in 'PrgPrincipal.pas' {Form1},
  Core.Database.Criteria in '..\Fontes\Core\Database\Core.Database.Criteria.pas',
  Core.Database.DBConnectionPGAdapter in '..\Fontes\Core\Database\Core.Database.DBConnectionPGAdapter.pas',
  Core.Database.DBManager in '..\Fontes\Core\Database\Core.Database.DBManager.pas',
  Core.Database.DBQueryPGAdapter in '..\Fontes\Core\Database\Core.Database.DBQueryPGAdapter.pas',
  Core.Database.DBRtti in '..\Fontes\Core\Database\Core.Database.DBRtti.pas',
  Core.Database.DBSQLMaker in '..\Fontes\Core\Database\Core.Database.DBSQLMaker.pas',
  Core.Database.DBTypes in '..\Fontes\Core\Database\Core.Database.DBTypes.pas',
  Core.Database.Interfaces in '..\Fontes\Core\Database\Core.Database.Interfaces.pas',
  Core.Database.RttiHelper in '..\Fontes\Core\Database\Core.Database.RttiHelper.pas',
  Core.Entidade.ModelBase in '..\Fontes\Core\Entidades\Core.Entidade.ModelBase.pas',
  Core.Global in '..\Fontes\Core\Core.Global.pas',
  Entidade.Pedido in '..\Fontes\Entidade\Entidade.Pedido.pas',
  Entidade.Cliente in '..\Fontes\Entidade\Entidade.Cliente.pas',
  Core.Entidade.CustomAttributes in '..\Fontes\Core\Entidades\Core.Entidade.CustomAttributes.pas',
  Entidade.Produto in '..\Fontes\Entidade\Entidade.Produto.pas',
  Entidade.Pedido_Item in '..\Fontes\Entidade\Entidade.Pedido_Item.pas',
  Model.Pedido in '..\Fontes\Model\Model.Pedido.pas',
  Model.Cliente in '..\Fontes\Model\Model.Cliente.pas',
  Core.Environment in '..\Fontes\Core\Core.Environment.pas',
  Core.Logs in '..\Fontes\Core\Core.Logs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
