# Database Setup Instructions

The database relationship fix script is ready, but we need to configure the database connection first.

## Step 1: Set up Database Connection

1. **Copy the environment file:**
   ```bash
   copy .env.example .env
   ```

2. **Edit the .env file with your database credentials:**
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=fantasy_sports_db
   ```

## Step 2: Create the Database

Make sure you have a MySQL database created. Connect to MySQL and run:
```sql
CREATE DATABASE fantasy_sports_db;
```

## Step 3: Run the Database Fix

Once your .env file is configured and the database exists, run:
```bash
python fix_database_relationships.py
```

This script will:
1. Fix sports and leagues data relationships
2. Properly link NFL teams and players
3. Properly link MLB teams and players  
4. Verify all data is correctly connected

## Step 4: Test the Application

After the fix script runs successfully, start your Flask app:
```bash
python app.py
```

Then visit:
- NFL Page: http://localhost:5000/fantasy-sports/nfl
- MLB Page: http://localhost:5000/fantasy-sports/mlb

Your NFL and MLB players should now be visible on their respective sport pages.

## Troubleshooting

If you get database connection errors:
1. Make sure MySQL server is running
2. Check your database credentials in the .env file
3. Verify the database exists
4. Test the connection with a MySQL client

The fix script will show you exactly what data was loaded and verified once it runs successfully.