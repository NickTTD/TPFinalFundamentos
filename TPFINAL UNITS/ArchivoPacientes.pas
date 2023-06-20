unit ArchivoPacientes;
{$codepage UTF8}
interface

const
  ruta  = '.\Pacientes.dat';


type
  
  dni_type = string[12];
  fecha_at = string[10];
  reg_pacientes = record
    apellido:    string[60];
    nombre:      string[60];
    ciudad:      string[60];
    dni:         dni_type;
    fecha_nacimiento: string[10];
    obra_social: string[60];
    numero_afiliado: string[10];
    email:       string[60];
    estado:      boolean;
  end;

  n_vector = array [1 .. 10] of reg_pacientes;

 
  t_archivo = file of reg_pacientes;



procedure cerrarArchPacientes(var arch: t_archivo);
procedure verificararchivoPacientes(var arch: t_archivo);

implementation

procedure cerrarArchPacientes(var arch: t_archivo);       //cierra archivo
begin
  Close(arch);
end;

procedure verificararchivoPacientes(var arch: t_archivo);
begin
  assign(arch,ruta);
  {$i-}
  reset(arch);
  {$i+}
  if ioresult<>0 then rewrite(arch);
end;
end.
