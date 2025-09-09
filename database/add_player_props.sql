-- Add Player Props for NFL and MLB Top Players
-- Creates realistic props for the current week's games

-- First, let's add some sample games for the current week
-- NFL Games for Week 2
INSERT IGNORE INTO games (league_id, home_team_id, away_team_id, game_date, week_number, season_year, venue) VALUES
-- Get league IDs dynamically
((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1), 
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'KC' AND l.short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'BUF' AND l.short_name = 'NFL' LIMIT 1),
 '2025-09-14 16:25:00', 2, 2025, 'Arrowhead Stadium'),

((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'SF' AND l.short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'LAR' AND l.short_name = 'NFL' LIMIT 1),
 '2025-09-14 13:00:00', 2, 2025, 'Levi\'s Stadium'),

((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'PHI' AND l.short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'DAL' AND l.short_name = 'NFL' LIMIT 1),
 '2025-09-14 20:20:00', 2, 2025, 'Lincoln Financial Field'),

((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'BAL' AND l.short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'CIN' AND l.short_name = 'NFL' LIMIT 1),
 '2025-09-15 13:00:00', 2, 2025, 'M&T Bank Stadium'),

((SELECT league_id FROM leagues WHERE short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'MIA' AND l.short_name = 'NFL' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'MIN' AND l.short_name = 'NFL' LIMIT 1),
 '2025-09-15 16:05:00', 2, 2025, 'Hard Rock Stadium');

-- MLB Games for current series  
INSERT IGNORE INTO games (league_id, home_team_id, away_team_id, game_date, week_number, season_year, venue) VALUES
((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'LAD' AND l.short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'NYY' AND l.short_name = 'MLB' LIMIT 1),
 '2025-09-10 19:10:00', 24, 2025, 'Dodger Stadium'),

((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'NYM' AND l.short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'ATL' AND l.short_name = 'MLB' LIMIT 1),
 '2025-09-10 19:10:00', 24, 2025, 'Citi Field'),

((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'HOU' AND l.short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'KC' AND l.short_name = 'MLB' LIMIT 1),
 '2025-09-10 20:10:00', 24, 2025, 'Minute Maid Park'),

((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'SD' AND l.short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'CLE' AND l.short_name = 'MLB' LIMIT 1),
 '2025-09-10 22:10:00', 24, 2025, 'Petco Park'),

((SELECT league_id FROM leagues WHERE short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'BAL' AND l.short_name = 'MLB' LIMIT 1),
 (SELECT team_id FROM teams t JOIN leagues l ON t.league_id = l.league_id WHERE t.short_name = 'LAD' AND l.short_name = 'MLB' LIMIT 1),
 '2025-09-11 19:05:00', 24, 2025, 'Oriole Park at Camden Yards');

-- Now add player props for NFL stars
-- Get game and prop type IDs for easier reference
SET @kc_buf_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'KC' AND at.short_name = 'BUF');

SET @sf_lar_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'SF' AND at.short_name = 'LAR');

SET @phi_dal_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'PHI' AND at.short_name = 'DAL');

SET @bal_cin_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'BAL' AND at.short_name = 'CIN');

SET @mia_min_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'MIA' AND at.short_name = 'MIN');

-- Get prop type IDs
SET @passing_yards_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Passing Yards' LIMIT 1);
SET @passing_tds_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Passing TDs' LIMIT 1);  
SET @rushing_yards_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Rushing Yards' LIMIT 1);
SET @receiving_yards_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Receiving Yards' LIMIT 1);
SET @receptions_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Receptions' LIMIT 1);

