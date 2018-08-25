CREATE OR REPLACE VIEW v_hsxparesourceNum AS
SELECT 
  snap3g_hsxparesource.btsequipment, 
  count(snap3g_hsxparesource.hsxparesource) AS hsxparesource_number
FROM 
  public.snap3g_hsxparesource
GROUP BY snap3g_hsxparesource.btsequipment;
