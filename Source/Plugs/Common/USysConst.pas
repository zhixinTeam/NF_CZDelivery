{*******************************************************************************
  作者: dmzn@163.com 2012-4-29
  描述: 常量定义
*******************************************************************************}
unit USysConst;

{$I Link.Inc}
interface

uses
  Windows, Classes, SysUtils, UBusinessPacker, UBusinessWorker, UBusinessConst,
  {$IFDEF MultiReplay}UMultiJS_Reply, {$ELSE}UMultiJS, {$ENDIF}
  UMITPacker, UWaitItem, ULibFun, USysDB, USysLoger;

type
  TMITReader = class(TThread)
  private
    FList: TStrings;
    FWaiter: TWaitObject;
    //等待对象
    FTunnel: TMultiJSTunnel;
    FOnData: TMultiJSEvent;
  protected
    procedure DoSync;
    procedure Execute; override;
  public
    constructor Create(AEvent: TMultiJSEvent);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
  end;

//------------------------------------------------------------------------------
var
  gMITReader: TMITReader = nil;                      //中间件读取

implementation

constructor TMITReader.Create(AEvent: TMultiJSEvent);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOnData := AEvent;
  FList := TStringList.Create;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 2 * 1000;
end;

destructor TMITReader.Destroy;
begin
  FWaiter.Free;
  FList.Free;  
  inherited;
end;

procedure TMITReader.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TMITReader.Execute;
var nIn: TWorkerBusinessCommand;
    nOut: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    nWorker := nil;
    try
      nIn.FCommand := cBC_JSGetStatus;
      nIn.FBase.FParam := sParam_NoHintOnError;
      
      nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);
      if not nWorker.WorkActive(@nIn, @nOut) then Continue;

      FList.Text := nOut.FData;
      if Assigned(FOnData) then
        Synchronize(DoSync);
      //xxxxx
    finally
      gBusinessWorkerManager.RelaseWorker(nWorker);
    end;
  except
    on E:Exception do
    begin
      gSysLoger.AddLog(E.Message);
    end;
  end;
end;

procedure TMITReader.DoSync;
var nIdx: Integer;
begin
  for nIdx:=0 to FList.Count - 1 do
  begin
    FTunnel.FID := FList.Names[nIdx];
    if not IsNumber(FList.Values[FTunnel.FID], False) then Continue;

    FTunnel.FHasDone := StrToInt(FList.Values[FTunnel.FID]);
    FOnData(@FTunnel);
  end;
end;

end.
