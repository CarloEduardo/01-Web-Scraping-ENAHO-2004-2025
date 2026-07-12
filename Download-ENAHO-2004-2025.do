* Project: Web-Scraping-ENAHO-2004-2025
* Author: Carlos Eduardo Torres Garcia 
* Email: carlo.eduardo749@gmail.com
* GitHub: CarloEduardo
* Last modified: Jul 2026
* Acknowledgment: Edinson Tolentino
********************************************************************************

cls
clear all
set more off

global Path    = "E:\07. GitHub\01-Web-Scraping-ENAHO-2004-2025" 
global Dataset = "$Path\ENAHO"

capture mkdir "$Dataset"

********************************************************************************
* Years:
********************************************************************************
* (2004/2005/2006/2007/2008/2009/2010/2011/2012/2013/2014/2015/2016/2017/2018/2019/2020/2021/2022/2023/2024/2025)	
mat ENAHO_YEARS = (280\281\282\283\284\285\279\291\324\404\440\498\546\603\634\687\737\759\784\906\966\1031)

********************************************************************************
* Modules:
********************************************************************************
* 1. Module	1 – Características de la Vivienda y del Hogar				
* 2. Module	2 – Características de los Miembros del Hogar				
* 3. Module	3 – Educación				
* 4. Module	4 – Salud				
* 5. Module	5 – Empleo e Ingresos				
* 6. Module	7 – Gastos en Alimentos y Bebidas (Módulo 601)				
* 7. Module	8 – Instituciones Beneficas				
* 8. Module	9 – Mantenimiento de la Vivienda				
* 9. Module	10 – Transportes y Comunicaciones				
*10. Module	11 – Servicios a la Vivienda				
*11. Module	12 – Esparcimiento , Diversion y Servicios de Cultura				
*12. Module	13 – Vestido y Calzado				
*13. Module	15 – Gastos de Transferencias				
*14. Module	16 – Muebles y Enseres				
*15. Module	17 – Otros Bienes y Servicios				
*16. Module	18 – Equipamiento del Hogar				
*17. Module	22 – Producción Agrícola				
*18. Module	23 – Subproductos Agricolas				
*19. Module	24 – Producción Forestal				
*20. Module	25 – Gastos en Actividades Agricolas y/o Forestales				
*21. Module	26 – Producción Pecuaria				
*22. Module	27 – Subproductos Pecuarios				
*23. Module	28 – Gastos en Actividades Pecuarias				
*24. Module	34 – Sumarias (Variables Calculadas)				
*25. Module	37 – Programas Sociales (Miembros del Hogar)				
*26. Module	77 – Ingresos del Trabajador Independiente				
*27. Module	78 – Bienes y Servicios de Cuidados Personales				
*28. Module	84 – Participación Ciudadana				
*29. Module	85 – Gobernabilidad, Democracia y Transparencia	
*30. Module	1825 – Beneficiarios de Instituciones sin fines de lucro: Olla Común
*31. Module	2081 – Crianza de Mascotas en el Hogar
*32. Module	2082 – Inseguridad Alimentaria

mat base_modules = (1,2,3,4,5,7,8,9,10,11,12,13,15,16,17,18,22,23,24,25,26,27,28,34,37,77,78,84,85,1825,2081,2082)
mat ENAHO_MODULES = J(22,32,.)
forvalues r = 1(1)22 {
    mat ENAHO_MODULES[`r',1] = base_modules
}

matlist ENAHO_YEARS
matlist ENAHO_MODULES

********************************************************************************
* Download and extract ENAHO modules
********************************************************************************
* Here you can choose the range of years you want to download
local y_start         = 4
local y_start_minus_1 = `y_start' - 1
local y_end           = 25

forvalues i = `y_start'(1)`y_end' {
    local year = 2000 + `i'
    local t    = `i' - `y_start_minus_1'
    
    capture mkdir "$Dataset/`year'"
    cd            "$Dataset/`year'"
    
    local survey_id = ENAHO_YEARS[`t',1]
    
	* Here you can choose which modules you want to download
	foreach j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 {
        
        local survey_mod = ENAHO_MODULES[`t',`j']
        
        display "Year: `year' - Survey ID: `survey_id' - Module: `survey_mod'"
		
        if `j' <= 8 {
            local mod_prefix "Modulo0"
        }
        else {
            local mod_prefix "Modulo"
        }
        				
        if `year' <= 2021 {
            copy https://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`survey_id'-`mod_prefix'`survey_mod'.zip      ENAHO_`year'_Modulo`survey_mod'.zip, replace
        }
        else {
            copy https://proyectos.inei.gob.pe/iinei/srienaho/descarga/STATA/`survey_id'-`mod_prefix'`survey_mod'.zip  ENAHO_`year'_Modulo`survey_mod'.zip, replace
        }
        
		cap unzipfile ENAHO_`year'_Modulo`survey_mod'.zip, replace
		
		if _rc == 0 {
			*erase ENAHO_`year'_Modulo`survey_mod'.zip
		} 
		else {
			display as error "Error during extraction. Please manually extract the file: ENAHO_`year'_Modulo`survey_mod'.zip"
		}
    }
}

