--Requete servant à trouver les parametres HOPI les plus courants sur le terrain en fonctions des relations de classes-classev
--Permet de trouver si des params croisés sont faux

BUG execution JAVA !!!!!!!!!!!!!!!!!!!

SELECT 
  bdref_s."Classe" AS classes, 
  bdref_v."Classe" AS classev, 
  t_voisines3g3g_nokia_inter."NrtHopiIdentifier",
  hopi1.name AS "NrtHopiIdentifier_name",
  t_voisines3g3g_nokia_inter."RtHopiIdentifier",
  hopi2.name AS "RtHopiIdentifier_name",
  COUNT(bdref_s."Classe")
FROM 
  public.t_voisines3g3g_nokia_inter INNER JOIN public.bdref_t_topologie bdref_s
  ON 
     t_voisines3g3g_nokia_inter."managedObject_WCEL" = bdref_s."LCID"
  INNER JOIN public.bdref_t_topologie bdref_v
  ON
     t_voisines3g3g_nokia_inter."LCIDV" = bdref_v."LCID"
  LEFT JOIN "nokia_HOPI" AS hopi1
  ON 
     hopi1."managedObject_HOPI" = t_voisines3g3g_nokia_inter."NrtHopiIdentifier"
  LEFT JOIN "nokia_HOPI" AS hopi2
  ON 
     hopi2."managedObject_HOPI" = t_voisines3g3g_nokia_inter."RtHopiIdentifier"
WHERE
  hopi1."managedObject_distName_parent" = 'PLMN-PLMN/RNC-358' AND
  hopi2."managedObject_distName_parent" = 'PLMN-PLMN/RNC-358' AND
  bdref_s."Classe" ILIKE 'Nokia%' --sinon des cellules créées en avance de phae apparaissent alors qu'elles sont encore allumées ALU

  
GROUP BY
  bdref_s."Classe", 
  bdref_v."Classe", 
  t_voisines3g3g_nokia_inter."NrtHopiIdentifier", 
  hopi1.name,
  t_voisines3g3g_nokia_inter."RtHopiIdentifier",
  hopi2.name
ORDER BY
  bdref_s."Classe", 
  bdref_v."Classe",
  COUNT(bdref_s."Classe") DESC;
