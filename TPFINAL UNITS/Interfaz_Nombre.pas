unit Interfaz_Nombre;
{$codepage UTF8}
interface
uses ArchivoPacientes, crt;
procedure mostrar_vector(var arch: t_archivo;var v:n_vector);
//procedure mostrar_registro3(var arch: t_archivo;var r:reg_pacientes; var minListadoN,maxListadoN:longInt);
//function maximoListado3(var arch: t_archivo2; dniselec:string): LongInt;
//function minimoListado3(var arch: t_archivo2; dniselec:string): LongInt;
procedure selector3(var y:LongInt);
procedure bajarSelector3(var y:LongInt);
procedure subirSelector3(var y:LongInt);
procedure Informacion3();
procedure FlechaDerecha3(var i: longint);
procedure FlechaIzquierda3(var i: longint);
function iSeleccionada(var y,i:LongInt):LongInt;
implementation


procedure mostrar_vector(var arch: t_archivo;var v:n_vector);
var i,j:byte;
begin
  i:= 1;
  j:= 0;
  while (i <= 10) do
    begin
      with v[i] do
        begin
          gotoxy(5,j+2);
          writeln(v[i].nombre,'|',v[i].dni);
          inc(j);
        end;
      inc(i);
    end;
end;

{procedure mostrar_registro3(var arch: t_archivo;var r:reg_pacientes; var minListadoN,maxListadoN:longInt);
var i,j:byte;
begin
  i:= minListadoN;
  j:=0;
  with r do
  begin
    while (i >= minListadoN) and (i < maxListadoN) and (i < FileSize(arch)) do
      begin
      seek(arch,i);
      read(arch,r);
      if r.estado then
        begin
          gotoxy(5,j+2);
          writeln(r.nombre,'|',r.dni);
          inc(j);
        end;
      inc(i);
      end;
    end;
end;}

procedure selector3(var y:LongInt);
begin
gotoxy(3,y);
TextColor(Red);
writeln('=>');
TextColor(White);
end;
procedure bajarSelector3(var y:LongInt);
        begin
           inc(y);
                if y>=12 then y:=2; //Mueve el selector al inicio (Nombre) si se intenta bajar estando en el último (Email)
                end;
procedure subirSelector3 (var y:LongInt);
        begin
        dec(y);
        if y<2 then y:=11; //mueve el selector al final (Email) si se intenta subir estando en el primero (Nombre)
        end;
procedure Informacion3();
begin

  gotoxy(5,12);
  writeln('----------(Información)-----------');
  gotoxy(5,13);
  writeln('Utilize las flechas de dirección <- -> para cambiar de paciente');
  gotoxy(5,14);
  writeln('Utilize las flechas de dirección subir y bajar para mover el selector');
  gotoxy(5,15);
  writeln('Pulsa V para Ver los datos del paciente seleccionado');
end;

procedure FlechaDerecha3(var i: longint);
  begin
          Inc(i);
      end;
procedure FlechaIzquierda3(var i: longint);
  begin
    if i > 1 then
          Dec(i);
      end;

function iSeleccionada(var y,i:LongInt):LongInt;//
begin
    if (i >= 1) then
      iSeleccionada:= (y - 1);
end;


end.