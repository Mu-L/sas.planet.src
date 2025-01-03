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

unit i_NotifierLonLatRectUpdate;

interface

uses
  t_GeoTypes,
  i_Listener,
  i_LonLatRect;

type
  INotifierLonLatRectUpdate = interface
    ['{BE8DACC7-D94E-408A-A202-985D6DAC682A}']
    procedure Add(
      const AListener: IListener;
      const ARect: ILonLatRect
    ); stdcall;
    procedure Remove(const AListener: IListener); stdcall;
  end;

  INotifierLonLatRectUpdateInternal = interface
    procedure RectUpdateNotify(const ARect: ILonLatRect); stdcall; overload;
    procedure RectUpdateNotify(const ARect: TDoubleRect); stdcall; overload;
  end;

implementation

end.
