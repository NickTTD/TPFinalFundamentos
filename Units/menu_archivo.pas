  unit menu_archivo;
  {$codepage UTF8}
  interface

  uses crt, ArchivoPacientes, ArchivoAtenciones, manejo_archivo_final, Interfaz_Pacientes, Interfaz_Atenciones;

  procedure menu;


  implementation

  procedure menu;
  var
    i:LongInt;
    arch: t_archivo;
    arch2:t_archivo2;
    opcion: byte;
    y:integer;
  begin
    i:=0;
    y:=2;
    verificarArchivoPacientes(arch);
    verificarArchivoAtenciones(arch2);
    repeat
      clrscr;
      writeln('1- Alta');
      writeln('2- Listado');
      writeln('3- Consulta');
      writeln('4- Alta/Baja logica');
      writeln('5- Listado por Nombres');
      writeln('6- Atenciónes entre 2 fechas');
      writeln('7- Porcentaje de atenciones ');
      writeln('0- Salir');
      writeln('Ingrese Opcion');
      readln(Opcion);
      case opcion of
        1: alta(arch,arch2);
        2: listadoCompleto(arch,arch2,i);
        3: consulta(arch);
        4: ABLogica(arch);
        5: ListadoNombres(arch,arch2);
        6: Atencion2Fechas(arch2);
        7: PorcentajeAtenciones(arch2);
      end;
    until opcion = 0;
    cerrarArchPacientes(arch);
    cerrarArchAtenciones(arch2);
  end;
  end.
