-- 1
-- Goals per season

select 
	season, 
	SUM(FTHG) as HomeGoals, 
	SUM(FTAG) as AwayGoals,
	SUM(FTHG + FTAG) as TotalGoals
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season
order by season

-- 2
-- Goals per season and date

select 
	season, 
	date,
	SUM(FTHG) as HomeGoals, 
	SUM(FTAG) as AwayGoals,
	SUM(FTHG + FTAG) as TotalGoals
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season, date
order by season, date