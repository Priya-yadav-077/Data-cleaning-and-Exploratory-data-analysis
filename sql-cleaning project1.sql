
                                              -- Data Cleaning
select * from layoffs;

create table layoffs_staging like layoffs;
insert  layoffs_staging  select * from layoffs;

select * from layoff_staging;
-- find and delete duplicates from the tabel;
with duplicate_cte as
(
select *, row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off, 'date', stage, country, funds_raised)rn
 from layoffs_staging)
select * from duplicate_cte where rn>1;
select * from layoffs_staging where company= 'oyster';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `rn` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2(select *, row_number() over(
partition by company,location,industry,total_laid_off,percentage_laid_off, 'date', stage, country, funds_raised)rn
 from layoffs_staging);

select * from layoffs_staging2 where rn>1;
delete from layoffs_staging2 where rn>1;
select * from layoffs_staging2;

-- standarize the data
select distinct company, trim(company) from layoffs_staging2;
update layoffs_staging2 set company=trim(company);

select  distinct industry from layoffs_staging2 order by industry;
select  *from layoffs_staging2 where industry like 'Crypto%';
select distinct location from layoffs_staging2;

select distinct country from layoffs_staging2 order by country;
update layoffs_staging2 set country = trim(trailing '.' from country) where country like 'United states%';
update layoffs_staging2 set `date`= str_to_date( `date`, '%Y-%m-%d' );
alter table layoffs_staging2 modify `date` DATE;

-- null values or blank values

select * from layoffs_staging2 where  percentage_laid_off = '' ;
select * from layoffs_staging2 where  total_laid_off = '' ;
select * from layoffs_staging2 where percentage_laid_off='' and total_laid_off='';
select * from layoffs_staging2 where industry ='';
select  industry from layoffs_staging2;
select * from layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company=t2.company 
where (t1.industry is null or t1.industry='') and t2.industry is not null;

select * from layoffs_staging2 where company='Appsmith';

select t1.industry,t2.industry from layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company=t2.company 
where (t1.industry is null or t1.industry='') and t2.industry is not null;
update layoffs_staging2 set industry =null where industry='';
update layoffs_staging2 t1 join layoffs_staging t2 on t1.company=t2.company set t1.industry =t2.industry where (t1.industry ='') and t2.industry is not null;


-- remove blank columns and rows

select * from layoffs_staging2 where percentage_laid_off='' and total_laid_off='';
delete from layoffs_staging2 where percentage_laid_off='' and total_laid_off='';
select * from layoffs_staging2;
alter table layoffs_staging2 drop column rn;

                                             -- Expolatory data analysis(EDA)
           
select max(total_laid_off) from layoffs_staging2;
select max(percentage_laid_off) from layoffs_staging2;
select * from layoffs_staging2 where percentage_laid_off=1.0 order by total_laid_off desc;
select company, sum(total_laid_off),industry from layoffs_staging2 group by company ,industry order by sum(total_laid_off) desc;
select company, sum(total_laid_off),industry,country from layoffs_staging2 group by company ,industry ,country order by sum(total_laid_off) desc;
-- observe that United states retails industry  was worst hit.Amayon company laid off more people as compared to any other company in the country United states.
select year(`date`) ,sum(total_laid_off) from layoffs_staging2 group by year(`date`) order by sum(total_laid_off) desc;
-- 2023 was the year of major layoff and observed comparatively less in the year of 2021.
select year(`date`), company, sum(total_laid_off),industry,country from layoffs_staging2 group by year(`date`), company ,industry ,country order by sum(total_laid_off) desc;
-- so we got to know that the year 2023 faced major layoff by the tech companies like amayon, intel, google,meta etc.. in the country united states in the retail, hardware 
-- transportation etc.. industry..
select stage,sum(total_laid_off) from layoffs_staging2 group by stage order by sum(total_laid_off) desc;
-- the major layoffs were done by the big companies like the amazon, google, meta etc...
select substring(`date`, 1,7)  as `month`, sum(total_laid_off)   from layoffs_staging2 group by `month` order by sum(total_laid_off) desc;
-- year 2023 and month of january was the period when major layoffs happened 
select substring(`date`, 1,7)  as `month`, sum(total_laid_off), company  from layoffs_staging2 group by `month` , company order by sum(total_laid_off) desc;
-- Intel company laid off 15000 emloyee in the august year 2024.This company laid off large number of employees in a single month as comared to others.

with cte as (select substring(`date`, 1,7)  as `month`, sum(total_laid_off) as total  from layoffs_staging2 group by `month` order by 1 asc)
select `month`,total, sum(total) over(order by `month`) as rolling_total from cte;
-- created a commom temporary table to look at the monthwise layoff grouped by zear and month and ordered in ascending by month.
-- calculated the rolling total by suming the sum of total laid off. and as a result we get a breakdown of how many employees get laid off every month
-- of each year since lockdown.

with cte1 as (select  company ,year(`date`) as yc ,sum(total_laid_off) as total from layoffs_staging2 group by yc, company order by 2 asc)
select company, yc,total,sum(total) over( partition by yc order by company) as rolling_total from cte1;
-- here I tried to calculate and observe which all companies laid off how many employees in what year and calulated a rolling total of that.

with company_yearwise_layoffs as (select year(`date`) as yc,company,sum(total_laid_off) as total from layoffs_staging2 group by company, yc order by sum(total_laid_off) desc),
company_rank as ( select *,dense_rank() over(partition by yc order by total desc) as ranking from company_yearwise_layoffs)
select * from company_rank where ranking<=5 ;
-- we are able to observe the top five companies that laid off in a particular year.