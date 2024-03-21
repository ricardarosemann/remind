*** |  (C) 2006-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/36_buildings/simple/equations.gms

***---------------------------------------------------------------------------
*'  Buildings Final Energy Balance
***---------------------------------------------------------------------------
q36_demFeBuild(ttot,regi,entyFe,emiMkt)$(ttot.val ge cm_startyear
                                         AND entyFe2Sector(entyFe,"build")) .. 
  sum((entySe,te)$se2fe(entySe,entyFe,te),
      vm_demFeSector_afterTax(ttot,regi,entySe,entyFe,"build",emiMkt)) 
  =e=
  sum(in$(fe2ppfEn(entyFe,in)
          AND ppfen_buildings_dyn36(in)),
      vm_cesIO(ttot,regi,in)
      + pm_cesdata(ttot,regi,in,"offset_quantity") 
  )$(sameas(emiMkt,"ES"))
;

***---------------------------------------------------------------------------
*'  Calculate sector-specific additional t&d cost (here only cost of H2 t&d at low H2 penetration levels when grid is not yet developed)
***---------------------------------------------------------------------------
q36_costAddTeInv(t,regi,te)$(sameAs(te,"tdh2s"))..
  vm_costAddTeInv(t,regi,te,"build")
  =e=
  v36_costAddTeInvH2(t,regi,te)
;

***---------------------------------------------------------------------------
*'  Additional hydrogen phase in cost at low H2 penetration levels 
***---------------------------------------------------------------------------
q36_costAddH2PhaseIn(t,regi)..
  v36_costAddTeInvH2(t,regi,"tdh2s")
  =e=
  v36_costAddH2LowPen(t,regi)
  * vm_demFeSector_afterTax(t,regi,"seh2","feh2s","build","ES")
  + (v36_expSlack(t,regi) * 1e-8)
;

*' barrier cost for low penetration
q36_costAddH2LowPen(t,regi)..
  v36_costAddH2LowPen(t,regi)
  =e=
  cm_build_H2costAddH2Inv * sm_TWa_2_kWh / sm_trillion_2_non
  / (1 + 3**v36_costExponent(t,regi)) 
;


*' Logistic function exponent for additional cost for hydrogen at low penetration cost equation
q36_auxCostAddTeInv(t,regi)..
  v36_costExponent(t,regi)
  =e=
  10 / (cm_build_H2costDecayEnd - cm_build_H2costDecayStart) 
  * (v36_avgH2share(t,regi) + 1e-7
     - (cm_build_H2costDecayEnd + cm_build_H2costDecayStart) / 2
    )
  - v36_expSlack(t,regi)
;


*' Average of the H2 share from this and the previous time period
q36_avgH2share(ttot, regi)$(ttot.val ge cm_startyear)..
  v36_avgH2share(ttot, regi)
  =e=
  (v36_H2share(ttot, regi)
  + v36_H2share(ttot-1, regi)$(ttot.val > cm_startyear)
  + v36_H2share(ttot, regi)$(ttot.val = cm_startyear))
  / 2
;


*' Hydrogen fe share in buildings energy use
q36_H2Share(t,regi)..
  v36_H2share(t,regi) 
  * sum(se2fe(entySe,entyFe,te)$(entyFe36(entyFe)),   
        vm_demFeSector_afterTax(t,regi,entySe,entyFe,"build","ES"))
  =e=
  sum(se2fe(entySe,entyFe,te)$SAMEAS(entyFe,"feh2s"),
      vm_demFeSector_afterTax(t,regi,entySe,entyFe,"build","ES"))
;


***---------------------------------------------------------------------------
*'  CES markup cost that are accounted in the budget (GDP) to represent sector-specific demand-side transformation cost in buildings
***---------------------------------------------------------------------------
q36_costCESmarkup(t,regi,in)$(ppfen_buildings_dyn36(in))..
  vm_costCESMkup(t,regi,in)
  =e=
  p36_CESMkup(t,regi,in)
  * (vm_cesIO(t,regi,in)
     + pm_cesdata(t,regi,in,"offset_quantity"))
;

***---------------------------------------------------------------------------
*' Use at least as much solids from biomass in buildings as was transformed
*' via biotr in order to prevent that traditionally used biomass is also used
*' in other sectors. This only applies to regions that still have traditional
*' biomass use, which is defined via a gdp criteria.
***---------------------------------------------------------------------------
q36_biotrBound(t,regi)$(t.val ge 2010 AND (pm_gdp("2005",regi)/pm_pop("2005",regi) / pm_shPPPMER(regi)) lt 4)..
  sum(sector2emiMkt('build',emiMkt),
    vm_demFeSector_afterTax(t,regi,'sesobio','fesos','build',emiMkt)
  )
  =g=
  vm_prodSe(t,regi,"pebiolc","sesobio","biotr")
;

*** EOF ./modules/36_buildings/simple/equations.gms
