import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class GameDataService {
  static final SupabaseClient _supabase = SupabaseService.client;
  
  // Example: Save player score
  static Future<void> savePlayerScore({
    required String playerName,
    required int score,
    required String gameMode,
  }) async {
    try {
      await _supabase
          .from('player_scores')
          .insert({
            'player_name': playerName,
            'score': score,
            'game_mode': gameMode,
            'created_at': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      print('Error saving player score: $e');
      rethrow;
    }
  }
  
  // Example: Get top scores
  static Future<List<Map<String, dynamic>>> getTopScores({
    String? gameMode,
    int limit = 10,
  }) async {
    try {
      var query = _supabase
          .from('player_scores')
          .select('*');
      
      if (gameMode != null) {
        query = query.eq('game_mode', gameMode);
      }
      
      final response = await query
          .order('score', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching top scores: $e');
      rethrow;
    }
  }
  
  // Example: Save game progress
  static Future<void> saveGameProgress({
    required String playerId,
    required Map<String, dynamic> progressData,
  }) async {
    try {
      await _supabase
          .from('game_progress')
          .upsert({
            'player_id': playerId,
            'progress_data': progressData,
            'updated_at': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      print('Error saving game progress: $e');
      rethrow;
    }
  }
  
  // Example: Get game progress
  static Future<Map<String, dynamic>?> getGameProgress(String playerId) async {
    try {
      final response = await _supabase
          .from('game_progress')
          .select('*')
          .eq('player_id', playerId)
          .single();
      
      return response;
    } catch (e) {
      print('Error fetching game progress: $e');
      return null;
    }
  }
}
