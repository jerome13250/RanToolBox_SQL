SELECT distinct
  noria_infonodeb."NOM", 
  noria_infonodeb."GN", 
  noria_candidat."CODESITE", 
  noria_infonodeb."NUM", 
  --noria_infonodeb."VERSION", 
  noria_infonodeb."CANDIDAT", 
  noria_infonodeb."ID_RESEAU", 
  noria_infonodeb."ETAT_DEPL", 
  noria_infonodeb."ETAT_FONCT", 
  noria_infonodeb."CONSTRUCTEUR|$|"
FROM 
  public.tmp_sitesnidt_sansp2, 
  public.noria_candidat, 
  public.noria_infonodeb
WHERE 
  tmp_sitesnidt_sansp2."NIDT" = noria_infonodeb."GN" AND
  noria_infonodeb."GN" = noria_candidat."GN" AND
  noria_infonodeb."CANDIDAT" = noria_candidat."CANDIDAT"
ORDER BY
  noria_infonodeb."NOM" ASC;
