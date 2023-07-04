unit FechaStuff;
{$codepage UTF8}
interface
uses ArchivoAtenciones, ArchivoPacientes, crt, SysUtils;
const
DiasEnMes: array[1..12] of Byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

function fechaValida(fecha: String):boolean; 
function esBisiesto(ano: Word): Boolean;
function fechaVeridica(ano, mes, dia: Integer): Boolean;
function fechanumero(r: reg_aten):LongInt;
function fecharecon(r: reg_aten):fecha_at;
function fechanumero2(fecha:String):LongInt;
procedure FechaSeparada(fecha:string;var dia:string;var mes:string;var an:string);
procedure FechaSeparadaInt(fecha:string;var dia:Integer;var mes:Integer;var an:Integer);
function FechaAuto():string;
function ValidarFecha(fecha: String): Boolean;
implementation

{=============Function FechaValida===========}
{Esta function valida que la fecha ingresada sea NN/NN/NNNN, donde N = numero del 0 al 9}
function fechaValida(fecha: String):boolean; 
var
dia,mes:String[2];
ano:String[4];
diaValido,mesValido,anoValido,barras:boolean;
num:LongInt; //A este "num" da output el int de TryStrToInt, no lo usamos pero es necesario declararlo
begin
    fechaValida:=False;
    barras:=False;
    diaValido:=False;
    mesValido:=False;
    anoValido:=False;
    
    FechaSeparada(fecha,dia,mes,ano);
    
    if (fecha[3] = '/') and (fecha[6] = '/') then barras := True;

    if (dia[1] <> 'x') and (dia <> '0x') then diaValido := TryStrToInt(dia,num);
    if (mes[1] <> 'x') and (mes <> '0x') then mesValido := TryStrToInt(mes,num);
    if (ano[1] <> 'x') and (ano <> '0x') then anoValido := TryStrToInt(ano,num);

    
    if (diaValido and mesValido and anoValido and barras) then fechaValida:=True;
end;

function esBisiesto(ano: Word): Boolean;
begin
  esBisiesto := (ano mod 4 = 0) and ((ano mod 100 <> 0) or (ano mod 400 = 0));
end;

{=============Function FechaVeridica===========}
{Esta function valida que la fecha ingresada sea verídica, es decir, que esté dentro del calendario, teniendo en cuenta años bisiestos}
function fechaVeridica(ano, mes, dia: Integer): Boolean;
var
  esValida: Boolean;
begin
  esValida := (ano >= 1900) and (ano <= 5000) and
             (mes >= 1) and (mes <= 12) and
             (dia >= 1) and (dia <= DiasEnMes[mes]) and
             (not ((mes = 2) and (dia = 29) and (not esBisiesto(ano))));
  fechaVeridica := esValida;
end;
{=============funcion para fecha directa de un registro===========}
function fechanumero(r: reg_aten):LongInt;
var
    dia,mes:string[2];
    an:String[4];
begin
    dia:= r.fecha_atencion[1] + r.fecha_atencion[2];
    mes:= r.fecha_atencion[4] + r.fecha_atencion[5];
    an:= r.fecha_atencion[7] + r.fecha_atencion[8] + r.fecha_atencion[9] + r.fecha_atencion[10];
    fechanumero:=(StrToInt(dia) + (StrToInt(mes)*30) + (StrToInt(an)*365));
end;

{=============funcion para fecha directa de un registro, pone el año + mes + dia para el burbujaDF===========}
function fecharecon(r: reg_aten):fecha_at;
var
    dia,mes:string[2];
    an:String[4];
begin
    dia:= r.fecha_atencion[1] + r.fecha_atencion[2];
    mes:= r.fecha_atencion[4] + r.fecha_atencion[5];
    an:= r.fecha_atencion[7] + r.fecha_atencion[8] + r.fecha_atencion[9] + r.fecha_atencion[10];
    fecharecon:= an + mes + dia;
end;

{=============funcion para pasar la fecha a un numero comparable, en formato string, para poder comparar, se usa en atención entre 2 fechas===========}
function fechanumero2(fecha:String):LongInt;
var
    dia,mes:string[2];
    an:String[4];
begin
    dia:= fecha[1] + fecha[2];
    mes:= fecha[4] + fecha[5];
    an:= fecha[7] + fecha[8] + fecha[9] + fecha[10];
    fechanumero2:=(StrToInt(dia) + (StrToInt(mes)*30) + (StrToInt(an)*365));
end;
{=============procedure para separar fecha en strings dia mes año===========}
procedure FechaSeparada(fecha:string;var dia:string;var mes:string;var an:string);
begin
    dia:= (fecha[1] + fecha[2]);
    mes:= (fecha[4] + fecha[5]);
    an:= (fecha[7] + fecha[8] + fecha[9] + fecha[10]);
end;
procedure FechaSeparadaInt(fecha:string;var dia:Integer;var mes:Integer;var an:Integer);
begin
    dia:= StrToInt(fecha[1] + fecha[2]);
    mes:= StrToInt(fecha[4] + fecha[5]);
    an:= StrToInt(fecha[7] + fecha[8] + fecha[9] + fecha[10]);
end;

function FechaAuto():string;
Var ThisMoment : TDateTime;
Begin
fechaAuto:=(FormatDateTime('DD/MM/YYYY',Now));
end;

{=============Function ValidarFecha===========}
{Esta función ejecuta FechaValida y FechaVeridica en la fecha ingresada}
function ValidarFecha(fecha: String): Boolean;
var
  diaStr, mesStr, anStr: string;
  diaInt, mesInt, anInt: Integer;
begin
  ValidarFecha := False;
 

  if fechaValida(fecha) = True then
    begin
     FechaSeparadaInt(fecha,diaInt,mesInt,anInt); 
      ValidarFecha := fechaVeridica(anInt, mesInt, diaInt);
      if ValidarFecha = False then
        begin
          gotoxy(0, 30);
          TextBackground(Red);
          writeln('La fecha ingresada no existe en el calendario');
          TextBackground(Black);
          readkey;
        end;
    end
  else
  begin
    gotoxy(0, 30);
    TextBackground(Red);
    writeln('Ingresó caracteres inválidos en la fecha, use DD/MM/AAAA');
    TextBackground(Black);
    readkey;
  end;
end;

end.