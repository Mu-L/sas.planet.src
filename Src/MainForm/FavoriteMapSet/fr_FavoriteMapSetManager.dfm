object frFavoriteMapSetManager: TfrFavoriteMapSetManager
  Left = 0
  Top = 0
  Width = 625
  Height = 438
  Align = alClient
  TabOrder = 0
  object spl1: TSplitter
    Left = 0
    Top = 229
    Width = 625
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object pnlRightButtons: TPanel
    Left = 524
    Top = 0
    Width = 101
    Height = 229
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object btnEdit: TButton
      AlignWithMargins = True
      Left = 3
      Top = 127
      Width = 95
      Height = 25
      Align = alTop
      Caption = 'Edit'
      TabOrder = 4
      OnClick = btnEditClick
    end
    object btnAdd: TButton
      AlignWithMargins = True
      Left = 3
      Top = 65
      Width = 95
      Height = 25
      Align = alTop
      Caption = 'Add'
      TabOrder = 2
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      AlignWithMargins = True
      Left = 3
      Top = 96
      Width = 95
      Height = 25
      Align = alTop
      Caption = 'Delete'
      TabOrder = 3
      OnClick = btnDeleteClick
    end
    object btnUp: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 95
      Height = 25
      Align = alTop
      Caption = 'Move Up'
      TabOrder = 0
      OnClick = btnUpClick
    end
    object btnDown: TButton
      AlignWithMargins = True
      Left = 3
      Top = 34
      Width = 95
      Height = 25
      Align = alTop
      Caption = 'Move Down'
      TabOrder = 1
      OnClick = btnDownClick
    end
    object btnSwitchOn: TButton
      AlignWithMargins = True
      Left = 3
      Top = 158
      Width = 95
      Height = 25
      Align = alTop
      Caption = 'Apply'
      TabOrder = 5
      OnClick = btnSwitchOnClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 232
    Width = 625
    Height = 183
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lvInfo: TListView
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 619
      Height = 177
      Align = alClient
      Columns = <
        item
          Caption = 'Parameter'
          Width = 120
        end
        item
          AutoSize = True
          Caption = 'Value'
        end>
      FlatScrollBars = True
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object pnlMapSets: TPanel
    Left = 0
    Top = 0
    Width = 524
    Height = 229
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lvMapSets: TListView
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 518
      Height = 223
      Align = alClient
      Columns = <
        item
          Caption = 'Name'
          Width = 400
        end
        item
          Caption = 'Hotkey'
          Width = 100
        end>
      FlatScrollBars = True
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvMapSetsClick
      OnDblClick = lvMapSetsDblClick
    end
  end
  object chkEditByDblClick: TCheckBox
    AlignWithMargins = True
    Left = 6
    Top = 418
    Width = 616
    Height = 17
    Margins.Left = 6
    Align = alBottom
    Caption = 'Edit / Apply on double click'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
end
