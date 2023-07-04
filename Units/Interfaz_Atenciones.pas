unit Interfaz_Atenciones;
{$codepage UTF8}
interface
uses ArchivoPacientes, ArchivoAtenciones, crt, sysutils, RegExpr, FechaStuff;

procedure AnadirConsulta(var arch2:t_archivo2;var r:reg_pacientes);
procedure mostrar_registro2(r: reg_aten; r2: reg_pacientes;i,j:longint);
function maximoListado2(var arch: t_archivo2; dniselec:dni_type): LongInt;
function minimoListado2(var arch: t_archivo2; dniselec:dni_type): LongInt;
procedure selector2(var y:integer);
procedure bajarSelector2(var y:integer);
procedure subirSelector2(var y:integer);
procedure FlechaDerecha2(var arch: t_archivo2;var i: longint; var max:LongInt);
procedure FlechaIzquierda2(var arch: t_archivo2;var i: longint; var min:LongInt);
procedure burbujaDF(var v:t_archivo2);
procedure burbujaFN(var v:t_archivo2);
procedure Atencion2Fechas(var v:t_archivo2);
procedure PorcentajeAtenciones(var v:t_archivo2);

implementation



procedure AnadirConsulta(var arch2: t_archivo2; var r: reg_pacientes);
var
  j, pos: longint;
  r2, raux: reg_aten;
  fecha: string[10]; 
  auto: string[1]; //No puse char porque si por algún motivo el usuario ingresa (por ejemplo) aE rompe todo.
begin
  clrscr;
  with r2 do
  begin
    j := FileSize(arch2);
    dni := r.dni;
    
    if j > 1 then
    begin
      Seek(arch2, j - 1);
      read(arch2, raux);
    end;
    
    writeln('Añadiendo una consulta para: ', r.nombre, ' DNI: ', r.dni);
    writeln('Desea ingresar automáticamente la fecha? Ingrese A para confirmar.');
    readln(auto);
    
    if (UpCase(auto[1]) = 'A') then
       fecha_atencion := FechaAuto()
     else
      begin
       writeln('Ingrese la fecha de atención (DD/MM/AAAA)');
       readln(fecha_atencion)
      end;
    if ValidarFecha(r2.fecha_atencion) then
    begin
      if (raux.dni = r.dni) and (fecha_atencion = raux.fecha_atencion) then
      begin
        writeln('Agregando un tratamiento a una consulta existente');
        pos := finaltrata(raux.tratamiento);
        writeln('Ingrese el código de atención: ');
        readln(tratamiento[pos].codigo);
        writeln('Ingrese detalle/tratamiento de la atención: ');
        readln(tratamiento[pos].detalle);
        Seek(arch2, j - 1);
        write(arch2, raux);
      end
      else
      begin
        fecha_numerica := fechanumero(r2);
        writeln('Ingrese el código de atención: ');
        readln(tratamiento[1].codigo);
        writeln('Ingrese detalle/tratamiento de la atención: ');
        readln(tratamiento[1].detalle);
        seek(arch2, j);
        write(arch2, r2);
        burbujaDF(arch2);
      end;
    end
    else
      AnadirConsulta(arch2, r); // Este llamado recursivo se usa en caso de que el usuario ingrese una fecha incorrecta 
  end;
end;

procedure mostrar_registro2(r: reg_aten; r2:reg_pacientes;i,j:longint);
begin

  with r do
  begin
    gotoxy(5,1);
    writeln('----------(Atenciones de: ',r2.nombre,' DNI:',r2.dni,')-----------');
    gotoxy(5,2);
    writeln('Fecha de atención ',i,': ', fecha_atencion);
    gotoxy(5,3);
    writeln('Fecha de atención numérica ',i,': ', fecha_numerica);
    gotoxy(5,4);
    writeln('----------(TRATAMIENTO:',j,')----------');
    gotoxy(5,5);
    writeln('Código: ', tratamiento[j].codigo);
    gotoxy(5,6);
    writeln('detalle: ', tratamiento[j].detalle);
    gotoxy(5,7);
    writeln('DNI Titular de la atención: ',dni);
    gotoxy(5,12);
    writeln('----------(Información)-----------');
    gotoxy(5,13);
    writeln('Utilize las flechas de dirección <- -> para cambiar de paciente');
    gotoxy(5,14);
    writeln('Utilize las flechas de dirección subir y bajar para mover el selector');
    gotoxy(5,15);
    writeln('Pulsa E para Editar la información seleccionada');
    gotoxy(5,16);
    writeln('Pulsa A para Añadir una consulta al paciente seleccionado');
    gotoxy(5,17);
    writeln('Pulsa D para eliminar la consulta seleccionada');
    end;
end;

function maximoListado2(var arch: t_archivo2; dniselec: dni_type): LongInt;
var
  i: LongInt;
  r: reg_aten;
begin
  i := FileSize(arch);
  if i = 1 then //Caso especial de que el archivo de atenciones solo tenga 1 atención
  begin
    seek(arch, 0); 
    read(arch, r); 
    if r.dni = dniselec then
      maximoListado2 := 0 
    else
      maximoListado2 := -1;
  end
  else
  begin
    repeat
      dec(i);
      seek(arch, i);
      read(arch, r);
    until (r.dni = dniselec) or (i = 0);
    maximoListado2 := i;
  end;
end;

function minimoListado2(var arch: t_archivo2; dniselec:dni_type): LongInt;
//Esta función devuelve el minimo listado por DNI del arhcivo de atenciones
var i: LongInt;
var r: reg_aten;
begin
  i:= -1;
   repeat
    inc(i);
    seek(arch,i);
    read(arch,r);
    until (r.dni = dniselec) or (i = FileSize(arch)-1);
  minimoListado2:= i;
