-- MLB Top 100 Players for 2025
-- Adding the top MLB players with enhanced data for fantasy sports app

-- First, let's make sure we have the MLB teams properly set up
INSERT IGNORE INTO teams (league_id, name, short_name, city, primary_color, secondary_color) VALUES
-- AL East
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Yankees', 'NYY', 'New York', '#132448', '#C4CED4'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Red Sox', 'BOS', 'Boston', '#BD3039', '#0C2340'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Blue Jays', 'TOR', 'Toronto', '#134A8E', '#1D2D5C'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Rays', 'TB', 'Tampa Bay', '#092C5C', '#8FBCE6'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Orioles', 'BAL', 'Baltimore', '#DF4601', '#000000'),
-- AL Central
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Guardians', 'CLE', 'Cleveland', '#E31937', '#0C2340'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'White Sox', 'CWS', 'Chicago', '#27251F', '#C4CED4'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Tigers', 'DET', 'Detroit', '#0C2340', '#FA4616'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Royals', 'KC', 'Kansas City', '#004687', '#BD9B60'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Twins', 'MIN', 'Minnesota', '#002B5C', '#D31145'),
-- AL West
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Astros', 'HOU', 'Houston', '#002D62', '#EB6E1F'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Angels', 'LAA', 'Los Angeles', '#BA0021', '#003263'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Athletics', 'OAK', 'Oakland', '#003831', '#EFB21E'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Mariners', 'SEA', 'Seattle', '#0C2C56', '#005C5C'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Rangers', 'TEX', 'Texas', '#003278', '#C0111F'),
-- NL East
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Braves', 'ATL', 'Atlanta', '#CE1141', '#13274F'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Marlins', 'MIA', 'Miami', '#00A3E0', '#EF3340'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Mets', 'NYM', 'New York', '#002D72', '#FF5910'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Phillies', 'PHI', 'Philadelphia', '#E81828', '#002D72'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Nationals', 'WSH', 'Washington', '#AB0003', '#14225A'),
-- NL Central
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Cubs', 'CHC', 'Chicago', '#0E3386', '#CC3433'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Reds', 'CIN', 'Cincinnati', '#C6011F', '#000000'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Brewers', 'MIL', 'Milwaukee', '#0A2351', '#B5985A'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Pirates', 'PIT', 'Pittsburgh', '#FDB827', '#27251F'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Cardinals', 'STL', 'St. Louis', '#C41E3A', '#0C2340'),
-- NL West
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Diamondbacks', 'ARI', 'Arizona', '#A71930', '#E3D4A2'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Rockies', 'COL', 'Colorado', '#33006F', '#C4CED4'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Dodgers', 'LAD', 'Los Angeles', '#005A9C', '#EF3E42'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Padres', 'SD', 'San Diego', '#2F241D', '#A2AAAD'),
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1), 'Giants', 'SF', 'San Francisco', '#FD5A1E', '#27251F');

-- Now insert the top MLB players for 2025
INSERT INTO players (team_id, first_name, last_name, position, jersey_number, photo_url) VALUES
-- Top 10 Players
((SELECT team_id FROM teams WHERE short_name = 'LAD' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Shohei', 'Ohtani', 'DH/P', '17', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/660271/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'NYY' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Aaron', 'Judge', 'RF', '99', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/592450/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'KC' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Bobby', 'Witt Jr.', 'SS', '7', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/677951/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'NYM' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Juan', 'Soto', 'RF', '22', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/665742/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'LAD' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Mookie', 'Betts', 'SS/RF', '50', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/605141/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'NYM' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Francisco', 'Lindor', 'SS', '12', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/596019/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'HOU' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Yordan', 'Alvarez', 'LF/DH', '44', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/670541/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'LAD' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Freddie', 'Freeman', '1B', '5', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/518692/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'CLE' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'José', 'Ramírez', '3B', '11', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/608070/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'BAL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Gunnar', 'Henderson', '3B/SS', '2', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/683002/headshot/67/current'),

-- Additional Top Players (11-25)
((SELECT team_id FROM teams WHERE short_name = 'HOU' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Kyle', 'Tucker', 'RF', '30', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/663656/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'ATL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Ronald', 'Acuna Jr.', 'CF', '13', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/660670/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'SD' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Fernando', 'Tatis Jr.', 'RF/SS', '23', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/665487/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'TOR' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Vladimir', 'Guerrero Jr.', '1B', '27', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/665489/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'PHI' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Bryce', 'Harper', '1B/RF', '3', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/547180/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'LAA' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Mike', 'Trout', 'CF', '27', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/545361/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'ATL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Matt', 'Olson', '1B', '28', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/621566/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'SEA' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Julio', 'Rodríguez', 'CF', '44', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/677594/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'PHI' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Trea', 'Turner', 'SS', '7', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/607208/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'TEX' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Corey', 'Seager', 'SS', '5', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/608369/headshot/67/current'),

-- Pitchers
((SELECT team_id FROM teams WHERE short_name = 'PHI' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Zack', 'Wheeler', 'P', '45', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/554430/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'NYY' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Gerrit', 'Cole', 'P', '45', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/543037/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'ATL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Spencer', 'Strider', 'P', '99', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/675911/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'HOU' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Framber', 'Valdez', 'P', '59', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/664285/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'SD' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Dylan', 'Cease', 'P', '84', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/656302/headshot/67/current'),

-- Rising Stars and Additional Players
((SELECT team_id FROM teams WHERE short_name = 'CWS' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Luis', 'Robert Jr.', 'CF', '88', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/673357/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'MIL' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Christian', 'Yelich', 'LF', '22', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/592885/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'BOS' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Rafael', 'Devers', '3B', '11', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/646240/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'TB' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'Wander', 'Franco', 'SS', '5', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/677551/headshot/67/current'),
((SELECT team_id FROM teams WHERE short_name = 'WSH' AND league_id = (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1) LIMIT 1), 'CJ', 'Abrams', 'SS', '5', 'https://img.mlbstatic.com/mlb-photos/image/upload/d_people:generic:headshot:67:current.png/w_213,q_auto:best/v1/people/682928/headshot/67/current');

-- Add some enhanced player props for the new MLB stars
INSERT INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds) 
SELECT 
    g.game_id,
    p.player_id,
    pt.prop_type_id,
    CASE 
        WHEN pt.name = 'Hits' THEN 1.5
        WHEN pt.name = 'RBIs' THEN 1.5
        WHEN pt.name = 'Home Runs' THEN 0.5
        WHEN pt.name = 'Strikeouts' AND p.position = 'P' THEN 6.5
        ELSE 2.5
    END as line_value,
    -110.00 as over_odds,
    -110.00 as under_odds
FROM games g
JOIN teams ht ON g.home_team_id = ht.team_id
JOIN teams at ON g.away_team_id = at.team_id
JOIN players p ON (p.team_id = ht.team_id OR p.team_id = at.team_id)
JOIN prop_types pt ON pt.sport_id = (SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1)
WHERE g.game_date > NOW() 
AND p.last_name IN ('Ohtani', 'Judge', 'Witt Jr.', 'Soto', 'Betts', 'Lindor', 'Alvarez', 'Freeman', 'Ramírez', 'Henderson')
AND pt.name IN ('Hits', 'RBIs', 'Home Runs', 'Strikeouts')
LIMIT 50;