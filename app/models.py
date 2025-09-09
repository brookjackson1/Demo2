from datetime import datetime
from flask import g
import pymysql.cursors

class BaseModel:
    def __init__(self):
        self.db = g.db
    
    def execute_query(self, query, params=None):
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, params or ())
                return cursor.fetchall()
        except Exception as e:
            print(f"Query error: {e}")
            return []
    
    def execute_single(self, query, params=None):
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, params or ())
                return cursor.fetchone()
        except Exception as e:
            print(f"Query error: {e}")
            return None
    
    def execute_insert(self, query, params=None):
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, params or ())
                self.db.commit()
                return cursor.lastrowid
        except Exception as e:
            print(f"Insert error: {e}")
            self.db.rollback()
            return None

class Sport(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_all_active(self):
        query = "SELECT * FROM sports WHERE active = TRUE ORDER BY name"
        return self.execute_query(query)
    
    def get_by_id(self, sport_id):
        query = "SELECT * FROM sports WHERE sport_id = %s"
        return self.execute_single(query, (sport_id,))
    
    def get_by_short_name(self, short_name):
        query = "SELECT * FROM sports WHERE short_name = %s"
        return self.execute_single(query, (short_name,))

class League(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_by_sport(self, sport_id):
        query = """
        SELECT l.*, s.name as sport_name, s.short_name as sport_short_name
        FROM leagues l
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE l.sport_id = %s AND l.active = TRUE
        ORDER BY l.league_type, l.name
        """
        return self.execute_query(query, (sport_id,))
    
    def get_all_active(self):
        query = """
        SELECT l.*, s.name as sport_name, s.short_name as sport_short_name
        FROM leagues l
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE l.active = TRUE
        ORDER BY s.name, l.league_type, l.name
        """
        return self.execute_query(query)
    
    def get_by_id(self, league_id):
        query = """
        SELECT l.*, s.name as sport_name, s.short_name as sport_short_name
        FROM leagues l
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE l.league_id = %s
        """
        return self.execute_single(query, (league_id,))

class Team(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_by_league(self, league_id):
        query = """
        SELECT t.*, l.name as league_name, l.short_name as league_short_name
        FROM teams t
        JOIN leagues l ON t.league_id = l.league_id
        WHERE t.league_id = %s AND t.active = TRUE
        ORDER BY t.city, t.name
        """
        return self.execute_query(query, (league_id,))
    
    def get_by_id(self, team_id):
        query = """
        SELECT t.*, l.name as league_name, l.short_name as league_short_name,
               s.name as sport_name, s.short_name as sport_short_name
        FROM teams t
        JOIN leagues l ON t.league_id = l.league_id
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE t.team_id = %s
        """
        return self.execute_single(query, (team_id,))
    
    def search_by_name(self, search_term):
        query = """
        SELECT t.*, l.name as league_name, l.short_name as league_short_name
        FROM teams t
        JOIN leagues l ON t.league_id = l.league_id
        WHERE (t.name LIKE %s OR t.city LIKE %s OR t.short_name LIKE %s) 
        AND t.active = TRUE
        ORDER BY t.city, t.name
        """
        search_pattern = f"%{search_term}%"
        return self.execute_query(query, (search_pattern, search_pattern, search_pattern))

class Player(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_by_team(self, team_id):
        query = """
        SELECT p.*, t.name as team_name, t.short_name as team_short_name,
               t.city as team_city
        FROM players p
        JOIN teams t ON p.team_id = t.team_id
        WHERE p.team_id = %s AND p.active = TRUE
        ORDER BY p.last_name, p.first_name
        """
        return self.execute_query(query, (team_id,))
    
    def get_by_id(self, player_id):
        query = """
        SELECT p.*, t.name as team_name, t.short_name as team_short_name,
               t.city as team_city, l.name as league_name,
               s.name as sport_name, s.short_name as sport_short_name
        FROM players p
        LEFT JOIN teams t ON p.team_id = t.team_id
        LEFT JOIN leagues l ON t.league_id = l.league_id
        LEFT JOIN sports s ON l.sport_id = s.sport_id
        WHERE p.player_id = %s
        """
        return self.execute_single(query, (player_id,))
    
    def search_by_name(self, search_term):
        query = """
        SELECT p.*, t.name as team_name, t.short_name as team_short_name,
               t.city as team_city, l.name as league_name
        FROM players p
        LEFT JOIN teams t ON p.team_id = t.team_id
        LEFT JOIN leagues l ON t.league_id = l.league_id
        WHERE (p.first_name LIKE %s OR p.last_name LIKE %s) 
        AND p.active = TRUE
        ORDER BY p.last_name, p.first_name
        LIMIT 20
        """
        search_pattern = f"%{search_term}%"
        return self.execute_query(query, (search_pattern, search_pattern))
    
    def get_players_by_sport(self, sport_short_name):
        """Get all players for a specific sport"""
        query = """
        SELECT p.*, t.name as team_name, t.short_name as team_short_name,
               t.city as team_city, t.primary_color, t.secondary_color,
               l.name as league_name, l.short_name as league_short_name,
               s.name as sport_name, s.short_name as sport_short_name
        FROM players p
        JOIN teams t ON p.team_id = t.team_id
        JOIN leagues l ON t.league_id = l.league_id
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE s.short_name = %s
        ORDER BY p.last_name, p.first_name
        """
        return self.execute_query(query, (sport_short_name,))

class Game(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_upcoming_games(self, limit=50):
        query = """
        SELECT g.*, 
               ht.name as home_team_name, ht.short_name as home_team_short,
               ht.city as home_team_city,
               at.name as away_team_name, at.short_name as away_team_short,
               at.city as away_team_city,
               l.name as league_name, l.short_name as league_short,
               s.name as sport_name
        FROM games g
        JOIN teams ht ON g.home_team_id = ht.team_id
        JOIN teams at ON g.away_team_id = at.team_id
        JOIN leagues l ON g.league_id = l.league_id
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE g.game_date > NOW() AND g.status = 'scheduled'
        ORDER BY g.game_date ASC
        LIMIT %s
        """
        return self.execute_query(query, (limit,))
    
    def get_games_by_date_range(self, start_date, end_date):
        query = """
        SELECT g.*, 
               ht.name as home_team_name, ht.short_name as home_team_short,
               at.name as away_team_name, at.short_name as away_team_short,
               l.name as league_name, s.name as sport_name
        FROM games g
        JOIN teams ht ON g.home_team_id = ht.team_id
        JOIN teams at ON g.away_team_id = at.team_id
        JOIN leagues l ON g.league_id = l.league_id
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE g.game_date BETWEEN %s AND %s
        ORDER BY g.game_date ASC
        """
        return self.execute_query(query, (start_date, end_date))

class PropType(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_by_sport(self, sport_id):
        query = """
        SELECT pt.*, s.name as sport_name
        FROM prop_types pt
        JOIN sports s ON pt.sport_id = s.sport_id
        WHERE pt.sport_id = %s AND pt.active = TRUE
        ORDER BY pt.name
        """
        return self.execute_query(query, (sport_id,))

class PlayerProp(BaseModel):
    def __init__(self):
        super().__init__()
    
    def get_active_props(self, limit=100):
        query = """
        SELECT pp.*, 
               p.first_name, p.last_name, p.position,
               pt.name as prop_type_name, pt.unit,
               g.game_date,
               ht.name as home_team_name, ht.short_name as home_team_short,
               at.name as away_team_name, at.short_name as away_team_short,
               t.name as player_team_name, t.short_name as player_team_short,
               l.name as league_name, s.name as sport_name
        FROM player_props pp
        JOIN players p ON pp.player_id = p.player_id
        JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
        JOIN games g ON pp.game_id = g.game_id
        JOIN teams ht ON g.home_team_id = ht.team_id
        JOIN teams at ON g.away_team_id = at.team_id
        JOIN teams t ON p.team_id = t.team_id
        JOIN leagues l ON g.league_id = l.league_id
        JOIN sports s ON l.sport_id = s.sport_id
        WHERE pp.status = 'active' AND g.game_date > NOW()
        ORDER BY g.game_date ASC, s.name, p.last_name
        LIMIT %s
        """
        return self.execute_query(query, (limit,))
    
    def get_props_by_game(self, game_id):
        query = """
        SELECT pp.*, 
               p.first_name, p.last_name, p.position,
               pt.name as prop_type_name, pt.unit,
               t.name as player_team_name, t.short_name as player_team_short
        FROM player_props pp
        JOIN players p ON pp.player_id = p.player_id
        JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
        JOIN teams t ON p.team_id = t.team_id
        WHERE pp.game_id = %s AND pp.status = 'active'
        ORDER BY p.last_name, pt.name
        """
        return self.execute_query(query, (game_id,))
    
    def get_props_by_sport(self, sport_id, limit=50):
        query = """
        SELECT pp.*, 
               p.first_name, p.last_name, p.position,
               pt.name as prop_type_name, pt.unit,
               g.game_date,
               ht.name as home_team_name, ht.short_name as home_team_short,
               at.name as away_team_name, at.short_name as away_team_short,
               t.name as player_team_name, t.short_name as player_team_short
        FROM player_props pp
        JOIN players p ON pp.player_id = p.player_id
        JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
        JOIN games g ON pp.game_id = g.game_id
        JOIN teams ht ON g.home_team_id = ht.team_id
        JOIN teams at ON g.away_team_id = at.team_id
        JOIN teams t ON p.team_id = t.team_id
        JOIN leagues l ON g.league_id = l.league_id
        WHERE l.sport_id = %s AND pp.status = 'active' AND g.game_date > NOW()
        ORDER BY g.game_date ASC, p.last_name
        LIMIT %s
        """
        return self.execute_query(query, (sport_id, limit))

class User(BaseModel):
    def __init__(self):
        super().__init__()
    
    def create_user(self, username, email, password_hash, first_name=None, last_name=None):
        query = """
        INSERT INTO users (username, email, password_hash, first_name, last_name)
        VALUES (%s, %s, %s, %s, %s)
        """
        return self.execute_insert(query, (username, email, password_hash, first_name, last_name))
    
    def get_by_username(self, username):
        query = "SELECT * FROM users WHERE username = %s AND active = TRUE"
        return self.execute_single(query, (username,))
    
    def get_by_email(self, email):
        query = "SELECT * FROM users WHERE email = %s AND active = TRUE"
        return self.execute_single(query, (email,))
    
    def update_balance(self, user_id, new_balance):
        query = "UPDATE users SET balance = %s WHERE user_id = %s"
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (new_balance, user_id))
                self.db.commit()
                return True
        except Exception as e:
            print(f"Balance update error: {e}")
            self.db.rollback()
            return False

class PickSlip(BaseModel):
    def __init__(self):
        super().__init__()
    
    def create_slip(self, user_id, entry_fee, potential_payout, num_picks):
        query = """
        INSERT INTO pick_slips (user_id, entry_fee, potential_payout, num_picks)
        VALUES (%s, %s, %s, %s)
        """
        return self.execute_insert(query, (user_id, entry_fee, potential_payout, num_picks))
    
    def get_user_slips(self, user_id, limit=20):
        query = """
        SELECT * FROM pick_slips 
        WHERE user_id = %s 
        ORDER BY submitted_at DESC 
        LIMIT %s
        """
        return self.execute_query(query, (user_id, limit))
    
    def get_slip_with_picks(self, slip_id):
        slip_query = """
        SELECT ps.*, u.username
        FROM pick_slips ps
        JOIN users u ON ps.user_id = u.user_id
        WHERE ps.slip_id = %s
        """
        
        picks_query = """
        SELECT p.*, pp.line_value as original_line, pp.over_odds, pp.under_odds,
               pl.first_name, pl.last_name, pt.name as prop_type_name, pt.unit,
               g.game_date, ht.short_name as home_team, at.short_name as away_team
        FROM picks p
        JOIN player_props pp ON p.prop_id = pp.prop_id
        JOIN players pl ON pp.player_id = pl.player_id
        JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
        JOIN games g ON pp.game_id = g.game_id
        JOIN teams ht ON g.home_team_id = ht.team_id
        JOIN teams at ON g.away_team_id = at.team_id
        WHERE p.slip_id = %s
        ORDER BY p.created_at
        """
        
        slip = self.execute_single(slip_query, (slip_id,))
        if slip:
            picks = self.execute_query(picks_query, (slip_id,))
            slip['picks'] = picks
        
        return slip

class Pick(BaseModel):
    def __init__(self):
        super().__init__()
    
    def create_pick(self, slip_id, prop_id, selection, line_value, odds):
        query = """
        INSERT INTO picks (slip_id, prop_id, selection, line_value, odds)
        VALUES (%s, %s, %s, %s, %s)
        """
        return self.execute_insert(query, (slip_id, prop_id, selection, line_value, odds))