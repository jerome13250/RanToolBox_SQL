--Rajoute les colonnes utiles pour avoir les cles cpriradioequipment et antennaport
ALTER TABLE snap4g_cellantennaport
    ADD COLUMN cpriradioequipment TEXT,
    ADD COLUMN antennaport TEXT;

-- Mise a jour des coordonnees X Y
UPDATE snap4g_cellantennaport AS t
 SET 
  cpriradioequipment = replace(split_part(t.antennaportid, ' ', 1),'CpriRadioEquipment/',''),
  antennaport = replace(split_part(t.antennaportid, ' ', 2),'AntennaPort/','')
;
