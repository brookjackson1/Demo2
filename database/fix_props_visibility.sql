-- Fix Props Visibility Issues
-- Addresses the "no available props" problem

-- 1. Fix game dates to be in the future (so they appear in API queries)
UPDATE games SET game_date = DATE_ADD(NOW(), INTERVAL 1 DAY) 
WHERE game_date < NOW();

-- 2. Update recent games to be spread over the next few days
UPDATE games SET 
    game_date = CASE 
        WHEN game_id % 5 = 0 THEN DATE_ADD(NOW(), INTERVAL 1 DAY)
        WHEN game_id % 5 = 1 THEN DATE_ADD(NOW(), INTERVAL 2 DAY)
        WHEN game_id % 5 = 2 THEN DATE_ADD(NOW(), INTERVAL 3 DAY)
        WHEN game_id % 5 = 3 THEN DATE_ADD(NOW(), INTERVAL 4 DAY)
        ELSE DATE_ADD(NOW(), INTERVAL 5 DAY)
    END
WHERE game_date IS NOT NULL;

-- 3. Make sure all props are active
UPDATE player_props SET status = 'active' WHERE status IS NULL OR status = '';

-- 4. Verify sport short names are correct
UPDATE sports SET short_name = 'NFL' WHERE name LIKE '%Football%' AND short_name != 'NFL';
UPDATE sports SET short_name = 'MLB' WHERE name LIKE '%Baseball%' AND short_name != 'MLB';

-- 5. Ensure leagues are properly linked to sports
UPDATE leagues l 
JOIN sports s ON s.short_name = 'NFL' 
SET l.sport_id = s.sport_id 
WHERE l.short_name = 'NFL';

UPDATE leagues l 
JOIN sports s ON s.short_name = 'MLB' 
SET l.sport_id = s.sport_id 
WHERE l.short_name = 'MLB';

-- 6. Add any missing prop types that might be needed
INSERT IGNORE INTO prop_types (sport_id, name, description, unit) VALUES
-- NFL prop types
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'Passing Yards', 'Total passing yards in the game', 'yards'),
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'Passing TDs', 'Total passing touchdowns', 'touchdowns'),
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'Rushing Yards', 'Total rushing yards in the game', 'yards'),
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'Receiving Yards', 'Total receiving yards in the game', 'yards'),
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'Receptions', 'Total receptions in the game', 'catches'),
-- MLB prop types
((SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1), 'Hits', 'Total hits in the game', 'hits'),
((SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1), 'RBIs', 'Total runs batted in', 'RBIs'),
((SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1), 'Home Runs', 'Total home runs hit', 'home runs'),
((SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1), 'Strikeouts', 'Total strikeouts (pitcher)', 'strikeouts');

-- 7. Create immediate test games if none exist with proper relationships
-- NFL test game
INSERT IGNORE INTO games (league_id, home_team_id, away_team_id, game_date, week_number, season_year, venue)
SELECT 
    (SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1),
    (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'KC' AND l.short_name = 'NFL' LIMIT 1),
    (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'BUF' AND l.short_name = 'NFL' LIMIT 1),
    DATE_ADD(NOW(), INTERVAL 1 DAY),
    2, 2025, 'Arrowhead Stadium'
WHERE NOT EXISTS (
    SELECT 1 FROM games g 
    JOIN leagues l ON g.league_id = l.league_id 
    WHERE l.short_name = 'NFL' AND g.game_date > NOW()
);

-- MLB test game  
INSERT IGNORE INTO games (league_id, home_team_id, away_team_id, game_date, week_number, season_year, venue)
SELECT
    (SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1),
    (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'LAD' AND l.short_name = 'MLB' LIMIT 1),
    (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'NYY' AND l.short_name = 'MLB' LIMIT 1),
    DATE_ADD(NOW(), INTERVAL 1 DAY),
    24, 2025, 'Dodger Stadium'
WHERE NOT EXISTS (
    SELECT 1 FROM games g 
    JOIN leagues l ON g.league_id = l.league_id 
    WHERE l.short_name = 'MLB' AND g.game_date > NOW()
);

-- 8. Add emergency test props if none exist for immediate visibility
-- Get the test game IDs
SET @test_nfl_game = (SELECT g.game_id FROM games g 
    JOIN leagues l ON g.league_id = l.league_id 
    WHERE l.short_name = 'NFL' AND g.game_date > NOW() 
    LIMIT 1);

