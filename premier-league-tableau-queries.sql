use [premier-league-project] 

-- KEY FOR DATA HEADER COLUMNS
/*
Div = League Division
Date = Match Date (dd/mm/yy)
Time = Time of match kick off
HomeTeam = Home Team
AwayTeam = Away Team
FTHG and HG = Full Time Home Team Goals
FTAG and AG = Full Time Away Team Goals
FTR and Res = Full Time Result (H=Home Win, D=Draw, A=Away Win)
HTHG = Half Time Home Team Goals
HTAG = Half Time Away Team Goals
HTR = Half Time Result (H=Home Win, D=Draw, A=Away Win)

Match Statistics (where available)
Attendance = Crowd Attendance
Referee = Match Referee
HS = Home Team Shots
AS = Away Team Shots
HST = Home Team Shots on Target
AST = Away Team Shots on Target
HHW = Home Team Hit Woodwork
AHW = Away Team Hit Woodwork
HC = Home Team Corners
AC = Away Team Corners
HF = Home Team Fouls Committed
AF = Away Team Fouls Committed
HFKC = Home Team Free Kicks Conceded
AFKC = Away Team Free Kicks Conceded
HO = Home Team Offsides
AO = Away Team Offsides
HY = Home Team Yellow Cards
AY = Away Team Yellow Cards
HR = Home Team Red Cards
AR = Away Team Red Cards
*/

CREATE TABLE SeasonMonthOrder (
  MonthNumber INT,
  MonthName VARCHAR(20)
);

INSERT INTO SeasonMonthOrder (MonthNumber, MonthName)
VALUES
  (1, 'August'),
  (2, 'September'),
  (3, 'October'),
  (4, 'November'),
  (5, 'December'),
  (6, 'January'),
  (7, 'February'),
  (8, 'March'),
  (9, 'April'),
  (10, 'May');

-- Goals per season

create view GoalsPerSeason as
select 
	season, 
	SUM(FTHG) as HomeGoals, 
	SUM(FTAG) as AwayGoals,
	SUM(FTHG + FTAG) as TotalGoals
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season
order by season

-- Goals per season and date

create view GoalsPerSeasonAndOrderDate as
select 
	season, 
	SeasonOrderDate,
	SUM(FTHG) as HomeGoals, 
	SUM(FTAG) as AwayGoals,
	SUM(FTHG + FTAG) as TotalGoals
from 
(
select
	*,
	CASE
           WHEN MONTH(date) = 1 THEN '01/01/9999'
           WHEN MONTH(date) = 2 THEN '01/02/9999'
           WHEN MONTH(date) = 3 THEN '01/03/9999'
           WHEN MONTH(date) = 4 THEN '01/04/9999'
           WHEN MONTH(date) = 5 THEN '01/05/9999'
           WHEN MONTH(date) = 6 THEN '01/06/9999'
           WHEN MONTH(date) = 7 THEN '01/07/9999'
           WHEN MONTH(date) = 8 THEN '01/08/9999'
           WHEN MONTH(date) = 9 THEN '01/09/9999'
           WHEN MONTH(date) = 10 THEN '01/10/9999'
           WHEN MONTH(date) = 11 THEN '01/11/9999'
           WHEN MONTH(date) = 12 THEN '01/12/9999'
       END AS SeasonOrderDate
from [premier-league-project]..[PremierLeagueDataWithCity]
) as SubQuery
group by SeasonOrderDate
order by SeasonOrderDate

-- Yellow cards vs Red cards over all seasons >= '2000/2021'

create view YellowVsRedAllSeasons as
select 
	SUM(HR + AR) as RedCards, 
	SUM(HY + AY) as YellowCards,
	COUNT(date) as TotalGames,
	(SUM(HR + AR)/COUNT(date))*100 as RedCardRate,
	(SUM(HY + AY)/COUNT(date))*100 as YellowCardRate
from [premier-league-project]..[PremierLeagueDataWithCity]

-- Yellow cards vs Red cards for each season

create view YellowVsRedBySeasons as
select 
	season, 
	SUM(HR) + SUM(AR) as RedCards, 
	SUM(HY) + SUM(AY) as YellowCards,
	COUNT(date) as TotalGames,
	(SUM(HR + AR)/COUNT(date))*100 as RedCardRate,
	(SUM(HY + AY)/COUNT(date))*100 as YellowCardRate
