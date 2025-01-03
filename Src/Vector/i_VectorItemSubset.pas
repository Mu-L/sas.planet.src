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

unit i_VectorItemSubset;

interface

uses
  ActiveX,
  t_Hash,
  i_VectorDataItemSimple;

type
  IVectorItemSubset = interface
    ['{D2DBC018-AAF5-44CB-A2B1-B5AC1C3341C5}']
    function GetEnum: IEnumUnknown;
    function IsEmpty: Boolean;
    function IsEqual(const ASubset: IVectorItemSubset): Boolean;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function GetItem(AIndex: Integer): IVectorDataItem;
    property Items[AIndex: Integer]: IVectorDataItem read GetItem; default;

    function GetHash: THashValue;
    property Hash: THashValue read GetHash;
  end;

implementation

end.
