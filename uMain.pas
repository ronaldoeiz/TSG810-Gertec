unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, ACBrBase,
  ACBrPosPrinter,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.EditBox, FMX.SpinBox, FMX.ListBox;

type
  TfMain = class(TForm)
    Rectangle1: TRectangle;
    Layout1: TLayout;
    PosP: TACBrPosPrinter;
    mImp: TMemo;
    Button2: TButton;
    ListBox1: TListBox;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    lbImpressoras: TListBoxItem;
    cbxImpressorasBth: TComboBox;
    btnProcurarBth: TCornerButton;
    chbTodasBth: TCheckBox;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    lbModelos: TListBoxItem;
    cbxModelo: TComboBox;
    cbControlePorta: TCheckBox;
    cbxPagCodigo: TComboBox;
    ListBoxGroupHeader3: TListBoxGroupHeader;
    lbLarguraEspacejamento: TListBoxItem;
    GridPanelLayout1: TGridPanelLayout;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    seColunas: TSpinBox;
    seEspLinhas: TSpinBox;
    seLinhasPular: TSpinBox;
    ListBoxGroupHeader4: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    GridPanelLayout5: TGridPanelLayout;
    Label1: TLabel;
    Label4: TLabel;
    cbHRI: TCheckBox;
    seBarrasLargura: TSpinBox;
    seBarrasAltura: TSpinBox;
    cbSuportaBMP: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure btnProcurarBthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function PedirPermissoes: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}

uses
System.typinfo, System.Permissions,
{$IFDEF ANDROID}
  Androidapi.Helpers, Androidapi.JNI.Os, Androidapi.JNI.JavaTypes,
{$ENDIF}
  FMX.DialogService, FMX.Platform,
  ACBrUtil, ACBrConsts;


function TFmain.PedirPermissoes: Boolean;
Var
  Ok: Boolean;
