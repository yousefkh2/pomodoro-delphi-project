object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 443
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object LabelTimeRemaining: TLabel
    Left = 296
    Top = 127
    Width = 86
    Height = 15
    Caption = 'Time Remaining'
  end
  object PomodoroButton: TButton
    Left = 168
    Top = 40
    Width = 81
    Height = 25
    Caption = 'Pomodoro'
    TabOrder = 0
    OnClick = PomodoroButtonClick
  end
  object ShortBreak: TButton
    Left = 272
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Short Break'
    TabOrder = 1
    OnClick = ShortBreakClick
  end
  object LongBreak: TButton
    Left = 368
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Long Break'
    TabOrder = 2
    OnClick = LongBreakClick
  end
  object StaticText1: TStaticText
    Left = 269
    Top = 192
    Width = 81
    Height = 19
    Caption = 'Time to Focus!'
    TabOrder = 3
  end
  object StartButton: TButton
    Left = 253
    Top = 80
    Width = 113
    Height = 41
    Caption = 'Start'
    TabOrder = 4
    OnClick = StartButtonClick
  end
  object btnAddTask: TButton
    Left = 269
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Add Task'
    TabOrder = 5
    OnClick = btnAddTaskClick
  end
  object TaskListView: TListView
    Left = 193
    Top = 279
    Width = 250
    Height = 150
    Columns = <
      item
        Caption = 'Task Name'
        Width = 100
      end
      item
        Caption = 'Pomodoros'
      end>
    TabOrder = 6
    ViewStyle = vsReport
  end
  object Reset: TButton
    Left = 512
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 7
    OnClick = ResetClick
  end
  object Delete: TButton
    Left = 512
    Top = 263
    Width = 89
    Height = 25
    Caption = 'Delete All Tasks'
    TabOrder = 8
    OnClick = DeleteClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 528
    Top = 112
  end
end
