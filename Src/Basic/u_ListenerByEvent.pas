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

unit u_ListenerByEvent;

interface

uses
  t_Listener,
  i_NotifierTime,
  i_Listener,
  i_ListenerTime,
  i_SimpleFlag,
  u_BaseInterfacedObject;

type
  TNotifyEventListener = class(TBaseInterfacedObject, IListener, IListenerDisconnectable)
  private
    FDisconnectFlag: ISimpleFlag;
    FEvent: TNotifyListenerEvent;
  private
    { IListener }
    procedure Notification(const AMsg: IInterface);
  private
    { IListenerDisconnectable }
    procedure Disconnect;
  public
    constructor Create(const AEvent: TNotifyListenerEvent);
  end;

  TNotifyNoMmgEventListener = class(TBaseInterfacedObject, IListener)
  private
    FEvent: TNotifyListenerNoMmgEvent;
  private
    { IListener }
    procedure Notification(const AMsg: IInterface);
  public
    constructor Create(const AEvent: TNotifyListenerNoMmgEvent);
  end;

  TNotifyEventListenerSync = class(TBaseInterfacedObject, IListener)
  private
    FTimerNoifier: INotifierTime;
    FTimerListener: IListenerTime;

    FNeedNotifyFlag: ISimpleFlag;
    FEvent: TNotifyListenerNoMmgEvent;
    procedure OnTimer;
  private
    { IListener }
    procedure Notification(const AMsg: IInterface);
  public
    constructor Create(
      const ATimerNoifier: INotifierTime;
      const ACheckInterval: Cardinal;
      const AEvent: TNotifyListenerNoMmgEvent
    );
    destructor Destroy; override;
  end;

implementation

uses
  u_ListenerTime,
  u_SimpleFlagWithInterlock;

{ TNotifyEventListener }

constructor TNotifyEventListener.Create(const AEvent: TNotifyListenerEvent);
begin
  Assert(Assigned(AEvent));
  inherited Create;
  FEvent := AEvent;
  FDisconnectFlag := TSimpleFlagWithInterlock.Create;
end;

procedure TNotifyEventListener.Disconnect;
begin
  FDisconnectFlag.SetFlag;
end;

procedure TNotifyEventListener.Notification(const AMsg: IInterface);
begin
  inherited;
  if not FDisconnectFlag.CheckFlag then begin
    FEvent(AMsg);
  end;
end;

{ TNotifyEventListenerSync }

constructor TNotifyEventListenerSync.Create(
  const ATimerNoifier: INotifierTime;
  const ACheckInterval: Cardinal;
  const AEvent: TNotifyListenerNoMmgEvent
);
begin
  Assert(Assigned(AEvent));
  Assert(Assigned(ATimerNoifier));

  inherited Create;

  FTimerNoifier := ATimerNoifier;
  FEvent := AEvent;

  FNeedNotifyFlag := TSimpleFlagWithInterlock.Create;

  FTimerListener := TListenerTimeCheck.Create(Self.OnTimer, ACheckInterval);
  FTimerNoifier.Add(FTimerListener);
end;

procedure TNotifyEventListenerSync.OnTimer;
begin
  if FNeedNotifyFlag.CheckFlagAndReset then begin
    FEvent;
  end;
end;

destructor TNotifyEventListenerSync.Destroy;
begin
  if Assigned(FTimerNoifier) and Assigned(FTimerListener) then begin
    FTimerNoifier.Remove(FTimerListener);
    FTimerNoifier := nil;
    FTimerListener := nil;
  end;
  inherited;
end;

procedure TNotifyEventListenerSync.Notification(const AMsg: IInterface);
begin
  inherited;
  FNeedNotifyFlag.SetFlag;
end;

{ TNotifyNoMmgEventListener }

constructor TNotifyNoMmgEventListener.Create(const AEvent: TNotifyListenerNoMmgEvent);
begin
  Assert(Assigned(AEvent));
  inherited Create;
  FEvent := AEvent;
end;

procedure TNotifyNoMmgEventListener.Notification(const AMsg: IInterface);
begin
  FEvent;
end;

end.
