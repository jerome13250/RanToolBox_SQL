CREATE OR REPLACE VIEW v_cemboardnum AS
SELECT 
  btsequipment,
  count(btsequipment) AS cemboard_number
FROM 
  public.snap3g_board
WHERE 
  moduletype IN ('36','37','86')
GROUP BY 
  btsequipment

ORDER BY
  btsequipment;