-- Get NFL player IDs
SET @mahomes_id = (SELECT player_id FROM players WHERE first_name = 'Patrick' AND last_name = 'Mahomes' LIMIT 1);
SET @allen_id = (SELECT player_id FROM players WHERE first_name = 'Josh' AND last_name = 'Allen' LIMIT 1);
SET @mccaffrey_id = (SELECT player_id FROM players WHERE first_name = 'Christian' AND last_name = 'McCaffrey' LIMIT 1);
SET @hill_id = (SELECT player_id FROM players WHERE first_name = 'Tyreek' AND last_name = 'Hill' LIMIT 1);
SET @kelce_id = (SELECT player_id FROM players WHERE first_name = 'Travis' AND last_name = 'Kelce' LIMIT 1);
SET @kupp_id = (SELECT player_id FROM players WHERE first_name = 'Cooper' AND last_name = 'Kupp' LIMIT 1);
SET @brown_id = (SELECT player_id FROM players WHERE first_name = 'A.J.' AND last_name = 'Brown' LIMIT 1);
SET @parsons_id = (SELECT player_id FROM players WHERE first_name = 'Micah' AND last_name = 'Parsons' LIMIT 1);
SET @jackson_id = (SELECT player_id FROM players WHERE first_name = 'Lamar' AND last_name = 'Jackson' LIMIT 1);
SET @burrow_id = (SELECT player_id FROM players WHERE first_name = 'Joe' AND last_name = 'Burrow' LIMIT 1);
SET @chase_id = (SELECT player_id FROM players WHERE first_name = 'Ja\'Marr' AND last_name = 'Chase' LIMIT 1);
SET @jefferson_id = (SELECT player_id FROM players WHERE first_name = 'Justin' AND last_name = 'Jefferson' LIMIT 1);

-- NFL Player Props
INSERT IGNORE INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds, status) VALUES
-- Patrick Mahomes (KC vs BUF)
(@kc_buf_game, @mahomes_id, @passing_yards_id, 285.5, -110.00, -110.00, 'active'),
(@kc_buf_game, @mahomes_id, @passing_tds_id, 2.5, -115.00, -105.00, 'active'),

-- Josh Allen (BUF @ KC) 
(@kc_buf_game, @allen_id, @passing_yards_id, 265.5, -110.00, -110.00, 'active'),
(@kc_buf_game, @allen_id, @passing_tds_id, 2.5, -105.00, -115.00, 'active'),
(@kc_buf_game, @allen_id, @rushing_yards_id, 45.5, -110.00, -110.00, 'active'),

-- Travis Kelce (KC vs BUF)
(@kc_buf_game, @kelce_id, @receiving_yards_id, 75.5, -110.00, -110.00, 'active'),
(@kc_buf_game, @kelce_id, @receptions_id, 5.5, -120.00, +100.00, 'active'),

-- Christian McCaffrey (SF vs LAR)
(@sf_lar_game, @mccaffrey_id, @rushing_yards_id, 95.5, -110.00, -110.00, 'active'),
(@sf_lar_game, @mccaffrey_id, @receiving_yards_id, 35.5, -110.00, -110.00, 'active'),
(@sf_lar_game, @mccaffrey_id, @receptions_id, 3.5, -115.00, -105.00, 'active'),

-- Cooper Kupp (LAR @ SF)
(@sf_lar_game, @kupp_id, @receiving_yards_id, 85.5, -110.00, -110.00, 'active'),
(@sf_lar_game, @kupp_id, @receptions_id, 6.5, -110.00, -110.00, 'active'),

-- A.J. Brown (PHI vs DAL)
(@phi_dal_game, @brown_id, @receiving_yards_id, 80.5, -110.00, -110.00, 'active'),
(@phi_dal_game, @brown_id, @receptions_id, 5.5, -115.00, -105.00, 'active'),

-- Lamar Jackson (BAL vs CIN)
(@bal_cin_game, @jackson_id, @passing_yards_id, 245.5, -110.00, -110.00, 'active'),
(@bal_cin_game, @jackson_id, @passing_tds_id, 1.5, -110.00, -110.00, 'active'),
(@bal_cin_game, @jackson_id, @rushing_yards_id, 65.5, -110.00, -110.00, 'active'),

-- Joe Burrow (CIN @ BAL)
(@bal_cin_game, @burrow_id, @passing_yards_id, 275.5, -110.00, -110.00, 'active'),
(@bal_cin_game, @burrow_id, @passing_tds_id, 2.5, -105.00, -115.00, 'active'),

-- Ja'Marr Chase (CIN @ BAL)
(@bal_cin_game, @chase_id, @receiving_yards_id, 85.5, -110.00, -110.00, 'active'),
(@bal_cin_game, @chase_id, @receptions_id, 6.5, -110.00, -110.00, 'active'),

-- Tyreek Hill (MIA vs MIN)
(@mia_min_game, @hill_id, @receiving_yards_id, 95.5, -110.00, -110.00, 'active'),
(@mia_min_game, @hill_id, @receptions_id, 6.5, -115.00, -105.00, 'active'),

