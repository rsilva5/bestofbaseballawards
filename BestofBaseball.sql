-- Heaviest Hitters

SELECT ROUND(AVG(weight),2) AS Avg_Weight_lbs, batting.yearid, teams.name
FROM people
INNER JOIN batting 
	ON people.playerID = Batting.playerID
INNER JOIN teams
	ON batting.teamID = teams.teamID
GROUP BY 2,3
ORDER BY 1 DESC;

-- Shortest Hitters 

SELECT ROUND(AVG(people.height),2) AS AVG_Height_Inches, teams.name, batting.yearid
FROM people
INNER JOIN batting 
	ON people.playerID = batting.playerID
INNER JOIN teams 
	ON batting.teamID = teams.teamID 
GROUP BY 2,3 
ORDER BY 1 ASC;

-- Biggest Spenders 
SELECT SUM(salaries.salary) AS sum_of_player_salaries, 
	salaries.teamid, 
  teams.name AS team, 
  salaries.yearid AS year, 
  ROW_NUMBER() OVER(PARTITION BY salaries.yearid ORDER BY SUM(salaries.salary) DESC) AS Biggest_Spender_Position_Based_on_Yr
FROM salaries
INNER JOIN teams
	ON salaries.teamid = teams.teamid
  AND teams.yearid = salaries.yearid
GROUP BY 2,3,4
ORDER BY 1 DESC;

-- Most Bang For Their Buck in 2010: The team with the smallest cost per win 
SELECT ROUND(SUM(salaries.salary)/(teams.w)) AS Cost_Per_Win,
  teams.name AS team, 
  salaries.yearid AS year 
FROM salaries
INNER JOIN teams
	ON salaries.teamid = teams.teamid
  AND teams.yearid = salaries.yearid
WHERE salaries.yearid = 2010
GROUP BY teams.name, 
	salaries.yearid, 
	teams.w
ORDER BY 1 ASC;

-- Priciest Starter 
SELECT salaries.salary, pitching.gs, ROUND(salaries.salary/pitching.gs) AS Cost_Per_Start, people.namefirst, people.namelast, pitching.teamid, pitching.yearid
FROM salaries 
INNER JOIN pitching
	ON salaries.playerid = pitching.playerid
  AND salaries.yearid = pitching.yearid
  AND salaries.teamid = pitching.teamid
INNER JOIN people 
	ON salaries.playerid = people.playerid
WHERE pitching.gs > 10 
ORDER BY 3 DESC;