unit manejo_archivo_final;
//Hacer que se refresque el archivo luego de hacer BurbujaNA cuando cambio nombre o apellido
{$codepage UTF8}
interface

uses ArchivoPacientes, ArchivoAtenciones, crt, Interfaz_Pacientes,Interfaz_Atenciones,Interfaz_Nombre,FechaStuff;
procedure EditarPaciente(var arch:t_archivo;var i:LongInt;var y:integer;var r:reg_pacientes);
procedure burbujaNA(var v:t_archivo);
procedure guardar_registro(var arch: t_archivo; pos: LongInt; r: reg_pacientes);
//procedure cargar_registro(var r:reg_pacientes;);   Quitar comentario si pretende usar en otra unit
procedure alta(var arch: t_archivo;var arch2:t_archivo2);
procedure listadoNombres(var arch: t_archivo;var arch2: t_archivo2);
procedure listadoCompleto(var arch: t_archivo;var arch2:t_archivo2;var PacienteSeleccionado:LongInt);
procedure consulta(var arch: t_archivo);
procedure ABLogica(var arch: t_archivo);
procedure eliminarAtencion(var v:t_archivo2;var I:LongInt; var v2:t_archivo);
implementation

procedure EditarAtencion(var arch:t_archivo2;var i:LongInt;var y:integer;var r:reg_aten);
var
FechaOK:Boolean;
begin
with r do
  case y of
  2:
  begin
    FechaOK:=False;
    while not FechaOK do
      begin
        gotoxy(25,2);
        clreol;
        readln(fecha_atencion);
        if ValidarFecha(fecha_atencion) then
          FechaOK := True
      end;
  end;
  5:
  begin
    gotoxy(12,5);
    clreol;
    readln(tratamiento[1].codigo);
  end;
  6:
  begin
    gotoxy(13,6);
    clreol;
    readln(tratamiento[1].detalle);
  end;
  end;
    seek(arch, i);
    Write(arch, r);
end;

procedure EditarPaciente(var arch:t_archivo;var i:LongInt;var y:integer;var r:reg_pacientes);
var
FechaOK:Boolean;
begin
with r do
  case y of
  2:
  begin
   gotoxy(12,2);
    clreol;
    readln(nombre);
    burbujaNA(arch);
  end;
  3:
  begin
    gotoxy(14,3);
    clreol;
    readln(apellido);
    burbujaNA(arch);
  end;
  4:
  begin
    gotoxy(12,4);
    clreol;
    readln(ciudad);
  end;
  5:
  begin
    gotoxy(10,5);
    clreol;
    readln(dni);
  end;
  6:
  begin
    FechaOK:=False;
    while not FechaOK do
    begin
      gotoxy(25,6);
      clreol;
      readln(fecha_nacimiento);

      if ValidarFecha(fecha_nacimiento) then
        FechaOK := True
      end;
  end;
  7:begin
    gotoxy(17,7);
    clreol;
    readln(obra_social);
  end;
  8:
  begin
    gotoxy(24,8);
    clreol;
    readln(numero_afiliado);
  end;
  9:
  begin
    gotoxy(12,9);
    clreol;
    readln(email);
  end;
  end;
       guardar_registro(arch, i, r);
end;


procedure bSecuencial (var v:t_archivo; var selected:integer;var buscado:String; var pos:LongInt);
var
h:LongInt;
r:reg_pacientes;
begin
pos:= 0;
h:= 0;
for h:=0 to FileSize(v)-1 do
begin
seek(v,h);
read (v,r);
case selected of
4:  if lowercase(r.ciudad) = lowercase(buscado) then pos:=h;
5:  if r.dni = buscado then pos:=h;
6:  if r.fecha_nacimiento = buscado then pos:=h;
7:  if lowercase(r.obra_social) = lowercase(buscado) then pos:=h;
8:  if r.numero_afiliado = buscado then pos:=h;
9:  if lowercase(r.email) = lowercase(buscado) then pos:=h;
end;
end;
end;
procedure bBinaria (var v:t_archivo;var buscado:string;var pos:LongInt);
var pri,med,ult:LongInt;
    r:reg_pacientes;
begin
    reset(v);
    pos:=-1;
		pri:=0;
		ult:= filesize(v)-1;
		while (pri <= ult) and (pos = -1) do
			begin
				med:=(pri + ult) div 2;
				seek(v,med);
        read(v,r);
        if (lowercase(r.nombre) = lowercase(buscado)) then
					pos:= med
				else
					begin
						if (lowercase(r.nombre) > lowercase(buscado)) then
							ult:= med - 1
						else
							pri:= med + 1;
					end;
			end;