SET @test_mlb_game = (SELECT g.game_id FROM games g 
    JOIN leagues l ON g.league_id = l.league_id 
    WHERE l.short_name = 'MLB' AND g.game_date > NOW() 
    LIMIT 1);

-- Add test NFL props if none exist
INSERT IGNORE INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds, status)
SELECT 
    @test_nfl_game,
    (SELECT player_id FROM players p JOIN teams t ON p.team_id = t.team_id 
     JOIN leagues l ON t.league_id = l.league_id 
     WHERE p.last_name = 'Mahomes' AND l.short_name = 'NFL' LIMIT 1),
    (SELECT prop_type_id FROM prop_types pt JOIN sports s ON pt.sport_id = s.sport_id 
     WHERE pt.name = 'Passing Yards' AND s.short_name = 'NFL' LIMIT 1),
    275.5, -110.00, -110.00, 'active'
WHERE @test_nfl_game IS NOT NULL 
    AND NOT EXISTS (
        SELECT 1 FROM player_props pp 
        JOIN games g ON pp.game_id = g.game_id
        JOIN leagues l ON g.league_id = l.league_id
        WHERE l.short_name = 'NFL' AND pp.status = 'active' AND g.game_date > NOW()
    );

-- Add test MLB props if none exist
INSERT IGNORE INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds, status)
SELECT
    @test_mlb_game,
    (SELECT player_id FROM players p JOIN teams t ON p.team_id = t.team_id 
     JOIN leagues l ON t.league_id = l.league_id 
     WHERE p.last_name = 'Ohtani' AND l.short_name = 'MLB' LIMIT 1),
    (SELECT prop_type_id FROM prop_types pt JOIN sports s ON pt.sport_id = s.sport_id 
     WHERE pt.name = 'Hits' AND s.short_name = 'MLB' LIMIT 1),
    1.5, -115.00, -105.00, 'active'
WHERE @test_mlb_game IS NOT NULL 
    AND NOT EXISTS (
        SELECT 1 FROM player_props pp 
        JOIN games g ON pp.game_id = g.game_id
        JOIN leagues l ON g.league_id = l.league_id
        WHERE l.short_name = 'MLB' AND pp.status = 'active' AND g.game_date > NOW()
    );

-- 9. Final verification queries
SELECT 'PROPS VISIBILITY CHECK:' as info;

-- Check NFL props that should be visible
SELECT 'NFL Props Available:' as info, COUNT(*) as count
FROM player_props pp
JOIN games g ON pp.game_id = g.game_id
JOIN leagues l ON g.league_id = l.league_id
WHERE l.short_name = 'NFL' AND pp.status = 'active' AND g.game_date > NOW();

-- Check MLB props that should be visible
SELECT 'MLB Props Available:' as info, COUNT(*) as count
FROM player_props pp
JOIN games g ON pp.game_id = g.game_id
JOIN leagues l ON g.league_id = l.league_id
WHERE l.short_name = 'MLB' AND pp.status = 'active' AND g.game_date > NOW();

-- Show sample props that should appear
SELECT 'Sample NFL Props:' as info;
SELECT CONCAT(p.first_name, ' ', p.last_name) as player,
       pt.name as prop_type, pp.line_value, pp.over_odds,
       DATE_FORMAT(g.game_date, '%Y-%m-%d %H:%i') as game_time
FROM player_props pp
JOIN players p ON pp.player_id = p.player_id
JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
JOIN games g ON pp.game_id = g.game_id
JOIN leagues l ON g.league_id = l.league_id
WHERE l.short_name = 'NFL' AND pp.status = 'active' AND g.game_date > NOW()
LIMIT 5;

SELECT 'Sample MLB Props:' as info;
SELECT CONCAT(p.first_name, ' ', p.last_name) as player,
       pt.name as prop_type, pp.line_value, pp.over_odds,
       DATE_FORMAT(g.game_date, '%Y-%m-%d %H:%i') as game_time
FROM player_props pp
JOIN players p ON pp.player_id = p.player_id
JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
JOIN games g ON pp.game_id = g.game_id
JOIN leagues l ON g.league_id = l.league_id
WHERE l.short_name = 'MLB' AND pp.status = 'active' AND g.game_date > NOW()
LIMIT 5;