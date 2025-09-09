-- NFL Top Players 2025 (Based on CBS Sports Rankings)
-- Adding top NFL players with enhanced data for fantasy sports app

-- First, ensure we have all NFL teams properly set up
INSERT IGNORE INTO teams (league_id, name, short_name, city, primary_color, secondary_color) VALUES
-- AFC East
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Bills', 'BUF', 'Buffalo', '#00338D', '#C60C30'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Dolphins', 'MIA', 'Miami', '#008E97', '#FC4C02'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Patriots', 'NE', 'New England', '#002244', '#C60C30'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Jets', 'NYJ', 'New York', '#125740', '#000000'),
-- AFC North
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Ravens', 'BAL', 'Baltimore', '#241773', '#000000'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Bengals', 'CIN', 'Cincinnati', '#FB4F14', '#000000'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Browns', 'CLE', 'Cleveland', '#311D00', '#FF3C00'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Steelers', 'PIT', 'Pittsburgh', '#FFB612', '#101820'),
-- AFC South
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Texans', 'HOU', 'Houston', '#03202F', '#A71930'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Colts', 'IND', 'Indianapolis', '#002C5F', '#A2AAAD'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Jaguars', 'JAX', 'Jacksonville', '#101820', '#D7A22A'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Titans', 'TEN', 'Tennessee', '#0C2340', '#4B92DB'),
-- AFC West
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Broncos', 'DEN', 'Denver', '#FB4F14', '#002244'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Chiefs', 'KC', 'Kansas City', '#E31837', '#FFB81C'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Raiders', 'LV', 'Las Vegas', '#000000', '#A5ACAF'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Chargers', 'LAC', 'Los Angeles', '#0080C6', '#FFC20E'),
-- NFC East
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Cowboys', 'DAL', 'Dallas', '#041E42', '#869397'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Giants', 'NYG', 'New York', '#0B2265', '#A71930'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Eagles', 'PHI', 'Philadelphia', '#004C54', '#A5ACAF'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Commanders', 'WAS', 'Washington', '#5A1414', '#FFB612'),
-- NFC North
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Bears', 'CHI', 'Chicago', '#0B162A', '#C83803'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Lions', 'DET', 'Detroit', '#0076B6', '#B0B7BC'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Packers', 'GB', 'Green Bay', '#203731', '#FFB612'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Vikings', 'MIN', 'Minnesota', '#4F2683', '#FFC62F'),
-- NFC South
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Falcons', 'ATL', 'Atlanta', '#A71930', '#000000'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Panthers', 'CAR', 'Carolina', '#0085CA', '#101820'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Saints', 'NO', 'New Orleans', '#101820', '#D3BC8D'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Buccaneers', 'TB', 'Tampa Bay', '#D50A0A', '#FF7900'),
-- NFC West
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Cardinals', 'ARI', 'Arizona', '#97233F', '#000000'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), '49ers', 'SF', 'San Francisco', '#AA0000', '#B3995D'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Seahawks', 'SEA', 'Seattle', '#002244', '#69BE28'),
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Rams', 'LAR', 'Los Angeles', '#003594', '#FFA300');

