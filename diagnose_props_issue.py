#!/usr/bin/env python3
"""
Diagnostic Script for Props Issue
Checks why props aren't showing up on sport pages
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

def diagnose_data(connection):
    """Diagnose the data structure to find the issue"""
    print("\n=== DIAGNOSTIC REPORT ===")
    
    with connection.cursor() as cursor:
        # Check sports
        print("\n1. SPORTS TABLE:")
        cursor.execute("SELECT sport_id, name, short_name FROM sports ORDER BY sport_id")
        sports = cursor.fetchall()
        for sport in sports:
            print(f"   ID: {sport['sport_id']} | Name: {sport['name']} | Short: {sport['short_name']}")
        
        # Check leagues  
        print("\n2. LEAGUES TABLE:")
        cursor.execute("""
            SELECT l.league_id, l.name, l.short_name, l.sport_id, s.name as sport_name 
            FROM leagues l 
            JOIN sports s ON l.sport_id = s.sport_id 
            ORDER BY l.sport_id, l.league_id
        """)
        leagues = cursor.fetchall()
        for league in leagues:
            print(f"   ID: {league['league_id']} | Name: {league['name']} | Short: {league['short_name']} | Sport: {league['sport_name']} (ID: {league['sport_id']})")
        
        # Check teams
        print("\n3. TEAMS COUNT BY LEAGUE:")
        cursor.execute("""
            SELECT l.short_name as league_short, l.name as league_name, COUNT(t.team_id) as team_count
            FROM leagues l 
            LEFT JOIN teams t ON l.league_id = t.league_id
            GROUP BY l.league_id, l.short_name, l.name
            ORDER BY l.sport_id
        """)
        team_counts = cursor.fetchall()
        for tc in team_counts:
            print(f"   {tc['league_short']}: {tc['team_count']} teams")
        
        # Check players
        print("\n4. PLAYERS COUNT BY LEAGUE:")
        cursor.execute("""
            SELECT l.short_name as league_short, COUNT(p.player_id) as player_count
            FROM leagues l 
            LEFT JOIN teams t ON l.league_id = t.league_id
            LEFT JOIN players p ON t.team_id = p.team_id
            GROUP BY l.league_id, l.short_name
            ORDER BY l.sport_id
        """)
        player_counts = cursor.fetchall()
        for pc in player_counts:
            print(f"   {pc['league_short']}: {pc['player_count']} players")
        
        # Check games
        print("\n5. GAMES BY LEAGUE:")
        cursor.execute("""
            SELECT l.short_name as league_short, COUNT(g.game_id) as game_count,
                   MIN(g.game_date) as earliest_game, MAX(g.game_date) as latest_game
            FROM leagues l 
            LEFT JOIN games g ON l.league_id = g.league_id
            GROUP BY l.league_id, l.short_name
            ORDER BY l.sport_id
        """)
        games = cursor.fetchall()
        for game in games:
            print(f"   {game['league_short']}: {game['game_count']} games | {game['earliest_game']} to {game['latest_game']}")
        
        # Check props
        print("\n6. PLAYER PROPS BY SPORT:")
        cursor.execute("""
            SELECT s.short_name as sport_short, COUNT(pp.prop_id) as prop_count,
                   COUNT(CASE WHEN pp.status = 'active' THEN 1 END) as active_props
            FROM sports s
            LEFT JOIN leagues l ON s.sport_id = l.sport_id
            LEFT JOIN games g ON l.league_id = g.league_id  
            LEFT JOIN player_props pp ON g.game_id = pp.game_id
            GROUP BY s.sport_id, s.short_name
            ORDER BY s.sport_id
        """)
        props = cursor.fetchall()
        for prop in props:
            print(f"   {prop['sport_short']}: {prop['prop_count']} total props | {prop['active_props']} active")
        
        # Check future games (the API query condition)
        print("\n7. FUTURE GAMES CHECK:")
        cursor.execute("""
            SELECT l.short_name as league_short, COUNT(g.game_id) as future_games
            FROM leagues l 
            LEFT JOIN games g ON l.league_id = g.league_id
            WHERE g.game_date > NOW()
            GROUP BY l.league_id, l.short_name
            ORDER BY l.sport_id
        """)
        future_games = cursor.fetchall()
        for fg in future_games:
            print(f"   {fg['league_short']}: {fg['future_games']} future games")
        
        # Test the exact query used by the API
        print("\n8. NFL PROPS API QUERY TEST:")
        nfl_sport_id = None
        for sport in sports:
            if sport['short_name'] == 'NFL':
                nfl_sport_id = sport['sport_id']
                break
        
        if nfl_sport_id:
            cursor.execute("""
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
                LIMIT 10
            """, (nfl_sport_id,))
            nfl_props = cursor.fetchall()
            print(f"   Found {len(nfl_props)} NFL props")
            for prop in nfl_props[:3]:  # Show first 3
                print(f"   - {prop['first_name']} {prop['last_name']} {prop['prop_type_name']}: {prop['line_value']}")
        else:
            print("   NFL sport not found!")
        
        # Test MLB props too
        print("\n9. MLB PROPS API QUERY TEST:")
        mlb_sport_id = None
        for sport in sports:
            if sport['short_name'] == 'MLB':
                mlb_sport_id = sport['sport_id']
                break
        
        if mlb_sport_id:
            cursor.execute("""
                SELECT COUNT(*) as count FROM player_props pp
                JOIN players p ON pp.player_id = p.player_id
                JOIN teams t ON p.team_id = t.team_id
                JOIN leagues l ON t.league_id = l.league_id
                JOIN games g ON pp.game_id = g.game_id
                WHERE l.sport_id = %s AND pp.status = 'active' AND g.game_date > NOW()
            """, (mlb_sport_id,))
            mlb_count = cursor.fetchone()
            print(f"   Found {mlb_count['count']} MLB props")
        else:
            print("   MLB sport not found!")

def main():
    print("Props Diagnostic Script")
    print("=" * 50)
    
    connection = create_database_connection()
    if not connection:
        return
    
    try:
        diagnose_data(connection)
    except Exception as e:
        print(f"Diagnostic failed: {e}")
    finally:
        connection.close()
        print("\nDatabase connection closed")

if __name__ == "__main__":
    main()