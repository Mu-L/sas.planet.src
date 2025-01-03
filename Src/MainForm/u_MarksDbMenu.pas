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

unit u_MarksDbMenu;

interface

uses
  Classes,
  TBX,
  i_Listener,
  i_MarkSystemConfig;

type
  TMarksDbMenu = class(TComponent)
  private
    FSubmenuItem: TTBXSubmenuItem;
    FConfig: IMarkSystemConfigListChangeable;
    FListener: IListener;
    procedure OnConfigChange;
    procedure OnItemClick(Sender: TObject);
  public
    constructor Create(
      const AOwner: TComponent;
      const ASubmenuItem: TTBXSubmenuItem;
      const AConfig: IMarkSystemConfigListChangeable
    ); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  u_MarksExplorerHelper,
  u_ListenerByEvent;

{ TMarksDbMenu }

constructor TMarksDbMenu.Create(
  const AOwner: TComponent;
  const ASubmenuItem: TTBXSubmenuItem;
  const AConfig: IMarkSystemConfigListChangeable
);
begin
  Assert(Assigned(AConfig));

  inherited Create(AOwner);

  FSubmenuItem := ASubmenuItem;
  FConfig := AConfig;

  FListener := TNotifyNoMmgEventListener.Create(Self.OnConfigChange);
  FConfig.GetChangeNotifier.Add(FListener);

  OnConfigChange;
end;

destructor TMarksDbMenu.Destroy;
begin
  if Assigned(FConfig) and Assigned(FListener) then begin
    FConfig.GetChangeNotifier.Remove(FListener);
    FListener := nil;
    FConfig := nil;
  end;
  inherited;
end;

procedure TMarksDbMenu.OnItemClick(Sender: TObject);
begin
  Assert(Assigned(Sender));
  FConfig.ActiveConfigID := TComponent(Sender).Tag;
end;

procedure TMarksDbMenu.OnConfigChange;
begin
  RefreshConfigListMenu(FSubmenuItem, False, Self.OnItemClick, FConfig);
end;

end.