end;
{========================== inicio procedure BuscarPaciente============================}
{busca el paciente llamando a bSecuencial, para todo menos nombre y apellido,donde se usa bBinaria}
procedure BuscarPaciente(var arch:t_archivo;var i:LongInt;var y:integer;var r:reg_pacientes);
var
buscado:string;
j:longint;
arch2:t_archivo2;
begin
  gotoxy(5,11);
  clreol;
  readln(buscado);
with r do
  case y of
  2,3:
  begin
  bBinaria(arch,buscado,i);
  if i > -1 then listadoCompleto(arch,arch2,i)
  else
  begin
  writeln('No encontrado');
  i:=0;
  readkey;
  end;
  end;
  4,5,6,7,8,9:
  begin
  bSecuencial(arch,y,buscado,i);
  if i > -1 then listadoCompleto(arch,arch2,i)
  else
  begin
  writeln('No encontrado');
  readkey;
  end;
  end;
  end;
end;
{==========================Fin procedure BuscarPaciente========================}

{========================== inicio procedure BuscarPacienteNombre============================}
{Adaptado del procedimiento de arriba pero para buscar por nombre de la lista de nombres}
procedure BuscarPacientevec(var arch:t_archivo;var r:reg_pacientes);
var
pos:longint;
arch2:t_archivo2;
x:string;
begin
  clreol;
  x:=r.nombre;
  pos:=-1;
with r do
  begin
    bBinaria(arch,x,pos);
    if pos > -1 then listadoCompleto(arch,arch2,pos)
    else
      begin
        writeln('No encontrado');
        pos:=-1;
        readkey;
    end;
  end;
end;
{==========================Fin procedure BuscarPaciente========================}

{==========================inicio procedure burbujaNA========================
=================ordenamiento burbuja, concatenando nombre y apellido======}
procedure burbujaNA(var v:t_archivo);
      var i,j:byte;
          aux1,aux2:reg_pacientes;
      begin
          for i := 0 to filesize(v) - 1 do
            begin
                for  j := filesize(v) - 1 downto i + 1 do
                    begin
                        seek(v,j-1);
                        read(v,aux1);
                        seek(v,j);
                        read(v,aux2);
                        if (LowerCase(aux1.nombre + aux1.apellido) > LowerCase(aux2.nombre + aux2.apellido)) then
                          begin
                              seek(v,j-1);
                              write(v,aux2);
                              seek(v,j);
                              write(v,aux1);
                          end;
                     end;
            end;
       end;
{==========================Fin procedure burbujaNA========================}

{======================inicio procedure busqueda==================
==============busqueda secuencial para la alta y baja logica=================}
procedure busqueda(var arch: t_archivo;var buscado:dni_type; var pos: longint);
var
  r: reg_pacientes;
  k: LongInt;
begin
  k := 0;
  pos := -1;
  while (k < filesize(arch)) and (pos = -1) do
  begin
    seek(arch, k);
    Read(arch, r);
    if (r.dni = buscado) then
      pos := k
    else
      Inc(k);
  end;
end;
{==========================Fin procedure busqueda========================}

procedure guardar_registro(var arch: t_archivo; pos: LongInt; r: reg_pacientes);
begin
  seek(arch, pos);
  Write(arch, r);
end;


procedure cargar_registro(var r: reg_pacientes);
var
  FechaOK:Boolean;
begin
  with r do
  begin
    FechaOK := False;

    while not FechaOK do
    begin
      Write('Fecha De Nacimiento: ');
      readln(fecha_nacimiento);

      if ValidarFecha(fecha_nacimiento) then
        FechaOK := True
      end;

    Write('Nombre: ');
    readln(nombre);
    Write('Apellido: ');
    readln(apellido);
    Write('Ciudad: ');
    readln(ciudad);
    Write('Obra Social: ');
    readln(obra_social);
    Write('Numero de Afiliado: ');
    readln(numero_afiliado);
    Write('E-Mail: ');
    readln(email);
    estado := True;
  end;
end;

{========================== inicio procedure alta============================}
{=========dar de alta un paciente, previamente comprobando si existe=========}
procedure alta(var arch: t_archivo;var arch2:t_archivo2);
var
  pos: LongInt;
  r: reg_pacientes;
