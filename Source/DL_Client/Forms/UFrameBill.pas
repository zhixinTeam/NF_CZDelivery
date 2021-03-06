{*******************************************************************************
  作者: dmzn@163.com 2009-6-22
  描述: 开提货单
*******************************************************************************}
unit UFrameBill;
{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, Menus,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters,
  cxCheckBox;

type
  TfFrameBill = class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Edit1: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N7: TMenuItem;
    N9: TMenuItem;
    VIP1: TMenuItem;
    VIP2: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    CheckDelButton: TcxCheckBox;
    dxLayout1Item10: TdxLayoutItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure VIP1Click(Sender: TObject);
    procedure CheckDelButtonClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //时间区间
    FUseDate: Boolean;
    //使用区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormInputbox, USysPopedom,
  USysConst, USysDB, USysBusiness, UFormDateFilter, UMgrRemotePrint,USysLoger;

//------------------------------------------------------------------------------
class function TfFrameBill.FrameID: integer;
begin
  Result := cFI_FrameBill;
end;

procedure TfFrameBill.OnCreateFrame;
begin
  inherited;
  FUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBill.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameBill.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Bill ';
  //提货单

  if (nWhere = '') or FUseDate then
  begin
    Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')';
    nStr := ' And ';
  end else nStr := ' Where ';

  if nWhere <> '' then
    Result := Result + nStr + '(' + nWhere + ')';
  //xxxxx

  if CheckDelButton.Checked then
  Result := MacroValue(Result, [MI('$Bill', sTable_BillBak),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))])
  else
  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameBill.AfterInitFormData;
begin
  FUseDate := True;
end;

function TfFrameBill.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price';
end;

