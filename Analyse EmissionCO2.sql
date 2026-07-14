								-- =============================================
								-- ========= Ma Base projectBDD ============    |
								-- =============================================
-- ======================
-- | L2 DSBD            |
-- |Youssoupha NDIAYE   |
-- ======================


							-- ----------------TP1: Analyse Emission CO2 ----------------
USE ProjectBDD;
show tables;
-- drop table co2_emission3;
create table co2_emission3( code_pays varchar(255), country varchar(255), Annee varchar(5), valeur integer);
select * from co2_emission3 order by valeur DESC;

-- d abord je veux savoir la premiere annee d etude et l'Annee la plus recente
select min(Annee) as premiere_annee, max(Annee) as derniere_annee, count(distinct country) as nombre_pays from co2_emission3 ;
-- select Annee, country  


-- comparons l evaluation annuelle au sein de chaque pays selon leur valeur d emmision en ordre desc ou asc
select 
	country, Annee,
    sum(valeur) as total_emission,
    ROUND(avg(valeur), 1) as moyenne_annuelle,
	MAX(valeur) as plus_grande_emmission
	from co2_emission3 
    group by 
		country, Annee 
	order by plus_grande_emmission DESC;

-- determinons les pays les plus polluants par ordre des pays de 1960 a 2019 
select country, Annee, sum(valeur) as total_emission,
 count(*) as nombre_enregistrement 
 from co2_emission3
 group by country, Annee 
 order by total_emission DESC 
 limit 10; -- dans mon cas je prend les 10 plus grands polluants

-- je veux savoir les plus grandes emissions ayant depasses plus de 200 000(..) en somme  partir de 2016
select distinct country,Annee,
sum(valeur) as total_emission from co2_emission3 where Annee>=2016
group by country, Annee having total_emission>=200000;

-- maintenant je peux calculer l ecart-type des emissions pour chaque pays
-- A prendre en compte : 
	-- 1- Plus l' ecart-type est petit -> plus les emissions sont constantes d'Annee en Annee
	-- 2- On prendra en compte les pays ayant ete enregistre sur 5 Annee != pour que les STDDEV sois plus fiables
select 
country, round(STDDEV(valeur), 2) as ecart_type_emissions,
round(avg(valeur), 2) as moyenne_emissions,
count(*) as nb_annee
from co2_emission3
group by country having nb_annee>=5
order by ecart_type_emissions ASC
limit 15;

-- On va essayer de creer une view
create or replace view v_emissions as 
select country, valeur,
case 
	when valeur > 200000 then 'Emission Eleve' -- a partir de 200 000 sera considere comme excessive
    when valeur > 0 then 'Emissions Moderees' -- entre 0 et 200000 comme moyenne
    else 'Emission Negative'
END as emission
from co2_emission3;
select * from v_emissions;
    