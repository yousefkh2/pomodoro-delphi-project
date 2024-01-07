object TaskForm: TTaskForm
  Left = 0
  Top = 0
  Caption = 'TTaskForm'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblEstimatedPomodoro: TLabel
    Left = 152
    Top = 211
    Width = 80
    Height = 15
    Caption = 'Est Pomodoros'
  end
  object Label1: TLabel
    Left = 152
    Top = 99
    Width = 138
    Height = 15
    Caption = 'What are you working on?'
  end
  object EditTaskName: TEdit
    Left = 152
    Top = 120
    Width = 121
    Height = 23
    TabOrder = 0
  end
  object EditEstimatedPomodoros: TEdit
    Left = 152
    Top = 232
    Width = 121
    Height = 23
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 320
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 464
    Top = 360
    Width = 75
    Height = 25
    Caption = 'Save'
    ModalResult = 1
    TabOrder = 3
    OnClick = btnSaveClick
  end
end
