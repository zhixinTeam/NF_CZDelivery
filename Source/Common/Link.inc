//----------------------------------- ͨ�� -------------------------------------
{.$DEFINE DEBUG}
//����ģʽ

{.$DEFINE TrialVersion}
//���ð汾

{$DEFINE UseReport}
//����֧��

{.$DEFINE RandomID}
//ʹ��������

{$DEFINE cxLibrary42}
//Ver4.2���뻷��

{$DEFINE EnableBackupDB}
//�������ݿ�֧��
{$DEFINE EnableDoubleDB}
//˫���ݿ�֧��

//---------------------------------- �м�� ------------------------------------
{.$DEFINE ClientMon}
//�����ػ��ͻ���

{$DEFINE HardMon}
//����Ӳ���ػ�

{.$DEFINE GenRODL}
//����RODL��Դ

{$DEFINE COM_MIT}
//����ϵͳģʽ

//ͨ���м��
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //�������ݿ�֧��
  {$DEFINE ChannelPool}
  //����ͨ��֧��
  {.$DEFINE AutoChannel}
  //����ͨ��ƽ��
  {.$DEFINE SAP}
  //����SAP֧��
  {.$DEFINE ClientMon}
  //֧���ػ�����
{$ENDIF}

//--------------------------------- �ض�ϵͳ -----------------------------------
{.$DEFINE COMMON}
//ͨ�ð汾

{$DEFINE GXNF}
//�ض�ϵͳ

{$IFDEF JDNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
{$ENDIF}
//�����Ϸ�

{$IFDEF FYNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE FORCEOPENDOOR}
  //ǿ��̧��
  {$DEFINE HKVDVR}
  //������ץ��
  {$DEFINE FORCEREADER}
  //����������
{$ENDIF}
//�����Ϸ�

{$IFDEF JSNF}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE PrintChinese}
  //��������֧��
  {$DEFINE VerfiyAutoWeight}
  //У�������ʽ
  {$DEFINE ORDERVALUE}
  //��ʾ��Ʊ��������
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {.$DEFINE JSTruck}
  //��ʽ������������
  {.$DEFINE JSTruckNone}
  //����ʽ������������
  {$DEFINE JSTruckPackStyle}
  //��ʽ������������(��װ����)
  {$DEFINE StockTypeByPackStyle}
  //Ԥˢ��Ʒ������(��װ����)
{$ENDIF}
//��ɽ�Ϸ�

{$IFDEF YFNF}
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE ORDERVALUE}
  //��ʾ��Ʊ��������
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
{$ENDIF}
//�����Ϸ�(���ᡢ�������ϸ�)

{$IFDEF SMNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
{$ENDIF}
//�����Ϸ�

{$IFDEF NCNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE ShowDaiWC}
  //��ʾ��װ�����ʾ
{$ENDIF}
//�ϳ��Ϸ�

{$IFDEF TLNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE CardProvide}
  //���ø���ģʽ
  {$DEFINE LineGroup}
  //ͨ�����з���
  {$DEFINE CombinePrintBill}
  //����β���ϵ���ϲ���ӡ
{$ENDIF}
//ͩ®�Ϸ�

{$IFDEF SYNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE CardProvide}
  //���ø���ģʽ
  {.$DEFINE LineGroup}
  //ͨ�����з���
  {$DEFINE PrintChinese}
  //��������֧��
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE DaiStepWuCha}
  //��װ�������
  {$DEFINE DaiForceQueue}
  //��װ����ǿ�ƶ���
  {$DEFINE CombinePrintBill}
  //����β���ϵ���ϲ���ӡ
  {$DEFINE StockPriorityInQueue}
  //�Ŷ�ʱʹ���������ȼ�
  {$DEFINE PrepareShowTruck}
  //Ԥˢ����ʾ����
  {$DEFINE PrepareShowOnLading}
  //ˢ��װ��ʱ����Ԥˢ��(��ʹ��Ԥˢ��������)
{$ENDIF}
//ɽ���Ϸ�

{$IFDEF ZGNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE CardProvide}
  //���ø���ģʽ
  {$DEFINE LineGroup}
  //ͨ�����з���
  {$DEFINE PrintChinese}
  //��������֧��
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE ORDERVALUE}
  //��ʾ������
  {$DEFINE GROUPBYBRAND}
  //����Ʒ�Ʒ���
  {$DEFINE DaiStepWuCha}
  //��װ�������
{$ENDIF}
//����Ϸ�

{$IFDEF GXNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE CardProvide}
  //���ø���ģʽ
  {$DEFINE LineGroup}
  //ͨ�����з���
  {$DEFINE PrintChinese}
  //��������֧��
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE ORDERVALUE}
  //��ʾ������
  {$DEFINE FORCEPSTATION}
  //ǿ�Ƶذ���վ
  {$DEFINE ERROPENONEDOOR}
  //����ʧ�ܵ����°�
  {$DEFINE VerifyInTimeWhenP}
  //��Ƥ����֤����ʱ��
  {$DEFINE DaiStepWuCha}
  //��װ�������
  {$DEFINE DaiForceQueue}
  //��װ����ǿ�ƶ���
{$ENDIF}
//�����Ϸ�

//�ٹ�,����
{$IFDEF LPNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE CardProvide}
  //���ø���ģʽ
  {$DEFINE LineGroup}
  //ͨ�����з���
  {$DEFINE PrintChinese}
  //��������֧��
  {$DEFINE JSTruck}
  //��ʽ������������
  {$DEFINE ORDERVALUE}
  //��ʾ������
  {$DEFINE FORCEPSTATION}
  //ǿ�Ƶذ���վ
  {$DEFINE ERROPENONEDOOR}
  //����ʧ�ܵ����°�
  {$DEFINE DaiStepWuCha}
  //��װ�������
{$ENDIF}

//�����Ϸ�
{$IFDEF JLNF}
  {$DEFINE AutoSan}
  //ɢװ�����Զ�����
  {$DEFINE HYRFID201}
  //�����ͷ
  {$DEFINE AppAtTaskBar}
  //״̬����ʾ
  {$DEFINE RFIDOPENDOOR}
  //���ӱ�ǩ�������򿪵�բ
  {$DEFINE BatchVerifyValue}
  //���ο��Ʒ�����
  {$DEFINE MITTruckProber}
  //�м�����Ƴ���
  {$DEFINE MultiReplay}
  //������Ӧ��ģʽ
  {$DEFINE LineGroup}
  //ͨ�����з���
  {$DEFINE JSTruckSimple}
  //��ʽ������������
  {$DEFINE ORDERVALUE}
  //��ʾ������
  {$DEFINE DaiStepWuCha}
  //��װ�������
  {$DEFINE PrintShipReport}
  //���˿���ʱǿ�ƴ�
  {$DEFINE NoVerifyTruckNo}
  //��У�鳵�ƺ�(���Ų����Ϲ���)
{$ENDIF}