-- Fixed MLB Players 2025 with proper league relationships
-- Ensure MLB teams and players are properly linked

-- Get the MLB league ID
SET @mlb_league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' AND league_type = 'professional' LIMIT 1);

-- Insert/Update MLB teams with proper league relationship
INSERT IGNORE INTO teams (league_id, name, short_name, city, primary_color, secondary_color) VALUES
-- AL Teams
(@mlb_league_id, 'Yankees', 'NYY', 'New York', '#132448', '#C4CED4'),
(@mlb_league_id, 'Red Sox', 'BOS', 'Boston', '#BD3039', '#0C2340'),
(@mlb_league_id, 'Blue Jays', 'TOR', 'Toronto', '#134A8E', '#1D2D5C'),
(@mlb_league_id, 'Rays', 'TB', 'Tampa Bay', '#092C5C', '#8FBCE6'),
(@mlb_league_id, 'Orioles', 'BAL', 'Baltimore', '#DF4601', '#000000'),
(@mlb_league_id, 'Guardians', 'CLE', 'Cleveland', '#E31937', '#0C2340'),
(@mlb_league_id, 'White Sox', 'CWS', 'Chicago', '#27251F', '#C4CED4'),
(@mlb_league_id, 'Tigers', 'DET', 'Detroit', '#0C2340', '#FA4616'),
(@mlb_league_id, 'Royals', 'KC', 'Kansas City', '#004687', '#BD9B60'),
(@mlb_league_id, 'Twins', 'MIN', 'Minnesota', '#002B5C', '#D31145'),
(@mlb_league_id, 'Astros', 'HOU', 'Houston', '#002D62', '#EB6E1F'),
(@mlb_league_id, 'Angels', 'LAA', 'Los Angeles', '#BA0021', '#003263'),
(@mlb_league_id, 'Athletics', 'OAK', 'Oakland', '#003831', '#EFB21E'),
(@mlb_league_id, 'Mariners', 'SEA', 'Seattle', '#0C2C56', '#005C5C'),
(@mlb_league_id, 'Rangers', 'TEX', 'Texas', '#003278', '#C0111F'),
-- NL Teams  
(@mlb_league_id, 'Braves', 'ATL', 'Atlanta', '#CE1141', '#13274F'),
(@mlb_league_id, 'Marlins', 'MIA', 'Miami', '#00A3E0', '#EF3340'),
(@mlb_league_id, 'Mets', 'NYM', 'New York', '#002D72', '#FF5910'),
(@mlb_league_id, 'Phillies', 'PHI', 'Philadelphia', '#E81828', '#002D72'),
(@mlb_league_id, 'Nationals', 'WSH', 'Washington', '#AB0003', '#14225A'),
(@mlb_league_id, 'Cubs', 'CHC', 'Chicago', '#0E3386', '#CC3433'),
(@mlb_league_id, 'Reds', 'CIN', 'Cincinnati', '#C6011F', '#000000'),
(@mlb_league_id, 'Brewers', 'MIL', 'Milwaukee', '#0A2351', '#B5985A'),
(@mlb_league_id, 'Pirates', 'PIT', 'Pittsburgh', '#FDB827', '#27251F'),
(@mlb_league_id, 'Cardinals', 'STL', 'St. Louis', '#C41E3A', '#0C2340'),
(@mlb_league_id, 'Diamondbacks', 'ARI', 'Arizona', '#A71930', '#E3D4A2'),
(@mlb_league_id, 'Rockies', 'COL', 'Colorado', '#33006F', '#C4CED4'),
(@mlb_league_id, 'Dodgers', 'LAD', 'Los Angeles', '#005A9C', '#EF3E42'),
(@mlb_league_id, 'Padres', 'SD', 'San Diego', '#2F241D', '#A2AAAD'),
(@mlb_league_id, 'Giants', 'SF', 'San Francisco', '#FD5A1E', '#27251F');

-- Get team IDs for key teams
SET @lad_id = (SELECT team_id FROM teams WHERE short_name = 'LAD' AND league_id = @mlb_league_id LIMIT 1);
SET @nyy_id = (SELECT team_id FROM teams WHERE short_name = 'NYY' AND league_id = @mlb_league_id LIMIT 1);
SET @kc_mlb_id = (SELECT team_id FROM teams WHERE short_name = 'KC' AND league_id = @mlb_league_id LIMIT 1);
SET @nym_id = (SELECT team_id FROM teams WHERE short_name = 'NYM' AND league_id = @mlb_league_id LIMIT 1);
SET @hou_id = (SELECT team_id FROM teams WHERE short_name = 'HOU' AND league_id = @mlb_league_id LIMIT 1);
SET @cle_id = (SELECT team_id FROM teams WHERE short_name = 'CLE' AND league_id = @mlb_league_id LIMIT 1);
SET @bal_mlb_id = (SELECT team_id FROM teams WHERE short_name = 'BAL' AND league_id = @mlb_league_id LIMIT 1);
SET @atl_id = (SELECT team_id FROM teams WHERE short_name = 'ATL' AND league_id = @mlb_league_id LIMIT 1);
SET @sd_id = (SELECT team_id FROM teams WHERE short_name = 'SD' AND league_id = @mlb_league_id LIMIT 1);

-- Insert MLB Top Players  
INSERT IGNORE INTO players (team_id, first_name, last_name, position, jersey_number, photo_url) VALUES
-- Top 10 MLB Players
(@lad_id, 'Shohei', 'Ohtani', 'DH', '17', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/660271/headshot/67/current'),
(@nyy_id, 'Aaron', 'Judge', 'RF', '99', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/592450/headshot/67/current'),
(@kc_mlb_id, 'Bobby', 'Witt Jr.', 'SS', '7', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/677951/headshot/67/current'),
(@nym_id, 'Juan', 'Soto', 'RF', '22', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/665742/headshot/67/current'),
(@lad_id, 'Mookie', 'Betts', 'RF', '50', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/605141/headshot/67/current'),
(@nym_id, 'Francisco', 'Lindor', 'SS', '12', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/596019/headshot/67/current'),
(@hou_id, 'Yordan', 'Alvarez', 'DH', '44', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/670541/headshot/67/current'),
(@lad_id, 'Freddie', 'Freeman', '1B', '5', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/518692/headshot/67/current'),
(@cle_id, 'José', 'Ramírez', '3B', '11', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/608070/headshot/67/current'),
(@bal_mlb_id, 'Gunnar', 'Henderson', 'SS', '2', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/683002/headshot/67/current'),

-- Additional Top Players
(@atl_id, 'Ronald', 'Acuna Jr.', 'OF', '13', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/660670/headshot/67/current'),
(@sd_id, 'Fernando', 'Tatis Jr.', 'SS', '23', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/665487/headshot/67/current');

-- Verify the data
SELECT 'MLB TEAMS VERIFICATION:' as info;
SELECT t.team_id, t.name, t.short_name, t.city, l.name as league_name, s.name as sport_name
FROM teams t 
JOIN leagues l ON t.league_id = l.league_id 
JOIN sports s ON l.sport_id = s.sport_id
WHERE s.short_name = 'MLB'
ORDER BY t.city, t.name;

SELECT 'MLB PLAYERS VERIFICATION:' as info;  
SELECT p.player_id, CONCAT(p.first_name, ' ', p.last_name) as name, p.position,
       t.short_name as team, l.name as league_name, s.name as sport_name
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
JOIN sports s ON l.sport_id = s.sport_id  
WHERE s.short_name = 'MLB'
ORDER BY p.last_name
LIMIT 15;