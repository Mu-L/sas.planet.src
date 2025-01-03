{******************************************************************************}
{* This file is part of SAS.Planet project.                                   *}
{*                                                                            *}
{* Copyright (C) 2007-Present, SAS.Planet development team.                   *}
{*                                                                            *}
{* SAS.Planet is free software: you can redistribute it and/or modify         *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* SAS.Planet is distributed in the hope that it will be useful,              *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with SAS.Planet. If not, see <http://www.gnu.org/licenses/>.         *}
{*                                                                            *}
{* https://github.com/sasgis/sas.planet.src                                   *}
{******************************************************************************}

unit i_MapZoomingConfig;

interface

uses
  i_ConfigDataElement;

type
  IMapZoomingConfig = interface(IConfigDataElement)
    ['{A322104E-A247-4EB3-83F6-C897F64E764C}']
    // ����������� ����� ��������� �������� ��� �������� ����
    function GetZoomingAtMousePos: Boolean;
    procedure SetZoomingAtMousePos(AValue: Boolean);
    property ZoomingAtMousePos: Boolean read GetZoomingAtMousePos write SetZoomingAtMousePos;

    //������������� ���
    function GetAnimateZoom: Boolean;
    procedure SetAnimateZoom(AValue: Boolean);
    property AnimateZoom: Boolean read GetAnimateZoom write SetAnimateZoom;

    function GetAnimateZoomTime: Cardinal;
    procedure SetAnimateZoomTime(AValue: Cardinal);
    property AnimateZoomTime: Cardinal read GetAnimateZoomTime write SetAnimateZoomTime;
  end;

implementation

end.
