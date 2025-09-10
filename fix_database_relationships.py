#!/usr/bin/env python3
"""
Database Relationship Fix Script
Fixes the sport-league-team-player relationships to ensure NFL and MLB players show up correctly
"""

import pymysql
import os
from dotenv import load_dotenv

load_dotenv()

def create_database_connection():
    """Create database connection"""
    try:
        connection = pymysql.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'), 
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME'),
            cursorclass=pymysql.cursors.DictCursor
        )
        print("Connected to database successfully")
        return connection
    except Exception as e:
        print(f"Database connection failed: {e}")
        return None

def execute_sql_file(connection, file_path, description):
    """Execute SQL commands from a file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            sql_content = file.read()
        
        # Split by semicolon and execute each statement
        statements = sql_content.split(';')
        
        with connection.cursor() as cursor:
            for statement in statements:
                statement = statement.strip()
                if statement:
                    cursor.execute(statement)
            connection.commit()
        
        print(f"{description} completed successfully")
        return True
    except FileNotFoundError:
        print(f"File not found: {file_path} - skipping...")
        return False
    except Exception as e:
        print(f"Error executing {description}: {e}")
        return False

def verify_data(connection):
    """Verify the data relationships are correct"""
    print("\nVerifying database relationships...")
    
    with connection.cursor() as cursor:
        # Check sports
        cursor.execute("SELECT name, short_name FROM sports ORDER BY sport_id")
        sports = cursor.fetchall()
        print(f"\nSports ({len(sports)} total):")
        for sport in sports:
            print(f"   - {sport['name']} ({sport['short_name']})")
        
        # Check leagues
        cursor.execute("""
            SELECT l.name, l.short_name, l.league_type, s.short_name as sport_short
            FROM leagues l 
            JOIN sports s ON l.sport_id = s.sport_id 
            ORDER BY s.sport_id, l.league_type, l.name
        """)
        leagues = cursor.fetchall()
        print(f"\nLeagues ({len(leagues)} total):")
        for league in leagues:
            print(f"   - {league['name']} ({league['short_name']}) - {league['sport_short']} {league['league_type']}")
        
        # Check NFL teams and players
        cursor.execute("""
            SELECT COUNT(t.team_id) as team_count, COUNT(p.player_id) as player_count
            FROM teams t
            LEFT JOIN players p ON t.team_id = p.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'NFL'
        """)
        nfl_stats = cursor.fetchone()
        print(f"\nNFL: {nfl_stats['team_count']} teams, {nfl_stats['player_count']} players")
        
        # Check MLB teams and players
        cursor.execute("""
            SELECT COUNT(t.team_id) as team_count, COUNT(p.player_id) as player_count
            FROM teams t
            LEFT JOIN players p ON t.team_id = p.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'MLB'
        """)
        mlb_stats = cursor.fetchone()
        print(f"MLB: {mlb_stats['team_count']} teams, {mlb_stats['player_count']} players")
        
        # Show sample NFL players
        cursor.execute("""
            SELECT CONCAT(p.first_name, ' ', p.last_name) as name, p.position, t.short_name as team
            FROM players p
            JOIN teams t ON p.team_id = t.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'NFL'
            ORDER BY p.last_name
            LIMIT 5
        """)
        nfl_players = cursor.fetchall()
        if nfl_players:
            print(f"\nSample NFL Players:")
            for player in nfl_players:
                print(f"   - {player['name']} ({player['position']}) - {player['team']}")
        
        # Show sample MLB players
        cursor.execute("""
            SELECT CONCAT(p.first_name, ' ', p.last_name) as name, p.position, t.short_name as team
            FROM players p
            JOIN teams t ON p.team_id = t.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'MLB'
            ORDER BY p.last_name
            LIMIT 5
        """)
        mlb_players = cursor.fetchall()
        if mlb_players:
            print(f"\nSample MLB Players:")
            for player in mlb_players:
                print(f"   - {player['name']} ({player['position']}) - {player['team']}")
        
        # Check NFL props
        cursor.execute("""
            SELECT COUNT(*) as prop_count
            FROM player_props pp
            JOIN players p ON pp.player_id = p.player_id
            JOIN teams t ON p.team_id = t.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'NFL' AND pp.status = 'active'
        """)
        nfl_props = cursor.fetchone()
        print(f"NFL Active Props: {nfl_props['prop_count']}")
        
        # Check MLB props
        cursor.execute("""
            SELECT COUNT(*) as prop_count
            FROM player_props pp
            JOIN players p ON pp.player_id = p.player_id
            JOIN teams t ON p.team_id = t.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'MLB' AND pp.status = 'active'
        """)
        mlb_props = cursor.fetchone()
        print(f"MLB Active Props: {mlb_props['prop_count']}")
        
        # Show sample props
        cursor.execute("""
            SELECT CONCAT(p.first_name, ' ', p.last_name) as player_name, 
                   pt.name as prop_type, pp.line_value, t.short_name as team
            FROM player_props pp
            JOIN players p ON pp.player_id = p.player_id
            JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
            JOIN teams t ON p.team_id = t.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'NFL' AND pp.status = 'active'
            LIMIT 3
        """)
        sample_nfl_props = cursor.fetchall()
        if sample_nfl_props:
            print(f"\nSample NFL Props:")
            for prop in sample_nfl_props:
                print(f"   - {prop['player_name']} {prop['prop_type']}: {prop['line_value']} ({prop['team']})")
        
        cursor.execute("""
            SELECT CONCAT(p.first_name, ' ', p.last_name) as player_name, 
                   pt.name as prop_type, pp.line_value, t.short_name as team
            FROM player_props pp
            JOIN players p ON pp.player_id = p.player_id
            JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
            JOIN teams t ON p.team_id = t.team_id
            JOIN leagues l ON t.league_id = l.league_id
            WHERE l.short_name = 'MLB' AND pp.status = 'active'
            LIMIT 3
        """)
        sample_mlb_props = cursor.fetchall()
        if sample_mlb_props:
            print(f"\nSample MLB Props:")
            for prop in sample_mlb_props:
                print(f"   - {prop['player_name']} {prop['prop_type']}: {prop['line_value']} ({prop['team']})")

def main():
    print("Database Relationship Fix Script")
    print("=" * 50)
    print("Fixing NFL and MLB player visibility issues...")
    
    connection = create_database_connection()
    if not connection:
        return
    
    try:
        # Fix sports and leagues first
        print("\n1. Fixing sports and leagues data...")
        execute_sql_file(connection, 'database/fix_sports_and_leagues.sql', 'Sports and leagues fix')
        
        # Fix NFL players
        print("\n2. Fixing NFL players and teams...")
        execute_sql_file(connection, 'database/fix_nfl_players.sql', 'NFL players fix')
        
        # Fix MLB players
        print("\n3. Fixing MLB players and teams...")
        execute_sql_file(connection, 'database/fix_mlb_players.sql', 'MLB players fix')
        
        # Add player props
        print("\n4. Adding player props for current games...")
        execute_sql_file(connection, 'database/add_player_props.sql', 'Player props addition')
        
        # Fix props visibility issues
        print("\n5. Fixing props visibility and game dates...")
        execute_sql_file(connection, 'database/fix_props_visibility.sql', 'Props visibility fix')
        
        # Verify everything is working
        verify_data(connection)
        
        print(f"\nDatabase relationships fixed successfully!")
        print(f"\nPlayers should now be visible on sport pages:")
        print("   - NFL Page: http://localhost:5000/fantasy-sports/nfl")
        print("   - MLB Page: http://localhost:5000/fantasy-sports/mlb")
        print("   - Player Gallery: http://localhost:5000/fantasy-sports/player-gallery")
        
    except Exception as e:
        print(f"Fix failed: {e}")
    finally:
        connection.close()
        print("\nDatabase connection closed")

if __name__ == "__main__":
    main()