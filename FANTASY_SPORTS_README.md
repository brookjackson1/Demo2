# Fantasy Sports App - PrizePicks Clone

A comprehensive fantasy sports application similar to PrizePicks, featuring player prop betting across multiple sports including Baseball, Basketball, Football, and Soccer (both college and professional levels).

## 🏆 Features

### Core Features
- **Multi-Sport Support**: Baseball, Basketball, Football, Soccer
- **College & Professional**: Support for both NCAA and professional leagues
- **Player Props**: Over/Under betting on player statistics
- **Pick Builder**: Interactive interface for creating pick slips
- **Real-time Updates**: Live prop odds and game information
- **Payout System**: Automated scoring and payout processing
- **Admin Panel**: Complete management interface

### Sports Supported
- **⚾ Baseball**: MLB, NCAA Baseball
- **🏀 Basketball**: NBA, NCAA Basketball  
- **🏈 Football**: NFL, NCAA Football
- **⚽ Soccer**: MLS, NCAA Soccer

### Prop Types by Sport
- **Football**: Passing Yards, Passing TDs, Rushing Yards, Receiving Yards, Receptions
- **Basketball**: Points, Rebounds, Assists, Steals, Blocks, 3-Pointers Made
- **Baseball**: Hits, RBIs, Home Runs, Strikeouts, Earned Runs
- **Soccer**: Goals, Assists, Shots on Goal, Saves

## 🚀 Getting Started

### Prerequisites
- Python 3.8+
- MySQL database
- pip (Python package manager)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd fantasy-sports-app
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Database Setup**
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit .env with your database credentials
   # Create your MySQL database first
   
   # Run setup script
   python setup_fantasy_db.py
   ```

5. **Run the application**
   ```bash
   python app.py
   ```

6. **Access the app**
   - Fantasy Sports App: http://localhost:5000/fantasy-sports/
   - Admin Panel: http://localhost:5000/admin/
   - Main Landing Page: http://localhost:5000/

## 📊 Database Schema

### Core Tables
- `sports` - Available sports (Baseball, Basketball, etc.)
- `leagues` - Sports leagues (NFL, NBA, NCAA, etc.)
- `teams` - Team information with colors and logos
- `players` - Player roster with positions and stats
- `games` - Game schedule and results
- `prop_types` - Types of props per sport
- `player_props` - Individual player propositions
- `users` - User accounts and balances
- `pick_slips` - User bet slips
- `picks` - Individual picks within slips
- `transactions` - Financial transaction history

## 🎮 How to Use

### For Users

1. **Browse Props**: Visit the main page and select a sport
2. **Build Picks**: Use the Pick Builder to select 2-6 player props
3. **Choose Over/Under**: Select whether you think the player will go over or under the line
4. **Set Entry Fee**: Choose how much to wager ($1-$1000)
5. **Submit Slip**: Submit your picks and wait for results

### Payout Structure (PrizePicks Style)
- 2 picks: 3x payout
- 3 picks: 5x payout  
- 4 picks: 10x payout
- 5 picks: 20x payout
- 6 picks: 50x payout

### For Admins

Access the admin panel at `/admin/` to:
- View pending pick slips
- Manually settle props with actual results
- Simulate results for demo purposes
- Manage games and update scores
- View user statistics and reports
- Adjust user balances

## 🔧 API Endpoints

### Fantasy Sports API
- `GET /fantasy-sports/api/props` - Get available props
- `GET /fantasy-sports/api/games` - Get upcoming games
- `POST /fantasy-sports/api/calculate-payout` - Calculate potential payout
- `POST /fantasy-sports/api/submit-slip` - Submit pick slip
- `GET /fantasy-sports/api/search/players` - Search players
- `GET /fantasy-sports/api/search/teams` - Search teams

### Admin API
- `POST /admin/api/settle-prop` - Manually settle a prop
- `POST /admin/api/simulate-results` - Simulate results for demo
- `POST /admin/api/update-game-status` - Update game status
- `POST /admin/api/adjust-user-balance` - Adjust user balance

## 🎯 Key Components

### Models (`app/models.py`)
- Complete ORM-style models for all database entities
- Query methods for common operations
- Relationship handling between sports, teams, players, etc.

### Scoring System (`app/scoring_system.py`)
- Automated prop settlement
- Pick result calculation
- Payout processing
- Game completion monitoring

### Blueprints
- `fantasy_sports.py` - Main user interface
- `admin.py` - Administrative functions
- `examples.py` - Original starter kit examples

### Templates
- Responsive design using Tailwind CSS
- Interactive JavaScript components
- Mobile-friendly interface
- Real-time updates

## 🔐 Security Features

- Input validation on all forms
- SQL injection protection via parameterized queries
- CSRF protection (Flask built-in)
- Balance verification before payouts
- Admin route protection (implement authentication as needed)

## 🧪 Demo Mode

The app includes demo functionality:
- **Simulate Results**: Generate random but realistic prop results
- **Sample Data**: Pre-loaded with NFL, NBA, MLB teams and players
- **Mock Games**: Sample upcoming games for testing

## 📈 Scaling Considerations

For production deployment:

1. **Authentication**: Implement user registration/login
2. **Real Data**: Integrate with sports data APIs (ESPN, The Odds API, etc.)
3. **Payment Processing**: Add Stripe/PayPal integration
4. **Caching**: Implement Redis for prop caching
5. **Background Jobs**: Use Celery for automated scoring
6. **Load Balancing**: Scale Flask with Gunicorn/uWSGI
7. **Database**: Consider PostgreSQL for production
8. **Monitoring**: Add logging and error tracking

## 🎨 Customization

### Adding New Sports
1. Insert sport in `sports` table
2. Add leagues in `leagues` table
3. Create prop types in `prop_types` table
4. Update templates with sport-specific styling

### Modifying Payout Structure
Edit the `payout_multipliers` dictionary in:
- `app/blueprints/fantasy_sports.py` (calculate_payout)
- Frontend JavaScript in pick builder

### Styling Changes
- Main styles: Tailwind CSS classes in templates
- Custom CSS: Add to individual template `{% block scripts %}`
- Colors: Modify team colors in database

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**
   - Check `.env` file credentials
   - Ensure MySQL server is running
   - Verify database exists

2. **Props Not Loading**
   - Check database has seed data
   - Verify games are scheduled in future
   - Check browser console for JS errors

3. **Pick Slip Submission Fails**
   - Ensure minimum 2 picks selected
   - Check entry fee is valid number
   - Verify database connection

### Debug Mode
```bash
# Run with debug enabled
export FLASK_ENV=development
python app.py
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review the code documentation
3. Open an issue on GitHub

---

**Note**: This is a demo/educational application. For production use, implement proper user authentication, real sports data integration, and payment processing.