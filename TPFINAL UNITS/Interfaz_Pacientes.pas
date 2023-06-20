unit Interfaz_Pacientes;
{$codepage UTF8}
interface
uses ArchivoPacientes, crt;
procedure mostrar_registro(r: reg_pacientes);
function minimoListado(var arch: t_archivo): LongInt;
procedure SaltearDerecha(var arch: t_archivo; var i: LongInt);
procedure SaltearIzquierda(var arch: t_archivo; var i: LongInt);
procedure FlechaDerecha(var arch: t_archivo;var i: longint);
procedure FlechaIzquierda(var arch: t_archivo;var i, min:longint);
procedure selector(var y:integer);
procedure bajarSelector(var y:integer);
procedure subirSelector(var y:integer);
procedure Informacion();
implementation


procedure mostrar_registro(r: reg_pacientes);
begin
  with r do
  begin
    gotoxy(5,2);
    writeln('Nombre: ', nombre);
    gotoxy(5,3);
    writeln('Apellido: ', apellido);
    gotoxy(5,4);
    writeln('Ciudad: ', ciudad);
    gotoxy(5,5);
    writeln('DNI: ', dni);
    gotoxy(5,6);
    writeln('Fecha de Nacimiento: ', fecha_nacimiento);
    gotoxy(5,7);
    writeln('Obra Social: ', obra_social);
    gotoxy(5,8);
    writeln('Número de Afiliado: ', numero_afiliado);
    gotoxy(5,9);
    writeln('E-Mail: ', email);
  end;
end;

function minimoListado(var arch: t_archivo): LongInt;
  {Esta función calcula el minimo del archivo que no tiene estado=false, también deja el puntero en esa posición.}
var
  r: reg_pacientes;
  min: LongInt;
  i: LongInt;
begin
  min := 0;
  i := 0;
  seek(arch, i);
  Read(arch, r);

  while r.estado = False do
  begin
    Inc(i);
    seek(arch, i);
    Read(arch, r);
    Inc(min);
  end;
  minimoListado := min;
end;


procedure SaltearDerecha(var arch: t_archivo; var i: LongInt);
{Este procedimiento "saltea" elementos desactivados del archivo hacia la derecha.}
var
  r: reg_pacientes;
begin
  seek(arch, i);
  Read(arch, r);
  while (i < (filesize(arch)) - 1) and (r.estado = False) do
  begin
    Inc(i);
    seek(arch, i);
    Read(arch, r);
  end;
end;

procedure SaltearIzquierda(var arch: t_archivo; var i: LongInt);
{Este procedimiento "saltea" elementos desactivados del archivo hacia la izquierda,}
{este y el anterior se utilizan para elementos que no estan en el inicio ni en el final del archivo}
var
  r: reg_pacientes;
begin
  seek(arch, i);
  Read(arch, r);
  while r.estado = False do
  begin
    Dec(i);
    seek(arch, i);
    Read(arch, r);
  end;
end;

procedure FlechaDerecha(var arch: t_archivo;var i: longint);
  var  r_sig,r_ant: reg_pacientes;
  begin
      if i < (filesize(arch)) - 1 then
          begin
            seek(arch, i + 1);
            Read(arch, r_sig);
            if r_sig.estado = False then
            begin
              Inc(i);
              SaltearDerecha(arch, i);
              if i >= (filesize(arch)) - 1 then SaltearIzquierda(arch,i);
            end
            else
              Inc(i);
          end;
  end;

procedure FlechaIzquierda(var arch: t_archivo;var i,min: longint);
var  r_ant,r_sig: reg_pacientes;
begin
if i > min then
          begin
            seek(arch, i - 1);
            Read(arch, r_ant);
            if r_ant.estado = False then
            begin
              Dec(i);
              SaltearIzquierda(arch, i);
            end
            else
              Dec(i);
          end;
          end;

procedure selector(var y:integer);
begin
gotoxy(3,y);
TextColor(Red);
writeln('=>');
TextColor(White);
end;
procedure bajarSelector(var y:integer);
        begin
           inc(y);
                if y>=10 then y:=2; //Mueve el selector al inicio (Nombre) si se intenta bajar estando en el último (Email)
                end;
procedure subirSelector(var y:integer);
        begin
        dec(y);
        if y<2 then y:=9; //mueve el selector al final (Email) si se intenta subir estando en el primero (Nombre)
        end;
procedure Informacion();
begin
  gotoxy(5,10);
  writeln('-----------(Búsqueda)-------------');

  gotoxy(5,12);
  writeln('----------(Información)-----------');
  gotoxy(5,13);
  writeln('Utilize las flechas de dirección <- -> para cambiar de paciente');
  gotoxy(5,14);
  writeln('Utilize las flechas de dirección subir y bajar para mover el selector');
  gotoxy(5,15);
  writeln('Pulsa A para Añadir una consulta al paciente seleccionado');
  gotoxy(5,16);
  writeln('Pulsa V para ver las consultas de este paciente');
  gotoxy(5,17);
  writeln('Pulsa E para Editar la información seleccionada');
  gotoxy(5,18);
  writeln('Pulsa B para Buscar un paciente con el dato seleccionado');
end;
end.