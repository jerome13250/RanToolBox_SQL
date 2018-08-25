SELECT 
  string_agg(snap3g_cellselectionprofile.userspecificinfo,'-') AS list_userspecificinfo,
  snap3g_cellselectionprofile.cellselectionprofile,
  string_agg(snap3g_cellselectionprofile.rnc,'-') AS list_rnc, 
  COUNT(snap3g_cellselectionprofile.cellselectionprofile) AS nb_rnc,

  snap3g_cellselectioninfo.cellselectioninfo, 
  snap3g_cellselectioninfo.interfreqscalingfactortreselection, 
  snap3g_cellselectioninfo.interratscalingfactortreselection, 
  snap3g_cellselectioninfo.qhyst1, 
  snap3g_cellselectioninfo.qhyst2, 
  snap3g_cellselectioninfo.qqualmin, 
  snap3g_cellselectioninfo.qrxlevmin, 
  snap3g_cellselectioninfo.qualmeas, 
  snap3g_cellselectioninfo.sintrasearch, 
  snap3g_cellselectioninfo.sintersearch, 
  snap3g_cellselectioninfo.ssearchratgsm,  
  snap3g_cellselectioninfo.ssearchhcs, 
  snap3g_cellselectioninfo.shcsratgsm,
  snap3g_cellselectioninfo.treselection, 
  snap3g_cellselectioninfoconnectedmode.cellselectioninfoconnectedmode, 
  snap3g_cellselectioninfoconnectedmode.interfreqscalingfactortreselection, 
  snap3g_cellselectioninfoconnectedmode.interratscalingfactortreselection, 
  snap3g_cellselectioninfoconnectedmode.qhyst1, 
  snap3g_cellselectioninfoconnectedmode.qhyst2, 
  snap3g_cellselectioninfoconnectedmode.qqualmin, 
  snap3g_cellselectioninfoconnectedmode.qrxlevmin, 
  snap3g_cellselectioninfoconnectedmode.qualmeas, 
  snap3g_cellselectioninfoconnectedmode.shcsratgsm, 
  snap3g_cellselectioninfoconnectedmode.sintersearch, 
  snap3g_cellselectioninfoconnectedmode.sintrasearch, 
  snap3g_cellselectioninfoconnectedmode.ssearchhcs, 
  snap3g_cellselectioninfoconnectedmode.ssearchratgsm, 
  snap3g_cellselectioninfoconnectedmode.treselection
FROM 
  public.snap3g_cellselectioninfo LEFT JOIN public.snap3g_cellselectionprofile 
	ON
	snap3g_cellselectionprofile.rnc = snap3g_cellselectioninfo.rnc AND
	snap3g_cellselectionprofile.cellprofiles = snap3g_cellselectioninfo.cellprofiles AND
	snap3g_cellselectionprofile.cellselectionprofile = snap3g_cellselectioninfo.cellselectionprofile
  LEFT JOIN public.snap3g_cellselectioninfoconnectedmode
	ON
	snap3g_cellselectionprofile.rnc = snap3g_cellselectioninfoconnectedmode.rnc AND
	snap3g_cellselectionprofile.cellprofiles = snap3g_cellselectioninfoconnectedmode.cellprofiles AND
	snap3g_cellselectionprofile.cellselectionprofile = snap3g_cellselectioninfoconnectedmode.cellselectionprofile
WHERE
  snap3g_cellselectionprofile.rnc NOT LIKE 'RS\_%' AND
  snap3g_cellselectionprofile.rnc NOT LIKE 'BACKUP%'
GROUP BY
  snap3g_cellselectionprofile.cellselectionprofile, 
  snap3g_cellselectioninfo.cellselectioninfo, 
  snap3g_cellselectioninfo.interfreqscalingfactortreselection, 
  snap3g_cellselectioninfo.interratscalingfactortreselection, 
  snap3g_cellselectioninfo.qhyst1, 
  snap3g_cellselectioninfo.qhyst2, 
  snap3g_cellselectioninfo.qqualmin, 
  snap3g_cellselectioninfo.qrxlevmin, 
  snap3g_cellselectioninfo.qualmeas, 
  snap3g_cellselectioninfo.shcsratgsm, 
  snap3g_cellselectioninfo.sintersearch, 
  snap3g_cellselectioninfo.sintrasearch, 
  snap3g_cellselectioninfo.ssearchhcs, 
  snap3g_cellselectioninfo.ssearchratgsm, 
  snap3g_cellselectioninfo.treselection, 
  snap3g_cellselectioninfoconnectedmode.cellselectioninfoconnectedmode, 
  snap3g_cellselectioninfoconnectedmode.interfreqscalingfactortreselection, 
  snap3g_cellselectioninfoconnectedmode.interratscalingfactortreselection, 
  snap3g_cellselectioninfoconnectedmode.qhyst1, 
  snap3g_cellselectioninfoconnectedmode.qhyst2, 
  snap3g_cellselectioninfoconnectedmode.qqualmin, 
  snap3g_cellselectioninfoconnectedmode.qrxlevmin, 
  snap3g_cellselectioninfoconnectedmode.qualmeas, 
  snap3g_cellselectioninfoconnectedmode.shcsratgsm, 
  snap3g_cellselectioninfoconnectedmode.sintersearch, 
  snap3g_cellselectioninfoconnectedmode.sintrasearch, 
  snap3g_cellselectioninfoconnectedmode.ssearchhcs, 
  snap3g_cellselectioninfoconnectedmode.ssearchratgsm, 
  snap3g_cellselectioninfoconnectedmode.treselection


ORDER BY
  snap3g_cellselectionprofile.cellselectionprofile::numeric,
  COUNT(snap3g_cellselectionprofile.cellselectionprofile) DESC
;
