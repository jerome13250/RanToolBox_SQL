DROP TABLE IF EXISTS t_noria_topo4g;

CREATE TABLE t_noria_topo4g AS
SELECT DISTINCT
  noria_enodebcell."NOM", 
  noria_enodebcell."ID_CELL_SI", 
  noria_enodebcell."ID_NORIA_CELL", 
  noria_enodebcell."GN", 
  noria_enodebcell."NUM", 
  noria_enodebcell."OPERATION", 
  noria_enodebcell."CANDIDAT", 
  noria_enodebcell."ETAT_DEPL", 
  noria_enodebcell."ETAT_FONCT", 
  noria_enodebcell."IDRESEAUCELLULE", 
  noria_enodebcell."CONSTRUCTEUR", 
  noria_enodebcell."NUMSECT", 
  noria_enodebcell."TECHNO", 
  noria_enodebcell."BANDE", 
  noria_enodebcell."CARRIER", 
  noria_enodebcell."ZONEMARKETING", 
  noria_enodebcell."TEMPLATE", 
  noria_operation."ETAT|$|", 
  noria_site."CODE_SITE", 
  noria_site."NOM_SITE", 
  noria_site."DR", 
  noria_site."UR", 
  noria_site."X", 
  noria_site."Y", 
  noria_site."Z", 
  noria_site."ADRESSE", 
  noria_site."CODE_POSTAL", 
  noria_site."VILLE|$|", 
  noria_site."NECESSITE_NACELLE", 
  noria_antenna_xpol."CAT_REF" AS antennatype, 
  noria_antenna_xpol."AZIMUT" AS azimut, 
  noria_antenna_xpol."TILT_MECANIQUE" AS tiltmeca, 
  noria_antenna_xpol."HAUTEUR_BAS_ANTENNE" AS hauteursol, 
  noria_antenna_xpol."TILT_ELECTRIQUE_LTE800" AS tiltelec800,
  noria_antenna_xpol."TILT_ELECTRIQUE_LTE1800" AS tiltelec1800,  
  noria_antenna_xpol."TILT_ELECTRIQUE_LTE2600" AS tiltelec2600
FROM 
  public.noria_enodebcell 
  INNER JOIN public.noria_enodeb
     ON
       noria_enodebcell."CANDIDAT" = noria_enodeb."CANDIDAT" AND
       noria_enodebcell."GN" = noria_enodeb."GN"
  INNER JOIN public.noria_operation
     ON 
       noria_enodebcell."OPERATION" = noria_operation."OPERATION"
  INNER JOIN public.noria_candidat
     ON
       noria_enodeb."GN" = noria_candidat."GN" AND
       noria_enodeb."CANDIDAT" = noria_candidat."CANDIDAT"

  INNER JOIN public.noria_site
     ON
       noria_candidat."CODESITE" = noria_site."CODE_SITE"

  LEFT JOIN public.noria_antenna_xpol
     ON
	noria_enodebcell."ID_NORIA_CELL" = noria_antenna_xpol."ID_NORIA_CELL"
--WHERE
  --noria_operation."ETAT|$|" != 'REPLACED|$|' AND
  --noria_enodebcell."ETAT_DEPL" != 'THEORETICAL'

ORDER BY 
  noria_enodebcell."NOM";
