{*******************************************************************************
  作者: dmzn@163.com 2014-09-01
  描述: 开提货单
*******************************************************************************}
unit UFormGetZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxMCListBox, dxLayoutControl,
  StdCtrls, ExtCtrls, cxGraphics;

type
  TOrderItem = record
    FOrderID: string;       //订单编号
    FStockID: string;       //物料编号
    FStockName: string;     //物料名称
    FStockBrand: string;    //水泥品牌

    FSaleMan: string;       //业务员
    FTruck: string;         //车牌号码
    FBatchCode: string;     //批次号
    FAreaName: string;      //到货地点
    FAreaTo: string;        //区域流向
    FValue: Double;         //订单可用
    FPlanNum: Double;       //计划量
    FMakeTime:string;    //订单时间
  end;

  TfFormGetZhiKa = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item10: TdxLayoutItem;
    EditName: TcxComboBox;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListDetail: TcxListView;
    dxLayout1Item4: TdxLayoutItem;
    EditStock: TcxComboBox;
    TimerDelay: TTimer;
    EditAreaname: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure BtnOKClick(Sender: TObject);
    procedure EditStockPropertiesEditValueChanged(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
  protected
    { Private declarations }
    FCusID: string;
    //客户编号
    FStockID: string;
    //物料编号
    FOrderType: string;
    //订单类型
    FMineName: string;
    //矿点名称
    FLastCusID: string;
    //上次客户
    FListA: TStrings;
    FItems: array of TOrderItem;
    //订单列表
    procedure InitFormData(const nID: string);
    //载入数据
    procedure ClearCustomerInfo;
    function LoadCustomerInfo(const nID: string): Boolean;
    function LoadCustomerData(const nID: string): Boolean;
    //载入客户
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UDataModule,
  UFormWait, UBase64, USysGrid, USysDB, USysConst, USysBusiness;

var
  gParam: PFormCommandParam = nil;
  //全局使用

class function TfFormGetZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  gParam := nParam;

  with TfFormGetZhiKa.Create(Application) do
  try
    Caption := '选择订单';
    FCusID := gParam.FParamA;
    FStockID := gParam.FParamB;
    FOrderType := gParam.FParamC;
    FMineName := gParam.FParamD;

    FListA := TStringList.Create;
    EditName.Properties.ReadOnly := FCusID <> '';
    TimerDelay.Enabled := True;

    gParam.FCommand := cCmd_ModalResult;
    gParam.FParamA := ShowModal;
  finally
    FListA.Free;
    Free;
  end;
end;

class function TfFormGetZhiKa.FormID: integer;
begin
  Result := cFI_FormGetOrder;
end;

procedure TfFormGetZhiKa.FormCreate(Sender: TObject);
begin
  FLastCusID := '';
  FMineName  := '';
  LoadFormConfig(Self);
  LoadMCListBoxConfig(Name, ListInfo);
  LoadcxListViewConfig(Name, ListDetail);
end;

procedure TfFormGetZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, ListInfo);
  SavecxListViewConfig(Name, ListDetail);
  
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormGetZhiKa.TimerDelayTimer(Sender: TObject);
begin
  TimerDelay.Enabled := False;
  InitFormData(FCusID);
end;

procedure TfFormGetZhiKa.InitFormData(const nID: string);
begin
  dxLayout1Item10.AlignVert := avBottom;
  dxLayout1Item7.AlignVert := avClient;
  dxGroup1.AlignVert := avTop;
  ActiveControl := EditName;
  
  if nID <> '' then
    LoadCustomerData(nID);
  //xxxxx
end;

//Desc: 清理客户信息
procedure TfFormGetZhiKa.ClearCustomerInfo;
begin
  SetLength(FItems, 0);
  ListInfo.Clear;
  ListDetail.Clear;
  AdjustCXComboBoxItem(EditStock, True);
  AdjustCXComboBoxItem(EditAreaname, True);
end;

function TfFormGetZhiKa.LoadCustomerData(const nID: string): Boolean;
begin
  Result := False;
  if nID = FLastCusID then Exit;
  FLastCusID := nID;

  try
    ShowWaitForm(Self, '读取订单', True);    
    LockWindowUpdate(Handle);
    Result := LoadCustomerInfo(nID);
  finally
    LockWindowUpdate(0);
    CloseWaitForm;
  end;
end;

