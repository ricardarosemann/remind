*** |  (C) 2006-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/21_tax/on/bounds.gms
*cb no taxes in 2005, fix budget equation term to zero
vm_taxrev.fx("2005",regi) = 0;

vm_taxrev.up(t,regi)$(t.val gt 2005) = + 0.05 * pm_gdp(t,regi);
vm_taxrev.lo(t,regi)$(t.val gt 2005) = - 0.05 * pm_gdp(t,regi);
*** EOF ./modules/21_tax/on/bounds.gms
