program MIT;

{$IFDEF GenRODL}
  {.#ROGEN:..\Common\MIT_Service.rodl}
{$ENDIF}

uses
  FastMM4,
  uROComInit,
  Windows,
  Forms,
  ULibFun,
  UMITConst,
  SrvConnection_Impl in '..\Common\SrvConnection_Impl.pas',
  SrvBusiness_Impl in '..\Common\SrvBusiness_Impl.pas',
  UROModule in '..\Forms\UROModule.pas' {ROModule: TDataModule},
  UDataModule in '..\Forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in '..\Forms\UFormMain.pas' {fFormMain},
  UFormBase in '..\Forms\UFormBase.pas' {BaseForm},
  UFrameBase in '..\Forms\UFrameBase.pas' {fFrameBase: TFrame},
  UFrameSummary in '..\Forms\UFrameSummary.pas' {fFrameSummary: TFrame},
  UFrameRunLog in '..\Forms\UFrameRunLog.pas' {fFrameRunLog: TFrame},
  UFrameConfig in '..\Forms\UFrameConfig.pas' {fFrameConfig: TFrame},
  UFrameParam in '..\Forms\UFrameParam.pas' {fFrameParam: TFrame},
  UFormPack in '..\Forms\UFormPack.pas' {fFormPack},
  UFormParamDB in '..\Forms\UFormParamDB.pas' {fFormParamDB},
  UFormParamSAP in '..\Forms\UFormParamSAP.pas' {fFormParamSAP},
  UFormPerform in '..\Forms\UFormPerform.pas' {fFormPerform},
  UFormServiceURL in '..\Forms\UFormServiceURL.pas' {fFormServiceURL},
  UFramePlugs in '..\Forms\UFramePlugs.pas' {fFramePlugs: TFrame};

{$R *.res}
{$R RODLFile.RES}
var
  gMutexHwnd: Hwnd;
  //互斥句柄
begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_NF_MIT');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  InitSystemEnvironment;
  //初始化运行环境
  ActionSysParameter(True);
  //载入系统配置信息
  
  if not IsValidConfigFile(gPath + sConfigFile, gSysParam.FProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint, GetDesktopWindow); Exit;
  end; //配置文件被改动

  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TROModule, ROModule);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.