-- Insert NFL Top Players 2025
INSERT INTO players (team_id, first_name, last_name, position, jersey_number, photo_url, height_inches, weight_lbs) VALUES
-- Top 10 NFL Players
((SELECT team_id FROM teams WHERE short_name = 'KC' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Patrick', 'Mahomes', 'QB', '15', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3139477.png&w=350&h=254', 75, 225),
((SELECT team_id FROM teams WHERE short_name = 'BUF' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Josh', 'Allen', 'QB', '17', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3918298.png&w=350&h=254', 77, 237),
((SELECT team_id FROM teams WHERE short_name = 'SF' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Christian', 'McCaffrey', 'RB', '23', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3116385.png&w=350&h=254', 71, 205),
((SELECT team_id FROM teams WHERE short_name = 'MIA' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Tyreek', 'Hill', 'WR', '10', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2976499.png&w=350&h=254', 70, 185),
((SELECT team_id FROM teams WHERE short_name = 'PHI' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'A.J.', 'Brown', 'WR', '11', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4035687.png&w=350&h=254', 73, 226),
((SELECT team_id FROM teams WHERE short_name = 'DAL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Micah', 'Parsons', 'LB', '11', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426515.png&w=350&h=254', 75, 245),
((SELECT team_id FROM teams WHERE short_name = 'LAR' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Cooper', 'Kupp', 'WR', '10', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3045138.png&w=350&h=254', 74, 208),
((SELECT team_id FROM teams WHERE short_name = 'KC' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Travis', 'Kelce', 'TE', '87', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/15847.png&w=350&h=254', 77, 250),
((SELECT team_id FROM teams WHERE short_name = 'BAL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Lamar', 'Jackson', 'QB', '8', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3916387.png&w=350&h=254', 74, 212),
((SELECT team_id FROM teams WHERE short_name = 'CIN' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Joe', 'Burrow', 'QB', '9', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426002.png&w=350&h=254', 76, 221),

-- Top Wide Receivers (11-20)
((SELECT team_id FROM teams WHERE short_name = 'CIN' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Ja\'Marr', 'Chase', 'WR', '1', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426384.png&w=350&h=254', 72, 201),
((SELECT team_id FROM teams WHERE short_name = 'MIN' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Justin', 'Jefferson', 'WR', '18', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426410.png&w=350&h=254', 73, 202),
((SELECT team_id FROM teams WHERE short_name = 'BUF' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Stefon', 'Diggs', 'WR', '14', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2976212.png&w=350&h=254', 72, 191),
((SELECT team_id FROM teams WHERE short_name = 'LV' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Davante', 'Adams', 'WR', '17', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2574511.png&w=350&h=254', 73, 215),
((SELECT team_id FROM teams WHERE short_name = 'TB' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Mike', 'Evans', 'WR', '13', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/16737.png&w=350&h=254', 77, 231),

-- Top Running Backs (21-25)
((SELECT team_id FROM teams WHERE short_name = 'DAL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Ezekiel', 'Elliott', 'RB', '21', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3051392.png&w=350&h=254', 72, 228),
((SELECT team_id FROM teams WHERE short_name = 'TEN' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Derrick', 'Henry', 'RB', '22', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3043078.png&w=350&h=254', 75, 247),
((SELECT team_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 'Alvin', 'Kamara', 'RB', '41', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3116365.png&w=350&h=254', 70, 215),
((SELECT team_id FROM teams WHERE short_name = 'CHI' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'D\'Andre', 'Swift', 'RB', '32', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426445.png&w=350&h=254', 68, 212),
((SELECT team_id FROM teams WHERE short_name = 'CLE' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Nick', 'Chubb', 'RB', '24', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3929939.png&w=350&h=254', 71, 227),

-- Top Tight Ends (26-28)
((SELECT team_id FROM teams WHERE short_name = 'SF' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'George', 'Kittle', 'TE', '85', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3116406.png&w=350&h=254', 76, 250),
((SELECT team_id FROM teams WHERE short_name = 'LV' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Darren', 'Waller', 'TE', '83', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/2977644.png&w=350&h=254', 78, 255),
((SELECT team_id FROM teams WHERE short_name = 'PHI' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Dallas', 'Goedert', 'TE', '88', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3929949.png&w=350&h=254', 76, 256),

-- Rising Stars and Additional QBs (29-35)
((SELECT team_id FROM teams WHERE short_name = 'LAC' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Justin', 'Herbert', 'QB', '10', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/4426353.png&w=350&h=254', 78, 236),
((SELECT team_id FROM teams WHERE short_name = 'GB' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Aaron', 'Rodgers', 'QB', '12', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/8439.png&w=350&h=254', 74, 225),
((SELECT team_id FROM teams WHERE short_name = 'SEA' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Russell', 'Wilson', 'QB', '3', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/14881.png&w=350&h=254', 71, 215),
((SELECT team_id FROM teams WHERE short_name = 'NYJ' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Aaron', 'Rodgers', 'QB', '8', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/8439.png&w=350&h=254', 74, 225),
((SELECT team_id FROM teams WHERE short_name = 'DEN' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Russell', 'Wilson', 'QB', '3', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/14881.png&w=350&h=254', 71, 215),

-- Defensive Stars
((SELECT team_id FROM teams WHERE short_name = 'PIT' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'T.J.', 'Watt', 'LB', '90', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3116365.png&w=350&h=254', 77, 252),
((SELECT team_id FROM teams WHERE short_name = 'LAR' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Aaron', 'Donald', 'DT', '99', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/16726.png&w=350&h=254', 73, 284),
((SELECT team_id FROM teams WHERE short_name = 'CLE' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1) LIMIT 1), 'Myles', 'Garrett', 'DE', '95', 'https://a.espncdn.com/combiner/i?img=/i/headshots/nfl/players/full/3116407.png&w=350&h=254', 76, 272);

-- Add some enhanced NFL props for the top players
INSERT INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds) 
SELECT 
    g.game_id,
    p.player_id,
    pt.prop_type_id,
    CASE 
        WHEN pt.name = 'Passing Yards' AND p.position = 'QB' THEN 
            CASE 
                WHEN p.last_name IN ('Mahomes', 'Allen', 'Burrow') THEN 285.5
                WHEN p.last_name IN ('Jackson', 'Herbert') THEN 275.5
                ELSE 250.5
            END
        WHEN pt.name = 'Passing TDs' AND p.position = 'QB' THEN 2.5
        WHEN pt.name = 'Rushing Yards' AND p.position = 'RB' THEN 
            CASE 
                WHEN p.last_name IN ('McCaffrey', 'Henry') THEN 95.5
                WHEN p.last_name IN ('Chubb', 'Elliott') THEN 85.5
                ELSE 75.5
            END
        WHEN pt.name = 'Receiving Yards' AND p.position IN ('WR', 'TE') THEN 
            CASE 
                WHEN p.last_name IN ('Hill', 'Jefferson', 'Chase') THEN 85.5
                WHEN p.last_name IN ('Kelce', 'Kittle') THEN 75.5
                ELSE 65.5
            END
        WHEN pt.name = 'Receptions' AND p.position IN ('WR', 'TE', 'RB') THEN 
            CASE 
                WHEN p.last_name IN ('Kelce', 'Kupp', 'Adams') THEN 6.5
                WHEN p.last_name IN ('Jefferson', 'Chase', 'Hill') THEN 5.5
                ELSE 4.5
            END
        WHEN pt.name = 'Fantasy Points' THEN 
            CASE 
                WHEN p.position = 'QB' AND p.last_name IN ('Mahomes', 'Allen') THEN 25.5
                WHEN p.position = 'RB' AND p.last_name IN ('McCaffrey', 'Henry') THEN 18.5
                WHEN p.position IN ('WR', 'TE') AND p.last_name IN ('Hill', 'Jefferson', 'Kelce') THEN 16.5
                ELSE 12.5
            END
        ELSE 15.5
    END as line_value,
    -110.00 as over_odds,
    -110.00 as under_odds
FROM games g
JOIN teams ht ON g.home_team_id = ht.team_id
JOIN teams at ON g.away_team_id = at.team_id
JOIN players p ON (p.team_id = ht.team_id OR p.team_id = at.team_id)
JOIN prop_types pt ON pt.sport_id = (SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1)
JOIN leagues l ON ht.league_id = l.league_id
WHERE g.game_date > NOW() 
AND l.short_name = 'NFL'
AND p.last_name IN ('Mahomes', 'Allen', 'McCaffrey', 'Hill', 'Brown', 'Parsons', 'Kupp', 'Kelce', 'Jackson', 'Burrow', 'Chase', 'Jefferson', 'Diggs', 'Adams', 'Evans')
AND pt.name IN ('Passing Yards', 'Passing TDs', 'Rushing Yards', 'Receiving Yards', 'Receptions', 'Fantasy Points')
LIMIT 75;