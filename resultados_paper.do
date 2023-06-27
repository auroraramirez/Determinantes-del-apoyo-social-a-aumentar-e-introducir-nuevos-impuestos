use "data/RedistributionFinal.dta", clear

*************************
** Generamos variables **
*************************

* Mobilidad social
gen social_mobility = decil_actual - decil_14anios

/* Nuevos impuestos */
recode sec3_p_36_1_a (3/5 = 1)(1/2 = 0), generate(tt_automobiles)
recode sec3_p_36_1_b (3/5 = 1)(1/2 = 0), generate(tt_automobiles_ricos)
recode sec3_p_36_2_a (3/5 = 1)(1/2 = 0), generate(tt_traspaso_inmuebles)
recode sec3_p_36_2_b (3/5 = 1)(1/2 = 0), generate(tt_traspaso_inmuebles_ricos)
recode sec3_p_36_3_a (3/5 = 1)(1/2 = 0), generate(tt_herencias)
recode sec3_p_36_3_b (3/5 = 1)(1/2 = 0), generate(tt_herencias_ricos)
recode sec3_p_36_4_a (3/5 = 1)(1/2 = 0), generate(tt_iva_temporal)
recode sec3_p_36_4_b (3/5 = 1)(1/2 = 0), generate(tt_iva_temporal_ricos)
recode sec3_p_36_5_a (3/5 = 1)(1/2 = 0), generate(tt_riqueza_temporal)
recode sec3_p_36_5_b (3/5 = 1)(1/2 = 0), generate(tt_riqueza_temporal_ricos)

gen any_nuevos = cond(tt_automobiles == 1 | tt_automobiles_ricos == 1 | tt_traspaso_inmuebles == 1 | tt_traspaso_inmuebles_ricos == 1 | tt_herencias == 1 | tt_iva_temporal == 1 | tt_iva_temporal_ricos == 1 | tt_riqueza_temporal == 1 | tt_riqueza_temporal_ricos == 1, 1, 0)

/* Aumento de impuestos */
recode sec3_p_33 (3 = 1)(1/2 = 0), generate(aumentar_ingresos_tributarios)
recode sec3_p_34_a (3 = 1)(1/2 = 0), generate(aumentar_iva)
recode sec3_p_34_b (3 = 1)(1/2 = 0), generate(aumentar_isr_promedio)
recode sec3_p_34_c (3 = 1)(1/2 = 0), generate(aumentar_isr_ricos)
recode sec3_p_34_d (3 = 1)(1/2 = 0), generate(aumentar_isr_empresas)
recode sec3_p_34_e (3 = 1)(1/2 = 0), generate(aumentar_gasolina)
recode sec3_p_34_f (3 = 1)(1/2 = 0), generate(aumentar_alcohol_tabaco)
recode sec3_p_34_g (3 = 1)(1/2 = 0), generate(aumentar_predial)
gen any_aumento = cond(aumentar_ingresos_tributarios == 1 | aumentar_iva == 1 | aumentar_isr_promedio == 1 | aumentar_isr_ricos == 1 | aumentar_isr_empresas == 1 |aumentar_gasolina == 1 | aumentar_alcohol_tabaco == 1 | aumentar_predial == 1, 1, 0)

/* Labels */
label variable tt_automobiles "Automoviles"
label variable tt_automobiles_ricos "Automoviles (+200 mil)"
label variable tt_traspaso_inmuebles "Traspaso de inmuebles"
label variable tt_traspaso_inmuebles_ricos "Traspaso de inmuebles (+10 millones)"
label variable tt_herencias "Herencias"
label variable tt_herencias_ricos "Herencias (+10 millones)"
label variable tt_iva_temporal "Aumento temporal IVA"
label variable tt_iva_temporal_ricos "Aumento temporal IVA (lujo)"
label variable tt_riqueza_temporal "Impuesto temporal riqueza"
label variable tt_riqueza_temporal_ricos "Impuesto temporal riqueza (ricos)"

label variable aumentar_ingresos_tributarios "Ingresos tributarios"
label variable aumentar_iva "IVA"
label variable aumentar_isr_promedio "ISR"
label variable aumentar_isr_ricos "ISR (muy ricos)"
label variable aumentar_isr_empresas "ISR empresas"
label variable aumentar_gasolina "Gasolina"
label variable aumentar_alcohol_tabaco "Alcohol y tabaco"
label variable aumentar_predial "Propiedad"