-- Justin Jefferson (MIN @ MIA)
(@mia_min_game, @jefferson_id, @receiving_yards_id, 90.5, -110.00, -110.00, 'active'),
(@mia_min_game, @jefferson_id, @receptions_id, 6.5, -110.00, -110.00, 'active');

-- Now add MLB player props
-- Get MLB game IDs
SET @lad_nyy_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'LAD' AND at.short_name = 'NYY');

SET @nym_atl_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'NYM' AND at.short_name = 'ATL');

SET @hou_kc_mlb_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'HOU' AND at.short_name = 'KC');

SET @sd_cle_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'SD' AND at.short_name = 'CLE');

SET @bal_mlb_lad_game = (SELECT MAX(g.game_id) FROM games g 
    JOIN teams ht ON g.home_team_id = ht.team_id 
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE ht.short_name = 'BAL' AND at.short_name = 'LAD');

-- Get MLB prop type IDs
SET @hits_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Hits' LIMIT 1);
SET @rbis_id = (SELECT prop_type_id FROM prop_types WHERE name = 'RBIs' LIMIT 1);
SET @home_runs_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Home Runs' LIMIT 1);
SET @strikeouts_id = (SELECT prop_type_id FROM prop_types WHERE name = 'Strikeouts' LIMIT 1);

-- Get MLB player IDs
SET @ohtani_id = (SELECT player_id FROM players WHERE first_name = 'Shohei' AND last_name = 'Ohtani' LIMIT 1);
SET @judge_id = (SELECT player_id FROM players WHERE first_name = 'Aaron' AND last_name = 'Judge' LIMIT 1);
SET @witt_id = (SELECT player_id FROM players WHERE first_name = 'Bobby' AND last_name = 'Witt Jr.' LIMIT 1);
SET @soto_id = (SELECT player_id FROM players WHERE first_name = 'Juan' AND last_name = 'Soto' LIMIT 1);
SET @betts_id = (SELECT player_id FROM players WHERE first_name = 'Mookie' AND last_name = 'Betts' LIMIT 1);
SET @lindor_id = (SELECT player_id FROM players WHERE first_name = 'Francisco' AND last_name = 'Lindor' LIMIT 1);
SET @alvarez_id = (SELECT player_id FROM players WHERE first_name = 'Yordan' AND last_name = 'Alvarez' LIMIT 1);
SET @freeman_id = (SELECT player_id FROM players WHERE first_name = 'Freddie' AND last_name = 'Freeman' LIMIT 1);
SET @ramirez_id = (SELECT player_id FROM players WHERE first_name = 'José' AND last_name = 'Ramírez' LIMIT 1);
SET @henderson_id = (SELECT player_id FROM players WHERE first_name = 'Gunnar' AND last_name = 'Henderson' LIMIT 1);
SET @acuna_id = (SELECT player_id FROM players WHERE first_name = 'Ronald' AND last_name = 'Acuna Jr.' LIMIT 1);
SET @tatis_id = (SELECT player_id FROM players WHERE first_name = 'Fernando' AND last_name = 'Tatis Jr.' LIMIT 1);

-- MLB Player Props  
INSERT IGNORE INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds, status) VALUES
-- Shohei Ohtani (LAD vs NYY)
(@lad_nyy_game, @ohtani_id, @hits_id, 1.5, -115.00, -105.00, 'active'),
(@lad_nyy_game, @ohtani_id, @rbis_id, 1.5, +105.00, -125.00, 'active'),
(@lad_nyy_game, @ohtani_id, @home_runs_id, 0.5, +165.00, -200.00, 'active'),

-- Aaron Judge (NYY @ LAD)
(@lad_nyy_game, @judge_id, @hits_id, 1.5, -110.00, -110.00, 'active'),
(@lad_nyy_game, @judge_id, @rbis_id, 1.5, +110.00, -130.00, 'active'),
(@lad_nyy_game, @judge_id, @home_runs_id, 0.5, +155.00, -190.00, 'active'),

-- Mookie Betts (LAD vs NYY)
(@lad_nyy_game, @betts_id, @hits_id, 1.5, -105.00, -115.00, 'active'),
(@lad_nyy_game, @betts_id, @rbis_id, 1.5, +115.00, -135.00, 'active'),

