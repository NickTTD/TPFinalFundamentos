program PruebaOrdinal;
uses crt,sysutils;
var 
fecha:string;
d,m,a:string;
card:integer;
begin
readln(fecha);
d:=fecha[1]+fecha[2];
m:=fecha[4]+fecha[5];
a:=fecha[7]+fecha[8]+fecha[9]+fecha[10];

card:=(StrToInt(d) + (StrToInt(m)*30) + (StrToInt(a)*365));
writeln(card);
readkey;
end.