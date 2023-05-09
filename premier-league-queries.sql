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

-- UNION all season from 2000/2001 onwards
-- create view of union data

use [premier-league-project] 
DECLARE @query AS VARCHAR(MAX) = 'CREATE VIEW PremierLeagueData AS ';
DECLARE @year INT = 2000;

WHILE (@year < 2023)
BEGIN
  SET @query += 'SELECT [Div], [Date], [HomeTeam], [AwayTeam], [FTHG], [FTAG], [FTR], [HTHG], [HTAG], [HTR], [Referee], [HS], [AS], [HST], [AST], [HF], [AF], [HC], [AC], [HY], [AY], [HR], [AR], ''' + CAST(@year AS VARCHAR(4)) + '/' + CAST(@year + 1 AS VARCHAR(4)) + ''' AS Season 
					FROM [premier-league-project].[dbo].[PremierLeagueData' + CAST(@year AS VARCHAR(4)) + CAST(@year + 1 AS VARCHAR(4)) + '] ';
  SET @year = @year + 1;
  IF (@year < 2023)
  BEGIN
    SET @query += 'UNION ';
  END
END

EXEC(@query);

-- create lookup to add 'City' column to the data

CREATE TABLE PremierLeagueTeamAndCity (
    team VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO PremierLeagueTeamAndCity (team, city) VALUES
('Arsenal', 'London'),
('Aston Villa', 'Birmingham'),
('Bournemouth', 'Bournemouth'),
('Brighton', 'Brighton & Hove'),
('Burnley', 'Burnley'),
('Brentford', 'Brentford'),
('Chelsea', 'London'),
('Crystal Palace', 'London'),
('Everton', 'Liverpool'),
('Fulham', 'London'),
('Leeds', 'Leeds'),
('Leicester', 'Leicester'),
('Liverpool', 'Liverpool'),
('Man City', 'Manchester'),
('Man United', 'Manchester'),
('Newcastle', 'Newcastle upon Tyne'),
('Nott''m Forest', 'Nottingham'),
('Norwich City', 'Norwich'),
('Sheffield United', 'Sheffield'),
('Southampton', 'Southampton'),
('Stoke City', 'Stoke-on-Trent'),
('Sunderland', 'Sunderland'),
('Swansea City', 'Swansea'),
('Tottenham', 'London'),
('Watford', 'Watford'),
('West Bromwich Albion', 'West Bromwich'),
('West Ham', 'London'),
('Wigan Athletic', 'Wigan'),
('Wolves', 'Wolverhampton');

-- join cities onto data

select firstjoin.*, c.city as AwayCity
from
(
select 
	a.*, b.city as HomeCity
from [premier-league-project]..[PremierLeagueData] as a 
left join [premier-league-project]..[PremierLeagueTeamAndCity] as b
on a.HomeTeam = b.team
) as firstjoin
left join [premier-league-project]..[PremierLeagueTeamAndCity] as c
on firstjoin.AwayTeam = c.team


