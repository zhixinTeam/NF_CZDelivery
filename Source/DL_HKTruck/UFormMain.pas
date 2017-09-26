{*******************************************************************************
  ����: dmzn@163.com 2015-01-09
  ����: ��������ʽ����ʶ������ͬ��
*******************************************************************************}
unit UFormMain;

{.$DEFINE DEBUG}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, ComCtrls, StdCtrls, ExtCtrls;

type
  TfFormMain = class(TForm)
    GroupBox1: TGroupBox;
    MemoLog: TMemo;
    StatusBar1: TStatusBar;
    CheckSrv: TCheckBox;
    EditPort: TLabeledEdit;
    CheckAuto: TCheckBox;
    CheckLoged: TCheckBox;
    BtnConn: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckLogedClick(Sender: TObject);
    procedure BtnConnClick(Sender: TObject);
    procedure CheckSrvClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*״̬��ͼ��*}
    FRecordIndex: Integer;
    //��¼����
    procedure ShowLog(const nStr: string);
    //��ʾ��־
    procedure StartHKClient;
    //��������ʶ��
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  ActiveX, IniFiles, Registry, TLHelp32, ShellAPI, ULibFun, UDataModule,
  UFormConn, UWaitItem, UFormCtrl, USysLoger, DB, USysDB;

type
  TSyncThread = class(TThread)
  private
    FStartIndex: Integer;
    //��ʼ����
    FWaiter: TWaitObject;
    //�ȴ�����
    FListA,FListB: TStrings;
    //�����б�
  protected
    procedure DoSync;
    procedure Execute; override;
    //ִ��ͬ��
    procedure SaveRecordIndex;
    //��������
  public
    constructor Create(const nStart: Integer);
    destructor Destroy; override;
    //�����ͷ�
    procedure StopMe;
    //ֹͣ�߳�
  end;

var
  gPath: string;               //����·��
  gSyncer: TSyncThread = nil;  //ͬ���߳�

resourcestring
  sHint               = '��ʾ';
  sConfig             = 'Config.Ini';
  sDB                 = 'DBConn.Ini';
  sAutoStartKey       = 'HKTruck';

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFormMain, '���Ʒ�������Ԫ', nEvent);
end;

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  gPath := ExtractFilePath(Application.ExeName);
  InitGlobalVariant(gPath, gPath+sConfig, gPath+sConfig, gPath+sDB);
  
  gSysLoger := TSysLoger.Create(gPath + 'Logs\');
  gSysLoger.LogEvent := ShowLog;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := Caption;
  FTrayIcon.Visible := True;

  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(gPath + sConfig);
    FRecordIndex := nIni.ReadInteger('Config', 'RecordStart', 0);

    EditPort.Text := nIni.ReadString('Config', 'Port', '8000');
    Timer1.Enabled := nIni.ReadBool('Config', 'Enabled', False);

    LoadFormConfig(Self, nIni); 
    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;

    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    CheckAuto.Checked := nReg.ValueExists(sAutoStartKey);
  finally
    nIni.Free;
    nReg.Free;
  end;
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
    nReg: TRegistry;
begin
  if Assigned(gSyncer) then
    gSyncer.StopMe;
  gSyncer := nil;

  nIni := nil;
  nReg := nil;
  try
    nIni := TIniFile.Create(gPath + 'Config.ini');
    nIni.WriteBool('Config', 'Enabled', CheckSrv.Checked);
    SaveFormConfig(Self, nIni);

    nReg := TRegistry.Create;
    nReg.RootKey := HKEY_CURRENT_USER;

    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    if CheckAuto.Checked then
      nReg.WriteString(sAutoStartKey, Application.ExeName)
    else if nReg.ValueExists(sAutoStartKey) then
      nReg.DeleteValue(sAutoStartKey);
    //xxxxx
  finally
    nIni.Free;
    nReg.Free;
  end;
end;

//Date: 2015-01-09
//Desc: ��������ʶ��ͻ���
procedure TfFormMain.StartHKClient;
var nStr: string;
    nRet: BOOL;
    nHwnd:THandle;
    nEntry:TProcessEntry32;
begin
  nHwnd := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS,0);
  try
    nEntry.dwSize := Sizeof(nEntry);
    nRet := Process32First(nHwnd, nEntry);
    while nRet do
    begin
      nStr := Trim(nEntry.szExeFile);
      nStr := Copy(nStr, 1, Pos('.', nStr) - 1);

      if CompareText('ITCClient', nStr) = 0 then Exit;
      //�ͻ��������� 
      nRet := Process32Next(nHwnd, nEntry);
    end;
  finally
    CloseHandle(nHwnd);
  end;

  nStr := gPath + 'bin\ITCClient.exe';
  ShellExecute(GetDesktopWindow, nil, PChar(nStr), nil, nil, SW_ShowNormal);
end;

//------------------------------------------------------------------------------
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  CheckSrv.Checked := True;

  {$IFDEF DEBUG}
  CheckLoged.Checked := True;
  {$ELSE}
  FTrayIcon.Minimize;
  {$ENDIF}

  StartHKClient;
  //��������ʶ��ͻ���
