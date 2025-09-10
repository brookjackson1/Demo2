#!/usr/bin/env python3
"""
Complete Database setup script for Fantasy Sports App with MLB and NFL Top Players
Run this script to create and populate the database with all sample data including top players
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
        print("✅ Connected to database successfully")
        return connection
    except Exception as e:
        print(f"❌ Database connection failed: {e}")
        print("\n📝 Make sure to:")
        print("1. Copy .env.example to .env")
        print("2. Fill in your database credentials in .env")
        print("3. Create the database specified in DB_NAME")
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
        
        print(f"✅ {description} completed successfully")
        return True
    except FileNotFoundError:
        print(f"⚠️  File not found: {file_path} - skipping...")
        return False
    except Exception as e:
        print(f"❌ Error executing {description}: {e}")
        return False

def main():
    print("🏆 Complete Fantasy Sports Database Setup")
    print("=" * 70)
    print("🏈 NFL + ⚾ MLB + 🏀 NBA + ⚽ Soccer Players Included")
    print("=" * 70)
    
    # Create database connection
    connection = create_database_connection()
    if not connection:
        return
    
    try:
        # Execute base schema
        print("\n📋 Creating database schema...")
        if not execute_sql_file(connection, 'database/fantasy_sports_schema.sql', 'Schema creation'):
            return
        
        # Execute base seed data
        print("\n🌱 Inserting basic seed data...")
        if not execute_sql_file(connection, 'database/fantasy_sports_seed_data.sql', 'Basic seed data insertion'):
            return
        
        # Execute MLB players data
        print("\n⚾ Adding MLB Top Players for 2025...")
        execute_sql_file(connection, 'database/mlb_top_players_2025.sql', 'MLB top players insertion')
        
        # Execute NFL players data
        print("\n🏈 Adding NFL Top Players for 2025...")
        execute_sql_file(connection, 'database/nfl_top_players_2025.sql', 'NFL top players insertion')
        
        print("\n🎉 Complete Database setup finished successfully!")
        print("\n🚀 You can now run your Flask app:")
        print("   python app.py")
        print("\n🔗 Access points:")
        print("   - Fantasy Sports App: http://localhost:5000/fantasy-sports/")
        print("   - NFL Page: http://localhost:5000/fantasy-sports/nfl")
        print("   - MLB Page: http://localhost:5000/fantasy-sports/mlb")
        print("   - NBA Page: http://localhost:5000/fantasy-sports/nba")
        print("   - Soccer Page: http://localhost:5000/fantasy-sports/soccer")
        print("   - Player Gallery: http://localhost:5000/fantasy-sports/player-gallery")
        print("   - Admin Panel: http://localhost:5000/admin/")
        print("   - Main App: http://localhost:5000/")
        
        # Show comprehensive stats
        with connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) as count FROM sports")
            sports_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM leagues")
            leagues_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM teams")
            teams_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM players")
            players_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM players WHERE photo_url IS NOT NULL")
            players_with_photos = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM player_props WHERE status = 'active'")
            props_count = cursor.fetchone()['count']
            
            # Get sample NFL players
            cursor.execute("""
                SELECT CONCAT(p.first_name, ' ', p.last_name) as name, p.position, t.city, t.name as team_name
                FROM players p
                JOIN teams t ON p.team_id = t.team_id
                JOIN leagues l ON t.league_id = l.league_id
                WHERE l.short_name = 'NFL' AND p.last_name IN ('Mahomes', 'Allen', 'McCaffrey', 'Hill')
                ORDER BY p.last_name
                LIMIT 4
            """)
            sample_nfl_players = cursor.fetchall()
            
            # Get sample MLB players
            cursor.execute("""
                SELECT CONCAT(p.first_name, ' ', p.last_name) as name, p.position, t.city, t.name as team_name
                FROM players p
                JOIN teams t ON p.team_id = t.team_id
                JOIN leagues l ON t.league_id = l.league_id
                WHERE l.short_name = 'MLB' AND p.last_name IN ('Ohtani', 'Judge', 'Soto', 'Betts')
                ORDER BY p.last_name
                LIMIT 4
            """)
            sample_mlb_players = cursor.fetchall()
            
            print(f"\n📊 Database contains:")
            print(f"   - {sports_count} sports")
            print(f"   - {leagues_count} leagues")
            print(f"   - {teams_count} teams")
            print(f"   - {players_count} players ({players_with_photos} with photos)")
            print(f"   - {props_count} active props")
            
            if sample_nfl_players:
                print(f"\n🏈 Featured NFL Stars:")
                for player in sample_nfl_players:
                    print(f"   - {player['name']} ({player['position']}) - {player['city']} {player['team_name']}")
            
            if sample_mlb_players:
                print(f"\n⚾ Featured MLB Stars:")
                for player in sample_mlb_players:
                    print(f"   - {player['name']} ({player['position']}) - {player['city']} {player['team_name']}")
        
        print(f"\n🎯 Ready to use:")
        print("✨ Individual sport pages with featured players")
        print("📸 Player photos from official sources")
        print("🎲 Realistic player props with proper odds")
        print("🏆 Top 2025 NFL and MLB players included")
        print("📱 Mobile-responsive design")
        print("🎮 Interactive pick builder")
        print("👑 Admin panel for prop management")
        
        print(f"\n🚀 Quick Start:")
        print("1. Run 'python app.py' to start the server")
        print("2. Visit http://localhost:5000/fantasy-sports/ to start")
        print("3. Click on NFL or MLB to see the new player features")
        print("4. Try the Player Gallery to browse all players")
        print("5. Use the Pick Builder to create fantasy pick slips")
        
    except Exception as e:
        print(f"❌ Setup failed: {e}")
    finally:
        connection.close()
        print("\n🔐 Database connection closed")

if __name__ == "__main__":
    main()