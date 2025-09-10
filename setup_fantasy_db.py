#!/usr/bin/env python3
"""
Database setup script for Fantasy Sports App
Run this script to create and populate the database with sample data
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
        with open(file_path, 'r') as file:
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
    print("🏆 Fantasy Sports Database Setup")
    print("=" * 50)
    
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
        print("\n🌱 Inserting seed data...")
        if not execute_sql_file(connection, 'database/fantasy_sports_seed_data.sql', 'Seed data insertion'):
            return
        
        print("\n🎉 Database setup completed successfully!")
        print("\n🚀 You can now run your Flask app:")
        print("   python app.py")
        print("\n🔗 Access points:")
        print("   - Fantasy Sports App: http://localhost:5000/fantasy-sports/")
        print("   - Admin Panel: http://localhost:5000/admin/")
        print("   - Main App: http://localhost:5000/")
        
        # Show some stats
        with connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) as count FROM sports")
            sports_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM teams")
            teams_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM players")
            players_count = cursor.fetchone()['count']
            
            cursor.execute("SELECT COUNT(*) as count FROM player_props WHERE status = 'active'")
            props_count = cursor.fetchone()['count']
            
            print(f"\n📊 Database contains:")
            print(f"   - {sports_count} sports")
            print(f"   - {teams_count} teams")
            print(f"   - {players_count} players")
            print(f"   - {props_count} active props")
        
    except Exception as e:
        print(f"❌ Setup failed: {e}")
    finally:
        connection.close()
        print("\n🔐 Database connection closed")

if __name__ == "__main__":
    main()