//Desc: 载入nID客户的信息
function TfFormGetZhiKa.LoadCustomerInfo(const nID: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDS: TDataSet;
    nUseAreaTo: Boolean;
begin
  ClearCustomerInfo;
  nDS := USysBusiness.LoadCustomerInfo(nID, ListInfo, nStr);
  Result := Assigned(nDS);
  
  if not Result then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := nDS.FieldByName('custname').AsString;
  if GetStringsItemIndex(EditName.Properties.Items, nID) < 0 then
  begin
    nStr := Format('%s=%s', [nID, nStr]);
    InsertStringsItem(EditName.Properties.Items, nStr);
  end;

  SetCtrlData(EditName, nID);
  //customer info done

  //----------------------------------------------------------------------------
  if FOrderType = sFlag_Sale then
    nStr := '103'
  else
  begin
    nStr := '203';

    if FMineName <> '' then
      FListA.Values['Filter'] := EncodeBase64('t1.vdef10=''' +
        FMineName + '''');
  end;

  FListA.Values['NoDate'] := sFlag_Yes;
  FListA.Values['CustomerID'] := nID;
  FListA.Values['Order'] := 'invtype,NPLANNUM ASC';

  nStr := GetQueryOrderSQL(nStr, EncodeBase64(FListA.Text));

  with FDM.QueryTemp(nStr, True) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('请先创建订单', sHint);
      Exit;
    end;

    InsertStringsItem(EditStock.Properties.Items, '1.全部订单');
    InsertStringsItem(EditAreaname.Properties.Items, '1.全部地点');
    SetLength(FItems, RecordCount);
    nIdx := 0;

    FListA.Clear;
    First;

    if Assigned(FindField('docname')) then
         nUseAreaTo := True
    else nUseAreaTo := False;
    //判断是否存在区域流向

    while not Eof do
    begin
      nStr := FieldByName('invcode').AsString;
      if (FStockID = '') or (FStockID = nStr) then
      begin
        with FItems[nIdx] do
        begin
          FOrderID := FieldByName('PK_MEAMBILL').AsString;
          FStockID := nStr;
          FStockName := FieldByName('invname').AsString;
          FSaleMan := FieldByName('VBILLTYPE').AsString;
          FStockBrand:= FieldByName('vdef5').AsString;

          FTruck := FieldByName('cvehicle').AsString;
          FBatchCode := FieldByName('vbatchcode').AsString;

          if nUseAreaTo then
               FAreaTo := FieldByName('docname').AsString
          else FAreaTo := '';

          if FOrderType = sFlag_Provide then
          begin
            FAreaName := FieldByName('vdef10').AsString;
            ListDetail.Column[2].Caption := '数量(吨)';
            ListDetail.Column[3].Caption := '矿点';
          end else
          begin
            FAreaName := FieldByName('areaclname').AsString;
          end;

          FValue := 0;
          FPlanNum := FieldByName('NPLANNUM').AsFloat;
          FMakeTime := FieldByName('tmaketime').AsString;
          FListA.Add(FOrderID);

          if GetStringsItemIndex(EditStock.Properties.Items, FStockID) < 0 then
          begin
            nStr := IntToStr(EditStock.Properties.Items.Count + 1);
            nStr := Format('%s=%s', [FStockID, nStr + '.' + FStockName]);
            InsertStringsItem(EditStock.Properties.Items, nStr);
          end;

          if GetStringsItemIndex(EditAreaname.Properties.Items, FAreaName)<0 then
          begin
            nStr := IntToStr(EditAreaname.Properties.Items.Count + 1);
            nStr := Format('%s=%s', [FAreaName, nStr + '.' + FAreaName]);
            InsertStringsItem(EditAreaname.Properties.Items, nStr);
          end;
        end;
      end else FItems[nIdx].FOrderID := '';

      Inc(nIdx);
      Next;
    end;

    if (FOrderType = sFlag_Sale) and (FListA.Count > 0) then
    begin
      if not GetOrderFHValue(FListA) then Exit;
      //获取已发货量

      for nIdx:=Low(FItems) to High(FItems) do
      begin
        nStr := FListA.Values[FItems[nIdx].FOrderID];
        if not IsNumber(nStr, True) then Continue;

        FItems[nIdx].FValue := FItems[nIdx].FPlanNum -
                               Float2Float(StrToFloat(nStr), cPrecision, True);
        //可用量 = 计划量 - 已发量
      end;
    end else

    if (FOrderType = sFlag_Provide) and (FListA.Count > 0) then
    begin
      if not GetOrderGYValue(FListA) then Exit;
      //获取已供应量

      for nIdx:=Low(FItems) to High(FItems) do
      begin
        nStr := FListA.Values[FItems[nIdx].FOrderID];
        if not IsNumber(nStr, True) then Continue;

        FItems[nIdx].FValue := FItems[nIdx].FPlanNum -
                               Float2Float(StrToFloat(nStr), cPrecision, True);
        //可用量 = 计划量 - 已供货量
      end;
    end;
  end;

  EditStock.ItemIndex := 0;
  //默认全显
  EditAreaname.ItemIndex := 0;
end;

procedure TfFormGetZhiKa.EditStockPropertiesEditValueChanged(Sender: TObject);
var nStr, nArea: string;
    nIdx: Integer;
begin
  ListDetail.Clear;
  if EditStock.ItemIndex > 0 then
       nStr := GetCtrlData(EditStock)
  else nStr := '';

  if EditAreaname.ItemIndex>0 then
       nArea := GetCtrlData(EditAreaname)
  else nArea := '';

  for nIdx:=Low(FItems) to High(FItems) do
  begin
    if FItems[nIdx].FOrderID = '' then Continue;
    if (nStr <> '') and (nStr <> FItems[nIdx].FStockID) then Continue;
    //品种匹配不通过

    if (nArea<>'') and (nArea <> FItems[nIdx].FAreaName) then Continue;
    //产地匹配不通过

    if FloatRelation(FItems[nIdx].FValue, 0, rtLE, cPrecision) then Continue;
    //无可用量 

    with ListDetail.Items.Add,FItems[nIdx] do
    begin
      Caption := FOrderID;
      SubItems.Add(FStockName);
      SubItems.Add(Format('%.2f', [FValue]));
      SubItems.Add(FAreaName);
      SubItems.Add(FStockBrand);
      SubItems.Add(FAreaTo);
      SubItems.Add(FMakeTime);

      Data := Pointer(nIdx);
    end;
  end;

  if ListDetail.Items.Count = 1 then
    ListDetail.Items[0].Checked := True;
  //xxxxx
end;

procedure TfFormGetZhiKa.EditNamePropertiesEditValueChanged(Sender: TObject);
begin
  if (EditName.ItemIndex > -1) and EditName.Focused then
    LoadCustomerData(GetCtrlData(EditName));
  //xxxxx
end;

//Desc: 选择客户
procedure TfFormGetZhiKa.EditNameKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
    nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    if EditName.Properties.ReadOnly then Exit;

    nP.FParamA := EditName.Text;
    CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    
    FLastCusID := '';
    EditName.ItemIndex := -1;
    SetCtrlData(EditName, nP.FParamB);

    if EditName.ItemIndex < 0 then
    begin
      nStr := Format('%s=%s', [nP.FParamB, nP.FParamC]);
      InsertStringsItem(EditName.Properties.Items, nStr);
      SetCtrlData(EditName, nP.FParamB);
    end;
  end;
end;

procedure TfFormGetZhiKa.BtnOKClick(Sender: TObject);
var nStr: string;
    nIdx,nInt: Integer;
    nOrder: TOrderItemInfo;
begin
  FillChar(nOrder, SizeOf(nOrder), #0);
  FListA.Clear;
  nStr := '';

  for nIdx:=ListDetail.Items.Count - 1 downto 0 do
  if ListDetail.Items[nIdx].Checked then
  begin
    nInt := Integer(ListDetail.Items[nIdx].Data);
    if (nStr <> '') and (nStr <> FItems[nInt].FStockID) then
    begin
      ShowMsg('禁止不同品种合单', sHint);
      Exit;
    end;

    if nStr <> '' then
    begin
      if nOrder.FStockID <> FItems[nInt].FStockID then
      begin
        ShowMsg('禁止不同品种合单', sHint);
        Exit;
      end;

      if nOrder.FStockBrand <> FItems[nInt].FStockBrand then
      begin
        ShowMsg('禁止不同品牌合单', sHint);
        Exit;
      end;

      if nOrder.FStockArea <> FItems[nInt].FAreaName then
      begin
        ShowMsg('禁止不同到货地点合单', sHint);
        Exit;
      end;

      if nOrder.FAreaTo <> FItems[nInt].FAreaTo then
      begin
        ShowMsg('禁止不同区域流向合单', sHint);
        Exit;
      end;
    end;

    if nStr = '' then //第一个选择项
    begin
      with nOrder do
      begin
        FCusID := GetCtrlData(EditName);
        FCusName := EditName.Text;

        FStockID := FItems[nInt].FStockID;
        FStockName := FItems[nInt].FStockName;
        FStockBrand:= FItems[nInt].FStockBrand;
        FStockArea := FItems[nInt].FAreaName;
        FAreaTo    := FItems[nInt].FAreaTo;

        FSaleMan := FItems[nInt].FSaleMan;
        FValue := FItems[nInt].FValue;
      end;

      nStr := FItems[nInt].FStockID;
      //参考物料号
    end else
    begin
      if FOrderType = sFlag_Provide then
      begin
        ShowMsg('采购业务不能并单', sHint);
        Exit;
      end;

      nOrder.FValue := nOrder.FValue + FItems[nInt].FValue;
      //叠加可用量
    end;

    if FItems[nInt].FTruck <> '' then
      nOrder.FTruck := FItems[nInt].FTruck;
    //车牌号码

    if FItems[nInt].FBatchCode <> '' then
      nOrder.FBatchCode := FItems[nInt].FBatchCode;
    //批次号

    FListA.Add(FItems[nInt].FOrderID);
  end;

  if nStr = '' then
  begin
    ShowMsg('请先选择订单', sHint);
    Exit;
  end;

  nOrder.FOrders := FListA.Text;
  gParam.FParamB := BuildOrderInfo(nOrder);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormGetZhiKa, TfFormGetZhiKa.FormID);
end.
