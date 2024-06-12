unit uformprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, DBCtrls, ZConnection, ZDataset, ZAbstractRODataset, uConfig;

type
  TLogType = (ltError, ltMsg);

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    btnInteractionSave: TButton;
    chConected: TCheckBox;
    dsInteraction: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblToSend: TLabel;
    lblSended: TLabel;
    mmLog: TMemo;
    Panel1: TPanel;
    tmInteractionSave: TTimer;
    TimerKey: TTimer;
    ZConnection: TZConnection;
    zqInteractionPost: TZQuery;
    procedure btnInteractionSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerKeyTimer(Sender: TObject);
    procedure tmInteractionSaveTimer(Sender: TObject);
  private
    interactions_count_sended:integer;
    interactions_count_tosend:integer;
  public
    procedure Coloca(valor:string);
    procedure acumular_um_digito();
    procedure interaction_save();
    procedure database_connect();
    procedure log_add(log_type:TLogType;title:string;msg:string);
    procedure counts_show();
  end;

var
  formPrincipal: TformPrincipal;

implementation
uses JwaWindows;

{$R *.lfm}

{ TformPrincipal }

procedure TformPrincipal.TimerKeyTimer(Sender: TObject);
var
  keyloop, KeyResult: integer;
begin
  keyloop := 0;
  repeat
    KeyResult := GetAsyncKeyState(keyloop);
    if KeyResult = -32767 then
    begin
      case keyloop of
        8: Coloca(' [bACKSPACE] ');
        9: Coloca(' [TAB] ');
        12: Coloca(' [ALT] ');
        13: Coloca(' [ENTER] ');
        16: Coloca(' [sHIFT] ');
        17: Coloca(' [CONTROL] ');
        18: Coloca(' [ALT] ');
        20: Coloca(' [CAPS LOCK] ');
        21: Coloca(' [PAGE UP] ');
        27: Coloca(' [ESC] ');
        33: Coloca(' [PAGE UP] ');
        34: Coloca(' [PAGE DOWN] ');
        35: Coloca(' [END] ');
        36: Coloca(' [HOME] ');
        37: Coloca(' [sETA ESQUERDA] ');
        38: Coloca(' [sETA ACIMA] ');
        39: Coloca(' [sETA DIREITA] ');
        40: Coloca(' [sETA ABAIXO] ');
        45: Coloca(' [iNSERT] ');
        46: Coloca(' [DEL] ');
        91: Coloca(' [WIN ESQUERDA] ');
        92: Coloca(' [WIN DIREITA] ');
        93: Coloca(' [MENU POP-UP] ');
        96: Coloca('0');
        97: Coloca('1');
        98: Coloca('2');
        99: Coloca('3');
        100: Coloca('4');
        101: Coloca('5');
        102: Coloca('6');
        103: Coloca('7');
        104: Coloca('8');
        105: Coloca('9');
        106: Coloca(' [NUM *] ');
        107: Coloca(' [NUM +] ');
        109: Coloca(' [NUM -] ');
        110: Coloca(' [NUM SEP. DECIMAL] ');
        111: Coloca(' [NUM /] ');
        112: Coloca(' [F1] ');
        113: Coloca(' [F2] ');
        114: Coloca(' [F3] ');
        115: Coloca(' [F4] ');
        116: Coloca(' [F5] ');
        117: Coloca(' [F6] ');
        118: Coloca(' [F7] ');
        119: Coloca(' [F8] ');
        120: Coloca(' [F9] ');
        121: Coloca(' [F10] ');
        122: Coloca(' [F11] ');
        123: Coloca(' [F12] ');
        144: Coloca(' [NUM LOCK] ');
        186: Coloca('Ç');
        187: Coloca('=');
        188: Coloca(',');
        189: Coloca('-');
        190: Coloca('.');
        191: Coloca(';');
        192: Coloca(' [APÓSTROFO] ');
        193: Coloca('/');
        194: Coloca(' [NUM PONTO] ');
        219: Coloca('´');
        220: Coloca(']');
        221: Coloca('[');
        222: Coloca('~');
        226: Coloca('\');
        else
          if (KeyLoop >= 65) and (keyloop <= 90) then
            Coloca(Chr(keyloop));
          if (keyloop >= 32) and (keyloop <= 63) then
            Coloca(Chr(keyloop));
          //numpad keycodes
          if (keyloop >= 96) and (keyloop <= 110) then
            Coloca(Chr(keyloop));
      end;
    end; //case;
    Inc(keyloop);
  until keyloop = 255;
end;

procedure TformPrincipal.interaction_save();
const
  LOG_TITLE = 'interaction_save()';
begin
  if interactions_count_tosend = 0 then
  begin
    //log_add(TLogType.ltMsg, LOG_TITLE, 'Nothing to be sent');
    exit;
  end;

  zqInteractionPost.ParamByName('value').AsInteger := interactions_count_tosend;

  try
     zqInteractionPost.ExecSQL;
  except
    on e:Exception do
    begin
       log_add(TLogType.ltError, LOG_TITLE, e.Message);
       exit;
    end;
  end;
  log_add(TLogType.ltMsg, LOG_TITLE, 'Sended: ' + intToStr(interactions_count_tosend));
  interactions_count_sended :=  interactions_count_sended + interactions_count_tosend;
  interactions_count_tosend := 0;
  counts_show();
end;

procedure TformPrincipal.tmInteractionSaveTimer(Sender: TObject);
begin
  if not ZConnection.Connected then
  begin
    database_connect();
    exit;
  end;

  interaction_save();
  counts_show();
end;

procedure TformPrincipal.TimerDisplayTimer(Sender: TObject);
begin

end;

procedure TformPrincipal.btnInteractionSaveClick(Sender: TObject);
begin
  interaction_save();
end;

procedure TformPrincipal.FormCreate(Sender: TObject);
begin

end;

procedure TformPrincipal.FormShow(Sender: TObject);
begin
  if ZConnection.Connected then
  begin
    raise Exception.Create('Previously connected connection');
  end;

  counts_show();
end;

procedure TFormPrincipal.Coloca(valor:string);
begin
 acumular_um_digito();
end;

procedure TFormPrincipal.acumular_um_digito();
begin
 interactions_count_tosend := interactions_count_tosend + 1;
 counts_show();
end;

procedure TFormPrincipal.database_connect();
begin

 setting_load();

 ZConnection.HostName := setting_database.host;
 ZConnection.Port := setting_database.port;
 ZConnection.User := setting_database.user;
 ZConnection.Password := setting_database.pasword;

 try
   ZConnection.Connect;
 except
   on E: Exception do
   begin
      log_add(ltError, E.ClassName, E.Message);
      chConected.Checked:=false;
   end;
 end;

  if ZConnection.Connected then
  begin
    log_add(TLogType.ltMsg, 'Conection openned', '');
    chConected.Checked:=true;
  end;
end;

procedure TFormPrincipal.log_add(log_type:TLogType;title:string;msg:string);
begin
  mmlog.lines.add('');
  mmlog.lines.add(title);
  mmlog.lines.add(msg);
end;
procedure TFormPrincipal.counts_show();
begin
  lblToSend.Caption:=IntToStr(interactions_count_tosend);
  lblSended.Caption:=IntToStr(interactions_count_sended);
end;

end.
