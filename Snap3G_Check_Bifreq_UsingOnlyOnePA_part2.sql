-- Resultat final:

SELECT 
  t_nodeb_stsr2_sectors.rnc, 
  t_nodeb_stsr2_sectors.rncid, 
  t_nodeb_stsr2_sectors.nodeb, 
  t_nodeb_stsr2_sectors.dlfrequencynumber, 
  t_nodeb_stsr2_sectors.sectors, 
  t_nodeb_pa_capacity.btsequipment, 
  t_nodeb_pa_capacity.modulename, 
  t_nodeb_pa_capacity.moduletype, 
  t_nodeb_pa_capacity.modulesubtype, 
  t_nodeb_pa_capacity.boards_number, 
  t_nodeb_pa_capacity.pa_board_capacity, 
  t_nodeb_pa_capacity.total_pa_number
FROM 
  public.t_nodeb_pa_capacity INNER JOIN public.t_nodeb_stsr2_sectors
  ON  
    t_nodeb_pa_capacity.btsequipment = t_nodeb_stsr2_sectors.nodeb
WHERE
  total_pa_number >= 2*sectors AND
  modulename NOT LIKE '%TRDU 2x80-21%' --Comme on a une limitation a 40W peu importe qu'on soit STSR1+1 ou STSR2
   ;