-- Freddie Freeman (LAD vs NYY)
(@lad_nyy_game, @freeman_id, @hits_id, 1.5, -110.00, -110.00, 'active'),
(@lad_nyy_game, @freeman_id, @rbis_id, 1.5, +100.00, -120.00, 'active'),

-- Juan Soto (NYM vs ATL)
(@nym_atl_game, @soto_id, @hits_id, 1.5, -105.00, -115.00, 'active'),
(@nym_atl_game, @soto_id, @rbis_id, 1.5, +105.00, -125.00, 'active'),
(@nym_atl_game, @soto_id, @home_runs_id, 0.5, +170.00, -205.00, 'active'),

-- Francisco Lindor (NYM vs ATL)
(@nym_atl_game, @lindor_id, @hits_id, 1.5, -110.00, -110.00, 'active'),
(@nym_atl_game, @lindor_id, @rbis_id, 1.5, +110.00, -130.00, 'active'),

-- Ronald Acuna Jr. (ATL @ NYM)
(@nym_atl_game, @acuna_id, @hits_id, 1.5, -105.00, -115.00, 'active'),
(@nym_atl_game, @acuna_id, @rbis_id, 1.5, +115.00, -135.00, 'active'),

-- Yordan Alvarez (HOU vs KC)
(@hou_kc_mlb_game, @alvarez_id, @hits_id, 1.5, -110.00, -110.00, 'active'),
(@hou_kc_mlb_game, @alvarez_id, @rbis_id, 1.5, +100.00, -120.00, 'active'),
(@hou_kc_mlb_game, @alvarez_id, @home_runs_id, 0.5, +160.00, -195.00, 'active'),

-- Bobby Witt Jr. (KC @ HOU)
(@hou_kc_mlb_game, @witt_id, @hits_id, 1.5, -105.00, -115.00, 'active'),
(@hou_kc_mlb_game, @witt_id, @rbis_id, 1.5, +110.00, -130.00, 'active'),

-- Fernando Tatis Jr. (SD vs CLE)
(@sd_cle_game, @tatis_id, @hits_id, 1.5, -105.00, -115.00, 'active'),
(@sd_cle_game, @tatis_id, @rbis_id, 1.5, +105.00, -125.00, 'active'),
(@sd_cle_game, @tatis_id, @home_runs_id, 0.5, +165.00, -200.00, 'active'),

-- José Ramírez (CLE @ SD)
(@sd_cle_game, @ramirez_id, @hits_id, 1.5, -110.00, -110.00, 'active'),
(@sd_cle_game, @ramirez_id, @rbis_id, 1.5, +105.00, -125.00, 'active'),

-- Gunnar Henderson (BAL vs LAD)
(@bal_mlb_lad_game, @henderson_id, @hits_id, 1.5, -105.00, -115.00, 'active'),
(@bal_mlb_lad_game, @henderson_id, @rbis_id, 1.5, +110.00, -130.00, 'active');

-- Show verification of added props
SELECT 'NFL PROPS ADDED:' as info;
SELECT COUNT(*) as nfl_props_count
FROM player_props pp
JOIN players p ON pp.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
WHERE l.short_name = 'NFL' AND pp.status = 'active';

SELECT 'MLB PROPS ADDED:' as info;  
SELECT COUNT(*) as mlb_props_count
FROM player_props pp
JOIN players p ON pp.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
WHERE l.short_name = 'MLB' AND pp.status = 'active';

-- Show sample props for verification
SELECT 'SAMPLE NFL PROPS:' as info;
SELECT CONCAT(p.first_name, ' ', p.last_name) as player, 
       pt.name as prop_type, pp.line_value, pp.over_odds, pp.under_odds,
       t.short_name as team
FROM player_props pp
JOIN players p ON pp.player_id = p.player_id
JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
WHERE l.short_name = 'NFL' AND pp.status = 'active'
LIMIT 10;

SELECT 'SAMPLE MLB PROPS:' as info;
SELECT CONCAT(p.first_name, ' ', p.last_name) as player, 
       pt.name as prop_type, pp.line_value, pp.over_odds, pp.under_odds,
       t.short_name as team
FROM player_props pp
JOIN players p ON pp.player_id = p.player_id
JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
JOIN teams t ON p.team_id = t.team_id
JOIN leagues l ON t.league_id = l.league_id
WHERE l.short_name = 'MLB' AND pp.status = 'active'
LIMIT 10;