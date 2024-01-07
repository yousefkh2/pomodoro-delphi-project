unit TaskFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TTaskForm = class(TForm)
    lblEstimatedPomodoro: TLabel;
    btnCancel: TButton;
    btnSave: TButton;
    Label1: TLabel;
    EditTaskName: TEdit;
    EditEstimatedPomodoros: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TaskName: string;
    EstimatedPomodoros: Integer;
  end;

var
  TaskForm: TTaskForm;

implementation

{$R *.dfm}

procedure TTaskForm.btnSaveClick(Sender: TObject);
begin
  TaskName := EditTaskName.Text;
  EstimatedPomodoros := StrToIntDef(EditEstimatedPomodoros.Text, 0);
  ModalResult := mrOk;
end;

procedure TTaskForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
end.

