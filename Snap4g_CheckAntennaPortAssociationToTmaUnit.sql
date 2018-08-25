/* Cette requete permet de verifier l'association d'un TmaUnit a l'ojet Antennaport, sinon le UL_RSSI est mal calcule et est 10dB trop eleve*/

SELECT 
  snap4g_tmasubunit.enbequipment, 
  snap4g_tmasubunit.tma, 
  snap4g_tmasubunit.tmasubunit, 
  snap4g_tmasubunit.bypassmode, 
  snap4g_tmasubunit.tmasubunitnumber
FROM 
  public.snap4g_tmasubunit LEFT JOIN public.snap4g_antennaport
ON
  snap4g_tmasubunit.enbequipment = snap4g_antennaport.enbequipment AND
  snap4g_tmasubunit.tma = snap4g_antennaport.key_tma AND
  snap4g_tmasubunit.tmasubunit = snap4g_antennaport.key_tmasubunit
WHERE
  snap4g_antennaport.enbequipment IS NULL
ORDER BY
  snap4g_tmasubunit.enbequipment ASC,
  snap4g_tmasubunit.tma ASC, 
  snap4g_tmasubunit.tmasubunit ASC;
