/*cette requete sert a verifier que les remotefddcell ont le bon lcid par rapport a leur nom qui est la clé sur alu
si le lcid est faux, il faut le corriger*/

DROP TABLE IF EXISTS tmp_checkremotefddcell_lcid;
CREATE TABLE tmp_checkremotefddcell_lcid AS
SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.neighbouringrncid, 
  snap3g_remotefddcell.neighbouringfddcellid, 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.localcellid AS lcid_remotefddcell, 
  snap3g_fddcell.localcellid AS vrai_lcid_omc,
  'cellule ALU'::text AS commentaire
FROM 
  public.snap3g_remotefddcell, 
  public.snap3g_fddcell
WHERE 
  snap3g_remotefddcell.remotefddcell = snap3g_fddcell.fddcell AND
  snap3g_remotefddcell.localcellid != snap3g_fddcell.localcellid
  
UNION

SELECT 
  snap3g_remotefddcell.rnc, 
  snap3g_remotefddcell.neighbouringrncid, 
  snap3g_remotefddcell.neighbouringfddcellid, 
  snap3g_remotefddcell.remotefddcell, 
  snap3g_remotefddcell.localcellid AS lcid_remotefddcell, 
  "nokia_WCEL"."managedObject_WCEL" AS vrai_lcid_omc,
  'nokia'::text AS commentaire
FROM 
  public.snap3g_remotefddcell, 
  public."nokia_WCEL"
WHERE 
  snap3g_remotefddcell.remotefddcell = "nokia_WCEL".name AND
  snap3g_remotefddcell.localcellid != "nokia_WCEL"."managedObject_WCEL"

ORDER BY
  remotefddcell ASC;
  