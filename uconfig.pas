unit uConfig;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type TSettingDatabase = record
    host : string;
    user : string;
    port :integer;
    pasword:string;
end;

procedure setting_load();
procedure setting_save();

const
  MASTER_DIR = 'c:\daniel_lima_dev\';
  CONFIG_FILE = MASTER_DIR + 'config.ini';
  CONFIG_FILE_DATABASE = 'DATABASE';
var
  setting_database : TSettingDatabase;

implementation

uses IniFiles;

procedure setting_load();
var
    Sett : TIniFile;
begin
  if not FileExists(CONFIG_FILE) then
  begin
    setting_save();
    exit;
  end;

  Sett := TIniFile.Create(CONFIG_FILE);
  setting_database.host    := Sett.ReadString(CONFIG_FILE_DATABASE, 'host', 'localhost');
  setting_database.port    := Sett.ReadInteger(CONFIG_FILE_DATABASE, 'port', 5432);
  setting_database.user    := Sett.ReadString(CONFIG_FILE_DATABASE, 'user', 'root');
  setting_database.pasword := Sett.ReadString(CONFIG_FILE_DATABASE, 'pasword', '1');
  Sett.Free;

end;

procedure  setting_save();
var
    Sett : TIniFile;
begin
    Sett := TIniFile.Create(CONFIG_FILE);
    Sett.WriteString(CONFIG_FILE_DATABASE, 'host', setting_database.host);
    Sett.WriteInteger(CONFIG_FILE_DATABASE, 'port', setting_database.port);
    Sett.WriteString(CONFIG_FILE_DATABASE, 'user', setting_database.user);
    Sett.WriteString(CONFIG_FILE_DATABASE, 'pasword', setting_database.pasword);
    Sett.Free;
end;

end.