label variable female "Mujer"
label variable social_mobility "Movilidad social"
label variable index_wealth "Indice de riqueza"
label variable sec3_p_25_2_3 "Evasion pobres"
label variable sec3_p_25_3_3 "Evasion clase media"
label variable sec3_p_25_4_3 "Evasion ricos"
label variable sec3_p_25_5_3 "Evasion muy ricos"
label variable sec3_p_30_b "Fuente de riqueza herencia"
label variable sec3_p_30_c "Fuente de riqueza corrupcion"
label variable sec3_p_29_a "Proporcion pobres"
label variable sec3_p_29_b "Proporcion ricos"
label variable sec3_p_29_c "Proporcion muy ricos"
label variable cd_norte "Region norte"
label variable cd_sur "Region sur"
label variable cd_centro "Region centro"
label variable index_trust "Indice de confianza"
label variable index_poverty "Indice de percepciones sobre la pobreza"
label variable index_ineq "Indice de preocupacion por desigualdad"
label variable index_efficiency "Indice de eficiencia"
label variable index_social "Indice de progresismo social"
label variable index_econ "Indice de progresismo económico"

*********************************
**#            Tabla 1          *
*********************************
local vars edad female yrs_educ married trabajo asegurado padres_indigenas
putexcel set "tables/tabla1.xlsx", replace

putexcel A1 = "Variable"
putexcel A2 = "Edad"
putexcel A3 = "Mujeres"
putexcel A4 = "Años de escolaridad"
putexcel A5 = "Casado"
putexcel A6 = "Empleado"
putexcel A7 = "Seguridad Social (restringido a empleados)"
putexcel A8 = "Padres indígenas"

putexcel B1 = "Media muestral"

local it = 1
local j = 2
foreach y of varlist `vars'{
	
	if inlist(`it', 2, 4, 5, 7){
		sum `y', format
		putexcel B`j' = `r(mean)', nformat(#.0%)
	}
	else if `it' == 6{
		
		sum `y' if trabajo == 1, format
		putexcel B`j' = `r(mean)', nformat(#.0%)

	}
	
	else{
		sum `y', format
		putexcel B`j' = `r(mean)', nformat(#.0)
	}
	local it = `it' + 1
	local j = `j' + 1
}

putexcel save

*********************************
**#            Tabla 2          *
*********************************
local nuevos_generales "tt_automobiles tt_traspaso_inmuebles tt_herencias tt_iva_temporal tt_riqueza_temporal"
local nuevos_ricos "tt_automobiles_ricos tt_traspaso_inmuebles_ricos tt_herencias_ricos tt_iva_temporal_ricos tt_riqueza_temporal_ricos"

putexcel set "tables/tabla2.xlsx", replace

putexcel A1 = "Impuestso"
putexcel A2 = "Tenencia automóviles"
putexcel A3 = "Traspaso o regalo de inmuebles"
putexcel A4 = "Herencias"
putexcel A5 = "Aumento temporal del IVA por pandemia"
putexcel A6 = "Impuesto temporal a la riqueza"
putexcel A7 = "Promedio"

putexcel B1 = "General"
local j = 2
local suma = 0
foreach var of varlist `nuevos_generales' {
	sum `var' [aw=weight]
	putexcel B`j' = `r(mean)', nformat(#.0%)
	local suma = `suma' + `r(mean)'
	local j = `j' + 1
}
local promedio = `suma'/(`j'- 2)
putexcel B`j' = `promedio', nformat(#.0%)

putexcel C1 = "Ricos"
local j = 2
local suma = 0
foreach var of varlist `nuevos_ricos' {
	sum `var' [aw=weight]
	putexcel C`j' = `r(mean)', nformat(#.0%)
	local suma = `suma' + `r(mean)'
	local j = `j' + 1
}
local promedio = `suma' / (`j' - 2)
putexcel C`j' = `promedio', nformat(#.0%)