begin
  clrscr;
  Write('DNI: ');
  readln(r.dni);
  busqueda(arch,r.dni,pos);
  if pos = -1 then
  begin
  cargar_registro(r);
  pos := filesize(arch);
  guardar_registro(arch, pos, r);
  end
  else
    listadoCompleto(arch,arch2,pos);
end;

procedure cargar_vector(var arch: t_archivo;var vec:n_vector;var indiceNombres: LongInt);
var i,j:LongInt;
    r:reg_pacientes;
begin
    i:= 1;
    j:= 0;
    while (i <= 10) and ((j + (indiceNombres * 10) - 10) < FileSize(arch)) do
      begin
        Seek(arch,(j + (indiceNombres * 10) - 10));
        read(arch,r);
        if r.estado then
          begin
            vec[i]:= r;
            inc(i);
          end;
        inc(j);
        end;
end;
{==========================Fin procedure alta========================}


{==========================INICIO LISTADO DE ATENCIONES==========================}
{==========te muetra el listado completo de atenciones del cliente seleccionado previamente en el menu de clientes y se encarga de
realizar las acciones vinculadas a las distintas teclas}

  procedure listadoAtenciones(var arch2: t_archivo2;var AtencionSeleccionada:LongInt;var r:reg_pacientes;var v2:t_archivo);
var
  y:integer;
  r2: reg_aten;
  tecla: char;
  salir: boolean;
  min,max,j: LongInt; //J es el indice del vector de tratamientos, en caso de que una atención tenga varios tratamientos, no implementado
  dniselec: dni_type;
  registrobusca: reg_aten;
begin
  if (FileSize(arch2) > 0) then
  begin
    burbujaDF(arch2);
    y:=2;
    clrscr;
    min := 0;
    j:=1;
    salir := False;
    dniselec := r.dni;
    min := minimoListado2(arch2,dniselec);
    max := maximoListado2(arch2,dniselec);
    AtencionSeleccionada:= min;
    if (max >= min) then
      begin
        while not salir do
          begin
            clrscr;
            writeln('');
            seek(arch2, AtencionSeleccionada);
            Read(arch2, r2);
            mostrar_registro2(r2,r,AtencionSeleccionada,j);
            selector2(y);
            tecla := readkey;
            if tecla = #00 then
              tecla := readkey;
            case tecla of
              #77: FlechaDerecha2(arch2,AtencionSeleccionada,max);
              #75: FlechaIzquierda2(arch2,AtencionSeleccionada,min);
              #27: salir:=True; //Escape
              #69,#101:EditarAtencion(arch2,AtencionSeleccionada,y,r2);{e}
              #72: subirSelector2(y); //Flecha Arriba
              #80: bajarSelector2(y); //Flecha Abajo
              #65,#97: AnadirConsulta(arch2,r);  {A}
              #100,#68: eliminarAtencion(arch2,AtencionSeleccionada,v2);
          end;
      end;
  end
  else
    begin
    writeln('No hay atenciones para el paciente seleccionado.');
    readkey;
    end;
  end;
end;

procedure listadoCompleto(var arch: t_archivo;var arch2:t_archivo2;var PacienteSeleccionado:LongInt);
var
  y:integer;
  r: reg_pacientes;
  tecla: char;
  salir: boolean;
  min,pos: LongInt;
  j:LongInt;
begin
  y:=2;
  j:=0;
  burbujaNA(arch);
  clrscr;
  salir := False;
  min:= minimoListado(arch); //Esto se usa especificamente para la flecha izquierda
  if PacienteSeleccionado = 0 then
    PacienteSeleccionado:= min;
  while not salir do
  begin
    clrscr;
    seek(arch, PacienteSeleccionado);
    Read(arch, r);
    if r.estado then
    begin
      gotoxy(5,1);
      writeln('----------(Paciente: ',PacienteSeleccionado,')-----------');
      mostrar_registro(r);
      selector(y);
      informacion;
      tecla := readkey;
      if tecla = #00 then
        tecla := readkey;
      case tecla of
        #77: flechaDerecha(arch,PacienteSeleccionado);
        #75: flechaIzquierda(arch,PacienteSeleccionado,min);
        #27: salir:=True; //Escape
        #72: subirSelector(y); //Flecha Arriba
        #80: bajarSelector(y); //Flecha Abajo
        #86,#118:listadoAtenciones(arch2,j,r,arch); {V}
        #65,#97: AnadirConsulta(arch2,r);  {A}
        #69,#101:EditarPaciente(arch,PacienteSeleccionado,y,r);{e}
        #76,#98: BuscarPaciente(arch,PacienteSeleccionado,y,r); {b}
      end;
    end;
  end;
