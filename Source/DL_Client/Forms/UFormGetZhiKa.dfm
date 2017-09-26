inherited fFormGetZhiKa: TfFormGetZhiKa
  Left = 398
  Top = 141
  Width = 634
  Height = 545
  BorderStyle = bsSizeable
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 618
    Height = 507
    inherited BtnOK: TButton
      Left = 472
      Top = 474
      Caption = #30830#23450
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 542
      Top = 474
      TabOrder = 6
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 459
      Height = 139
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 370
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditName: TcxComboBox [3]
      Left = 81
      Top = 190
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.OnEditValueChanged = EditNamePropertiesEditValueChanged
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 1
      OnKeyPress = EditNameKeyPress
      Width = 185
    end
    object ListDetail: TcxListView [4]
      Left = 23
      Top = 297
      Width = 355
      Height = 154
      Checkboxes = True
      Columns = <
        item
          Caption = #35746#21333#32534#21495
          Width = 100
        end
        item
          Caption = #29289#26009#31867#22411
          Width = 120
        end
        item
          Caption = #21150#29702#37327'('#21544')'
          Width = 100
        end
        item
          Caption = #21040#36135#22320#28857
        end
        item
          Caption = #21697#29260
          Width = 60
        end
        item
          Caption = #21306#22495#27969#21521
          Width = 120
        end
        item
          Caption = #35746#21333#26102#38388
          Width = 120
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 4
      ViewStyle = vsReport
    end
    object EditStock: TcxComboBox [5]
      Left = 81
      Top = 247
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 2
      OnKeyPress = EditNameKeyPress
      Width = 386
    end
    object EditAreaname: TcxComboBox [6]
      Left = 81
      Top = 272
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnEditValueChanged = EditStockPropertiesEditValueChanged
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 3
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = '1.'#36873#25321#23458#25143
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahClient
          AlignVert = avBottom
          Caption = #23458#25143#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = '2.'#36873#25321#35746#21333
        object dxLayout1Item4: TdxLayoutItem
          Caption = #29289#26009#31867#22411':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #21040#36135#22320#28857':'
          Control = EditAreaname
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListDetail
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object TimerDelay: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerDelayTimer
    Left = 44
    Top = 84
  end
end