putexcel D1 = "Diferencia"
local j = 2
local suma = 0
foreach var of varlist `nuevos_generales' {
	sum `var' [aw=weight]
	local mu1 =  `r(mean)'
	sum `var'_ricos [aw=weight]
	local mu2 = `r(mean)'
	putexcel D`j' = `mu2'-`mu1', nformat(#.0%)
	local suma = `suma' + `mu2'-`mu1'
	local j = `j' + 1
}
local promedio = `suma' / (`j' - 2)
putexcel D`j' = `promedio', nformat(#.0%)
putexcel save

**********************************
**#            Tabla 3           *
**********************************

local aumentar "aumentar_iva aumentar_isr_promedio aumentar_isr_ricos aumentar_isr_empresas aumentar_gasolina aumentar_alcohol_tabaco aumentar_predial"
local aumentar_generales "aumentar_iva aumentar_isr_promedio aumentar_gasolina aumentar_alcohol_tabaco aumentar_predial"

putexcel set "tables/tabla3.xlsx", replace

putexcel A1 = "Impuesto"
putexcel A2 = "Ingresos tributarios"
putexcel A3 = "IVA"
putexcel A4 = "ISR para personas promedio"
putexcel A5 = "ISR para muy ricos"
putexcel A6 = "ISR para empresas"
putexcel A7 = "Impuesto a la gasolina"
putexcel A8 = "Impuesto al alcohol y tabaco"
putexcel A9 = "Impuesto a la propiedad"
putexcel A10 = "Promedio"

putexcel B1 = "Apoyo"
sum aumentar_ingresos_tributarios [aw = weight]
putexcel B2 = `r(mean)', nformat(0.0%)

local j = 3
local suma = 0
foreach var of varlist `aumentar'{
	sum `var' [aw = weight]
	putexcel B`j' = `r(mean)', nformat(0.0%)
	local suma = `suma' + `r(mean)'
	local j = `j' + 1
}
local promedio = `suma' / (`j' - 3)
putexcel B`j' = `promedio', nformat(0.0%)

putexcel C1 = "ΔISR para muy ricos"
sum aumentar_isr_ricos [aw = weight]
local ricos = `r(mean)'

local j = 3
local suma = 0
foreach var of varlist `aumentar_generales'{
	sum `var' [aw = weight]
	local dif = `ricos' - `r(mean)'
	local suma = `suma' + `dif'
	putexcel C`j' = `dif', nformat(0.0%)
	
	if `j' == 4{
		
		local j = 7 
	} 
	
	else{
		
		local j = `j' + 1
		
	}
}
local promedio = `suma' / (`j' - 5)
putexcel C`j' = `promedio', nformat(0.0%)

putexcel D1 = "ΔISR para empresas"
sum aumentar_isr_empresas [aw = weight]
local ricos = `r(mean)'

local j = 3
local suma = 0
foreach var of varlist `aumentar_generales'{
	sum `var' [aw = weight]
	local dif = `ricos' - `r(mean)'
	local suma = `suma' + `dif'
	putexcel D`j' = `dif', nformat(0.0%)
	
	if `j' == 4{
		
		local j = 7 
	} 
	
	else{
		
		local j = `j' + 1
		
	}
}
local promedio = `suma' / (`j' - 5)
putexcel D`j' = `promedio', nformat(0.0%)


**************
**# Tabla 4 **
**************

* Variables
local controles "sec3_p_25_2_3 sec3_p_25_3_3 sec3_p_25_4_3 sec3_p_25_5_3 index_ineq sec3_p_29_a sec3_p_29_b sec3_p_29_c social_mobility index_poverty sec3_p_30_b sec3_p_30_c index_trust cd_norte cd_sur cd_centro female index_wealth index_efficiency index_social index_econ"

