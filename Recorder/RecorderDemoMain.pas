unit RecorderDemoMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Media;

const
  AUDIO_FILENAME = 'test.mp3'; // ¼��������ļ���

type
  TRecorderdDemoForm = class(TForm)
    ActionList1: TActionList;
    acStartRecording: TAction;
    acStopRecording: TAction;
    acPlay: TAction;
    acStop: TAction;
    MediaPlayer1: TMediaPlayer;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure Button5Click(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure acStartRecordingExecute(Sender: TObject);
    procedure acPlayExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FMicrophone: TAudioCaptureDevice;
    function HasMicrophone: Boolean;
    function IsMicrophoneRecording: Boolean;
  end;

var
  RecorderdDemoForm: TRecorderdDemoForm;

implementation

uses
  System.IOUtils; // ��Ҫ����

{$R *.fmx}


// �õ���ͬƽ̨��¼���ļ�����·��
function GetAudioFileName(const AFileName: string): string;
begin
{$IFDEF ANDROID}
  Result := TPath.GetTempPath + '/' + AFileName;
{$ELSE}
{$IFDEF IOS}
  Result := TPath.GetHomePath + '/Documents/' + AFileName;
{$ELSE}
  Result := AFileName;
{$ENDIF}
{$ENDIF}
end;

procedure TRecorderdDemoForm.acPlayExecute(Sender: TObject);
begin
  if IsMicrophoneRecording then // �����¼��������ֹͣ¼��
    acStopRecording.Execute;
  // ���²���¼���ļ� AUDIO_FILENAME
  MediaPlayer1.FileName := GetAudioFileName(AUDIO_FILENAME);
  MediaPlayer1.Play;
end;

procedure TRecorderdDemoForm.acStartRecordingExecute(Sender: TObject);
begin
  acStop.Execute; // ѡ��ֹͣ¼��
  if HasMicrophone then
  begin
    // ׼����¼�����浽�ļ� 'test.mp3'
    FMicrophone.FileName := GetAudioFileName(AUDIO_FILENAME);
    try
      FMicrophone.StartCapture; // ��ʼ¼��
    except
      ShowMessage('���豸��֧��¼��������');
    end;
  end
  else
    ShowMessage('û����˷��豸��');
end;

procedure TRecorderdDemoForm.acStopExecute(Sender: TObject);
begin
  MediaPlayer1.Stop;
end;

procedure TRecorderdDemoForm.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  // �ж�ͼƬ�Ŀɼ���
  case (HasMicrophone and
    (FMicrophone.State = TCaptureDeviceState.Capturing)) of
    True:
      Label2.Text := '¼��';
    False:
      Label2.Text := 'ֹͣ¼��';
  end;
  // �ж� 4 ����ť���Ƿ�ɰ���
  acStartRecording.Enabled := not IsMicrophoneRecording and HasMicrophone;
  acStopRecording.Enabled := IsMicrophoneRecording;
  acStop.Enabled := Assigned(MediaPlayer1.Media) and (MediaPlayer1.State =
    TMediaState.Playing);
  acPlay.Enabled := FileExists(GetAudioFileName(AUDIO_FILENAME)) and
    (MediaPlayer1.State <> TMediaState.Playing);
end;

procedure TRecorderdDemoForm.Button1Click(Sender: TObject);
begin
  acStop.Execute; // ѡ��ֹͣ¼��
  if HasMicrophone then
  begin
    // ׼����¼�����浽�ļ� 'test.mp3'
    FMicrophone.FileName := GetAudioFileName(AUDIO_FILENAME);
    try
      FMicrophone.StartCapture; // ��ʼ¼��
    except
      ShowMessage('���豸��֧��¼��������');
    end;
  end
  else
    ShowMessage('û����˷��豸��');
end;

procedure TRecorderdDemoForm.Button5Click(Sender: TObject);
begin
  if IsMicrophoneRecording then // �������¼��
    try
      FMicrophone.StopCapture; { ֹͣ¼�� }
    except
      ShowMessage('���豸��֧��ֹͣ¼��������');
    end;
end;

// �ж��Ƿ�����˷�
procedure TRecorderdDemoForm.FormCreate(Sender: TObject);
begin
  // ��ʼ��¼���豸
  FMicrophone := TCaptureDeviceManager.Current.DefaultAudioCaptureDevice;
end;

function TRecorderdDemoForm.HasMicrophone: Boolean;
begin
  Result := Assigned(FMicrophone);
end;

// �ж��Ƿ���¼��
function TRecorderdDemoForm.IsMicrophoneRecording: Boolean;
begin
  Result := HasMicrophone and
    (FMicrophone.State = TCaptureDeviceState.Capturing);
end;

end.
