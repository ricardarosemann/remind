*** |  (C) 2006-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/29_CES_parameters/load/datainput.gms
*** Load CES parameters based on current model configuration
*** ATTENTION the file name is replaced by the function start_run()
*##################### R SECTION START (CES INPUT) ##########################
$include "./modules/29_CES_parameters/load/input/indu_subsectors-buil_simple-tran_edge_esm-POP_pop_SSP2EU-GDP_gdp_SSP2EU-En_gdp_SSP2EU-Kap_debt_limit-costAddH2-0-offsetquad-Reg_62eff8f7.inc"
*###################### R SECTION END (CES INPUT) ###########################

if ((cm_build_overwriteH2Calibration = 1) or (cm_build_overwriteH2Calibration = 3) or (cm_build_overwriteH2Calibration = 5),
  pm_cesdata(t,regi,"feh2b","eff")$(NOT tnovw(t)) = pm_cesdata(t,regi,"fegab","eff");
);
if ((cm_build_overwriteH2Calibration = 2) or (cm_build_overwriteH2Calibration = 3) or (cm_build_overwriteH2Calibration = 5),
  pm_cesdata(t,regi,"feh2b","effGr")$(NOT tnovw(t)) = pm_cesdata(t,regi,"fegab","effGr");
);
if ((cm_build_overwriteH2Calibration = 4) or (cm_build_overwriteH2Calibration = 5),
  pm_cesdata(t,regi,"feh2b","xi")$(NOT tnovw(t)) = pm_cesdata(t,regi,"fegab","xi");
);
if ((cm_build_overwriteH2Calibration = 6),
  pm_cesdata(t,regi,"feh2b","effGr")$(NOT tnovw(t)) = 1;
);

option pm_cesdata:8:3:1;
display "loaded pm_cesdata", pm_cesdata;

*** EOF ./modules/29_CES_parameters/load/datainput.gms