* Regresiones
local it = 1
foreach y of varlist tt_*{
	regress `y' `controles' [aw=weight], robust
	local etiqueta: variable label `y'
	
	if `it' == 1 {
		outreg2 using tables/tabla4, replace label keep(`controles') dec(3) ctitle(`etiqueta') excel
	} 
	else {
		outreg2 using tables/tabla4, append label keep(`controles') dec(3) ctitle(`etiqueta') excel
	}
	
	local it = `it' + 1
}


**************
**# Tabla 5 **
**************

* Regresiones
local it = 1
foreach y of varlist aumentar_iva aumentar_isr_promedio aumentar_isr_ricos aumentar_isr_empresas aumentar_gasolina aumentar_alcohol_tabaco aumentar_predial {
	regress `y' `controles' [aw=weight], robust
	local etiqueta: variable label `y'
	
	if `it' == 1 {
		outreg2 using tables/tabla5, replace label keep(`controles') ctitle(`etiqueta') dec(3) excel
	} 
	else {
		outreg2 using tables/tabla5, append label keep(`controles')ctitle(`etiqueta') dec(3) excel
	}
	
	local it = `it' + 1
}

******************
**# Romano-Wolf **
******************


/************/
**# Evasion */
/************/

* Evasion
gen pobres = sec3_p_25_2_3
gen medias = sec3_p_25_3_3
gen ricos = sec3_p_25_4_3
gen mricos = sec3_p_25_5_3

local evasion "pobres medias ricos mricos"
local controles2 "index_ineq sec3_p_29_a sec3_p_29_b sec3_p_29_c social_mobility index_poverty sec3_p_30_b sec3_p_30_c index_trust cd_norte cd_sur cd_centro female index_wealth index_efficiency index_social index_econ"

*******************************
* Nuevos impuestos para ricos *
*******************************

* Acortamos el nombre de las variables para que rwolf las pueda leer
gen auto = tt_automobiles_ricos
gen trasp = tt_traspaso_inmuebles_ricos
gen herencias = tt_herencias_ricos
gen iva = tt_iva_temporal_ricos
gen riqueza = tt_riqueza_temporal_ricos
local nuevos_ricos2 "auto trasp herencias iva riqueza"

putexcel set "tables/nuevos_evasion_rw.xlsx", replace

putexcel A1= "Variable dependiente"
putexcel A2 = "Automóviles (+200 mil)"
putexcel A3 = "Traspaso de inmuebles (+10 millones)"
putexcel A4 = "Herencias (+10 millones)"
putexcel A5 = "Aumento temporal IVA (lujo)"
putexcel A6 = "Impuesto temporal riqueza (ricos)"

putexcel B1= "Evasión pobres p-value"
putexcel C1= "Evasión pobres Romano-Wolf p-value"
putexcel D1= "Evasión clases medias p-value"
putexcel E1= "Evasión clases medias Romano-Wolf p-value"
putexcel F1= "Evasión ricos p-value"
putexcel G1= "Evasión ricos Romano-Wolf p-value"
putexcel H1= "Evasión muy ricos p-value"
putexcel I1= "Evasión muy ricos Romano-Wolf p-value"
putexcel J1= "Cambios"

rwolf `nuevos_ricos2' [aw = weight], indepvar(`evasion') controls(`controles2') method(reg) reps(500) seed(12345) robust verbose

putexcel B2 = matrix(e(RW_pobres)[1..5,1])
putexcel C2 = matrix(e(RW_pobres)[1..5,3])
putexcel D2 = matrix(e(RW_medias)[1..5,1])
putexcel E2 = matrix(e(RW_medias)[1..5,3])
putexcel F2 = matrix(e(RW_ricos)[1..5,1])
putexcel G2 = matrix(e(RW_ricos)[1..5,3])
putexcel H2 = matrix(e(RW_mricos)[1..5,1])
putexcel I2 = matrix(e(RW_mricos)[1..5,3])

forvalues i = 2/6{
	putexcel J`i' = formula(CONCAT(CONCAT("Pobres: ", IF(AND(B`i'<0.05, C`i'>= 0.05),1,0), "; "), CONCAT("Medias: ", IF(AND(D`i'<0.05, E`i'>= 0.05),1,0), "; "), CONCAT("Ricos: ", IF(AND(F`i'<0.05, G`i'>= 0.05),1,0), "; "), CONCAT("Muy ricos: ", IF(AND(H`i'<0.05, I`i'>= 0.05),1,0), ".")))
}

putexcel save

*********************************
* Aumentar impuestos para ricos *
*********************************

* Acortamos el nombre de las variables para que rwolf las pueda leer
gen iricos = aumentar_isr_ricos
gen empresas = aumentar_isr_empresas

local aumentar_ricos "iricos empresas"

putexcel set "tables/aumentar_evasion_rw.xlsx", replace
putexcel A1= "Variable dependiente"
putexcel A2 = "ISR muy ricos"
putexcel A3 = "ISR empresas"

putexcel B1= "Evasión pobres p-value"
putexcel C1= "Evasión pobres Romano-Wolf p-value"
putexcel D1= "Evasión clases medias p-value"
putexcel E1= "Evasión clases medias Romano-Wolf p-value"
putexcel F1= "Evasión ricos p-value"
putexcel G1= "Evasión ricos Romano-Wolf p-value"
putexcel H1= "Evasión muy ricos p-value"
putexcel I1= "Evasión muy ricos Romano-Wolf p-value"
putexcel J1= "Cambios"


rwolf `aumentar_ricos' [aw = weight], indepvar(`evasion') controls(`controles2') method(reg) reps(500) seed(12345) robust verbose

putexcel B2 = matrix(e(RW_pobres)[1..2,1])
putexcel C2 = matrix(e(RW_pobres)[1..2,3])
putexcel D2 = matrix(e(RW_medias)[1..2,1])
putexcel E2 = matrix(e(RW_medias)[1..2,3])
putexcel F2 = matrix(e(RW_ricos)[1..2,1])
putexcel G2 = matrix(e(RW_ricos)[1..2,3])
putexcel H2 = matrix(e(RW_mricos)[1..2,1])
putexcel I2 = matrix(e(RW_mricos)[1..2,3])

forvalues i = 2/3{
	putexcel J`i' = formula(CONCAT(CONCAT("Pobres: ", IF(AND(B`i'<0.05, C`i'>= 0.05),1,0), "; "), CONCAT("Medias: ", IF(AND(D`i'<0.05, E`i'>= 0.05),1,0), "; "), CONCAT("Ricos: ", IF(AND(F`i'<0.05, G`i'>= 0.05),1,0), "; "), CONCAT("Muy ricos: ", IF(AND(H`i'<0.05, I`i'>= 0.05),1,0), ".")))
}

putexcel save

/*********************************/
**# Variables sobre distribución */
/*********************************/

* Distribucion
replace pobres = sec3_p_29_a
replace ricos = sec3_p_29_b
replace mricos = sec3_p_29_c
gen ineq = index_ineq

local distribucion "ineq pobres ricos mricos"

local controles3 "sec3_p_25_2_3 sec3_p_25_3_3 sec3_p_25_4_3 sec3_p_25_5_3 social_mobility index_poverty sec3_p_30_b sec3_p_30_c index_trust cd_norte cd_sur cd_centro female index_wealth index_efficiency index_social index_econ"

*******************************
* Nuevos impuestos para ricos *
*******************************

putexcel set "tables/nuevos_distribucion_rw.xlsx", replace

putexcel A1= "Variable dependiente"
putexcel A2 = "Automóviles (+200 mil)"
putexcel A3 = "Traspaso de inmuebles (+10 millones)"
putexcel A4 = "Herencias (+10 millones)"
putexcel A5 = "Aumento temporal IVA (lujo)"
putexcel A6 = "Impuesto temporal riqueza (ricos)"

putexcel B1= "Preocupación por desigualdad p-value"
putexcel C1= "Preocupación por desigualdad Romano-Wolf p-value"
putexcel D1= "Proporcion de pobres p-value"
putexcel E1= "Proporcion de pobres Romano-Wolf p-value"
putexcel F1= "Poporción ricos p-value"
putexcel G1= "Poporción ricos Romano-Wolf p-value"
putexcel H1= "Proporcion muy ricos p-value"
putexcel I1= "Proporción muy ricos Romano-Wolf p-value"
putexcel J1= "Cambios"

rwolf `nuevos_ricos2' [aw = weight], indepvar(`distribucion') controls(`controles3') method(reg) reps(500) seed(12345) robust verbose

putexcel B2 = matrix(e(RW_ineq)[1..5,1])
putexcel C2 = matrix(e(RW_ineq)[1..5,3])
putexcel D2 = matrix(e(RW_pobres)[1..5,1])
putexcel E2 = matrix(e(RW_pobres)[1..5,3])
putexcel F2 = matrix(e(RW_ricos)[1..5,1])
putexcel G2 = matrix(e(RW_ricos)[1..5,3])
putexcel H2 = matrix(e(RW_mricos)[1..5,1])
putexcel I2 = matrix(e(RW_mricos)[1..5,3])

forvalues i = 2/6{
	putexcel J`i' = formula(CONCAT(CONCAT("Desigualdad: ", IF(AND(B`i'<0.05, C`i'>= 0.05),1,0), "; "), CONCAT("Pobres: ", IF(AND(D`i'<0.05, E`i'>= 0.05),1,0), "; "), CONCAT("Ricos: ", IF(AND(F`i'<0.05, G`i'>= 0.05),1,0), "; "), CONCAT("Muy ricos: ", IF(AND(H`i'<0.05, I`i'>= 0.05),1,0), ".")))
}

putexcel save


*********************************
* Aumentar impuestos para ricos *
*********************************

putexcel set "tables/aumentar_distribucion_rw.xlsx", replace
putexcel A1= "Variable dependiente"
putexcel A2 = "ISR muy ricos"
putexcel A3 = "ISR empresas"

putexcel B1= "Preocupación por desigualdad p-value"
putexcel C1= "Preocupación por desigualdad Romano-Wolf p-value"
putexcel D1= "Proporcion de pobres p-value"
putexcel E1= "Proporcion de pobres Romano-Wolf p-value"
putexcel F1= "Poporción ricos p-value"
putexcel G1= "Poporción ricos Romano-Wolf p-value"
putexcel H1= "Proporcion muy ricos p-value"
putexcel I1= "Proporción muy ricos Romano-Wolf p-value"
putexcel J1= "Cambios"


rwolf `aumentar_ricos' [aw = weight], indepvar(`distribucion') controls(`controles3') method(reg) reps(500) seed(12345) robust verbose

putexcel B2 = matrix(e(RW_ineq)[1..2,1])
putexcel C2 = matrix(e(RW_ineq)[1..2,3])
putexcel D2 = matrix(e(RW_pobres)[1..2,1])
putexcel E2 = matrix(e(RW_pobres)[1..2,3])
putexcel F2 = matrix(e(RW_ricos)[1..2,1])
putexcel G2 = matrix(e(RW_ricos)[1..2,3])
putexcel H2 = matrix(e(RW_mricos)[1..2,1])
putexcel I2 = matrix(e(RW_mricos)[1..2,3])

forvalues i = 2/3{
	putexcel J`i' = formula(CONCAT(CONCAT("Desigualdad: ", IF(AND(B`i'<0.05, C`i'>= 0.05),1,0), "; "), CONCAT("Pobres: ", IF(AND(D`i'<0.05, E`i'>= 0.05),1,0), "; "), CONCAT("Ricos: ", IF(AND(F`i'<0.05, G`i'>= 0.05),1,0), "; "), CONCAT("Muy ricos: ", IF(AND(H`i'<0.05, I`i'>= 0.05),1,0), ".")))
}

putexcel save

/******************************/
**# Igualdad de oportunidades */
/******************************/

* Distribucion
gen mob = social_mobility
gen ppoverty = index_poverty
gen winh = sec3_p_30_b
gen wcorr = sec3_p_30_c

local igualdadop "mob ppoverty winh wcorr"

local controles4 "sec3_p_25_2_3 sec3_p_25_3_3 sec3_p_25_4_3 sec3_p_25_5_3 index_ineq sec3_p_29_a sec3_p_29_b sec3_p_29_c index_trust cd_norte cd_sur cd_centro female index_wealth index_efficiency index_social index_econ"

*******************************
* Nuevos impuestos para ricos *
*******************************

putexcel set "tables/nuevos_igualdadop_rw.xlsx", replace

putexcel A1= "Variable dependiente"
putexcel A2 = "Automóviles (+200 mil)"
putexcel A3 = "Traspaso de inmuebles (+10 millones)"
putexcel A4 = "Herencias (+10 millones)"
putexcel A5 = "Aumento temporal IVA (lujo)"
putexcel A6 = "Impuesto temporal riqueza (ricos)"

putexcel B1= "Movilidad social p-value"
putexcel C1= "Movilidad social Romano-Wolf p-value"
putexcel D1= "Pobreza por falta de esfuerzo p-value"
putexcel E1= "Pobreza por falta de esfuerzo Romano-Wolf p-value"
putexcel F1= "Proporción de riqueza heredada p-value"
putexcel G1= "Proporción de riqueza heredada Romano-Wolf p-value"
putexcel H1= "Proporcion de riqueza por corrupción p-value"
putexcel I1= "Proporcion de riqueza por corrupción Romano-Wolf p-value"
putexcel J1= "Cambios"

rwolf `nuevos_ricos2' [aw = weight], indepvar(`igualdadop') controls(`controles4') method(reg) reps(500) seed(12345) robust verbose

putexcel B2 = matrix(e(RW_mob)[1..5,1])
putexcel C2 = matrix(e(RW_mob)[1..5,3])
putexcel D2 = matrix(e(RW_ppoverty)[1..5,1])
putexcel E2 = matrix(e(RW_ppoverty)[1..5,3])
putexcel F2 = matrix(e(RW_winh)[1..5,1])
putexcel G2 = matrix(e(RW_winh)[1..5,3])
putexcel H2 = matrix(e(RW_wcorr)[1..5,1])
putexcel I2 = matrix(e(RW_wcorr)[1..5,3])

forvalues i = 2/6{
	putexcel J`i' = formula(CONCAT(CONCAT("Movilidad: ", IF(AND(B`i'<0.05, C`i'>= 0.05),1,0), "; "), CONCAT("Pobreza por falta de esfuerzo: ", IF(AND(D`i'<0.05, E`i'>= 0.05),1,0), "; "), CONCAT("Proporción herencias: ", IF(AND(F`i'<0.05, G`i'>= 0.05),1,0), "; "), CONCAT("Proporción corrupción: ", IF(AND(H`i'<0.05, I`i'>= 0.05),1,0), ".")))
}

putexcel save


*********************************
* Aumentar impuestos para ricos *
*********************************

putexcel set "tables/aumentar_igualdadop_rw.xlsx", replace
putexcel A1= "Variable dependiente"
putexcel A2 = "ISR muy ricos"
putexcel A3 = "ISR empresas"

putexcel B1= "Movilidad social p-value"
putexcel C1= "Movilidad social Romano-Wolf p-value"
putexcel D1= "Pobreza por falta de esfuerzo p-value"
putexcel E1= "Pobreza por falta de esfuerzo Romano-Wolf p-value"
putexcel F1= "Proporción de riqueza heredada p-value"
putexcel G1= "Proporción de riqueza heredada Romano-Wolf p-value"
putexcel H1= "Proporcion de riqueza por corrupción p-value"
putexcel I1= "Proporcion de riqueza por corrupción Romano-Wolf p-value"
putexcel J1= "Cambios"

rwolf `aumentar_ricos' [aw = weight], indepvar(`igualdadop') controls(`controles4') method(reg) reps(500) seed(12345) robust verbose

putexcel B2 = matrix(e(RW_mob)[1..2,1])
putexcel C2 = matrix(e(RW_mob)[1..2,3])
putexcel D2 = matrix(e(RW_ppoverty)[1..2,1])
putexcel E2 = matrix(e(RW_ppoverty)[1..2,3])
putexcel F2 = matrix(e(RW_winh)[1..2,1])
putexcel G2 = matrix(e(RW_winh)[1..2,3])
putexcel H2 = matrix(e(RW_wcorr)[1..2,1])
putexcel I2 = matrix(e(RW_wcorr)[1..2,3])

forvalues i = 2/3{
	putexcel J`i' = formula(CONCAT(CONCAT("Movilidad: ", IF(AND(B`i'<0.05, C`i'>= 0.05),1,0), "; "), CONCAT("Pobreza por falta de esfuerzo: ", IF(AND(D`i'<0.05, E`i'>= 0.05),1,0), "; "), CONCAT("Proporción herencias: ", IF(AND(F`i'<0.05, G`i'>= 0.05),1,0), "; "), CONCAT("Proporción corrupción: ", IF(AND(H`i'<0.05, I`i'>= 0.05),1,0), ".")))
}

putexcel save
