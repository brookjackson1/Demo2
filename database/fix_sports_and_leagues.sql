-- Fix Sports and Leagues Data
-- Ensure proper sports and leagues exist with correct short names

-- First, let's make sure we have the correct sports with the right short names
INSERT IGNORE INTO sports (name, short_name) VALUES
('Football', 'NFL'),
('Baseball', 'MLB'), 
('Basketball', 'BBL'),
('Soccer', 'SOC');

-- Update existing sports to ensure correct short names
UPDATE sports SET short_name = 'NFL' WHERE name = 'Football';
UPDATE sports SET short_name = 'MLB' WHERE name = 'Baseball';
UPDATE sports SET short_name = 'BBL' WHERE name = 'Basketball';  
UPDATE sports SET short_name = 'SOC' WHERE name = 'Soccer';

-- Now insert/update leagues with proper relationships
INSERT IGNORE INTO leagues (sport_id, name, short_name, league_type, season_start_month, season_end_month) VALUES
-- Football leagues
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'National Football League', 'NFL', 'professional', 9, 2),
((SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1), 'NCAA Football', 'NCAAF', 'college', 8, 1),
-- Baseball leagues  
((SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1), 'Major League Baseball', 'MLB', 'professional', 4, 10),
((SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1), 'NCAA Baseball', 'NCAAB', 'college', 2, 6),
-- Basketball leagues
((SELECT sport_id FROM sports WHERE short_name = 'BBL' LIMIT 1), 'National Basketball Association', 'NBA', 'professional', 10, 4),
((SELECT sport_id FROM sports WHERE short_name = 'BBL' LIMIT 1), 'NCAA Basketball', 'NCAABB', 'college', 11, 4),
-- Soccer leagues
((SELECT sport_id FROM sports WHERE short_name = 'SOC' LIMIT 1), 'Major League Soccer', 'MLS', 'professional', 2, 11),
((SELECT sport_id FROM sports WHERE short_name = 'SOC' LIMIT 1), 'NCAA Soccer', 'NCAAS', 'college', 8, 12);

-- Update existing leagues to ensure they're linked to the right sports
UPDATE leagues SET sport_id = (SELECT sport_id FROM sports WHERE short_name = 'NFL' LIMIT 1) 
WHERE short_name IN ('NFL', 'NCAAF');

UPDATE leagues SET sport_id = (SELECT sport_id FROM sports WHERE short_name = 'MLB' LIMIT 1) 
WHERE short_name IN ('MLB', 'NCAAB');

UPDATE leagues SET sport_id = (SELECT sport_id FROM sports WHERE short_name = 'BBL' LIMIT 1) 
WHERE short_name IN ('NBA', 'NCAABB');

UPDATE leagues SET sport_id = (SELECT sport_id FROM sports WHERE short_name = 'SOC' LIMIT 1) 
WHERE short_name IN ('MLS', 'NCAAS');

-- Show current sports and leagues for verification
SELECT 'SPORTS DATA:' as info;
SELECT sport_id, name, short_name, active FROM sports ORDER BY sport_id;

SELECT 'LEAGUES DATA:' as info;
SELECT l.league_id, l.name, l.short_name, l.league_type, s.name as sport_name, s.short_name as sport_short
FROM leagues l 
JOIN sports s ON l.sport_id = s.sport_id 
ORDER BY s.sport_id, l.league_type, l.name;