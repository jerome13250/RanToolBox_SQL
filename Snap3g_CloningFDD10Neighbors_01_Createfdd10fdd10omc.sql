-- Table de reference fdd10-fdd10:
DROP TABLE IF EXISTS t_vois_fdd10fdd10_omc;

CREATE TABLE t_vois_fdd10fdd10_omc AS
SELECT
  fddcell,
  umtsfddneighbouringcell
FROM 
  public.t_voisines3g3g
WHERE 
  t_voisines3g3g.dlfrequencynumber_s = '10787' AND 
  t_voisines3g3g.dlfrequencynumber_v = '10787';

--On cree la table FDD11-FDD11:

DROP TABLE IF EXISTS t_vois_fdd11fdd11_clonefdd10;

CREATE TABLE t_vois_fdd11fdd11_clonefdd10 AS
SELECT *
FROM t_vois_fdd10fdd10_omc;

UPDATE 
  public.t_vois_fdd11fdd11_clonefdd10
SET 
  fddcell = REPLACE(REPLACE(REPLACE(fddcell,'_U11','_U12'),'_U21','_U22'),'_U31','_U32'),
  umtsfddneighbouringcell = REPLACE(REPLACE(REPLACE(umtsfddneighbouringcell,'_U11','_U12'),'_U21','_U22'),'_U31','_U32');

--On cree la table FDD12-FDD12:

DROP TABLE IF EXISTS t_vois_fdd12fdd12_clonefdd10;

CREATE TABLE t_vois_fdd12fdd12_clonefdd10 AS
SELECT *
FROM t_vois_fdd10fdd10_omc;

UPDATE 
  public.t_vois_fdd12fdd12_clonefdd10
SET 
  fddcell = REPLACE(REPLACE(REPLACE(fddcell,'_U11','_U13'),'_U21','_U23'),'_U31','_U33'),
  umtsfddneighbouringcell = REPLACE(REPLACE(REPLACE(umtsfddneighbouringcell,'_U11','_U13'),'_U21','_U23'),'_U31','_U33');


--On cree la table FDD7-FDD7:

DROP TABLE IF EXISTS t_vois_fdd7fdd7_clonefdd10;

CREATE TABLE t_vois_fdd7fdd7_clonefdd10 AS
SELECT *
FROM t_vois_fdd10fdd10_omc;

UPDATE 
  public.t_vois_fdd7fdd7_clonefdd10
SET 
  fddcell = REPLACE(REPLACE(REPLACE(fddcell,'_U11','_U14'),'_U21','_U24'),'_U31','_U34'),
  umtsfddneighbouringcell = REPLACE(REPLACE(REPLACE(umtsfddneighbouringcell,'_U11','_U14'),'_U21','_U24'),'_U31','_U34');

