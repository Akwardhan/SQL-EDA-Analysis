-- Exploratory Data Analysis	

Select *
from layoff_staging2;


Select max(total_laid_off), max(percentage_laid_off)
from layoff_staging2;

Select *
from layoff_staging2
where percentage_laid_off =1
order by funds_raised_millions desc;

Select company,sum(total_laid_off)
from layoff_staging2
group by company 
order by 2 desc;

select min(`date`),max(`date`)
from layoff_staging2;

Select industry,sum(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

Select *
from layoff_staging2;

Select country,sum(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

Select Year(`date`),country,sum(total_laid_off)
from layoff_staging2
group by country,Year(`date`)
order by 1 ;

Select stage,sum(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc ;

Select company,sum(percentage_laid_off)
from layoff_staging2
group by company 
order by 2 desc;

Select company,avg(percentage_laid_off)
from layoff_staging2
group by company 
order by 2 desc;

select *
from layoff_staging2;

-- Understanding the progression of layoff
-- Rolling Sum

select substring(`date`,1,7) as MONTH, SUM(total_laid_off)
from layoff_staging2
where substring(`date`,1,7) is not null
group by MONTH
ORDER BY 1 asc ;

with Rolling_total as
(
	select substring(`date`,1,7) as MONTH, SUM(total_laid_off) as total_off
	from layoff_staging2
	where substring(`date`,1,7) is not null
	group by MONTH
	ORDER BY 1 asc
)
select MONTH, total_off,
sum(total_off) over(order by MONTH) as rolling_total
from Rolling_total;

Select company,sum(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

Select company,YEAR(`date`),sum(total_laid_off)
from layoff_staging2
group by company,`date`
order by company asc;

-- which year they layoff the most
-- we need to partition it based on year and rank it based on how many they layoff in that year
-- which company laid off the most
Select company,YEAR(`date`),sum(total_laid_off)
from layoff_staging2
group by company,`date`
order by 3 desc;

with company_Year (company,years,total_laid_off) as
(
Select company,YEAR(`date`),sum(total_laid_off)
from layoff_staging2
group by company,Year(`date`)
),company_Year_Rank as
(select *, 
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_Year
where years is not null
)
select *
from company_Year_Rank
where ranking <= 5;