from [premier-league-project]..PremierLeagueData
group by season
order by season

select 
	HR, AR
from [premier-league-project]..PremierLeagueData20222023

-- card probailities over all seasons >= '2000/2021'

create view CardRates as
select 
	SUM(HR) as HomeRedCards, 
	SUM(AR) as AwayRedCards, 
	SUM(HY) as HomeYellowCards,
	SUM(AY) as AwayYellowCards,
	COUNT(date) as TotalGames,
	(SUM(HR)/COUNT(date))*100 as HomeRedCardRate,
	(SUM(AR)/COUNT(date))*100 as AwayRedCardRate,
	(SUM(AR)/COUNT(date))/(SUM(HR)/COUNT(date)) as IncreasedAwayRedCardProbability,
	(SUM(HY)/COUNT(date))*100 as HomeYellowCardRate,
	(SUM(AY)/COUNT(date))*100 as AwayYellowCardRate,
	(SUM(AY)/COUNT(date))/(SUM(HY)/COUNT(date)) as IncreasedAwayYellowCardProbability,
	(SUM(AR)+SUM(AY))/COUNT(date)*100 as OverallAwayCardRate,
	(SUM(HR)+SUM(HY))/COUNT(date)*100 as OverallHomeCardRate,
	(SUM(HR)+SUM(HY)+SUM(AR)+SUM(AY))/COUNT(date)*100 as OverallCardRate,
	((SUM(AR)+SUM(AY))/COUNT(date))/((SUM(HR)+SUM(HY))/COUNT(date)) as IncreasedAwayCardProbability
from [premier-league-project]..[PremierLeagueDataWithCity]

-- Home and Away Yellow cards vs Red cards by season

create view HomeAndAwayYellowVsRedBySeasons as
select 
	season, 
	SUM(HR) as HomeRedCards, 
	SUM(AR) as AwayRedCards, 
	SUM(HY) as HomeYellowCards,
	SUM(AY) as AwayYellowCards,
	COUNT(date) as TotalGames,
	(SUM(HR)/COUNT(date))*100 as HomeRedCardRate,
	(SUM(AR)/COUNT(date))*100 as AwayRedCardRate,
	(SUM(HY)/COUNT(date))*100 as HomeYellowCardRate,
	(SUM(AY)/COUNT(date))*100 as AwayYellowCardRate
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season
order by season

-- Yellow cards vs Red cards by seasons and Home team

create view YellowVsRedBySeasonsAndHomeTeam as
select 
	season, 
	HomeTeam,
	SUM(HR) as HomeRedCards, 
	SUM(HY) as HomeYellowCards
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season, HomeTeam
order by season, HomeTeam

-- Yellow cards vs Red cards by seasons and Away team

create view YellowVsRedBySeasonsAndAwayTeam as
select 
	season, 
	AwayTeam,
	SUM(AR) as AwayRedCards, 
	SUM(AY) as AwayYellowCards
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season, AwayTeam
order by season, AwayTeam

-- Total cards for each season and team 

create view TotalCardsBySeasonAndTeam as
select 
	a.*, 
	b.HomeRedCards,
	b.HomeYellowCards,
	c.AwayRedCards,
	c.AwayYellowCards,
	(b.HomeRedCards + b.HomeYellowCards + c.AwayRedCards + c.AwayYellowCards) as TotalCards
from
(
select
	season,
	HomeTeam as Team
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season, HomeTeam
) as a
left join [premier-league-project]..[YellowVsRedBySeasonsAndHomeTeam] as b
on a.season = b.season and a.Team = b.HomeTeam
left join [premier-league-project]..[YellowVsRedBySeasonsAndAwayTeam] as c
on a.season = c.season and a.Team = c.AwayTeam
order by season, Team

-- Total cards by team over all seasons >= '2000/2021'

create view TotalCardsByTeamAllSeasons as
select
	Team,
	SUM(HomeRedCards) as HomeRedCards,
	SUM(HomeYellowCards) as HomeYellowCards,
	SUM(AwayRedCards) as AwayRedCards,
	SUM(AwayYellowCards) as AwayYellowCards,
	SUM(TotalCards) as TotalCards
from [premier-league-project]..[TotalCardsBySeasonAndTeam]
group by Team
order by Team

