object frmCacheManager: TfrmCacheManager
  Left = 0
  Top = 0
  Caption = 'Cache Manager'
  ClientHeight = 445
  ClientWidth = 572
  Color = clBtnFace
  ParentFont = True
  PopupMode = pmExplicit
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 572
    Height = 408
    ActivePage = tsConverter
    Align = alClient
    TabOrder = 0
    object tsConverter: TTabSheet
      Caption = 'Convert Cache Format'
      object grpSrc: TGroupBox
        Left = 2
        Top = 0
        Width = 555
        Height = 185
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Source Cache'
        TabOrder = 0
        object lblPath: TLabel
          Left = 11
          Top = 42
          Width = 27
          Height = 15
          Caption = 'Path:'
        end
        object lblCacheType: TLabel
          Left = 11
          Top = 86
          Width = 41
          Height = 15
          Caption = 'Format:'
        end
        object lblDefExtension: TLabel
          Left = 176
          Top = 86
          Width = 54
          Height = 15
          Caption = 'Extension:'
        end
        object edtPath: TEdit
          Left = 11
          Top = 59
          Width = 512
          Height = 23
          Align = alCustom
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
        end
        object pnlCacheTypes: TPanel
          Left = 11
          Top = 105
          Width = 153
          Height = 21
          BevelOuter = bvNone
          TabOrder = 4
        end
        object chkIgnoreTNE: TCheckBox
          Left = 280
          Top = 105
          Width = 130
          Height = 17
          Caption = 'Ignore *.tne'
          TabOrder = 5
        end
        object chkRemove: TCheckBox
          Left = 416
          Top = 105
          Width = 141
          Height = 17
          Caption = 'Remove tiles'
          TabOrder = 6
        end
        object btnSelectSrcPath: TButton
          Left = 529
          Top = 58
          Width = 21
          Height = 19
          Align = alCustom
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = btnSelectSrcPathClick
        end
        object chkCheckSourceVersion: TCheckBox
          Left = 11
          Top = 132
          Width = 536
          Height = 17
          Caption = 'Process only tiles  with version:'
          TabOrder = 7
        end
        object edtSourceVersion: TEdit
          Left = 11
          Top = 155
          Width = 532
          Height = 23
          Align = alCustom
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 8
        end
        object cbbSourceType: TComboBox
          Left = 11
          Top = 16
          Width = 158
          Height = 23
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 0
          Text = 'Folder'
          Items.Strings = (
            'Archive'
            'Folder'
            'File')
        end
        object cbbExt: TComboBox
          Left = 176
          Top = 104
          Width = 97
          Height = 23
          Style = csDropDownList
          TabOrder = 3
        end
      end
      object grpDestCache: TGroupBox
        Left = 3
        Top = 192
        Width = 555
        Height = 185
        Align = alCustom
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Dest Cache'
        TabOrder = 1
        object lblDestPath: TLabel
          Left = 10
          Top = 40
          Width = 27
          Height = 15
          Caption = 'Path:'
        end
        object lblDestFormat: TLabel
          Left = 10
          Top = 86
          Width = 41
          Height = 15
          Caption = 'Format:'
        end
        object edtDestPath: TEdit
          Left = 10
          Top = 59
          Width = 512
          Height = 23
          Align = alCustom
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
        end
        object pnlDestCacheTypes: TPanel
          Left = 10
          Top = 105
          Width = 153
          Height = 21
          BevelOuter = bvNone
          TabOrder = 3
        end
        object chkOverwrite: TCheckBox
          Left = 175
          Top = 105
          Width = 381
          Height = 17
          Caption = 'Overwrite existing tiles'
          TabOrder = 4
        end
        object btnSelectDestPath: TButton
          Left = 528
          Top = 59
          Width = 21
          Height = 19
          Align = alCustom
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = btnSelectDestPathClick
        end
        object chkReplaceDestVersion: TCheckBox
          Left = 10
          Top = 132
          Width = 536
          Height = 17
          Caption = 'Set same version for all processed tiles:'
          TabOrder = 5
        end
        object edtDestVersion: TEdit
          Left = 10
          Top = 155
          Width = 531
          Height = 23
          Align = alCustom
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 6
        end
        object cbbDestType: TComboBox
          Left = 10
          Top = 16
          Width = 159
          Height = 23
          Style = csDropDownList
          ItemIndex = 2
          TabOrder = 0
          Text = 'Folder'
          Items.Strings = (
            'Archive (zip)'
            'Archive (tar)'
            'Folder'
            'File')
        end
        object btnArchiveWriterConfig: TTBXButton
          Left = 175
          Top = 14
          Width = 26
          Height = 26
          ButtonStyle = bsFlat
          ImageIndex = 20
          Images = frmMain.MenusImageList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          Visible = False
          OnClick = btnArchiveWriterConfigClick
        end
      end
    end
  end
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 408
    Width = 572
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 1
    object btnStart: TButton
      AlignWithMargins = True
      Left = 410
      Top = 6
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Start'
      Default = True
      TabOrder = 1
      OnClick = btnStartClick
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 491
      Top = 6
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Close'
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object tbxtlbrDontClose: TTBXToolbar
      Left = 4
      Top = 6
      Width = 25
      Height = 24
      Align = alCustom
      Images = frmMain.MenusImageList
      ShrinkMode = tbsmWrap
      TabOrder = 0
      object tbtmDontClose: TTBItem
        AutoCheck = True
        Hint = 'Do not close this window after start'
        ImageIndex = 46
      end
    end
  end
  object dlgOpenFile: TOpenDialog
    Options = [ofReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 520
    Top = 32
  end
  object dlgSaveFile: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 520
    Top = 232
  end
end