//Desc: 执行查询
procedure TfFrameBill.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FUseDate := Length(EditLID.Text) <= 3;
    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('L_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 未开始提货的提货单
procedure TfFrameBill.N4Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
   10: FWhere := Format('(L_Status=''%s'')', [sFlag_BillNew]);
   20: FWhere := 'L_OutFact Is Null'
   else Exit;
  end;

  FUseDate := False;
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameBill.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 开提货单
procedure TfFrameBill.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FParamA := '';
  CreateBaseFormItem(cFI_FormMakeBill, PopedomItem, @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameBill.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := '确定要删除编号为[ %s ]的单据吗?';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_ID').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if DeleteBill(SQLQuery.FieldByName('L_ID').AsString) then
  begin
    InitFormData(FWhere);
    ShowMsg('提货单已删除', sHint);
  end;
end;

//Desc: 打印提货单
procedure TfFrameBill.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintBillReport(nStr, False);
  end;
end;

procedure TfFrameBill.PMenu1Popup(Sender: TObject);
begin
  N3.Enabled := BtnEdit.Enabled;
  N5.Enabled := BtnEdit.Enabled;
  N7.Enabled := BtnEdit.Enabled;
  N12.Enabled := BtnEdit.Enabled;
end;

//Desc: 修改未进厂车牌号
procedure TfFrameBill.N5Click(Sender: TObject);
var nStr,nTruck: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_Truck').AsString;
    nTruck := nStr;
    if not ShowInputBox('请输入新的车牌号码:', '修改', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //无效或一致

    nStr := SQLQuery.FieldByName('L_ID').AsString;
    if ChangeLadingTruckNo(nStr, nTruck) then
    begin
      InitFormData(FWhere);
      ShowMsg('车牌号修改成功', sHint);
    end;
  end;
end;

//Desc: 修改封签号
procedure TfFrameBill.N7Click(Sender: TObject);
var nStr,nID,nSeal: string;
  nOldSeal,nNewSeal:string;
  nValue:Double;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_Seal').AsString;
    nValue := SQLQuery.FieldByName('L_Value').AsFloat;
    nSeal := nStr;
    nOldSeal := nSeal;
    if not ShowInputBox('请输入新的批次号:', '修改', nSeal, 100) then Exit;

    if (nSeal = '') or (nStr = nSeal) then Exit;
    //无效或一致
    nNewSeal := nSeal;
    nID := SQLQuery.FieldByName('L_ID').AsString;

    nStr := 'select * from %s where d_id=''%s''';
    nStr := Format(nStr,[sTable_BatcodeDoc,nNewSeal]);
    with fdm.QuerySQL(nStr) do
    begin
      if RecordCount=0 then
      begin
        nStr := '批次号[ %s ]不存在，请检查输入';
        nStr := Format(nStr,[nNewSeal]);
        ShowDlg(nStr, sHint);
        Exit;
      end;
      if FieldByName('d_valid').AsString=sflag_no then
      begin
        nStr := '批次号[ %s ]已封存，是否继续';
        nStr := Format(nStr,[nNewSeal]);
        if not QueryDlg(nStr, sAsk) then Exit;
        Exit;      
      end;
    end;

    nStr := '确定要将交货单[ %s ]的批次号改为[ %s ]吗?';
    nStr := Format(nStr, [nID, nSeal]);
    if not QueryDlg(nStr, sAsk) then Exit;

    FDM.ADOConn.BeginTrans;
    try
      nStr := 'Update %s Set L_Seal=''%s'' Where L_ID=''%s''';
      nStr := Format(nStr, [sTable_Bill, nSeal, nID]);
      FDM.ExecuteSQL(nStr);

      nStr := '修改批次号[ %s -> %s ].';
      nStr := Format(nStr, [SQLQuery.FieldByName('L_Seal').AsString, nSeal]);
      FDM.WriteSysLog(sFlag_BillItem, nID, nStr, False);

      //减少原批次号使用量
      nStr := 'update %s set d_sent=d_sent-%f where d_id=''%s''';
      nStr := Format(nStr,[sTable_BatcodeDoc,nValue,nOldSeal]);
      FDM.ExecuteSQL(nStr);

      //增加新批次号使用量
      nStr := 'update %s set d_sent=d_sent+%f where d_id=''%s''';
      nStr := Format(nStr,[sTable_BatcodeDoc,nValue,nNewSeal]);
      FDM.ExecuteSQL(nStr);
      
      FDM.ADOConn.CommitTrans;

      InitFormData(FWhere);
      ShowMsg('批次号修改成功', sHint);
    except
      on E:Exception do
      begin
        FDM.ADOConn.RollbackTrans;
        ShowMsg('批次号修改失败', sHint);
        gSysLoger.AddLog('交货单['+nID+']批次号修改失败，原批次号['+nOldSeal+']，新批次号['+nNewSeal+']:'+e.Message);
      end;
    end;
  end;
end;

//Desc: 单据类型转换
procedure TfFrameBill.VIP1Click(Sender: TObject);
var nStr,nFlag: string;
    nTag: Integer;
begin
  if cxView1.DataController.GetSelectedCount < 1 then Exit;
  nTag := (Sender as TComponent).Tag;

  case nTag of
   10: nFlag := sFlag_TypeCommon;
   20: nFlag := sFlag_TypeVIP;
   30: nFlag := sFlag_TypeShip;
   40: nFlag := sFlag_TypeZT;
  end;

  nStr := 'Update %s Set L_IsVIP=''%s'' Where R_ID=%s';
  nStr := Format(nStr, [sTable_Bill, nFlag,
          SQLQuery.FieldByName('R_ID').AsString]);
  FDM.ExecuteSQL(nStr);

  nStr := 'Update %s Set T_VIP=''%s'' Where T_HKBills Like ''%%%s%%''';
  nStr := Format(nStr, [sTable_ZTTrucks, nFlag,
          SQLQuery.FieldByName('L_ID').AsString]);
  FDM.ExecuteSQL(nStr);

  nStr := '交货单类型[ %s -> %s ].';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_IsVIP').AsString, nFlag]);
  FDM.WriteSysLog(sFlag_BillItem, SQLQuery.FieldByName('L_ID').AsString, nStr);

  InitFormData(FWhere);
  ShowMsg('修改成功', sHint);
end;

procedure TfFrameBill.CheckDelButtonClick(Sender: TObject);
begin
  inherited;
  BtnRefresh.Click;
end;

procedure TfFrameBill.N12Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if SQLQuery.FieldByName('L_IsVIP').AsString <> sFlag_TypeShip then
    begin
      ShowMsg('请选择船运单据', sHint);
      Exit;
    end;

    if TComponent(Sender).Tag = 10 then
    begin
      nP.FCommand := cCmd_AddData;
      nP.FParamA := SQLQuery.FieldByName('L_ID').AsString;
      CreateBaseFormItem(cFI_FormShipPound, PopedomItem, @nP);
    end; //发货单

    if TComponent(Sender).Tag = 20 then
    begin
      PrintShipLeaveReport(SQLQuery.FieldByName('L_ID').AsString, False);
    end; //离岸通知单
  end;
end;

procedure TfFrameBill.N13Click(Sender: TObject);
var nStr,nP: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要打印的记录', sHint);
    Exit;
  end;

  nStr := '是否在远程打印[ %s.%s ]单据?';
  nStr := Format(nStr, [SQLQuery.FieldByName('L_ID').AsString,
                        SQLQuery.FieldByName('L_Truck').AsString]);
  if not QueryDlg(nStr, sAsk) then Exit;

  if gRemotePrinter.RemoteHost.FPrinter = '' then
       nP := ''
  else nP := #9 + gRemotePrinter.RemoteHost.FPrinter;

  nStr := SQLQuery.FieldByName('L_ID').AsString + nP + #7 + sFlag_Sale;
  gRemotePrinter.PrintBill(nStr);
end;

initialization
  gControlManager.RegCtrl(TfFrameBill, TfFrameBill.FrameID);
end.