end;



{==========================Fin procedure listado========================}
procedure listadoNombres(var arch: t_archivo;var arch2: t_archivo2);
var
  vec: n_vector;
  tecla: char;
  salir: boolean;
  min,max,minf,maxf,pos,indiceNombres,indiceantNombres,y,n,j: LongInt;
begin
  if filesize(arch)> 0 then
  begin
  burbujaNA(arch);
  clrscr;
  indiceNombres:= 1;
  j:= 0;
  minF := 1;
  salir := False;
  //min := minimoListado3(arch, pos);
  while (not salir) do
  begin
      clrscr;
      gotoxy(5,1);
      writeln('----------(Página: ',indiceNombres,')-----------');
      if indiceNombres <> indiceantNombres then
        cargar_vector(arch,vec,indiceNombres);
      mostrar_vector(arch,vec);
      selector3(y);
      informacion3;
      tecla := readkey;
      n:=iSeleccionada(y,indiceNombres);
      indiceantNombres:= indiceNombres;
      if tecla = #00 then
        tecla := readkey;
      case tecla of
        #77: flechaDerecha3(indiceNombres);
        #75: flechaIzquierda3(indiceNombres);
        #27: salir:=True; //Escape
        #72: subirSelector3(y); //Flecha Arriba
        #80: bajarSelector3(y); //Flecha Abajo
        #86,#118:BuscarPacientevec(arch,vec[n]); {V}
      end;
  end;
end;
end;
{======================inicio consulta=====================}
{==========te lleva al paciente que quieras, solo en caso que exista}
procedure consulta(var arch: t_archivo);
var
  r: reg_pacientes;
  buscado:dni_type;
  pos: longint;
begin
  pos := -1;
  clrscr;
  Write('Ingrese numero de DNI A buscar: ');
  readln(buscado);
  busqueda(arch, buscado, pos);
  if pos <> -1 then
  begin
    seek(arch, pos);
    Read(arch, r);
    mostrar_registro(r);
  end
  else
    writeln('No encontrado');
  readkey;
end;
{================Fin consulta=========================}

procedure ABLogica(var arch: t_archivo);
var
  dni: dni_type;
  BA: char;
  r: reg_pacientes;
  pos: LongInt;
begin
  writeln('Ingrese el DNI de la persona a dar de baja/alta logica: ');
  readln(dni);
  writeln('Ingrese si quiere dar de baja (B) o de Alta (A) al usuario');
  readln(BA);
  busqueda(arch, dni, pos);
  if pos <> -1 then
    begin
  seek(arch, pos);
  Read(arch, r);
  if (upcase(BA) = 'A') then
    r.estado := True
  else
  if (upcase(BA) = 'B') then
    r.estado := False;

  seek(arch, pos);
  Write(arch, r);
  end;
end;

//"Arregla" el archivo moviendo todos los registros que esten luego del registro borrado una posición a la "izquierda", sobreescribiendo el borrado
procedure ArreglarArchivo(var v: t_archivo2; AtencionSeleccionada:LongInt ;var arch:t_archivo);
var
i,j:LongInt;
r,aux:reg_aten;
truncado:LongInt;


begin
i:=AtencionSeleccionada;
while i < filesize(v)-1 do
  begin
    Seek(v,i);
    read(v,r);
    Seek(v,i+1);
    read(v,aux);
    r:=aux;
    Seek(v,i);
    write(v,aux);
    Seek(v,i+1);
    write(v,r);
    inc(i);
  end;
  truncado:=FileSize(v)-1;
  seek(v,truncado);
  Truncate(v);
  j:=0;
  listadoCompleto(arch,v,j);
end;

//Confirma si el usuario quiere borrar la atención, llama al procedimiento que lo borra y te devuelve al perfil del usuario
procedure eliminarAtencion(var v:t_archivo2;var I:LongInt ;var v2:t_archivo);
var tecla:char;
begin
    clrscr;
    writeln('Estas seguro de eliminar esta atención? Pulsa D para confirmar');
    tecla:= readkey;
    if (tecla=#100) or (tecla=#68) then
      begin
        ArreglarArchivo(v,I,v2);
      end;
end;
end.