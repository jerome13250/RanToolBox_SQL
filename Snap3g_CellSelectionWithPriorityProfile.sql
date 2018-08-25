﻿SELECT 
  snap3g_cellselectionwithpriorityprofile.rnc, 
  snap3g_cellselectionwithpriorityprofile.cellprofiles, 
  snap3g_cellselectionwithpriorityprofile.cellselectionwithpriorityprofile, 
  snap3g_cellselectionwithpriorityprofile.userspecificinfo, 
  snap3g_cellselectioninfowithpriority.cellselectioninfowithpriority, 
  snap3g_cellselectioninfowithpriority.utranthreshslow, 
  snap3g_cellselectioninfowithpriority.utranthreshslow2, 
  snap3g_cellselectioninfowithpriority.utraservingcellpriority, 
  snap3g_cellselectioninfowithpriority.utrasprioritysearch1, 
  snap3g_cellselectioninfowithpriority.utrasprioritysearch2, 
  snap3g_eutranfrequencyandpriorityinfolist.eutranfrequencyandpriorityinfolist, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetdlcarrierfrequencyarfcn, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencydetection, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencypriority, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencyqqualmin, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencyqrxlevmin, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencythreshxhigh, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencythreshxhigh2, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencythreshxlow, 
  snap3g_eutranfrequencyandpriorityinfolist.eutratargetfrequencythreshxlow2, 
  snap3g_eutranfrequencyandpriorityinfolist.measurementbandwidth
FROM 
  public.snap3g_cellselectionwithpriorityprofile, 
  public.snap3g_cellselectioninfowithpriority, 
  public.snap3g_eutranfrequencyandpriorityinfolist
WHERE 
  snap3g_cellselectionwithpriorityprofile.rnc = snap3g_cellselectioninfowithpriority.rnc AND
  snap3g_cellselectionwithpriorityprofile.cellprofiles = snap3g_cellselectioninfowithpriority.cellprofiles AND
  snap3g_cellselectionwithpriorityprofile.cellselectionwithpriorityprofile = snap3g_cellselectioninfowithpriority.cellselectionwithpriorityprofile AND
  snap3g_cellselectioninfowithpriority.rnc = snap3g_eutranfrequencyandpriorityinfolist.rnc AND
  snap3g_cellselectioninfowithpriority.cellprofiles = snap3g_eutranfrequencyandpriorityinfolist.cellprofiles AND
  snap3g_cellselectioninfowithpriority.cellselectionwithpriorityprofile = snap3g_eutranfrequencyandpriorityinfolist.cellselectionwithpriorityprofile;
