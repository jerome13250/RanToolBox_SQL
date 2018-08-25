SELECT query_to_xml(
'SELECT 
'''' AS name,
''Cell Name : '' || t_topologie3g.fddcell || ''
LCID : '' || t_topologie3g.localcellid AS description,
''#SectorAssetUMTS'' AS styleUrl,
t_topologie3g.longitude || '','' || t_topologie3g.latitude || '',0'' AS coordinates,
t_topologie3g.azimuth AS heading

FROM public.t_topologie3g
ORDER BY t_topologie3g.fddcell;
'
 , false, false,'');
