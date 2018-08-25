CREATE OR REPLACE VIEW v_pcmNum AS
SELECT 
  snap3g_pcm.btsequipment, 
  count(snap3g_pcm.pcm) AS pcm_number
FROM 
  public.snap3g_pcm
GROUP BY snap3g_pcm.btsequipment;
