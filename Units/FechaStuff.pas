unit FechaStuff;
interface
uses ArchivoAtenciones, ArchivoPacientes, crt, sysutils;
const
DiasEnMes: array[1..12] of Byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
NumeroValido: array[1..10] of Char = ('0','1','2','3','4','5','6','7','8','9');
function fechaValida(r: reg_aten):boolean;
function esBisiesto(ano: Word): Boolean;
function fechaVeridica(ano, mes, dia: Word): Boolean;
function fechanumero(r: reg_aten):LongInt;
function fecharecon(r: reg_aten):fecha_at;
function fechanumero2(fecha:String):LongInt;
procedure FechaSeparada(r: reg_aten;var an:Word;var mes:Word;var dia:Word);
function FechaAuto():string;
function ValidarFecha(r:reg_aten):Boolean;

implementation
{=============Function FechaValida===========}
{Esta function valida que la fecha ingresada sea NN/NN/NNNN, donde N = numero del 0 al 9}
function fechaValida(r: reg_aten):boolean;
var
dia,mes:String[2];
ano:String[4];
i:byte;
begin
    dia:= r.fecha_atencion[1] + r.fecha_atencion[2];
    mes:= r.fecha_atencion[4] + r.fecha_atencion[5];
    ano:= r.fecha_atencion[7] + r.fecha_atencion[8] + r.fecha_atencion[9] + r.fecha_atencion[10];
    for i:=0 to Length(NumeroValido)-1 do
    begin
        FechaValida := (dia[1] = NumeroValido[i]) and (dia[2] = NumeroValido[i]) and
               (r.fecha_atencion[3] = '/') and
               (mes[1] = NumeroValido[i]) and (mes[2] = NumeroValido[i]) and
               (r.fecha_atencion[6] = '/') and
               (ano[1] = NumeroValido[i]) and (ano[2] = NumeroValido[i]) and
               (ano[3] = NumeroValido[i]) and (ano[4] = NumeroValido[i]);
    end;
end;

function esBisiesto(ano: Word): Boolean;
begin
  esBisiesto := (ano mod 4 = 0) and ((ano mod 100 <> 0) or (ano mod 400 = 0));
end;
{=============Function FechaVeridica===========}
{Esta function valida que la fecha ingresada sea verídica, es decir, que esté dentro del calendario, teniendo en cuenta años bisiestos}
function fechaVeridica(ano, mes, dia: Word): Boolean;
var
  esValida: Boolean;
begin
  esValida := (ano >= 1800) and (ano <= 5000) and
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
{=============procedure para fecha en strings separados===========}
procedure FechaSeparada(r: reg_aten;var an:Word;var mes:Word;var dia:Word);
begin
    dia:= StrToInt(r.fecha_atencion[1] + r.fecha_atencion[2]);
    mes:= StrToInt(r.fecha_atencion[4] + r.fecha_atencion[5]);
    an:= StrToInt(r.fecha_atencion[7] + r.fecha_atencion[8] + r.fecha_atencion[9] + r.fecha_atencion[10]);
end;

function FechaAuto():string;
Var ThisMoment : TDateTime;
Begin
fechaAuto:=(FormatDateTime('DD/MM/YYYY',Now));
end;
{=============Function ValidarFecha===========}
{Esta función ejecuta FechaValida y FechaVeridica en la fecha ingresada}
function ValidarFecha(r:reg_aten):Boolean;
var di,mes,an:Word;
begin
  FechaSeparada(r,an,mes,di);
  ValidarFecha:= fechaValida(r) and fechaVeridica(an,mes,di);
end;
end.