end;

procedure selector2(var y:integer);
begin
gotoxy(3,y);
TextColor(Red);
writeln('=>');
TextColor(White);
end;
procedure bajarSelector2(var y:integer);
        begin
           inc(y);
                if y>=7 then y:=2; //Mueve el selector al inicio (Nombre) si se intenta bajar estando en el último (Email)
                if y=3 then y:=5
                end;
procedure subirSelector2 (var y:integer);
        begin
        dec(y);
        if y<2 then y:=5; //mueve el selector al final (Email) si se intenta subir estando en el primero (Nombre)
        if y=4 then y:=2
        end;






procedure FlechaDerecha2(var arch: t_archivo2;var i: longint; var max:LongInt);
  begin
    if i+1 <= max then
          begin
          Inc(i);
          end
      end;
procedure FlechaIzquierda2(var arch: t_archivo2;var i: longint; var min:LongInt);
  begin
    if i-1 >= min then
          begin
          Dec(i);
          end
      end;



{==========================inicio procedure burbujaDF========================
=================ordenamiento burbuja, concatenando fecha y dni======}
procedure burbujaDF(var v:t_archivo2);
      var i,j:byte;
          aux1,aux2:reg_aten;
      begin
          for i := 0 to filesize(v) - 1 do
            begin
                for  j := filesize(v) - 1 downto i + 1 do
                    begin
                        seek(v,j-1);
                        read(v,aux1);
                        seek(v,j);
                        read(v,aux2);
                        if (aux1.dni + fecharecon(aux1)) > (aux2.dni + fecharecon(aux2)) then
                          begin
                              seek(v,j-1);
                              write(v,aux2);
                              seek(v,j);
                              write(v,aux1);
                          end;
                     end;
            end;
       end;
{==========================inicio procedure burbujaFN========================
=================ordenamiento burbuja fecha numerica===========}
procedure burbujaFN(var v:t_archivo2);
      var i,j:byte;
          aux1,aux2:reg_aten;
      begin
          for i := 0 to filesize(v) - 1 do
            begin
                for  j := filesize(v) - 1 downto i + 1 do
                    begin
                        seek(v,j-1);
                        read(v,aux1);
                        seek(v,j);
                        read(v,aux2);
                        if (aux1.fecha_numerica) > (aux2.fecha_numerica) then
                          begin
                              seek(v,j-1);
                              write(v,aux2);
                              seek(v,j);
                              write(v,aux1);
                          end;
                     end;
            end;
       end;

function minimoFN (var v:t_archivo2; var buscado:LongInt):longInt;
var
r:reg_aten;
begin
minimoFN:=-1;
r.fecha_numerica:= 0;
    while (r.fecha_numerica <> buscado) and (minimoFN < FileSize(v))do
      begin
        inc(minimoFN);
        seek(v,minimoFN);
        read(v,r);
      end;
end;

function maximoFN(var v:t_archivo2; var  buscado:LongInt):longInt;
var r:reg_aten;
begin
maximoFN:=filesize(v);
    while (r.fecha_numerica <> buscado) and (maximoFN > 0)do
      begin
        dec(maximoFN);
        seek(v,maximoFN);
        read(v,r);
      end;
end;


procedure Atencion2Fechas(var v:t_archivo2);
var
min,max:String;
MinIndice,MaxIndice:LongInt;
begin
min:='0';
max:='0';
minIndice:=0;
maxIndice:=0;
  burbujaFN(v);
  writeln('Ingrese la primera fecha en formato DD/MM/AAAA');
  readln(min);
  MinIndice:=fechanumero2(min);
  MinIndice:=minimoFN(v,MinIndice);
  writeln('Ingrese la segunda fecha en formato DD/MM/AAAA');
  readln(max);
  MaxIndice:=fechanumero2(max);
  MaxIndice:=maximoFN(v,MaxIndice);
  writeln('El total de atenciones entre ',min,' y ', max,' es de: ', MaxIndice-MinIndice+1);
  readkey;
end;

procedure ContarAtencionesMes(var v:t_archivo2; var mes:string; var an:string;var contano, contMesEnAno:integer);
var
i:byte;
r:reg_aten;
begin
contano:=0;
contMesEnAno:=0;
with r do
for i:=0 to FileSize(v)-1 do
begin
  seek(v,i);
  read(v,r);
  if (fecha_atencion[7] = an[1]) and (fecha_atencion[8] = an[2]) and (fecha_atencion[9] = an[3]) and (fecha_atencion[10] = an[4]) then
  begin
    inc(contAno);
    if ((fecha_atencion[4] = mes[1]) and (fecha_atencion[5] = mes[2])) then
      inc(contMesEnAno);
  end;
end;

end;


{En este procedimiento decidimos recorrer todo el archivo de atenciones para buscar cuales atenciones coinciden con el mes seleccionado,
ya que si hacemos burbuja y luego busqueda binaria terminamos con mas complejidad ya que deberíamos reordenar el archivo cada vez}
procedure PorcentajeAtenciones(var v:t_archivo2);
var
    contAno,contMesEnAno:integer;
    mes:String;
    an:string;
    porcien:real;
begin
writeln('Este procedimiento calcula el porcentaje de atenciones de un mes con respecto al ano.');
writeln('Ingrese el ano a calcular el porcentaje (AAAA)');
readln(an);
writeln('Ingrese el mes a calcular el porcentaje (MM)');
readln(mes);
ContarAtencionesMes(v,mes,an,contAno,contMesEnAno);
porcien:= (contMesEnAno * 100)/ContAno;
writeln('El total de atenciones del mes ',mes,' En el ano ', an, ' Es de: ',contMesEnAno,' de un total de: ',contAno,' Lo que representa un:',porcien:0:2,'%');
readkey;
end;

end.