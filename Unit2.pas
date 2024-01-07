unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, TaskFormUnit,
  Vcl.ComCtrls, MMSystem;

type
  TMode = (Pomodoro, ShortBreak, LongBreak);
  TForm2 = class(TForm)

    PomodoroButton: TButton;
    ShortBreak: TButton;
    LongBreak: TButton;
    Timer1: TTimer;
    StaticText1: TStaticText;
    StartButton: TButton;
    LabelTimeRemaining: TLabel;
    btnAddTask: TButton;
    TaskListView: TListView;
    Reset: TButton;
    Delete: TButton;
    procedure PomodoroButtonClick(Sender: TObject);
    procedure ShortBreakClick(Sender: TObject);
    procedure LongBreakClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnAddTaskClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SaveTasksToFile(const FileName: string);
    procedure LoadTasksFromFile(const FileName: string);
    procedure ResetClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
  private
    { Private declarations }
    Countdown: Integer;
    CurrentMode: TMode;
    IsTimerRunning: Boolean;
    procedure SetTime(Duration: Integer; Mode: TMode);
    procedure UpdateCompletedPomodoros;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TTask = record
    Name: string;
    EstimatedPomodoros: Integer;
    CompletedPomodoros: Integer;
    constructor Create(const AName: string; AEstimatedPomodoros: Integer);
  end;

const
  PomodoroDuration = 5;   // Should be 25 minutes, but left it at 5 sec. for testing
  ShortBreakDuration = 10;  // should've been 5 minutes, but left it at 10 sec.
  LongBreakDuration = 900;   // 15 minutes in milliseconds

var
  Form2: TForm2;


implementation

{$R *.dfm}


constructor TTask.Create(const AName: string; AEstimatedPomodoros: Integer);
begin
  Name := AName;
  EstimatedPomodoros := AEstimatedPomodoros;
  CompletedPomodoros := 0;
end;

procedure TForm2.SaveTasksToFile(const FileName: string);
var
  i: Integer;
  Task: ^TTask;
  FileStream: TFileStream;
  Writer: TStreamWriter;
begin
  FileStream := TFileStream.Create(FileName, fmCreate);
  Writer := TStreamWriter.Create(FileStream);
  try
    for I := 0 to TaskListView.Items.Count - 1 do
    begin
      Task := TaskListView.Items[i].Data;
      Writer.WriteLine(Task^.Name + ',' + IntToStr(Task^.EstimatedPomodoros) + ',' + IntToStr(Task^.CompletedPomodoros));
    end;
  finally
    Writer.Free;
    FileStream.Free;
  end;
end;

procedure TForm2.LoadTasksFromFile(const FileName: string);
var
  FileStream: TFileStream;
  Reader: TStreamReader;
  Line: string;
  Parts: TArray<string>;
  NewTask: ^TTask;
  ListItem: TListItem;
begin
  if not FileExists(FileName) then Exit;

  FileStream := TFileStream.Create(FileName, fmOpenRead);
  Reader := TStreamReader.Create(FileStream);
  try
    while not Reader.EndOfStream do
    begin
      Line := Reader.ReadLine;
      Parts := Line.Split([',']);
      if Length(Parts) = 3 then
      begin
        New(NewTask);
        NewTask^.Name := Parts[0];
        NewTask^.EstimatedPomodoros := StrToIntDef(Parts[1], 0);
        NewTask^.CompletedPomodoros := StrToIntDef(Parts[2], 0);

        ListItem := TaskListView.Items.Add;
        ListItem.Caption := NewTask^.Name;
        ListItem.SubItems.Add(IntToStr(NewTask^.CompletedPomodoros) + '/'+ IntToStr(NewTask^.EstimatedPomodoros));
        ListItem.Data := NewTask;
      end;
    end;

  finally
    Reader.Free;
    FileStream.Free;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  LoadTasksFromFile('tasks.txt');
end;

procedure TForm2.btnAddTaskClick(Sender: TObject);
var
  TaskForm: TTaskForm;
  NewTask: ^TTask;
  ListItem: TListItem;
begin
  TaskForm := TTaskForm.Create(nil);
  try
    if TaskForm.ShowModal = mrOK then
  begin
    New(NewTask);
    NewTask^ := TTask.Create(TaskForm.EditTaskName.Text, StrToIntDef(TaskForm.EditEstimatedPomodoros.Text, 0));


    ListItem := TaskListView.Items.Add;
    ListItem.Caption := NewTask^.Name;
    ListItem.SubItems.Add(IntToStr(NewTask^.CompletedPomodoros) + '/' + IntToStr(NewTask^.EstimatedPomodoros));
    ListItem.Data := NewTask
  end;
  finally
    TaskForm.Free;
  end;

end;

