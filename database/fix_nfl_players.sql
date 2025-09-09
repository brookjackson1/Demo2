-- Fixed NFL Players 2025 with proper league relationships
-- Ensure NFL teams and players are properly linked

-- First, ensure we have NFL teams linked to the correct league
-- Get the NFL league ID first
SET @nfl_league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' AND league_type = 'professional' LIMIT 1);

-- Insert/Update NFL teams with proper league relationship
INSERT IGNORE INTO teams (league_id, name, short_name, city, primary_color, secondary_color) VALUES
-- AFC Teams
(@nfl_league_id, 'Bills', 'BUF', 'Buffalo', '#00338D', '#C60C30'),
(@nfl_league_id, 'Dolphins', 'MIA', 'Miami', '#008E97', '#FC4C02'),  
(@nfl_league_id, 'Patriots', 'NE', 'New England', '#002244', '#C60C30'),
(@nfl_league_id, 'Jets', 'NYJ', 'New York', '#125740', '#000000'),
(@nfl_league_id, 'Ravens', 'BAL', 'Baltimore', '#241773', '#000000'),
(@nfl_league_id, 'Bengals', 'CIN', 'Cincinnati', '#FB4F14', '#000000'),
(@nfl_league_id, 'Browns', 'CLE', 'Cleveland', '#311D00', '#FF3C00'),
(@nfl_league_id, 'Steelers', 'PIT', 'Pittsburgh', '#FFB612', '#101820'),
(@nfl_league_id, 'Texans', 'HOU', 'Houston', '#03202F', '#A71930'),
(@nfl_league_id, 'Colts', 'IND', 'Indianapolis', '#002C5F', '#A2AAAD'),
(@nfl_league_id, 'Jaguars', 'JAX', 'Jacksonville', '#101820', '#D7A22A'),
(@nfl_league_id, 'Titans', 'TEN', 'Tennessee', '#0C2340', '#4B92DB'),
(@nfl_league_id, 'Broncos', 'DEN', 'Denver', '#FB4F14', '#002244'),
(@nfl_league_id, 'Chiefs', 'KC', 'Kansas City', '#E31837', '#FFB81C'),
(@nfl_league_id, 'Raiders', 'LV', 'Las Vegas', '#000000', '#A5ACAF'),
(@nfl_league_id, 'Chargers', 'LAC', 'Los Angeles', '#0080C6', '#FFC20E'),
-- NFC Teams
(@nfl_league_id, 'Cowboys', 'DAL', 'Dallas', '#041E42', '#869397'),
(@nfl_league_id, 'Giants', 'NYG', 'New York', '#0B2265', '#A71930'),
(@nfl_league_id, 'Eagles', 'PHI', 'Philadelphia', '#004C54', '#A5ACAF'),
(@nfl_league_id, 'Commanders', 'WAS', 'Washington', '#5A1414', '#FFB612'),
(@nfl_league_id, 'Bears', 'CHI', 'Chicago', '#0B162A', '#C83803'),
(@nfl_league_id, 'Lions', 'DET', 'Detroit', '#0076B6', '#B0B7BC'),
(@nfl_league_id, 'Packers', 'GB', 'Green Bay', '#203731', '#FFB612'),
(@nfl_league_id, 'Vikings', 'MIN', 'Minnesota', '#4F2683', '#FFC62F'),
(@nfl_league_id, 'Falcons', 'ATL', 'Atlanta', '#A71930', '#000000'),
(@nfl_league_id, 'Panthers', 'CAR', 'Carolina', '#0085CA', '#101820'),
(@nfl_league_id, 'Saints', 'NO', 'New Orleans', '#101820', '#D3BC8D'),
(@nfl_league_id, 'Buccaneers', 'TB', 'Tampa Bay', '#D50A0A', '#FF7900'),
(@nfl_league_id, 'Cardinals', 'ARI', 'Arizona', '#97233F', '#000000'),
(@nfl_league_id, '49ers', 'SF', 'San Francisco', '#AA0000', '#B3995D'),
(@nfl_league_id, 'Seahawks', 'SEA', 'Seattle', '#002244', '#69BE28'),
(@nfl_league_id, 'Rams', 'LAR', 'Los Angeles', '#003594', '#FFA300');