begin
  Ok := True;
{$IFDEF ANDROID}
  PermissionsService.RequestPermissions
    ([JStringToString(TJManifest_permission.JavaClass.BLUETOOTH),
    JStringToString(TJManifest_permission.JavaClass.BLUETOOTH_ADMIN),
    JStringToString(TJManifest_permission.JavaClass.BLUETOOTH_PRIVILEGED)],
    procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
    var
      GR: TPermissionStatus;
    begin
      Ok := (Length(AGrantResults) = 3);

      if Ok then
      begin
        for GR in AGrantResults do
          if (GR <> TPermissionStatus.Granted) then
          begin
            Ok := False;
            Break;
          end;
      end;
    end);

  if not Ok then
  begin
    TDialogService.MessageDialog
      ('Sem permissões para acessar despositivo BlueTooth', TMsgDlgType.mtError,
      [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil, nil);
  end;
{$ENDIF}
  Result := Ok;
end;

procedure TfMain.btnProcurarBthClick(Sender: TObject);
begin
  if not PedirPermissoes then
    Exit;

  cbxImpressorasBth.Items.Clear;
  try
    fmain.posP.Device.AcharPortasBlueTooth(cbxImpressorasBth.Items,
      chbTodasBth.IsChecked);
    cbxImpressorasBth.Items.Add('NULL');
  except
  end;

end;

procedure TfMain.Button2Click(Sender: TObject);
begin
  mImp.Lines.Clear;
  mImp.Lines.Add('</zera>');
  mImp.Lines.Add('</linha_dupla>');
  mImp.Lines.Add('FONTE NORMAL: ' + IntToStr(fMain.PosP.ColunasFonteNormal) +
    ' Colunas');
   mImp.Lines.Add('<e>EXPANDIDO: ' + IntToStr(fMain.PosP.ColunasFonteExpandida) +
    ' Colunas');
  mImp.Lines.Add('</e><c>CONDENSADO: ' +
    IntToStr(fMain.PosP.ColunasFonteCondensada) + ' Colunas');
  mImp.Lines.Add('</c><n>FONTE NEGRITO</N>');
  mImp.Lines.Add('<in>FONTE INVERTIDA');
  mImp.Lines.Add('</in><S>FONTE SUBLINHADA</s>');
  mImp.Lines.Add('<i>FONTE ITALICO</i>');
  mImp.Lines.Add('FONTE NORMAL');
  mImp.Lines.Add('</linha_simples>');

  mImp.Lines.Add('</corte_total>');

    mImp.Lines.Add('</zera>');
  mImp.Lines.Add('</linha_dupla>');
  mImp.Lines.Add('<qrcode_tipo>' + IntToStr(fmain.posP.ConfigQRCode.Tipo) +
    '</qrcode_tipo>');
  mImp.Lines.Add('<qrcode_largura>' +
    IntToStr(fmain.posP.ConfigQRCode.LarguraModulo) + '</qrcode_largura>');
  mImp.Lines.Add('<qrcode_error>' + IntToStr(fmain.posP.ConfigQRCode.ErrorLevel)
    + '</qrcode_error>');
  mImp.Lines.Add('<qrcode>http://projetoacbr.com.br</qrcode>');
  mImp.Lines.Add('</ce>');
  mImp.Lines.Add
    ('<qrcode>http://www.projetoacbr.com.br/forum/index.php?/page/SAC/sobre_o_sac.html</qrcode>');
  mImp.Lines.Add('</ad>');
  mImp.Lines.Add
    ('<qrcode>http://www.projetoacbr.com.br/forum/index.php?/page/SAC/questoes_importantes.html</qrcode>');
  mImp.Lines.Add('</ce>');
  mImp.Lines.Add('Exemplo de QRCode para NFCe');
  mImp.Lines.Add
    ('<qrcode_error>0</qrcode_error><qrcode>https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?'
    + 'chNFe=35150805481336000137650220000000711000001960&nVersao=100&tpAmb=2&dhEmi=323031352D30382D31395432323A33333A32352D30333A3030&vNF=3.00&'
    + 'vICMS=0.12&digVal=776967396F2</qrcode>');
  mImp.Lines.Add('Exemplo de QRCode para SAT');
  mImp.Lines.Add
    ('<qrcode_error>0</qrcode_error><qrcode>35150811111111111111591234567890001672668828|20150820201736|118.72|05481336000137|'
    + 'TCbeD81ePUpMvso4VjFqRTvs4ovqmR1ZG3bwSCumzHtW8bbMedVJjVnww103v3LxKfgckAyuizcR/9pXaKay6M4Gu8kyDef+6VH5qONIZV1cB+mFfXiaCgeZ'
    + 'ALuRDCH1PRyb6hoBeRUkUk6lOdXSczRW9Y83GJMXdOFroEbzFmpf4+WOhe2BZ3mEdXKKGMfl1EB0JWnAThkGT+1Er9Jh/3En5YI4hgQP3NC2BiJVJ6oCEbKb'
    + '85s5915DSZAw4qB/MlESWViDsDVYEnS/FQgA2kP2A9pR4+agdHmgWiz30MJYqX5Ng9XEYvvOMzl1Y6+7/frzsocOxfuQyFsnfJzogw==</qrcode>');
  mImp.Lines.Add('</corte_total>');


  if not PedirPermissoes then
    Exit;

  if Assigned(cbxImpressorasBth.Selected) then
    fMain.PosP.Porta := cbxImpressorasBth.Selected.Text;

  if Assigned(cbxModelo.Selected) then
    fMain.PosP.Modelo := TACBrPosPrinterModelo(cbxModelo.ItemIndex);

  if Assigned(cbxPagCodigo.Selected) then
    fMain.PosP.PaginaDeCodigo := TACBrPosPaginaCodigo(cbxPagCodigo.ItemIndex);

  fMain.PosP.ColunasFonteNormal := Trunc(seColunas.Value);
  fMain.PosP.EspacoEntreLinhas := Trunc(seEspLinhas.Value);
  fMain.PosP.LinhasEntreCupons := Trunc(seLinhasPular.Value);
  fMain.PosP.ConfigLogo.KeyCode1 := 1;
  fMain.PosP.ConfigLogo.KeyCode2 := 0;
  fMain.PosP.ControlePorta := cbControlePorta.IsChecked;

  fMain.PosP.Buffer.Text := mImp.Lines.Text;
  fMain.PosP.Imprimir;
end;


procedure TfMain.FormCreate(Sender: TObject);
var
  m: TACBrPosPrinterModelo;
  p: TACBrPosPaginaCodigo;
begin
btnProcurarBthClick(Sender);
  if cbxImpressorasBth.Items.Count > 0 then
    cbxImpressorasBth.ItemIndex := 0;

  cbxModelo.Items.Clear;
  For m := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
    cbxModelo.Items.Add(GetEnumName(TypeInfo(TACBrPosPrinterModelo),
      integer(m)));

  cbxPagCodigo.Items.Clear;
  For p := Low(TACBrPosPaginaCodigo) to High(TACBrPosPaginaCodigo) do
    cbxPagCodigo.Items.Add(GetEnumName(TypeInfo(TACBrPosPaginaCodigo),
      integer(p)));
   if cbxPagCodigo.Items.Count > 0 then
     cbxPagCodigo.ItemIndex := 2;

  if cbxModelo.Items.Count > 0 then
    cbxModelo.ItemIndex := 5;

end;

end.
