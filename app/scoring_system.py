from decimal import Decimal
from flask import g
import pymysql.cursors
from datetime import datetime
from app.models import PickSlip, Pick, PlayerProp, User

class ScoringSystem:
    def __init__(self):
        self.db = g.db
    
    def settle_completed_games(self):
        """
        Check for completed games and settle all associated props
        This would typically be run as a scheduled job
        """
        # Get all completed games that haven't been processed
        query = """
        SELECT DISTINCT g.game_id, g.home_team_score, g.away_team_score
        FROM games g
        JOIN player_props pp ON g.game_id = pp.game_id
        WHERE g.status = 'completed' AND pp.status = 'active'
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query)
                completed_games = cursor.fetchall()
                
                for game in completed_games:
                    self.settle_game_props(game['game_id'])
                    
        except Exception as e:
            print(f"Error checking completed games: {e}")
    
    def settle_game_props(self, game_id):
        """
        Settle all props for a specific game
        """
        # Get all active props for this game
        query = """
        SELECT pp.*, pt.name as prop_type_name
        FROM player_props pp
        JOIN prop_types pt ON pp.prop_type_id = pt.prop_type_id
        WHERE pp.game_id = %s AND pp.status = 'active'
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (game_id,))
                props = cursor.fetchall()
                
                for prop in props:
                    # In a real app, you'd fetch actual stats from an API
                    # For demo purposes, we'll simulate some results
                    actual_value = self.simulate_prop_result(prop)
                    
                    # Update the prop with actual value
                    self.update_prop_result(prop['prop_id'], actual_value)
                    
                    # Update all picks for this prop
                    self.settle_picks_for_prop(prop['prop_id'], prop['line_value'], actual_value)
                    
        except Exception as e:
            print(f"Error settling game props: {e}")
    
    def simulate_prop_result(self, prop):
        """
        Simulate actual stat results for demo purposes
        In production, this would fetch real stats from a sports data API
        """
        import random
        
        line_value = float(prop['line_value'])
        prop_type = prop['prop_type_name'].lower()
        
        # Simulate realistic values based on prop type
        if 'points' in prop_type:
            # Basketball points: usually 15-35
            actual_value = random.uniform(max(0, line_value - 10), line_value + 15)
        elif 'yards' in prop_type:
            # Football yards: can vary widely
            actual_value = random.uniform(max(0, line_value - 50), line_value + 75)
        elif 'rebounds' in prop_type:
            # Basketball rebounds: usually 5-15
            actual_value = random.uniform(max(0, line_value - 3), line_value + 6)
        elif 'assists' in prop_type:
            # Assists: usually 3-12
            actual_value = random.uniform(max(0, line_value - 2), line_value + 5)
        elif 'hits' in prop_type:
            # Baseball hits: usually 0-4
            actual_value = random.randint(0, max(4, int(line_value + 2)))
        elif 'strikeouts' in prop_type:
            # Pitcher strikeouts: usually 4-12
            actual_value = random.uniform(max(0, line_value - 3), line_value + 4)
        else:
            # Default: vary around the line
            actual_value = random.uniform(max(0, line_value - 2), line_value + 3)
        
        return round(actual_value, 1)
    
    def update_prop_result(self, prop_id, actual_value):
        """
        Update a prop with the actual result
        """
        query = """
        UPDATE player_props 
        SET actual_value = %s, status = 'settled'
        WHERE prop_id = %s
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (actual_value, prop_id))
                self.db.commit()
        except Exception as e:
            print(f"Error updating prop result: {e}")
            self.db.rollback()
    
    def settle_picks_for_prop(self, prop_id, line_value, actual_value):
        """
        Settle all picks for a specific prop
        """
        # Get all picks for this prop
        query = """
        SELECT p.*, ps.slip_id, ps.user_id
        FROM picks p
        JOIN pick_slips ps ON p.slip_id = ps.slip_id
        WHERE p.prop_id = %s AND p.result IS NULL
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (prop_id,))
                picks = cursor.fetchall()
                
                for pick in picks:
                    result = self.determine_pick_result(
                        pick['selection'], 
                        float(line_value), 
                        actual_value
                    )
                    
                    # Update pick result
                    self.update_pick_result(pick['pick_id'], result)
                    
                # Check if any slips are now completely settled
                affected_slips = list(set([pick['slip_id'] for pick in picks]))
                for slip_id in affected_slips:
                    self.check_and_settle_slip(slip_id)
                    
        except Exception as e:
            print(f"Error settling picks for prop: {e}")
    
    def determine_pick_result(self, selection, line_value, actual_value):
        """
        Determine if a pick won, lost, or pushed
        """
        if actual_value > line_value:
            return 'win' if selection == 'over' else 'loss'
        elif actual_value < line_value:
            return 'win' if selection == 'under' else 'loss'
        else:
            return 'push'  # Exact tie
    
    def update_pick_result(self, pick_id, result):
        """
        Update a pick with its result
        """
        query = "UPDATE picks SET result = %s WHERE pick_id = %s"
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (result, pick_id))
                self.db.commit()
        except Exception as e:
            print(f"Error updating pick result: {e}")
            self.db.rollback()
    
    def check_and_settle_slip(self, slip_id):
        """
        Check if a slip is completely settled and process payout
        """
        # Get slip details and all picks
        slip_query = """
        SELECT ps.*, COUNT(p.pick_id) as total_picks,
               SUM(CASE WHEN p.result IS NOT NULL THEN 1 ELSE 0 END) as settled_picks,
               SUM(CASE WHEN p.result = 'win' THEN 1 ELSE 0 END) as wins,
               SUM(CASE WHEN p.result = 'loss' THEN 1 ELSE 0 END) as losses,
               SUM(CASE WHEN p.result = 'push' THEN 1 ELSE 0 END) as pushes
        FROM pick_slips ps
        JOIN picks p ON ps.slip_id = p.slip_id
        WHERE ps.slip_id = %s AND ps.status = 'pending'
        GROUP BY ps.slip_id
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(slip_query, (slip_id,))
                slip_data = cursor.fetchone()
                
                if not slip_data:
                    return
                
                # Check if all picks are settled
                if slip_data['settled_picks'] != slip_data['total_picks']:
                    return  # Not all picks are settled yet
                
                # Determine slip outcome
                required_wins = slip_data['num_picks']
                actual_wins = slip_data['wins']
                pushes = slip_data['pushes']
                
                # Handle pushes (reduce required wins)
                effective_required_wins = required_wins - pushes
                
                if actual_wins >= effective_required_wins and effective_required_wins > 0:
                    # Winner!
                    self.process_winning_slip(slip_id, slip_data)
                else:
                    # Loser
                    self.process_losing_slip(slip_id)
                    
        except Exception as e:
            print(f"Error checking slip settlement: {e}")
    
    def process_winning_slip(self, slip_id, slip_data):
        """
        Process a winning slip - update status and credit user
        """
        payout_amount = slip_data['potential_payout']
        
        # Update slip status
        settle_query = """
        UPDATE pick_slips 
        SET status = 'won', actual_payout = %s, settled_at = NOW()
        WHERE slip_id = %s
        """
        
        # Update user balance
        balance_query = """
        UPDATE users 
        SET balance = balance + %s, total_winnings = total_winnings + %s
        WHERE user_id = %s
        """
        
        # Create transaction record
        transaction_query = """
        INSERT INTO transactions (user_id, transaction_type, amount, status, slip_id, completed_at)
        VALUES (%s, 'payout', %s, 'completed', %s, NOW())
        """
        
        try:
            with self.db.cursor() as cursor:
                # Update slip
                cursor.execute(settle_query, (payout_amount, slip_id))
                
                # Update user balance
                cursor.execute(balance_query, (payout_amount, payout_amount, slip_data['user_id']))
                
                # Create transaction
                cursor.execute(transaction_query, (slip_data['user_id'], payout_amount, slip_id))
                
                self.db.commit()
                
                print(f"Slip {slip_id} won! Paid out ${payout_amount}")
                
        except Exception as e:
            print(f"Error processing winning slip: {e}")
            self.db.rollback()
    
    def process_losing_slip(self, slip_id):
        """
        Process a losing slip - just update status
        """
        query = """
        UPDATE pick_slips 
        SET status = 'lost', settled_at = NOW()
        WHERE slip_id = %s
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (slip_id,))
                self.db.commit()
                
                print(f"Slip {slip_id} lost")
                
        except Exception as e:
            print(f"Error processing losing slip: {e}")
            self.db.rollback()
    
    def manually_settle_prop(self, prop_id, actual_value):
        """
        Manually settle a prop with a specific value (admin function)
        """
        # Get prop details
        query = "SELECT * FROM player_props WHERE prop_id = %s"
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query, (prop_id,))
                prop = cursor.fetchone()
                
                if not prop:
                    return False, "Prop not found"
                
                if prop['status'] != 'active':
                    return False, "Prop is not active"
                
                # Update prop
                self.update_prop_result(prop_id, actual_value)
                
                # Settle picks
                self.settle_picks_for_prop(prop_id, prop['line_value'], actual_value)
                
                return True, "Prop settled successfully"
                
        except Exception as e:
            print(f"Error manually settling prop: {e}")
            return False, str(e)
    
    def get_pending_slips_summary(self):
        """
        Get summary of all pending slips
        """
        query = """
        SELECT ps.slip_id, ps.user_id, ps.entry_fee, ps.potential_payout, ps.num_picks,
               COUNT(p.pick_id) as total_picks,
               SUM(CASE WHEN p.result IS NOT NULL THEN 1 ELSE 0 END) as settled_picks,
               SUM(CASE WHEN p.result = 'win' THEN 1 ELSE 0 END) as wins
        FROM pick_slips ps
        JOIN picks p ON ps.slip_id = p.slip_id
        WHERE ps.status = 'pending'
        GROUP BY ps.slip_id
        ORDER BY ps.submitted_at DESC
        """
        
        try:
            with self.db.cursor() as cursor:
                cursor.execute(query)
                return cursor.fetchall()
        except Exception as e:
            print(f"Error getting pending slips: {e}")
            return []