object frmStartLogo: TfrmStartLogo
  Left = 269
  Top = 224
  AutoSize = True
  BorderStyle = bsNone
  ClientHeight = 276
  ClientWidth = 480
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgLogo: TImage32
    Left = 0
    Top = 0
    Width = 480
    Height = 276
    Align = alClient
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baTopLeft
    Scale = 1.000000000000000000
    ScaleMode = smResize
    TabOrder = 0
    OnClick = imgLogoClick
    DesignSize = (
      480
      276)
    object lblWebSite: TLabel
      Left = 8
      Top = 254
      Width = 4
      Height = 16
      Anchors = [akLeft, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblVersion: TLabel
      Left = 464
      Top = 254
      Width = 4
      Height = 16
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object tmrLogo: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmrLogoTimer
    Left = 8
    Top = 8
  end
end
