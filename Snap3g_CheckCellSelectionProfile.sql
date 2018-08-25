SELECT 
  snap3g_cellselectionprofile.cellselectionprofile, 
  COUNT(snap3g_cellselectionprofile.cellselectionprofile) AS COUNT_NB,
  --snap3g_cellselectionprofile.rdnid, 
  MIN(snap3g_cellselectionprofile.userspecificinfo), 
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
  snap3g_cellselectioninfo.treselection
FROM 
  public.snap3g_cellselectionprofile, 
  public.snap3g_cellselectioninfo
WHERE 
  snap3g_cellselectionprofile.rnc = snap3g_cellselectioninfo.rnc AND
  snap3g_cellselectionprofile.cellprofiles = snap3g_cellselectioninfo.cellprofiles AND
  snap3g_cellselectionprofile.cellselectionprofile = snap3g_cellselectioninfo.cellselectionprofile
GROUP BY 
  snap3g_cellselectionprofile.cellselectionprofile, 
  --snap3g_cellselectionprofile.rdnid, 
  --snap3g_cellselectionprofile.userspecificinfo, 
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
  snap3g_cellselectioninfo.treselection

  ORDER BY
    snap3g_cellselectionprofile.cellselectionprofile
  ;