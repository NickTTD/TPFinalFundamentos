unit ArchivoAtenciones;
{$codepage UTF8}
interface

const
  ruta2 = '.\Atenciones.dat';

type
  
  dni_type = string[12];
  fecha_at = string[10];
  
  reg_aten_d = record
  codigo: string[10];
  detalle: string[100];
  end;

  trata_type = array [1..10] of reg_aten_d;

  reg_aten = record
  dni: dni_type;
  fecha_atencion: fecha_at;
  fecha_numerica: LongInt;
  tratamiento: trata_type;
  end;

  t_archivo2 = file of reg_aten;


procedure cerrarArchAtenciones(var arch: t_archivo2);
procedure verificarArchivoAtenciones( var arch2: t_archivo2);
function finaltrata(v:trata_type):LongInt;
implementation



procedure cerrarArchAtenciones(var arch: t_archivo2);       //cierra archivo
begin
  Close(arch);
end;

procedure verificarArchivoAtenciones(var arch2:t_archivo2);
begin
  assign(arch2,ruta2);
  {$i-}
  reset(arch2);
  {$i+}
  if ioresult<>0 then rewrite(arch2);
end;

function finaltrata(v:trata_type):LongInt;
  var
    i:LongInt;
begin
  i:= 1;
    if v[i].codigo = ' ' then
      inc(i);
  finaltrata:= i;
end;

end.
