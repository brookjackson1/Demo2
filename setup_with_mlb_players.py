#!/usr/bin/env python3
"""
Enhanced Database setup script for Fantasy Sports App with MLB Top Players
Run this script to create and populate the database with sample data including MLB stars
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
        print(f"❌ File not found: {file_path}")
        return False
    except Exception as e:
        print(f"❌ Error executing {description}: {e}")
        return False

def main():
    print("🏆 Fantasy Sports Database Setup with MLB Stars")
    print("=" * 60)
    
    # Create database connection
    connection = create_database_connection()
    if not connection:
        return
    
    try:
        # Execute schema
        print("\n📋 Creating database schema...")
        if not execute_sql_file(connection, 'database/fantasy_sports_schema.sql', 'Schema creation'):
            return
        
        # Execute seed data
        print("\n🌱 Inserting basic seed data...")
        if not execute_sql_file(connection, 'database/fantasy_sports_seed_data.sql', 'Basic seed data insertion'):
            return
        
        # Execute MLB players data
        print("\n⚾ Adding MLB Top Players for 2025...")
        if not execute_sql_file(connection, 'database/mlb_top_players_2025.sql', 'MLB top players insertion'):
            print("⚠️  MLB players file not found, skipping...")
        
        print("\n🎉 Database setup completed successfully!")
        print("\n🚀 You can now run your Flask app:")
        print("   python app.py")
        print("\n🔗 Access points:")
        print("   - Fantasy Sports App: http://localhost:5000/fantasy-sports/")
        print("   - Player Gallery: http://localhost:5000/fantasy-sports/player-gallery")
        print("   - Admin Panel: http://localhost:5000/admin/")
        print("   - Main App: http://localhost:5000/")
        
        # Show enhanced stats
        with connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) as count FROM sports")
            sports_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM teams")
            teams_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM players")
            players_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM players WHERE photo_url IS NOT NULL")
            players_with_photos = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM player_props WHERE status = 'active'")
            props_count = cursor.fetchone()['count']
            
            # Get some sample MLB stars
            cursor.execute("""
                SELECT CONCAT(p.first_name, ' ', p.last_name) as name, t.city, t.name as team_name
                FROM players p
                JOIN teams t ON p.team_id = t.team_id
                WHERE p.last_name IN ('Ohtani', 'Judge', 'Soto', 'Betts')
                ORDER BY p.last_name
                LIMIT 4
            """)
            sample_players = cursor.fetchall()
            
            print(f"\n📊 Database contains:")
            print(f"   - {sports_count} sports")
            print(f"   - {teams_count} teams")
            print(f"   - {players_count} players ({players_with_photos} with photos)")
            print(f"   - {props_count} active props")
            
            if sample_players:
                print(f"\n⭐ Featured MLB Stars:")
                for player in sample_players:
                    print(f"   - {player['name']} ({player['city']} {player['team_name']})")
        
        print(f"\n🎯 Next Steps:")
        print("1. Run 'python app.py' to start the server")
        print("2. Visit the Player Gallery to see MLB stars with photos")
        print("3. Use the admin panel to simulate prop results")
        print("4. Try creating pick slips with the new players")
        
    except Exception as e:
        print(f"❌ Setup failed: {e}")
    finally:
        connection.close()
        print("\n🔐 Database connection closed")

if __name__ == "__main__":
    main()