end;

procedure TfFormMain.CheckLogedClick(Sender: TObject);
begin
  gSysLoger.LogSync := CheckLoged.Checked;
end;

procedure TfFormMain.ShowLog(const nStr: string);
var nIdx: Integer;
begin
  MemoLog.Lines.BeginUpdate;
  try
    MemoLog.Lines.Insert(0, nStr);
    if MemoLog.Lines.Count > 100 then
     for nIdx:=MemoLog.Lines.Count - 1 downto 50 do
      MemoLog.Lines.Delete(nIdx);
  finally
    MemoLog.Lines.EndUpdate;
  end;
end;

//Desc: ����nConnStr�Ƿ���Ч
function ConnCallBack(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: ���ݿ�����
procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  ShowConnectDBSetupForm(ConnCallBack);
end;

//Desc: ��������
procedure TfFormMain.CheckSrvClick(Sender: TObject);
begin
  BtnConn.Enabled := not CheckSrv.Checked;
  EditPort.Enabled := not CheckSrv.Checked;

  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := BuildConnectDBStr;

  FDM.ADOLocal.Close;
  FDM.ADOLocal.ConnectionString := BuildConnectDBStr(nil, '����');

  if CheckSrv.Checked then
  begin
    if not Assigned(gSyncer) then
      gSyncer := TSyncThread.Create(FRecordIndex);
    //xxxxx
  end else
  begin
    if Assigned(gSyncer) then
      gSyncer.StopMe;
    gSyncer := nil;
  end;
end;

//------------------------------------------------------------------------------
constructor TSyncThread.Create(const nStart: Integer);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FStartIndex := nStart;
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 20 * 1000;
end;

destructor TSyncThread.Destroy;
begin
  FWaiter.Free;
  inherited;
end;

procedure TSyncThread.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TSyncThread.SaveRecordIndex;
var nIni: TIniFile;
begin
  nIni := nil;
  try
    nIni := TIniFile.Create(gPath + sConfig);
    nIni.WriteInteger('Config', 'RecordStart', FStartIndex);
  finally
    nIni.Free;
  end;
end;

procedure TSyncThread.Execute;
begin
  CoInitialize(nil);

  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    DoSync;
    //ִ��
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;

  CoUninitialize;
end;

procedure TSyncThread.DoSync;
var nStr: string;
    nDS: TDataSet;
    nTruck: WideString;
    nIdx,nInt,nRecord: Integer;
begin
  nStr := 'Select Index,License,PlateColor,VehicleType,AbsTime From MVC_Data ' +
          'Where Index>%d';
  nStr := Format(nStr, [FStartIndex]);

  nDS := FDM.QueryData(nStr, nil, True);
  if not (Assigned(nDS) and (nDS.RecordCount > 0)) then Exit;

  with nDS do
  begin
    FListA.Clear;
    FListB.Clear;

    nRecord := FStartIndex;
    First;

    while not nDS.Eof do
    try
      nInt := FieldByName('Index').AsInteger;
      if nInt > nRecord then
        nRecord := nInt;
      //xxxx

      nTruck := Trim(FieldByName('License').AsString);
      nInt := Length(nTruck);

      if nInt < 5 then Continue;
      nTruck := Copy(nTruck, 2, nInt);

      nStr := MakeSQLByStr([
              SF('T_LastTime', FieldByName('AbsTime').AsString)
              ], sTable_Truck, SF('T_Truck', nTruck), False);
      FListA.Values[nTruck] := nStr;

      nStr := MakeSQLByStr([SF('T_Truck', nTruck),
              SF('T_PY', GetPinYinOfStr(nTruck)),
              SF('T_PlateColor', FieldByName('PlateColor').AsString),
              SF('T_Type', FieldByName('VehicleType').AsString),
              SF('T_LastTime', FieldByName('AbsTime').AsString),
              SF('T_NoVerify', sFlag_No),
              SF('T_Valid', sFlag_Yes)
              ], sTable_Truck, '', True);
      FListB.Values[nTruck] := nStr;
    finally
      nDS.Next;
    end;
  end;

  FDM.ADOConn.Connected := True;
  try
    FDM.ADOConn.BeginTrans;
    //��������

    for nIdx:=FListA.Count - 1 downto 0 do
    begin
      nStr := FListA.Names[nIdx];
      FDM.SQLTemp.Close;
      FDM.SQLTemp.SQL.Text := FListA.Values[nStr]; //update
      nInt := FDM.SQLTemp.ExecSQL;

      if nInt < 1 then
      begin
        FDM.SQLTemp.Close;
        FDM.SQLTemp.SQL.Text := FListB.Values[nStr]; //update
        FDM.SQLTemp.ExecSQL;
      end;
    end;

    FDM.ADOConn.CommitTrans;
    nStr := '��¼[ %d->%d ]���ɹ����䳵��[ %d ]��.';
    nStr := Format(nStr, [FStartIndex, nRecord, FListA.Count]);

    WriteLog(nStr);
    FStartIndex := nRecord;
    SaveRecordIndex;
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

end.