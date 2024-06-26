object frmSettings: TfrmSettings
  Left = 293
  Top = 114
  Caption = 'Options'
  ClientHeight = 546
  ClientWidth = 652
  Color = clBtnFace
  Constraints.MinHeight = 468
  Constraints.MinWidth = 660
  ParentFont = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 652
    Height = 515
    ActivePage = tsMaps
    Align = alClient
    TabOrder = 0
    object tsMaps: TTabSheet
      BorderWidth = 3
      Caption = 'Maps'
      ImageIndex = 8
    end
    object tsFavorite: TTabSheet
      Caption = 'Favorites'
      ImageIndex = 10
    end
    object tsCache: TTabSheet
      Caption = 'Cache'
      ImageIndex = 1
      object flwpnlMemCache: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 361
        Width = 638
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 13
        object Label30: TLabel
          AlignWithMargins = True
          Left = 0
          Top = 3
          Width = 173
          Height = 13
          Margins.Left = 0
          Align = alLeft
          Caption = 'Number of tiles to be cached in RAM'
          Layout = tlCenter
        end
        object SETilesOCache: TSpinEdit
          Left = 176
          Top = 0
          Width = 65
          Height = 22
          MaxValue = 10000
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
      end
      object pnlNewCpath: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object pnlDBMSPath: TPanel
        Left = 0
        Top = 308
        Width = 644
        Height = 22
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 11
        object lbDBMSCachePath: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 54
          Height = 16
          Align = alLeft
          Caption = 'DBMS root:'
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object edtDBMSCachePath: TEdit
          Left = 200
          Top = 0
          Width = 395
          Height = 22
          Align = alRight
          Anchors = [akLeft, akTop, akRight, akBottom]
          BiDiMode = bdLeftToRight
          Ctl3D = True
          ParentBiDiMode = False
          ParentCtl3D = False
          TabOrder = 0
          ExplicitHeight = 21
        end
        object pnlButtnos: TPanel
          Left = 595
          Top = 0
          Width = 49
          Height = 22
          Align = alRight
          BevelEdges = []
          BevelKind = bkTile
          BevelOuter = bvNone
          TabOrder = 1
          object BtnDef: TButton
            Left = 2
            Top = 2
            Width = 23
            Height = 19
            Align = alCustom
            Caption = '<>'
            TabOrder = 0
            OnClick = BtnDefClick
          end
        end
      end
      object pnlOldCpath: TPanel
        Left = 0
        Top = 28
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlEScPath: TPanel
        Left = 0
        Top = 56
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 2
      end
      object pnlGMTilesPath: TPanel
        Left = 0
        Top = 84
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 3
      end
      object pnlGECachePath: TPanel
        Left = 0
        Top = 168
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 6
      end
      object pnledtBDBCachePath: TPanel
        Left = 0
        Top = 196
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 7
      end
      object pnledtBDBVerCachePath: TPanel
        Left = 0
        Top = 224
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 8
      end
      object pnledtGCCachePath: TPanel
        Left = 0
        Top = 280
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 10
      end
      object pnlDefCache: TPanel
        Left = 0
        Top = 330
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 12
        object lbl: TLabel
          Left = 3
          Top = 12
          Width = 91
          Height = 13
          Caption = 'Default cache type'
        end
        object pnlCacheTypesList: TPanel
          Left = 200
          Top = 5
          Width = 395
          Height = 23
          Align = alCustom
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
      object pnlMATilesPath: TPanel
        Left = 0
        Top = 112
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 4
      end
      object pnlTMSPath: TPanel
        Left = 0
        Top = 140
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 5
      end
      object pnlSQLiteCachePath: TPanel
        Left = 0
        Top = 252
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 9
      end
    end
    object tsInternet: TTabSheet
      BorderWidth = 3
      Caption = 'Internet'
      ImageIndex = 1
      object pnlDownloadParams: TPanel
        Left = 0
        Top = 0
        Width = 638
        Height = 481
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object chkRetryIfNoResponse: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 202
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Retry download tile if no response'
          TabOrder = 1
        end
        object chkProcessNextTile: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 225
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Process next tile if no response (when downloading the region)'
          TabOrder = 2
        end
        object CBSaveTileNotExists: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 248
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Store info about not found tiles'
          TabOrder = 3
        end
        object flwpnlDownloadTimeOut: TFlowPanel
          Left = 3
          Top = 291
          Width = 632
          Height = 28
          Margins.Left = 0
          Margins.Right = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 6
          object Label32: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 153
            Height = 13
            Caption = 'Network operations timeout, ms'
          end
          object SETimeOut: TSpinEdit
            Left = 162
            Top = 3
            Width = 73
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
        object CBLastSuccess: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 271
          Width = 626
          Height = 17
          Align = alTop
          Caption = 'Restore download from last successful tile'
          TabOrder = 4
        end
        object GroupBox4: TGroupBox
          Left = 3
          Top = 32
          Width = 632
          Height = 167
          Align = alTop
          Caption = 'Proxy settings'
          TabOrder = 0
          object pnlProxyUrl: TPanel
            AlignWithMargins = True
            Left = 5
            Top = 86
            Width = 622
            Height = 21
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object EditIP: TEdit
              Left = 128
              Top = 0
              Width = 494
              Height = 21
              Align = alClient
              TabOrder = 0
              ExplicitLeft = 56
              ExplicitWidth = 566
            end
            object cbbProxyType: TComboBox
              AlignWithMargins = True
              Left = 18
              Top = 0
              Width = 100
              Height = 21
              Margins.Left = 18
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 0
              Align = alLeft
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 1
            end
          end
          object flwpnlProxyAuth: TFlowPanel
            AlignWithMargins = True
            Left = 5
            Top = 136
            Width = 622
            Height = 21
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            TabOrder = 1
            object lblProxyLogin: TLabel
              AlignWithMargins = True
              Left = 18
              Top = 3
              Width = 52
              Height = 13
              Margins.Left = 18
              Caption = 'Username:'
            end
            object EditLogin: TEdit
              Left = 73
              Top = 0
              Width = 125
              Height = 21
              TabOrder = 0
            end
            object lblProxyPass: TLabel
              AlignWithMargins = True
              Left = 213
              Top = 3
              Width = 50
              Height = 13
              Margins.Left = 15
              Caption = 'Password:'
            end
            object EditPass: TEdit
              Left = 266
              Top = 0
              Width = 125
              Height = 21
              PasswordChar = '*'
              TabOrder = 1
            end
          end
          object CBLogin: TCheckBox
            AlignWithMargins = True
            Left = 22
            Top = 113
            Width = 605
            Height = 17
            Margins.Left = 20
            Align = alTop
            Caption = 'Proxy server requires authentication'
            TabOrder = 2
            OnClick = CBLoginClick
          end
          object pnlProxyRadioButtons: TPanel
            Left = 2
            Top = 15
            Width = 628
            Height = 68
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 3
            object rbManualProxy: TRadioButton
              Tag = 3
              AlignWithMargins = True
              Left = 3
              Top = 49
              Width = 622
              Height = 17
              Align = alTop
              Caption = 'Manual proxy configuration'
              TabOrder = 0
              OnClick = rbProxyClick
            end
            object rbNoProxy: TRadioButton
              Tag = 1
              AlignWithMargins = True
              Left = 3
              Top = 3
              Width = 622
              Height = 17
              Align = alTop
              Caption = 'No proxy'
              TabOrder = 1
              OnClick = rbProxyClick
            end
            object rbUseIESettings: TRadioButton
              Tag = 2
              AlignWithMargins = True
              Left = 3
              Top = 26
              Width = 622
              Height = 17
              Align = alTop
              Caption = 'Use system (Internet Explorer) proxy settings'
              TabOrder = 2
              OnClick = rbProxyClick
            end
          end
        end
        object flwpnl1: TFlowPanel
          Left = 3
          Top = 319
          Width = 632
          Height = 28
          Margins.Left = 0
          Margins.Right = 0
          Margins.Bottom = 5
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 7
          object lbl1: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 144
            Height = 13
            Caption = 'Sleep on reset connection, ms'
          end
          object seSleepOnResetConnection: TSpinEdit
            Left = 153
            Top = 3
            Width = 73
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
        object pnl1: TPanel
          AlignWithMargins = True
          Left = 6
          Top = 378
          Width = 626
          Height = 23
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 9
          object lbl2: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 59
            Height = 20
            Align = alLeft
            Caption = 'User-Agent:'
          end
          object edtUserAgent: TEdit
            AlignWithMargins = True
            Left = 68
            Top = 0
            Width = 534
            Height = 23
            Margins.Top = 0
            Margins.Bottom = 0
            Align = alClient
            TabOrder = 0
          end
          object btnResetUserAgentString: TButton
            Left = 605
            Top = 0
            Width = 21
            Height = 23
            Align = alRight
            Caption = '<>'
            TabOrder = 1
            OnClick = btnResetUserAgentStringClick
          end
        end
        object flwpnlMaxConnsPerServer: TFlowPanel
          Left = 3
          Top = 347
          Width = 632
          Height = 28
          Margins.Left = 0
          Margins.Right = 0
          Align = alTop
          AutoSize = True
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 8
          object lblMaxConnsPerServer: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 250
            Height = 13
            Caption = 'Max number of simultaneous connections per server'
          end
          object seMaxConnsPerServer: TSpinEdit
            Left = 259
            Top = 3
            Width = 73
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
        object pnlNetworkEngine: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 6
          Width = 629
          Height = 23
          Margins.Left = 0
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 9
          object lbl3: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 79
            Height = 17
            Align = alLeft
            Caption = 'Network engine:'
            ExplicitHeight = 13
          end
          object cbbNetworkEngine: TComboBox
            Left = 85
            Top = 0
            Width = 544
            Height = 21
            Align = alClient
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = cbbNetworkEngineChange
          end
        end
      end
    end
    object tsControl: TTabSheet
      Caption = 'Control'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 644
        Height = 42
        Align = alTop
        Caption = 'Mouse wheel'
        TabOrder = 0
        object ScrolInvert: TCheckBox
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 634
          Height = 17
          Align = alTop
          Caption = 'Roll backward to zoom in'
          TabOrder = 0
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 42
        Width = 644
        Height = 445
        Align = alClient
        Caption = 'Hotkeys'
        TabOrder = 1
      end
    end
    object tsView: TTabSheet
      Caption = 'View'
      ImageIndex = 3
      object grdpnlUI: TGridPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 487
        Align = alClient
        BevelOuter = bvNone
        ColumnCollection = <
          item
            Value = 50.000000000000000000
          end
          item
            Value = 50.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = pnlUILeft
            Row = 0
          end
          item
            Column = 1
            Control = pnlUIRight
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 0
        object pnlUILeft: TPanel
          Left = 0
          Top = 0
          Width = 322
          Height = 487
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 0
          object pnlDistFormat: TPanel
            Left = 3
            Top = 70
            Width = 316
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 2
            object Label3: TLabel
              Left = 3
              Top = 3
              Width = 115
              Height = 26
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Distance representation'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object ComboBox1: TComboBox
              AlignWithMargins = True
              Left = 121
              Top = 6
              Width = 189
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 0
              DropDownCount = 10
              TabOrder = 0
              Items.Strings = (
                '123 km 123 m'
                '123.12 km'
                'Kilometers'
                'Meters'
                'Centimeters'
                'Miles'
                'Yards'
                'Feet'
                'Inches'
                'Nautical Miles')
            end
          end
          object pnlLonLatFormat: TPanel
            Left = 3
            Top = 170
            Width = 316
            Height = 45
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 5
            object Label84: TLabel
              Left = 3
              Top = 3
              Width = 132
              Height = 15
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Coordinates representation'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbCoordRepresentation: TComboBox
              AlignWithMargins = True
              Left = 3
              Top = 21
              Width = 307
              Height = 21
              Margins.Left = 0
              Margins.Bottom = 0
              Align = alBottom
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = cbbCoordRepresentationChange
            end
          end
          object pnlLang: TPanel
            Left = 3
            Top = 3
            Width = 316
            Height = 35
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 0
            object Label8: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 47
              Height = 23
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Language'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object CBoxLocal: TComboBox
              AlignWithMargins = True
              Left = 59
              Top = 6
              Width = 251
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = CBoxLocalChange
            end
          end
          object pnlOptions: TPanel
            Left = 3
            Top = 215
            Width = 316
            Height = 91
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 6
            object CBShowmapname: TCheckBox
              Left = 3
              Top = 20
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Show map name on toolbar'
              TabOrder = 1
              ExplicitTop = 37
            end
            object ChBoxFirstLat: TCheckBox
              Left = 3
              Top = 3
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Latitude-Longitude order'
              TabOrder = 0
            end
            object CBlock_toolbars: TCheckBox
              Left = 3
              Top = 37
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Lock toolbars'
              TabOrder = 2
              ExplicitTop = 54
            end
            object CBMinimizeToTray: TCheckBox
              Left = 3
              Top = 54
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Minimize to tray'
              TabOrder = 3
              ExplicitTop = 71
            end
            object chkShowLogo: TCheckBox
              Left = 3
              Top = 71
              Width = 310
              Height = 17
              Align = alTop
              Caption = 'Show Logo on startup'
              TabOrder = 4
              ExplicitLeft = 6
              ExplicitTop = 420
              ExplicitWidth = 308
            end
          end
          object flwpnlTileBorder: TFlowPanel
            Left = 3
            Top = 306
            Width = 316
            Height = 28
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 7
            object Label69: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 122
              Height = 13
              Alignment = taRightJustify
              Caption = 'Download tiles off-screen'
            end
            object TilesOverScreenEdit: TSpinEdit
              Left = 131
              Top = 3
              Width = 37
              Height = 22
              MaxValue = 24
              MinValue = -2
              TabOrder = 0
              Value = 0
            end
          end
          object pnlImageProcess: TPanel
            Left = 3
            Top = 334
            Width = 316
            Height = 125
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 8
            object LabelGamma: TLabel
              Left = 3
              Top = 23
              Width = 310
              Height = 13
              Align = alTop
              Caption = '_'
              ExplicitWidth = 6
            end
            object LabelContrast: TLabel
              Left = 3
              Top = 61
              Width = 310
              Height = 13
              Align = alTop
              Caption = '_'
              ExplicitWidth = 6
            end
            object TrBarGamma: TTrackBar
              Left = 3
              Top = 36
              Width = 310
              Height = 25
              Hint = 'You can reset value by right mouse click'
              Align = alTop
              Max = 100
              Min = 1
              Frequency = 5
              Position = 1
              TabOrder = 1
              ThumbLength = 15
              TickMarks = tmTopLeft
              OnChange = TrBarGammaChange
            end
            object TrBarContrast: TTrackBar
              Left = 3
              Top = 74
              Width = 310
              Height = 25
              Hint = 'You can reset value by right mouse click'
              Align = alTop
              Max = 100
              Min = -100
              Frequency = 10
              TabOrder = 2
              ThumbLength = 15
              TickMarks = tmTopLeft
              OnChange = TrBarContrastChange
            end
            object CBinvertcolor: TCheckBox
              AlignWithMargins = True
              Left = 6
              Top = 102
              Width = 304
              Height = 17
              Align = alTop
              Caption = 'Night mode (color inversion)'
              TabOrder = 3
            end
            object pnlImageProcessTop: TPanel
              Left = 3
              Top = 3
              Width = 310
              Height = 20
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              object lblImageProcessCaption: TLabel
                Left = 0
                Top = 0
                Width = 105
                Height = 20
                Align = alLeft
                Caption = 'Image postprocessing'
                ExplicitHeight = 13
              end
              object btnImageProcessReset: TButton
                Left = 289
                Top = 0
                Width = 21
                Height = 20
                Hint = 'Reset postprocessing settings to defaults'
                Align = alRight
                Caption = '<>'
                TabOrder = 0
                OnClick = btnImageProcessResetClick
              end
            end
          end
          object pnlAreaFormat: TPanel
            Left = 3
            Top = 38
            Width = 316
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 1
            object lblAreaFormat: TLabel
              Left = 3
              Top = 3
              Width = 97
              Height = 26
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Area representation'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbAreaFormat: TComboBox
              AlignWithMargins = True
              Left = 103
              Top = 6
              Width = 207
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              DropDownCount = 10
              ItemIndex = 0
              TabOrder = 0
              Items.Strings = (
                'Auto'
                'Square Meters'
                'Square Kilometers'
                'Ares'
                'Hectares'
                'Square Feet'
                'Square Yards'
                'Square Miles'
                'Square Nautical Miles'
                'Acres')
            end
          end
          object pnlCoordSys: TPanel
            Left = 3
            Top = 102
            Width = 316
            Height = 34
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 3
            object lblCoordSysType: TLabel
              Left = 3
              Top = 3
              Width = 83
              Height = 28
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Coordinates type'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbCoordSysType: TComboBox
              AlignWithMargins = True
              Left = 89
              Top = 6
              Width = 221
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              OnChange = cbbCoordSysTypeChange
            end
          end
          object pnlCoordSysInfoType: TPanel
            Left = 3
            Top = 136
            Width = 316
            Height = 34
            Align = alTop
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 4
            object lblCoordSysInfoType: TLabel
              Left = 3
              Top = 3
              Width = 79
              Height = 28
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Coordinates info'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbCoordSysInfoType: TComboBox
              AlignWithMargins = True
              Left = 85
              Top = 6
              Width = 225
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              ItemIndex = 1
              TabOrder = 0
              Text = 'Don'#39't show for WGS 84'
              Items.Strings = (
                'Don'#39't show for All'
                'Don'#39't show for WGS 84'
                'Show for All')
            end
          end
        end
        object pnlUIRight: TPanel
          Left = 322
          Top = 0
          Width = 322
          Height = 487
          Align = alClient
          BevelEdges = [beLeft]
          BevelKind = bkTile
          BevelOuter = bvNone
          BorderWidth = 3
          TabOrder = 1
          object lblResize: TLabel
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 308
            Height = 13
            Align = alTop
            Caption = 'Resize Algorithm:'
            ExplicitWidth = 83
          end
          object flwpnlMiniMapAlfa: TFlowPanel
            Left = 3
            Top = 220
            Width = 314
            Height = 30
            Align = alTop
            AutoSize = True
            BevelEdges = [beTop]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 6
            object lblMiniMapAlfa: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 76
              Height = 13
              Alignment = taRightJustify
              Caption = 'Minimap opacity'
            end
            object MiniMapAlphaEdit: TSpinEdit
              Left = 85
              Top = 3
              Width = 57
              Height = 22
              MaxValue = 255
              MinValue = 0
              TabOrder = 0
              Value = 1
            end
          end
          object pnlFillMap: TPanel
            Left = 3
            Top = 286
            Width = 314
            Height = 51
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 8
            object Label24: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 302
              Height = 13
              Align = alTop
              Caption = 'Cached tiles map:'
              ExplicitWidth = 85
            end
            object flwpnlFillMap: TFlowPanel
              Left = 3
              Top = 22
              Width = 308
              Height = 24
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Label26: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 3
                Width = 25
                Height = 13
                Caption = 'Color'
              end
              object MapZapColorBox: TColorBox
                Left = 31
                Top = 0
                Width = 135
                Height = 22
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
                ItemHeight = 16
                TabOrder = 0
              end
              object Label29: TLabel
                AlignWithMargins = True
                Left = 169
                Top = 3
                Width = 37
                Height = 13
                Alignment = taRightJustify
                Caption = 'Opacity'
              end
              object MapZapAlphaEdit: TSpinEdit
                Left = 209
                Top = 0
                Width = 42
                Height = 22
                MaxValue = 255
                MinValue = 0
                TabOrder = 1
                Value = 255
              end
            end
          end
          object pnlBgColor: TPanel
            Left = 3
            Top = 250
            Width = 314
            Height = 36
            Align = alTop
            AutoSize = True
            BevelEdges = [beBottom]
            BevelKind = bkTile
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 7
            object lblBGColor: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 82
              Height = 22
              Align = alLeft
              Caption = 'Background color'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object ColorBoxBackGround: TColorBox
              AlignWithMargins = True
              Left = 94
              Top = 6
              Width = 214
              Height = 22
              Align = alClient
              Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
              ItemHeight = 16
              TabOrder = 0
            end
          end
          object pnlResize: TPanel
            Left = 3
            Top = 187
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 5
            object lblResizeMethod: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 28
              Height = 21
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'Other'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbResizeMethod: TComboBox
              AlignWithMargins = True
              Left = 40
              Top = 6
              Width = 268
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlResizeOnload: TPanel
            Left = 3
            Top = 22
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 0
            object lblResizeOnLoad: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 93
              Height = 21
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On load from cache'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbResizeOnLoad: TComboBox
              AlignWithMargins = True
              Left = 105
              Top = 6
              Width = 203
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlResizeGetPre: TPanel
            Left = 3
            Top = 55
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 1
            object lblResizeGetPre: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 115
              Height = 21
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On get from lower zoom'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbResizeGetPre: TComboBox
              AlignWithMargins = True
              Left = 127
              Top = 6
              Width = 181
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlProjectionChange: TPanel
            Left = 3
            Top = 88
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 2
            object lblProjectionChange: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 103
              Height = 21
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On projection change'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbProjectionChange: TComboBox
              AlignWithMargins = True
              Left = 115
              Top = 6
              Width = 193
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlDownloadResize: TPanel
            Left = 3
            Top = 121
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 3
            object lblDownloadResize: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 63
              Height = 21
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On download'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbDownloadResize: TComboBox
              AlignWithMargins = True
              Left = 75
              Top = 6
              Width = 233
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlResizeTileMatrixDraft: TPanel
            Left = 3
            Top = 154
            Width = 314
            Height = 33
            Align = alTop
            AutoSize = True
            BevelOuter = bvNone
            BorderWidth = 3
            TabOrder = 4
            object lblResizeTileMatrixDraft: TLabel
              AlignWithMargins = True
              Left = 6
              Top = 6
              Width = 107
              Height = 21
              Align = alLeft
              Alignment = taRightJustify
              Caption = 'On change zoom draft'
              Layout = tlCenter
              ExplicitHeight = 13
            end
            object cbbResizeTileMatrixDraft: TComboBox
              AlignWithMargins = True
              Left = 119
              Top = 6
              Width = 189
              Height = 21
              Align = alClient
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                '')
            end
          end
          object pnlMarksCaption: TPanel
            Left = 3
            Top = 337
            Width = 314
            Height = 80
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 9
            object grpMarksCaption: TGroupBox
              Left = 0
              Top = 0
              Width = 314
              Height = 80
              Align = alClient
              Caption = 'Placemark names'
              TabOrder = 0
              object chkMarkCaptionSolidBg: TCheckBox
                AlignWithMargins = True
                Left = 5
                Top = 39
                Width = 304
                Height = 17
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Solid background color'
                TabOrder = 0
              end
              object pnlMarkCaptionFont: TPanel
                Left = 2
                Top = 15
                Width = 310
                Height = 21
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 1
                object lblMarksCaptionFontName: TLabel
                  AlignWithMargins = True
                  Left = 3
                  Top = 3
                  Width = 22
                  Height = 15
                  Align = alLeft
                  Caption = 'Font'
                  ExplicitHeight = 13
                end
                object btnMarkCaptionFont: TSpeedButton
                  AlignWithMargins = True
                  Left = 286
                  Top = 0
                  Width = 21
                  Height = 21
                  Margins.Top = 0
                  Margins.Bottom = 0
                  Align = alRight
                  Caption = '...'
                  OnClick = btnMarkCaptionFontClick
                  ExplicitLeft = 290
                end
                object edtMarksCaptionFontName: TEdit
                  Left = 28
                  Top = 0
                  Width = 255
                  Height = 21
                  Align = alClient
                  TabOrder = 0
                end
              end
              object chkMarksCaptionVisible: TCheckBox
                AlignWithMargins = True
                Left = 5
                Top = 56
                Width = 304
                Height = 17
                Margins.Top = 0
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Show placemark names'
                TabOrder = 2
              end
            end
          end
          object CBShowHintOnMarks: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 420
            Width = 308
            Height = 17
            Align = alTop
            Caption = 'Show hints when hovering over placemarks'
            TabOrder = 10
            ExplicitTop = 460
            ExplicitWidth = 314
          end
          object chkAddTimeToMarkDescription: TCheckBox
            AlignWithMargins = True
            Left = 6
            Top = 440
            Width = 308
            Height = 17
            Align = alTop
            Caption = 'Insert timestamp into placemark description'
            TabOrder = 11
          end
        end
      end
    end
    object tsSearch: TTabSheet
      Caption = 'Search'
      ImageIndex = 11
      object pnlGoogleApiKey: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 45
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object pnlYandexApiKey: TPanel
        Left = 0
        Top = 45
        Width = 644
        Height = 45
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitLeft = 3
        ExplicitTop = 146
      end
    end
    object tsGrids: TTabSheet
      Caption = 'Grids'
      ImageIndex = 8
      object pnlTileBorders: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 68
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 0
        object Label23: TLabel
          Left = 3
          Top = 3
          Width = 638
          Height = 13
          Align = alTop
          Caption = 'Tile borders:'
          ExplicitWidth = 60
        end
        object flwpnlTileBorders: TFlowPanel
          Left = 3
          Top = 16
          Width = 638
          Height = 25
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelOuter = bvNone
          Padding.Top = 3
          TabOrder = 0
          object Label27: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 6
            Width = 25
            Height = 13
            Caption = 'Color'
          end
          object ColorBoxBorder: TColorBox
            Left = 31
            Top = 3
            Width = 135
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
          end
          object Label28: TLabel
            AlignWithMargins = True
            Left = 169
            Top = 6
            Width = 37
            Height = 13
            Caption = 'Opacity'
          end
          object SpinEditBorderAlpha: TSpinEdit
            Left = 209
            Top = 3
            Width = 42
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 1
            Value = 255
          end
        end
        object CBBorderText: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 44
          Width = 286
          Height = 16
          Align = alLeft
          Caption = 'Tile coordinates'
          TabOrder = 1
        end
      end
      object pnlGenshtabBorders: TPanel
        Left = 0
        Top = 68
        Width = 644
        Height = 68
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 1
        object LabelGsh1: TLabel
          Left = 3
          Top = 3
          Width = 638
          Height = 13
          Align = alTop
          Caption = 'Genshtab Map boundaries:'
          ExplicitWidth = 129
        end
        object flwpnlGenshtabBorders: TFlowPanel
          Left = 3
          Top = 16
          Width = 638
          Height = 25
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelOuter = bvNone
          Padding.Top = 3
          TabOrder = 0
          object LabelGsh2: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 6
            Width = 25
            Height = 13
            Caption = 'Color'
          end
          object GenshtabBoxBorder: TColorBox
            Left = 31
            Top = 3
            Width = 135
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
          end
          object LabelGsh3: TLabel
            AlignWithMargins = True
            Left = 169
            Top = 6
            Width = 37
            Height = 13
            Caption = 'Opacity'
          end
          object SpinEditGenshtabBorderAlpha: TSpinEdit
            Left = 209
            Top = 3
            Width = 42
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 1
            Value = 255
          end
        end
        object CBGenshtabBorderText: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 44
          Width = 300
          Height = 16
          Align = alLeft
          Caption = 'Genshtab Map names'
          TabOrder = 1
        end
      end
      object pnlDegreeBorders: TPanel
        Left = 0
        Top = 136
        Width = 644
        Height = 68
        Align = alTop
        AutoSize = True
        BevelEdges = [beBottom]
        BevelKind = bkTile
        BevelOuter = bvNone
        BorderWidth = 3
        TabOrder = 2
        object LabelDeg1: TLabel
          Left = 3
          Top = 3
          Width = 638
          Height = 13
          Align = alTop
          Caption = 'Lat/Lon grid:'
          ExplicitWidth = 61
        end
        object flwpnlDegreeBorders: TFlowPanel
          Left = 3
          Top = 16
          Width = 638
          Height = 25
          Align = alTop
          AutoSize = True
          BevelEdges = [beBottom]
          BevelOuter = bvNone
          Padding.Top = 3
          TabOrder = 0
          object LabelDeg2: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 6
            Width = 25
            Height = 13
            Caption = 'Color'
          end
          object DegreeBoxBorder: TColorBox
            Left = 31
            Top = 3
            Width = 135
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
            ItemHeight = 16
            TabOrder = 0
          end
          object LabelDeg3: TLabel
            AlignWithMargins = True
            Left = 169
            Top = 6
            Width = 37
            Height = 13
            Caption = 'Opacity'
          end
          object SpinEditDegreeBorderAlpha: TSpinEdit
            Left = 209
            Top = 3
            Width = 42
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 1
            Value = 255
          end
        end
        object CBDegreeBorderText: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 44
          Width = 300
          Height = 16
          Align = alLeft
          Caption = 'Grid line labels'
          TabOrder = 1
        end
      end
    end
    object tsGPS: TTabSheet
      Caption = 'GPS'
      ImageIndex = 4
    end
    object tsWiki: TTabSheet
      Caption = 'Vector Layer'
      ImageIndex = 7
      object grdpnlWiki: TGridPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 129
        Align = alTop
        BevelOuter = bvNone
        ColumnCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 200.000000000000000000
          end
          item
            Value = 100.000000000000000000
          end>
        ControlCollection = <
          item
            Column = 0
            Control = lblWikiMainColor
            Row = 0
          end
          item
            Column = 1
            Control = CBWMainColor
            Row = 0
          end
          item
            Column = 0
            Control = lblWikiShadowColor
            Row = 1
          end
          item
            Column = 1
            Control = CBWShadowColor
            Row = 1
          end
          item
            Column = 0
            Control = lblWikiFillColor
            Row = 2
          end
          item
            Column = 1
            Control = CBWFillColor
            Row = 2
          end
          item
            Column = 0
            Control = lblWikiBorderColor
            Row = 3
          end
          item
            Column = 1
            Control = CBWBorderColor
            Row = 3
          end
          item
            Column = 0
            Control = lblWikiMarkerSize
            Row = 4
          end
          item
            Column = 1
            Control = seWikiMarkerSize
            Row = 4
          end>
        RowCollection = <
          item
            SizeStyle = ssAbsolute
            Value = 25.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 25.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 25.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 25.000000000000000000
          end
          item
            SizeStyle = ssAbsolute
            Value = 25.000000000000000000
          end>
        TabOrder = 0
        DesignSize = (
          644
          129)
        object lblWikiMainColor: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 5
          Width = 194
          Height = 17
          Margins.Top = 5
          Margins.Bottom = 3
          Align = alClient
          Caption = 'Primary color'
        end
        object CBWMainColor: TColorBox
          Left = 200
          Top = 1
          Width = 159
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akBottom]
          TabOrder = 0
        end
        object lblWikiShadowColor: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 30
          Width = 194
          Height = 17
          Margins.Top = 5
          Margins.Bottom = 3
          Align = alClient
          Caption = 'Shadow color'
        end
        object CBWShadowColor: TColorBox
          Left = 200
          Top = 26
          Width = 159
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akBottom]
          TabOrder = 1
        end
        object lblWikiFillColor: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 55
          Width = 194
          Height = 17
          Margins.Top = 5
          Margins.Bottom = 3
          Align = alClient
          Caption = 'Marker fill color'
        end
        object CBWFillColor: TColorBox
          Left = 200
          Top = 51
          Width = 159
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akBottom]
          TabOrder = 2
        end
        object lblWikiBorderColor: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 80
          Width = 194
          Height = 17
          Margins.Top = 5
          Margins.Bottom = 3
          Align = alClient
          Caption = 'Marker border color'
        end
        object CBWBorderColor: TColorBox
          Left = 200
          Top = 76
          Width = 159
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
          Anchors = [akLeft, akTop, akBottom]
          TabOrder = 3
        end
        object lblWikiMarkerSize: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 105
          Width = 194
          Height = 17
          Margins.Top = 5
          Margins.Bottom = 3
          Align = alClient
          Caption = 'Marker size'
        end
        object seWikiMarkerSize: TSpinEdit
          Left = 200
          Top = 100
          Width = 159
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
      end
    end
    object tsPaths: TTabSheet
      Caption = 'Paths'
      ImageIndex = 10
      object pnlMapsPath: TPanel
        Left = 0
        Top = 168
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 6
      end
      object pnlUserDataPath: TPanel
        Left = 0
        Top = 140
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 5
      end
      object pnlTerrainDataPath: TPanel
        Left = 0
        Top = 196
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 7
      end
      object pnlTrackPath: TPanel
        Left = 0
        Top = 112
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 4
      end
      object pnlMarksDbPath: TPanel
        Left = 0
        Top = 28
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 1
      end
      object pnlMarksIconsPath: TPanel
        Left = 0
        Top = 84
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 3
      end
      object pnlMediaDataPath: TPanel
        Left = 0
        Top = 56
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 2
      end
      object pnlBaseCahcePath: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 28
        Align = alTop
        BevelEdges = []
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
  object pnlBottomButtons: TPanel
    Left = 0
    Top = 515
    Width = 652
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 574
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object btnOk: TButton
      AlignWithMargins = True
      Left = 493
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnApplyClick
    end
    object btnApply: TButton
      AlignWithMargins = True
      Left = 412
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Apply'
      TabOrder = 0
      OnClick = btnApplyClick
    end
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Top = 512
  end
end
