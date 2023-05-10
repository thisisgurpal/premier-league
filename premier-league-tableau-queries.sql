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

-- 1
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

-- 2
-- Goals per season and date

create view GoalsPerSeasonAndDate as
select 
	season, 
	date,
	SUM(FTHG) as HomeGoals, 
	SUM(FTAG) as AwayGoals,
	SUM(FTHG + FTAG) as TotalGoals
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season, date
order by season, date

-- 3
-- Yellow cards vs Red cards over all seasons >= '2000/2021'

create view YellowVsRedAllSeasons as
select 
	SUM(HR + AR) as RedCards, 
	SUM(HY + AY) as YellowCards,
	COUNT(date) as TotalGames,
	(SUM(HR + AR)/COUNT(date))*100 as RedCardRate,
	(SUM(HY + AY)/COUNT(date))*100 as YellowCardRate
from [premier-league-project]..[PremierLeagueDataWithCity]

-- 4
-- Yellow cards vs Red cards for each season

create view YellowVsRedBySeasons as
select 
	season, 
	SUM(HR + AR) as RedCards, 
	SUM(HY + AY) as YellowCards,
	COUNT(date) as TotalGames,
	(SUM(HR + AR)/COUNT(date))*100 as RedCardRate,
	(SUM(HY + AY)/COUNT(date))*100 as YellowCardRate
from [premier-league-project]..[PremierLeagueDataWithCity]
group by season
order by season

-- 5
-- Home and Away Yellow cards vs Red cards over all seasons >= '2000/2021'

create view HomeAndAwayYellowVsRedAllSeasons as
select 
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

-- 6
-- Home and Away Yellow cards vs Red cards over all seasons >= '2000/2021'

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

-- 7
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

-- 8
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

-- 9
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

-- 10
-- Total cards for team over all seasons >= '2000/2021'

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

