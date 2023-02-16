create database project_4_energy;
use project_4_energy;
select * from data_1;

set global local_infile=1;
load data  infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\data_1.csv" into table data_1
fields terminated by','
enclosed by '"'
escaped by '\\'
lines terminated by'\n'
starting by ''
ignore 1 lines;
show variables like "%secure_file_priv%";
set foreign_key_checks=0;
truncate table data_2;
load data  infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\data_2.csv" into table data_2
fields terminated by','
enclosed by '"'
escaped by '\\'
lines terminated by'\n'
starting by ''
ignore 1 lines;

# KPI-1 (MMBtu_TOTAL for Ethane & Ethanol )
select fuel_type, sum(MMBtu_TOTAL) from data_1 where fuel_type like 'ethan%'
 group by fuel_type;
#KPI-2 (% Share of MMBtu Total for each MECS_Region)
update data_1 set mecs_region="other" where mecs_region="";
select mecs_region, sum(MMBtu_TOTAL) as total,
concat(round(sum(MMBtu_TOTAL)*100/(select sum(MMBtu_TOTAL) from data_1),2),'%') as '% of total' from data_1
group by mecs_region ;
 
 #KPI-3 (Unit Name trend (1950-2020) Vs GWht_TOTAL)
 select * from data_1;
 select unit_name, sum(gwht_total) as total from data_1 where unit_name in ('Apr-81','May-81','Jun-81','Aug-50','Dec-90','Jun-97')
 group by unit_name order by total ;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
#KPI-4 (Statistics about Solid Waste Landfill w.r.t. Facility and County)
select county,count(facility_name) as landfill from data_1 
where facility_name like "% solid waste landfill%" 
group by county order by count(facility_name) desc;


#KPI-5 (% Distribution of each Grouping for MMBtu_TOTAL and GWht_TOTAL)
select groupings,sum(mmbtu_total),sum(gwht_total),
concat(round(sum(mmbtu_total)*100/(select sum(mmbtu_total),2),"%") as '% mmbtu_total',
concat(round(sum(gwht_total)*100/(select sum(gwht_total),2),"%") as '% total gwht_total'
from data_1
group by groupings;
 
