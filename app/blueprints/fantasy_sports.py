from flask import Blueprint, render_template, request, jsonify, session, redirect, url_for, flash
from app.models import (Sport, League, Team, Player, Game, PlayerProp, PropType, 
                       User, PickSlip, Pick)
import json
from decimal import Decimal

fantasy_sports = Blueprint('fantasy_sports', __name__)

@fantasy_sports.route('/')
def index():
    sport_model = Sport()
    sports = sport_model.get_all_active()
    return render_template('fantasy_sports/index.html', sports=sports)

@fantasy_sports.route('/sports/<int:sport_id>')
def sport_props(sport_id):
    sport_model = Sport()
    prop_model = PlayerProp()
    
    sport = sport_model.get_by_id(sport_id)
    if not sport:
        flash('Sport not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    props = prop_model.get_props_by_sport(sport_id, 50)
    
    return render_template('fantasy_sports/sport_props.html', 
                         sport=sport, props=props)

# Individual Sport Pages
@fantasy_sports.route('/nfl')
def nfl():
    """NFL specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('NFL')
    
    if not sport:
        flash('NFL not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/nfl.html', sport=sport)

@fantasy_sports.route('/nfl-props')
def nfl_props():
    """Direct NFL props display page"""
    sport_model = Sport()
    prop_model = PlayerProp()
    player_model = Player()
    
    sport = sport_model.get_by_short_name('NFL')
    if not sport:
        flash('NFL not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    # Get all NFL players with their team info
    players = player_model.get_players_by_sport('NFL')
    
    # Get all NFL props
    props = prop_model.get_props_by_sport(sport['sport_id'], 100)
    
    return render_template('fantasy_sports/nfl_props_display.html', 
                         sport=sport, players=players, props=props)

@fantasy_sports.route('/mlb')
def mlb():
    """MLB specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('MLB')
    
    if not sport:
        flash('MLB not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/mlb.html', sport=sport)

@fantasy_sports.route('/mlb-props')
def mlb_props():
    """Direct MLB props display page"""
    sport_model = Sport()
    prop_model = PlayerProp()
    player_model = Player()
    
    sport = sport_model.get_by_short_name('MLB')
    if not sport:
        flash('MLB not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    # Get all MLB players with their team info
    players = player_model.get_players_by_sport('MLB')
    
    # Get all MLB props
    props = prop_model.get_props_by_sport(sport['sport_id'], 100)
    
    return render_template('fantasy_sports/mlb_props_display.html', 
                         sport=sport, players=players, props=props)

@fantasy_sports.route('/nba')
def nba():
    """NBA specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('BBL')
    
    if not sport:
        flash('NBA not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/nba.html', sport=sport)

@fantasy_sports.route('/nhl')
def nhl():
    """NHL specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('NHL')
    
    if not sport:
        flash('NHL not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/nhl.html', sport=sport)

@fantasy_sports.route('/soccer')
def soccer():
    """Soccer specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('SOC')
    
    if not sport:
        flash('Soccer not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/soccer.html', sport=sport)

@fantasy_sports.route('/college-football')
def college_football():
    """College Football specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('CFB')
    
    if not sport:
        flash('College Football not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/college_football.html', sport=sport)

@fantasy_sports.route('/college-basketball')
def college_basketball():
    """College Basketball specific page"""
    sport_model = Sport()
    sport = sport_model.get_by_short_name('CBB')
    
    if not sport:
        flash('College Basketball not found', 'error')
        return redirect(url_for('fantasy_sports.index'))
    
    return render_template('fantasy_sports/sports/college_basketball.html', sport=sport)

@fantasy_sports.route('/api/props')
def get_props():
    sport_id = request.args.get('sport_id')
    game_id = request.args.get('game_id')
    limit = request.args.get('limit', 50, type=int)
    
    prop_model = PlayerProp()
    
    if sport_id:
        props = prop_model.get_props_by_sport(sport_id, limit)
    elif game_id:
        props = prop_model.get_props_by_game(game_id)
    else:
        props = prop_model.get_active_props(limit)
    
    return jsonify({
        'success': True,
        'props': props
    })

@fantasy_sports.route('/api/games')
def get_games():
    game_model = Game()
    upcoming_games = game_model.get_upcoming_games(20)
    
    return jsonify({
        'success': True,
        'games': upcoming_games
    })

@fantasy_sports.route('/pick-builder')
def pick_builder():
    sport_model = Sport()
    game_model = Game()
    
    sports = sport_model.get_all_active()
    upcoming_games = game_model.get_upcoming_games(10)
    
    return render_template('fantasy_sports/pick_builder.html', 
                         sports=sports, games=upcoming_games)

@fantasy_sports.route('/api/calculate-payout', methods=['POST'])
def calculate_payout():
    data = request.get_json()
    entry_fee = Decimal(str(data.get('entry_fee', 0)))
    num_picks = len(data.get('picks', []))
    
    if num_picks < 2:
        return jsonify({
            'success': False,
            'message': 'Minimum 2 picks required'
        })
    
    # PrizePicks-style payout multipliers
    payout_multipliers = {
        2: 3.0,   # 2 picks = 3x payout
        3: 5.0,   # 3 picks = 5x payout
        4: 10.0,  # 4 picks = 10x payout
        5: 20.0,  # 5 picks = 20x payout
        6: 50.0   # 6 picks = 50x payout
    }
    
    multiplier = payout_multipliers.get(num_picks, 1.0)
    potential_payout = entry_fee * Decimal(str(multiplier))
    
    return jsonify({
        'success': True,
        'potential_payout': float(potential_payout),
        'multiplier': multiplier,
        'num_picks': num_picks
    })

@fantasy_sports.route('/api/submit-slip', methods=['POST'])
def submit_slip():
    # For demo purposes, we'll create a simple submission
    # In production, you'd want proper user authentication
    
    data = request.get_json()
    
    # Mock user for demo
    user_id = 1  # In production, get from session/auth
    
    entry_fee = Decimal(str(data.get('entry_fee', 0)))
    picks_data = data.get('picks', [])
    
    if len(picks_data) < 2:
        return jsonify({
            'success': False,
            'message': 'Minimum 2 picks required'
        })
    
    # Calculate payout
    num_picks = len(picks_data)
    payout_multipliers = {2: 3.0, 3: 5.0, 4: 10.0, 5: 20.0, 6: 50.0}
    multiplier = payout_multipliers.get(num_picks, 1.0)
    potential_payout = entry_fee * Decimal(str(multiplier))
    
    try:
        # Create pick slip
        slip_model = PickSlip()
        slip_id = slip_model.create_slip(user_id, entry_fee, potential_payout, num_picks)
        
        if not slip_id:
            return jsonify({
                'success': False,
                'message': 'Failed to create pick slip'
            })
        
        # Add individual picks
        pick_model = Pick()
        for pick_data in picks_data:
            pick_model.create_pick(
                slip_id,
                pick_data['prop_id'],
                pick_data['selection'],
                Decimal(str(pick_data['line_value'])),
                Decimal(str(pick_data['odds']))
            )
        
        return jsonify({
            'success': True,
            'message': 'Pick slip submitted successfully!',
            'slip_id': slip_id,
            'potential_payout': float(potential_payout)
        })
        
    except Exception as e:
        print(f"Error submitting slip: {e}")
        return jsonify({
            'success': False,
            'message': 'Failed to submit pick slip'
        })

@fantasy_sports.route('/my-picks')
def my_picks():
    # Mock user for demo
    user_id = 1
    
    slip_model = PickSlip()
    slips = slip_model.get_user_slips(user_id, 10)
    
    return render_template('fantasy_sports/my_picks.html', slips=slips)

@fantasy_sports.route('/slip/<int:slip_id>')
def view_slip(slip_id):
    slip_model = PickSlip()
    slip = slip_model.get_slip_with_picks(slip_id)
    
    if not slip:
        flash('Pick slip not found', 'error')
        return redirect(url_for('fantasy_sports.my_picks'))
    
    return render_template('fantasy_sports/slip_detail.html', slip=slip)

@fantasy_sports.route('/sports')
def sports_list():
    sport_model = Sport()
    league_model = League()
    
    sports = sport_model.get_all_active()
    all_leagues = league_model.get_all_active()
    
    # Group leagues by sport
    leagues_by_sport = {}
    for league in all_leagues:
        sport_id = league['sport_id']
        if sport_id not in leagues_by_sport:
            leagues_by_sport[sport_id] = []
        leagues_by_sport[sport_id].append(league)
    
    return render_template('fantasy_sports/sports_list.html', 
                         sports=sports, leagues_by_sport=leagues_by_sport)

@fantasy_sports.route('/league/<int:league_id>')
def league_detail(league_id):
    league_model = League()
    team_model = Team()
    
    league = league_model.get_by_id(league_id)
    if not league:
        flash('League not found', 'error')
        return redirect(url_for('fantasy_sports.sports_list'))
    
    teams = team_model.get_by_league(league_id)
    
    return render_template('fantasy_sports/league_detail.html', 
                         league=league, teams=teams)

@fantasy_sports.route('/team/<int:team_id>')
def team_detail(team_id):
    team_model = Team()
    player_model = Player()
    
    team = team_model.get_by_id(team_id)
    if not team:
        flash('Team not found', 'error')
        return redirect(url_for('fantasy_sports.sports_list'))
    
    players = player_model.get_by_team(team_id)
    
    return render_template('fantasy_sports/team_detail.html', 
                         team=team, players=players)

@fantasy_sports.route('/player/<int:player_id>')
def player_detail(player_id):
    player_model = Player()
    
    player = player_model.get_by_id(player_id)
    if not player:
        flash('Player not found', 'error')
        return redirect(url_for('fantasy_sports.sports_list'))
    
    return render_template('fantasy_sports/player_detail.html', player=player)

@fantasy_sports.route('/api/search/players')
def search_players():
    query = request.args.get('q', '').strip()
    
    if len(query) < 2:
        return jsonify({
            'success': False,
            'message': 'Search query too short'
        })
    
    player_model = Player()
    players = player_model.search_by_name(query)
    
    return jsonify({
        'success': True,
        'players': players
    })

@fantasy_sports.route('/api/search/teams')
def search_teams():
    query = request.args.get('q', '').strip()
    
    if len(query) < 2:
        return jsonify({
            'success': False,
            'message': 'Search query too short'
        })
    
    team_model = Team()
    teams = team_model.search_by_name(query)
    
    return jsonify({
        'success': True,
        'teams': teams
    })

@fantasy_sports.route('/player-gallery')
def player_gallery():
    """Player gallery page"""
    return render_template('fantasy_sports/player_gallery.html')

@fantasy_sports.route('/api/players')
def get_players():
    """Get all players with enhanced data for gallery"""
    sport_id = request.args.get('sport_id')
    team_id = request.args.get('team_id')
    position = request.args.get('position')
    include_photos = request.args.get('include_photos', 'false').lower() == 'true'
    limit = request.args.get('limit', 100, type=int)
    
    query = """
    SELECT p.*, t.name as team_name, t.short_name as team_short_name,
           t.city as team_city, t.primary_color, t.secondary_color,
           l.name as league_name, s.name as sport_name
    FROM players p
    LEFT JOIN teams t ON p.team_id = t.team_id
    LEFT JOIN leagues l ON t.league_id = l.league_id
    LEFT JOIN sports s ON l.sport_id = s.sport_id
    WHERE p.active = TRUE
    """
    params = []
    
    if sport_id:
        query += " AND s.sport_id = %s"
        params.append(sport_id)
    
    if team_id:
        query += " AND t.team_id = %s"
        params.append(team_id)
        
    if position:
        query += " AND p.position LIKE %s"
        params.append(f"%{position}%")
    
    query += " ORDER BY p.last_name, p.first_name LIMIT %s"
    params.append(limit)
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(query, params)
            players = cursor.fetchall()
            
        return jsonify({
            'success': True,
            'players': players
        })
        
    except Exception as e:
        print(f"Error getting players: {e}")
        return jsonify({
            'success': False,
            'message': 'Failed to load players'
        })

@fantasy_sports.route('/api/teams')
def get_teams():
    """Get all teams for filters"""
    sport_id = request.args.get('sport_id')
    
    query = """
    SELECT t.*, l.name as league_name, s.name as sport_name
    FROM teams t
    JOIN leagues l ON t.league_id = l.league_id
    JOIN sports s ON l.sport_id = s.sport_id
    WHERE t.active = TRUE
    """
    params = []
    
    if sport_id:
        query += " AND s.sport_id = %s"
        params.append(sport_id)
    
    query += " ORDER BY s.name, l.name, t.city, t.name"
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(query, params)
            teams = cursor.fetchall()
            
        return jsonify({
            'success': True,
            'teams': teams
        })
        
    except Exception as e:
        print(f"Error getting teams: {e}")
        return jsonify({
            'success': False,
            'message': 'Failed to load teams'
        })

@fantasy_sports.route('/api/player-props')
def get_player_props():
    """Get props for a specific player"""
    player_id = request.args.get('player_id')
    
    if not player_id:
        return jsonify({
            'success': False,
            'message': 'Player ID required'
        })
    
    query = """
    SELECT pp.*, 
           p.first_name, p.last_name, p.position,
           pt.name as prop_type_name, pt.unit,
           g.game_date,
           ht.name as home_team_name, ht.short_name as home_team_short,
           at.name as away_team_name, at.short_name as away_team_short
    FROM player_props pp
    JOIN players p ON pp.player_id = p.player_id
    JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
    JOIN games g ON pp.game_id = g.game_id
    JOIN teams ht ON g.home_team_id = ht.team_id
    JOIN teams at ON g.away_team_id = at.team_id
    WHERE pp.player_id = %s AND pp.status = 'active' AND g.game_date > NOW()
    ORDER BY g.game_date ASC, pt.name
    """
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(query, (player_id,))
            props = cursor.fetchall()
            
        return jsonify({
            'success': True,
            'props': props
        })
        
    except Exception as e:
        print(f"Error getting player props: {e}")
        return jsonify({
            'success': False,
            'message': 'Failed to load props'
        })

@fantasy_sports.route('/api/prop-types')
def get_prop_types():
    """Get prop types for a specific sport"""
    sport_id = request.args.get('sport_id')
    
    if not sport_id:
        return jsonify({
            'success': False,
            'message': 'Sport ID required'
        })
    
    query = """
    SELECT pt.*, s.name as sport_name
    FROM prop_types pt
    JOIN sports s ON pt.sport_id = s.sport_id
    WHERE pt.sport_id = %s AND pt.active = TRUE
    ORDER BY pt.name
    """
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(query, (sport_id,))
            prop_types = cursor.fetchall()
            
        return jsonify({
            'success': True,
            'prop_types': prop_types
        })
        
    except Exception as e:
        print(f"Error getting prop types: {e}")
        return jsonify({
            'success': False,
            'message': 'Failed to load prop types'
        })

# Error handlers
@fantasy_sports.errorhandler(404)
def not_found_error(error):
    return render_template('fantasy_sports/404.html'), 404

@fantasy_sports.errorhandler(500)
def internal_error(error):
    return render_template('fantasy_sports/500.html'), 500