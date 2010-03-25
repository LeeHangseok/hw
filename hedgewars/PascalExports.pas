(*
 *  PascalExports.pas
 *  hwengine
 *
 *  Created by Vittorio on 09/01/10.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 *)


{$INCLUDE "options.inc"}

unit PascalExports;

interface
uses uKeys, uConsole, hwengine;

{$INCLUDE "config.inc"}

implementation

{$IFDEF HWLIBRARY}
// retrieve protocol information
procedure HW_versionInfo(netProto: PShortInt; versionStr: PString); cdecl; export;
begin
    if netProto <> nil then netProto^:= cNetProtoVersion;
    if versionStr <> nil then versionStr^:= shortstring(cVersionString);
end;

procedure HW_click; cdecl; export;
begin
    leftClick:= true;
end;

procedure HW_zoomIn; cdecl; export;
begin
    wheelUp:= true;
end;

procedure HW_zoomOut; cdecl; export;
begin
    wheelDown:= true;
end;

procedure HW_zoomReset; cdecl; export;
begin
    middleClick:= true;
end;

procedure HW_ammoMenu; cdecl; export;
begin
    rightClick:= true;
end;

procedure HW_allKeysUp; cdecl; export;
begin
    // set all keys to released
    uKeys.initModule;
end;

procedure HW_walkLeft; cdecl; export;
begin
    leftKey:= true;
end;

procedure HW_walkRight; cdecl; export;
begin
    rightKey:= true;
end;

procedure HW_aimUp; cdecl; export;
begin
    upKey:= true;
end;

procedure HW_aimDown; cdecl; export;
begin
    downKey:= true;
end;

procedure HW_shoot; cdecl; export;
begin
    spaceKey:= true;
end;

procedure HW_jump; cdecl; export;
begin
    enterKey:= true;
end;

procedure HW_backjump; cdecl; export;
begin
    backspaceKey:= true;
end;

procedure HW_chat; cdecl; export;
begin
    chatAction:= true;
end;

procedure HW_tab; cdecl; export;
begin
    switchAction:= true;
end;

procedure HW_pause; cdecl; export;
begin
    pauseAction:= true;
end;

procedure HW_whereIsHog; cdecl; export;
//var Xcoord, Ycoord: LongInt;
begin
    //Xcoord:= Gear^.dX + WorldDx;
    WriteLnToConsole('HW - hog is at x: ' + ' y:');

    exit
end;

procedure HW_terminate(closeFrontend: boolean); cdecl; export;
begin
    isTerminated:= true;
    if closeFrontend then alsoShutdownFrontend:= true;
end;
{$ENDIF}

end.

