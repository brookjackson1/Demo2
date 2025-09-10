from flask import Blueprint, render_template, request, jsonify, flash, redirect, url_for
from app.models import PlayerProp, Game, PickSlip
from app.scoring_system import ScoringSystem
import json

admin = Blueprint('admin', __name__)

@admin.route('/')
def dashboard():
    """Admin dashboard showing system overview"""
    scoring_system = ScoringSystem()
    
    # Get pending slips summary
    pending_slips = scoring_system.get_pending_slips_summary()
    
    # Get recent games
    game_model = Game()
    recent_games = game_model.get_upcoming_games(10)
    
    return render_template('admin/dashboard.html', 
                         pending_slips=pending_slips,
                         recent_games=recent_games)

@admin.route('/props')
def manage_props():
    """View and manage player props"""
    prop_model = PlayerProp()
    
    # Get active props
    active_props = prop_model.get_active_props(100)
    
    return render_template('admin/props.html', props=active_props)

@admin.route('/api/settle-prop', methods=['POST'])
def settle_prop():
    """Manually settle a prop"""
    data = request.get_json()
    prop_id = data.get('prop_id')
    actual_value = data.get('actual_value')
    
    if not prop_id or actual_value is None:
        return jsonify({
            'success': False,
            'message': 'Missing required fields'
        })
    
    try:
        scoring_system = ScoringSystem()
        success, message = scoring_system.manually_settle_prop(prop_id, float(actual_value))
        
        return jsonify({
            'success': success,
            'message': message
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        })

@admin.route('/api/simulate-results', methods=['POST'])
def simulate_results():
    """Simulate results for demo purposes"""
    try:
        scoring_system = ScoringSystem()
        
        # Get all active props
        prop_model = PlayerProp()
        active_props = prop_model.get_active_props(50)
        
        settled_count = 0
        for prop in active_props:
            # Simulate result
            actual_value = scoring_system.simulate_prop_result(prop)
            
            # Settle the prop
            success, message = scoring_system.manually_settle_prop(prop['prop_id'], actual_value)
            if success:
                settled_count += 1
        
        return jsonify({
            'success': True,
            'message': f'Simulated and settled {settled_count} props'
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        })

@admin.route('/slips')
def manage_slips():
    """View and manage pick slips"""
    slip_model = PickSlip()
    
    # Get recent slips (you'd want pagination in production)
    query = """
    SELECT ps.*, u.username,
           COUNT(p.pick_id) as total_picks,
           SUM(CASE WHEN p.result = 'win' THEN 1 ELSE 0 END) as wins,
           SUM(CASE WHEN p.result = 'loss' THEN 1 ELSE 0 END) as losses,
           SUM(CASE WHEN p.result = 'push' THEN 1 ELSE 0 END) as pushes,
           SUM(CASE WHEN p.result IS NULL THEN 1 ELSE 0 END) as pending_picks
    FROM pick_slips ps
    JOIN users u ON ps.user_id = u.user_id
    LEFT JOIN picks p ON ps.slip_id = p.slip_id
    GROUP BY ps.slip_id
    ORDER BY ps.submitted_at DESC
    LIMIT 50
    """
    
    try:
        slips = slip_model.execute_query(query)
    except:
        slips = []
    
    return render_template('admin/slips.html', slips=slips)

@admin.route('/games')
def manage_games():
    """View and manage games"""
    game_model = Game()
    
    # Get upcoming games
    upcoming_games = game_model.get_upcoming_games(20)
    
    return render_template('admin/games.html', games=upcoming_games)

@admin.route('/api/update-game-status', methods=['POST'])
def update_game_status():
    """Update game status"""
    data = request.get_json()
    game_id = data.get('game_id')
    status = data.get('status')
    home_score = data.get('home_score', 0)
    away_score = data.get('away_score', 0)
    
    if not game_id or not status:
        return jsonify({
            'success': False,
            'message': 'Missing required fields'
        })
    
    query = """
    UPDATE games 
    SET status = %s, home_team_score = %s, away_team_score = %s
    WHERE game_id = %s
    """
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(query, (status, home_score, away_score, game_id))
            g.db.commit()
            
        # If game is completed, trigger scoring
        if status == 'completed':
            scoring_system = ScoringSystem()
            scoring_system.settle_game_props(game_id)
            
        return jsonify({
            'success': True,
            'message': 'Game status updated successfully'
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        })

