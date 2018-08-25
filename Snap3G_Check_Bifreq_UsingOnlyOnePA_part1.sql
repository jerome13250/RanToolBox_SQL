--Creation de la table des capacités PA par board 2100

DROP TABLE IF EXISTS t_boards_pa_capacity;
CREATE TABLE public.t_boards_pa_capacity
(
  modulename text,
  moduletype text,
  modulesubtype text,
  pa_board_capacity integer,
  bande text
);
INSERT INTO t_boards_pa_capacity VALUES ('MOD: 30/45W 2100 UMTS MCPA','22','0',1,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD: 30/45W 2100 UMTS MCPA','22','1',1,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('PA: MCPA 2100 60W UMTS LIN','91','0',1,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD: RRH BAND01 60W','98','0',1,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD: TRDU BAND01 4C 60W','111','0',1,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD:TRDU 2x80-21','125','3',2,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD:RRH60-21C','112','0',1,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD:RRH2x60-21','112','3',2,'2100');
INSERT INTO t_boards_pa_capacity VALUES ('MOD:RH2x60-21A','112','11',2,'2100');


--Creation de la table des nombre de PA 2100 par nodeB

DROP TABLE IF EXISTS t_nodeb_pa_capacity;
CREATE TABLE public.t_nodeb_pa_capacity AS

SELECT 
  t_topologie3g_allboards.btsequipment, 
  t_boards_pa_capacity.modulename, --On prend dans cette table sinon il y a des erreurs de nommages
  t_topologie3g_allboards.moduletype, 
  t_topologie3g_allboards.modulesubtype,
  COUNT(t_topologie3g_allboards.btsequipment) AS boards_number,
  t_boards_pa_capacity.pa_board_capacity,
  COUNT(t_topologie3g_allboards.btsequipment) * t_boards_pa_capacity.pa_board_capacity AS total_pa_number
  
FROM 
  public.t_topologie3g_allboards INNER JOIN t_boards_pa_capacity
  ON 
    t_topologie3g_allboards.moduletype = t_boards_pa_capacity.moduletype AND
    t_topologie3g_allboards.modulesubtype = t_boards_pa_capacity.modulesubtype
    
GROUP BY
  t_topologie3g_allboards.btsequipment, 
  t_topologie3g_allboards.moduleapplication, 
  t_boards_pa_capacity.modulename, 
  t_topologie3g_allboards.moduletype, 
  t_topologie3g_allboards.modulesubtype,
  t_boards_pa_capacity.pa_board_capacity
ORDER BY
    t_topologie3g_allboards.btsequipment;


--Requete permettant de trouver les STSR2 + nombre de secteur

DROP TABLE IF EXISTS t_nodeb_stsr2_sectors;
CREATE TABLE public.t_nodeb_stsr2_sectors AS

SELECT 
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.dlfrequencynumber, 
  COUNT(t_topologie3g.dlfrequencynumber) AS sectors
  --MAX(t_topologie3g.sector_number) AS sectors
FROM 
  public.t_topologie3g INNER JOIN public.bdref_t_topologie
    ON
      t_topologie3g.localcellid = bdref_t_topologie."LCID"
 
WHERE 
  t_topologie3g.dlfrequencynumber = '10787' AND 
  t_topologie3g.nodeb IS NOT NULL AND
  bdref_t_topologie."Classe" LIKE 'STSR2\_%' -- "\" caractere d'echappement
GROUP BY
  t_topologie3g.rnc, 
  t_topologie3g.rncid, 
  t_topologie3g.nodeb, 
  t_topologie3g.runningsoftwareversion, 
  t_topologie3g.dlfrequencynumber
ORDER BY
  t_topologie3g.nodeb
;