constructor TForm2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Countdown := PomodoroDuration;
  LabelTimeRemaining.Caption := Format('%.2d:%.2d', [PomodoroDuration div 60, PomodoroDuration mod 60]);
  Timer1.Enabled := False;
  IsTimerRunning := False;
end;

procedure TForm2.SetTime(Duration: Integer; Mode: TMode);
begin
  Timer1.Enabled := False;
  Countdown := Duration;
  CurrentMode := Mode;
  LabelTimeRemaining.Caption := Format('%.2d:%.2d', [Duration div 60, Duration mod 60]);
end;

procedure TForm2.ShortBreakClick(Sender: TObject);
begin
  SetTime(ShortBreakDuration, TMode.ShortBreak);
end;

procedure TForm2.LongBreakClick(Sender: TObject);
begin
  SetTime(LongBreakDuration, TMode.LongBreak);
end;

procedure TForm2.PomodoroButtonClick(Sender: TObject);
begin
  SetTime(PomodoroDuration, TMode.Pomodoro);
end;



procedure TForm2.ResetClick(Sender: TObject);
var
  i: integer;
  TaskPtr: ^TTask;
begin
  for I := 0 to TaskListView.Items.Count - 1 do
  begin
    if Assigned(TaskListView.Items[i].Data) then
    begin
      TaskPtr := TaskListView.Items[i].Data;
      TaskPtr^.CompletedPomodoros := 0;
      TaskListView.Items[i].SubItems[0] := '0/'+ IntToStr(TaskPtr^.EstimatedPomodoros);
    end;
  end;

end;

procedure TForm2.DeleteClick(Sender: TObject);
var
  i: Integer;
begin
  for i := TaskListView.Items.Count - 1 downto 0 do
  begin
    if Assigned(TaskListView.Items[i].Data) then
    begin
      Dispose(Pointer(TaskListView.Items[i].Data));
    end;
  end;
  TaskListView.Items.Clear;
end;

procedure TForm2.StartButtonClick(Sender: TObject);
begin
  if (CurrentMode = TMode.Pomodoro) and (TaskListView.Selected = nil) then
  begin
    ShowMessage('You have to choose a task!');
    Exit;
  end;
  IsTimerRunning := not IsTimerRunning;
  if IsTimerRunning then
  begin
    sndPlaySound('audio/click-button-140881.wav', SND_ASYNC);
    Timer1.Enabled := True;
    StartButton.Caption := 'Pause';
  end
  else
  begin
    sndPlaySound('audio/click-button-140881.wav', SND_ASYNC);
    Timer1.Enabled := False;
    StartButton.Caption := 'Start';
  end;

end;

procedure TForm2.Timer1Timer(Sender: TObject);
var
  Minutes, Seconds: Integer;
begin
  Dec(Countdown, Timer1.Interval div 1000);

  Minutes := Countdown div 60;
  Seconds := Countdown mod 60;

  LabelTimeRemaining.Caption := Format('%.2d:%.2d', [Minutes, Seconds]);

  if Countdown <= 0 then
  begin
    sndPlaySound('audio/Alarm Clock.wav', SND_ASYNC);
    Timer1.Enabled := False;
    ShowMessage('Time is up!');
    IsTimerRunning := False;
    StartButton.Caption := 'Start';
    // Reset the timer to its default value for the current mode
    if CurrentMode = TMode.Pomodoro then
    begin
      SetTime(PomodoroDuration, TMode.Pomodoro);
      UpdateCompletedPomodoros;
    end
    else if CurrentMode = TMode.ShortBreak then
    begin
      SetTime(ShortBreakDuration, TMode.ShortBreak);
    end
    else if CurrentMode = TMode.LongBreak then
    begin
      SetTime(LongBreakDuration, TMode.LongBreak);
    end;
    end;


end;
procedure TForm2.UpdateCompletedPomodoros;
var
  TaskPtr: ^TTask;
  SelectedItem: TListItem;
begin
  SelectedItem := TaskListView.Selected;
  if Assigned(SelectedItem) and Assigned(SelectedItem.Data) then
  begin
    TaskPtr := SelectedItem.Data;
    Inc(TaskPtr^.CompletedPomodoros);
    SelectedItem.SubItems[0] := IntToStr(TaskPtr^.CompletedPomodoros) + '/' + IntToStr(TaskPtr^.EstimatedPomodoros);
  end;
end;



destructor TForm2.Destroy;
var
  i: Integer;
begin
  // Free memory for all tasks
  for i := 0 to TaskListView.Items.Count - 1 do
  begin
    if Assigned(TaskListView.Items[i].Data) then
      Dispose(Pointer(TaskListView.Items[i].Data));
  end;

  inherited Destroy;
end;
procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveTasksToFile('tasks.txt');
end;
end.