@admin.route('/users')
def manage_users():
    """View user statistics"""
    query = """
    SELECT u.user_id, u.username, u.email, u.balance, u.total_deposited, u.total_winnings,
           COUNT(ps.slip_id) as total_slips,
           SUM(CASE WHEN ps.status = 'won' THEN 1 ELSE 0 END) as won_slips,
           SUM(CASE WHEN ps.status = 'lost' THEN 1 ELSE 0 END) as lost_slips,
           SUM(CASE WHEN ps.status = 'pending' THEN 1 ELSE 0 END) as pending_slips
    FROM users u
    LEFT JOIN pick_slips ps ON u.user_id = ps.user_id
    WHERE u.active = TRUE
    GROUP BY u.user_id
    ORDER BY u.created_at DESC
    LIMIT 100
    """
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(query)
            users = cursor.fetchall()
    except:
        users = []
    
    return render_template('admin/users.html', users=users)

@admin.route('/api/adjust-user-balance', methods=['POST'])
def adjust_user_balance():
    """Adjust user balance (admin function)"""
    data = request.get_json()
    user_id = data.get('user_id')
    adjustment = data.get('adjustment')
    reason = data.get('reason', 'Admin adjustment')
    
    if not user_id or adjustment is None:
        return jsonify({
            'success': False,
            'message': 'Missing required fields'
        })
    
    try:
        adjustment = float(adjustment)
        
        # Update user balance
        balance_query = "UPDATE users SET balance = balance + %s WHERE user_id = %s"
        
        # Create transaction record
        transaction_query = """
        INSERT INTO transactions (user_id, transaction_type, amount, status, reference_id, completed_at)
        VALUES (%s, %s, %s, 'completed', %s, NOW())
        """
        
        transaction_type = 'deposit' if adjustment > 0 else 'withdrawal'
        
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(balance_query, (adjustment, user_id))
            cursor.execute(transaction_query, (user_id, transaction_type, abs(adjustment), reason))
            g.db.commit()
            
        return jsonify({
            'success': True,
            'message': f'Balance adjusted by ${adjustment}'
        })
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': str(e)
        })

@admin.route('/reports')
def reports():
    """Generate various reports"""
    
    # Daily summary report
    daily_summary_query = """
    SELECT DATE(ps.submitted_at) as date,
           COUNT(ps.slip_id) as total_slips,
           SUM(ps.entry_fee) as total_entries,
           SUM(CASE WHEN ps.status = 'won' THEN ps.actual_payout ELSE 0 END) as total_payouts,
           SUM(ps.entry_fee) - SUM(CASE WHEN ps.status = 'won' THEN ps.actual_payout ELSE 0 END) as net_revenue
    FROM pick_slips ps
    WHERE ps.submitted_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    GROUP BY DATE(ps.submitted_at)
    ORDER BY date DESC
    """
    
    # Popular props report
    popular_props_query = """
    SELECT pt.name as prop_type, COUNT(p.pick_id) as pick_count,
           AVG(pp.line_value) as avg_line,
           SUM(CASE WHEN p.result = 'win' THEN 1 ELSE 0 END) as wins,
           SUM(CASE WHEN p.result = 'loss' THEN 1 ELSE 0 END) as losses
    FROM picks p
    JOIN player_props pp ON p.prop_id = pp.prop_id
    JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
    WHERE p.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY pt.prop_type_id
    ORDER BY pick_count DESC
    LIMIT 10
    """
    
    try:
        from flask import g
        with g.db.cursor() as cursor:
            cursor.execute(daily_summary_query)
            daily_summary = cursor.fetchall()
            
            cursor.execute(popular_props_query)
            popular_props = cursor.fetchall()
    except:
        daily_summary = []
        popular_props = []
    
    return render_template('admin/reports.html', 
                         daily_summary=daily_summary,
                         popular_props=popular_props)