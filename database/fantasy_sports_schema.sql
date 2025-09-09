-- Fantasy Sports Database Schema
-- Similar to PrizePicks functionality for baseball, basketball, football, soccer
-- Supports both college and professional sports

-- Sports table
CREATE TABLE sports (
    sport_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    short_name VARCHAR(10) NOT NULL UNIQUE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Leagues table
CREATE TABLE leagues (
    league_id INT AUTO_INCREMENT PRIMARY KEY,
    sport_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    short_name VARCHAR(10) NOT NULL,
    league_type ENUM('professional', 'college') NOT NULL,
    season_start_month INT NOT NULL,
    season_end_month INT NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sport_id) REFERENCES sports(sport_id),
    UNIQUE KEY unique_league (sport_id, short_name, league_type)
);

-- Teams table
CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    league_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    short_name VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    logo_url VARCHAR(255),
    primary_color VARCHAR(7),
    secondary_color VARCHAR(7),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (league_id) REFERENCES leagues(league_id),
    UNIQUE KEY unique_team (league_id, short_name)
);

-- Players table
CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(20),
    jersey_number VARCHAR(10),
    height_inches INT,
    weight_lbs INT,
    birth_date DATE,
    photo_url VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

-- Games table
CREATE TABLE games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    league_id INT NOT NULL,
    home_team_id INT NOT NULL,
    away_team_id INT NOT NULL,
    game_date DATETIME NOT NULL,
    week_number INT,
    season_year INT NOT NULL,
    status ENUM('scheduled', 'in_progress', 'completed', 'cancelled') DEFAULT 'scheduled',
    home_team_score INT DEFAULT 0,
    away_team_score INT DEFAULT 0,
    venue VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (league_id) REFERENCES leagues(league_id),
    FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);

-- Prop types table (points, rebounds, assists, etc.)
CREATE TABLE prop_types (
    prop_type_id INT AUTO_INCREMENT PRIMARY KEY,
    sport_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    unit VARCHAR(20),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sport_id) REFERENCES sports(sport_id),
    UNIQUE KEY unique_prop_type (sport_id, name)
);

-- Player props table
CREATE TABLE player_props (
    prop_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    prop_type_id INT NOT NULL,
    line_value DECIMAL(6,2) NOT NULL,
    over_odds DECIMAL(5,2) DEFAULT -110.00,
    under_odds DECIMAL(5,2) DEFAULT -110.00,
    actual_value DECIMAL(6,2),
    status ENUM('active', 'settled', 'cancelled') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (prop_type_id) REFERENCES prop_types(prop_type_id),
    UNIQUE KEY unique_player_prop (game_id, player_id, prop_type_id)
);

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    balance DECIMAL(10,2) DEFAULT 0.00,
    total_deposited DECIMAL(10,2) DEFAULT 0.00,
    total_winnings DECIMAL(10,2) DEFAULT 0.00,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Pick slips/entries table
CREATE TABLE pick_slips (
    slip_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    entry_fee DECIMAL(8,2) NOT NULL,
    potential_payout DECIMAL(10,2) NOT NULL,
    actual_payout DECIMAL(10,2) DEFAULT 0.00,
    num_picks INT NOT NULL,
    status ENUM('pending', 'won', 'lost', 'cancelled') DEFAULT 'pending',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    settled_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Individual picks table
CREATE TABLE picks (
    pick_id INT AUTO_INCREMENT PRIMARY KEY,
    slip_id INT NOT NULL,
    prop_id INT NOT NULL,
    selection ENUM('over', 'under') NOT NULL,
    line_value DECIMAL(6,2) NOT NULL,
    odds DECIMAL(5,2) NOT NULL,
    result ENUM('win', 'loss', 'push') NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (slip_id) REFERENCES pick_slips(slip_id),
    FOREIGN KEY (prop_id) REFERENCES player_props(prop_id)
);

-- Transactions table for deposits/withdrawals/payouts
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'payout', 'entry_fee') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'completed', 'failed', 'cancelled') DEFAULT 'pending',
    reference_id VARCHAR(100),
    slip_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (slip_id) REFERENCES pick_slips(slip_id)
);

-- Indexes for performance
CREATE INDEX idx_players_team ON players(team_id);
CREATE INDEX idx_players_name ON players(last_name, first_name);
CREATE INDEX idx_games_date ON games(game_date);
CREATE INDEX idx_games_teams ON games(home_team_id, away_team_id);
CREATE INDEX idx_games_league_season ON games(league_id, season_year);
CREATE INDEX idx_player_props_game ON player_props(game_id);
CREATE INDEX idx_player_props_player ON player_props(player_id);
CREATE INDEX idx_player_props_status ON player_props(status);
CREATE INDEX idx_pick_slips_user ON pick_slips(user_id);
CREATE INDEX idx_pick_slips_status ON pick_slips(status);
CREATE INDEX idx_picks_slip ON picks(slip_id);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_type_status ON transactions(transaction_type, status);