-- Now insert NFL players with proper team relationships
-- Get team IDs for easier reference
SET @kc_id = (SELECT team_id FROM teams WHERE short_name = 'KC' AND league_id = @nfl_league_id LIMIT 1);
SET @buf_id = (SELECT team_id FROM teams WHERE short_name = 'BUF' AND league_id = @nfl_league_id LIMIT 1);
SET @sf_id = (SELECT team_id FROM teams WHERE short_name = 'SF' AND league_id = @nfl_league_id LIMIT 1);
SET @mia_id = (SELECT team_id FROM teams WHERE short_name = 'MIA' AND league_id = @nfl_league_id LIMIT 1);
SET @phi_id = (SELECT team_id FROM teams WHERE short_name = 'PHI' AND league_id = @nfl_league_id LIMIT 1);
SET @dal_id = (SELECT team_id FROM teams WHERE short_name = 'DAL' AND league_id = @nfl_league_id LIMIT 1);
SET @lar_id = (SELECT team_id FROM teams WHERE short_name = 'LAR' AND league_id = @nfl_league_id LIMIT 1);
SET @bal_id = (SELECT team_id FROM teams WHERE short_name = 'BAL' AND league_id = @nfl_league_id LIMIT 1);
SET @cin_id = (SELECT team_id FROM teams WHERE short_name = 'CIN' AND league_id = @nfl_league_id LIMIT 1);
SET @min_id = (SELECT team_id FROM teams WHERE short_name = 'MIN' AND league_id = @nfl_league_id LIMIT 1);

-- Insert NFL Top Players
INSERT IGNORE INTO players (team_id, first_name, last_name, position, jersey_number, photo_url, height_inches, weight_lbs) VALUES
-- Top 10 NFL Players
(@kc_id, 'Patrick', 'Mahomes', 'QB', '15', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3139477.png&w=350&h=254', 75, 225),
(@buf_id, 'Josh', 'Allen', 'QB', '17', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3918298.png&w=350&h=254', 77, 237),
(@sf_id, 'Christian', 'McCaffrey', 'RB', '23', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3116385.png&w=350&h=254', 71, 205),
(@mia_id, 'Tyreek', 'Hill', 'WR', '10', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2976499.png&w=350&h=254', 70, 185),
(@phi_id, 'A.J.', 'Brown', 'WR', '11', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4035687.png&w=350&h=254', 73, 226),
(@dal_id, 'Micah', 'Parsons', 'LB', '11', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426515.png&w=350&h=254', 75, 245),
(@lar_id, 'Cooper', 'Kupp', 'WR', '10', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3045138.png&w=350&h=254', 74, 208),
(@kc_id, 'Travis', 'Kelce', 'TE', '87', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/15847.png&w=350&h=254', 77, 250),
(@bal_id, 'Lamar', 'Jackson', 'QB', '8', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3916387.png&w=350&h=254', 74, 212),
(@cin_id, 'Joe', 'Burrow', 'QB', '9', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426002.png&w=350&h=254', 76, 221),

-- Additional Elite Players
(@cin_id, 'Ja\'Marr', 'Chase', 'WR', '1', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426384.png&w=350&h=254', 72, 201),
(@min_id, 'Justin', 'Jefferson', 'WR', '18', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426410.png&w=350&h=254', 73, 202);

-- Verify the data
SELECT 'NFL TEAMS VERIFICATION:' as info;
SELECT t.team_id, t.name, t.short_name, t.city, l.name as league_name, s.name as sport_name
FROM teams t 
JOIN leagues l ON t.league_id = l.league_id 
JOIN sports s ON l.sport_id = s.sport_id
WHERE s.short_name = 'NFL'
ORDER BY t.city, t.name;

SELECT 'NFL PLAYERS VERIFICATION:' as info;
SELECT p.player_id, CONCAT(p.first_name, ' ', p.last_name) as name, p.position, 
       t.short_name as team, l.name as league_name, s.name as sport_name
FROM players p
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id  
JOIN sports s ON l.sport_id = s.sport_id
WHERE s.short_name = 'NFL'
ORDER BY p.last_name
LIMIT 15;