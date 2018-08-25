ALTER TABLE snap4g_antennaport ADD COLUMN key_tma TEXT;
ALTER TABLE snap4g_antennaport ADD COLUMN key_tmasubunit TEXT;

UPDATE snap4g_antennaport SET key_tma = substring(snap4g_antennaport.tmasubunitid from 'Tma/(.) TmaSubunit');
UPDATE snap4g_antennaport SET key_tmasubunit = substring(snap4g_antennaport.tmasubunitid from 'TmaSubunit/(.)');