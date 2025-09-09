-- Fantasy Sports Seed Data
-- Initial data for sports, leagues, teams, and prop types

-- Insert sports
INSERT INTO sports (name, short_name) VALUES
('Baseball', 'MLB'),
('Basketball', 'BBL'),
('Football', 'NFL'),
('Soccer', 'SOC');

-- Insert leagues
INSERT INTO leagues (sport_id, name, short_name, league_type, season_start_month, season_end_month) VALUES
-- Baseball
(1, 'Major League Baseball', 'MLB', 'professional', 4, 10),
(1, 'NCAA Baseball', 'NCAAB', 'college', 2, 6),
-- Basketball
(2, 'National Basketball Association', 'NBA', 'professional', 10, 4),
(2, 'NCAA Basketball', 'NCAABB', 'college', 11, 4),
-- Football
(3, 'National Football League', 'NFL', 'professional', 9, 2),
(3, 'NCAA Football', 'NCAAF', 'college', 8, 1),
-- Soccer
(4, 'Major League Soccer', 'MLS', 'professional', 2, 11),
(4, 'NCAA Soccer', 'NCAAS', 'college', 8, 12);

-- Insert sample NFL teams
INSERT INTO teams (league_id, name, short_name, city, primary_color, secondary_color) VALUES
-- NFL teams (league_id = 5)
(5, 'Chiefs', 'KC', 'Kansas City', '#E31837', '#FFB81C'),
(5, 'Bills', 'BUF', 'Buffalo', '#00338D', '#C60C30'),
(5, 'Bengals', 'CIN', 'Cincinnati', '#FB4F14', '#000000'),
(5, 'Ravens', 'BAL', 'Baltimore', '#241773', '#000000'),
(5, 'Dolphins', 'MIA', 'Miami', '#008E97', '#FC4C02'),
(5, 'Patriots', 'NE', 'New England', '#002244', '#C60C30'),
(5, 'Jets', 'NYJ', 'New York', '#125740', '#000000'),
(5, 'Steelers', 'PIT', 'Pittsburgh', '#FFB612', '#101820'),
-- NBA teams (league_id = 3)
(3, 'Lakers', 'LAL', 'Los Angeles', '#552583', '#FDB927'),
(3, 'Warriors', 'GSW', 'Golden State', '#1D428A', '#FFC72C'),
(3, 'Celtics', 'BOS', 'Boston', '#007A33', '#BA9653'),
(3, 'Heat', 'MIA', 'Miami', '#98002E', '#F9A01B'),
-- MLB teams (league_id = 1)
(1, 'Yankees', 'NYY', 'New York', '#132448', '#C4CED4'),
(1, 'Dodgers', 'LAD', 'Los Angeles', '#005A9C', '#EF3E42'),
(1, 'Red Sox', 'BOS', 'Boston', '#BD3039', '#0C2340'),
(1, 'Astros', 'HOU', 'Houston', '#002D62', '#EB6E1F');

-- Insert sample players
INSERT INTO players (team_id, first_name, last_name, position, jersey_number) VALUES
-- Chiefs players (team_id = 1)
(1, 'Patrick', 'Mahomes', 'QB', '15'),
(1, 'Travis', 'Kelce', 'TE', '87'),
(1, 'Tyreek', 'Hill', 'WR', '10'),
-- Lakers players (team_id = 9)
(9, 'LeBron', 'James', 'F', '23'),
(9, 'Anthony', 'Davis', 'F/C', '3'),
-- Yankees players (team_id = 13)
(13, 'Aaron', 'Judge', 'OF', '99'),
(13, 'Gerrit', 'Cole', 'P', '45');

-- Insert prop types for each sport
INSERT INTO prop_types (sport_id, name, description, unit) VALUES
-- Football prop types (sport_id = 3)
(3, 'Passing Yards', 'Total passing yards in the game', 'yards'),
(3, 'Passing TDs', 'Total passing touchdowns', 'touchdowns'),
(3, 'Rushing Yards', 'Total rushing yards in the game', 'yards'),
(3, 'Receiving Yards', 'Total receiving yards in the game', 'yards'),
(3, 'Receptions', 'Total receptions in the game', 'catches'),
(3, 'Fantasy Points', 'Total fantasy points scored', 'points'),
-- Basketball prop types (sport_id = 2)
(2, 'Points', 'Total points scored in the game', 'points'),
(2, 'Rebounds', 'Total rebounds in the game', 'rebounds'),
(2, 'Assists', 'Total assists in the game', 'assists'),
(2, 'Steals', 'Total steals in the game', 'steals'),
(2, 'Blocks', 'Total blocks in the game', 'blocks'),
(2, '3-Pointers Made', 'Total three-pointers made', 'makes'),
-- Baseball prop types (sport_id = 1)
(1, 'Hits', 'Total hits in the game', 'hits'),
(1, 'RBIs', 'Total runs batted in', 'RBIs'),
(1, 'Home Runs', 'Total home runs hit', 'home runs'),
(1, 'Strikeouts', 'Total strikeouts (pitcher)', 'strikeouts'),
(1, 'Earned Runs', 'Total earned runs allowed (pitcher)', 'runs'),
-- Soccer prop types (sport_id = 4)
(4, 'Goals', 'Total goals scored in the game', 'goals'),
(4, 'Assists', 'Total assists in the game', 'assists'),
(4, 'Shots on Goal', 'Total shots on goal', 'shots'),
(4, 'Saves', 'Total saves (goalkeeper)', 'saves');

-- Insert sample games for current week
INSERT INTO games (league_id, home_team_id, away_team_id, game_date, week_number, season_year, venue) VALUES
-- NFL games (league_id = 5)
(5, 1, 2, '2024-09-15 20:20:00', 2, 2024, 'Arrowhead Stadium'),
(5, 3, 4, '2024-09-15 13:00:00', 2, 2024, 'Paycor Stadium'),
-- NBA games (league_id = 3)
(3, 9, 10, '2024-03-15 19:30:00', NULL, 2024, 'Crypto.com Arena'),
(3, 11, 12, '2024-03-15 20:00:00', NULL, 2024, 'TD Garden');

-- Insert sample player props
INSERT INTO player_props (game_id, player_id, prop_type_id, line_value, over_odds, under_odds) VALUES
-- Patrick Mahomes props for game 1
(1, 1, 1, 275.5, -110.00, -110.00),  -- Passing yards
(1, 1, 2, 2.5, -115.00, -105.00),    -- Passing TDs
-- Travis Kelce props for game 1
(1, 2, 4, 85.5, -110.00, -110.00),   -- Receiving yards
(1, 2, 5, 6.5, -120.00, +100.00),    -- Receptions
-- LeBron James props for game 3
(3, 4, 7, 25.5, -110.00, -110.00),   -- Points
(3, 4, 8, 7.5, -110.00, -110.00),    -- Rebounds
(3, 4, 9, 8.5, -105.00, -115.00),    -- Assists
-- Anthony Davis props for game 3
(3, 5, 7, 23.5, -110.00, -110.00),   -- Points
(3, 5, 8, 11.5, -110.00, -110.00);   -- Rebounds

-- Create a sample user
INSERT INTO users (username, email, password_hash, first_name, last_name, balance) VALUES
('demo_user', 'demo@example.com', 'hashed_password_here', 'Demo', 'User', 100.00);