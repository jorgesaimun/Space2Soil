import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized audio service for background music and sound effects.
/// - Uses two players: one for music (looped) and one for SFX (one-shot).
/// - Persists volumes via SharedPreferences.
class AudioManager {
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;

  // Keys for persistence
  static const String _musicVolumeKey = 'music_volume';
  static const String _sfxVolumeKey = 'sfx_volume';

  // Default volumes
  static const double _defaultMusicVolume = 0.7;
  static const double _defaultSfxVolume = 0.8;

  late final AudioPlayer _musicPlayer;
  late final AudioPlayer _sfxPlayer;

  bool _initialized = false;
  double _musicVolume = _defaultMusicVolume;
  double _sfxVolume = _defaultSfxVolume;

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get isInitialized => _initialized;

  /// Call once on app startup.
  Future<void> init() async {
    if (_initialized) return;

    // Load persisted volumes
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _musicVolume = prefs.getDouble(_musicVolumeKey) ?? _defaultMusicVolume;
      _sfxVolume = prefs.getDouble(_sfxVolumeKey) ?? _defaultSfxVolume;
    } catch (e) {
      if (kDebugMode) {
        // Fallback to defaults if prefs not available
        print('AudioManager: Failed to load volumes: $e');
      }
      _musicVolume = _defaultMusicVolume;
      _sfxVolume = _defaultSfxVolume;
    }

    _musicPlayer = AudioPlayer(playerId: 'music_player');
    _sfxPlayer = AudioPlayer(playerId: 'sfx_player');

    // Apply initial volumes
    await _musicPlayer.setVolume(_musicVolume);
    await _sfxPlayer.setVolume(_sfxVolume);

    // Ensure music resumes loop after completion (on some platforms loop may need re-set)
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);

    _initialized = true;
  }

  /// Start or restart background music with looping.
  /// Provide asset path like 'assets/audios/game_music.mp3'.
  Future<void> playBackgroundMusic({required String assetPath}) async {
    if (!_initialized) {
      await init();
    }
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(_musicVolume);
      
      final source = AssetSource(_stripAssetPrefix(assetPath));
      await _musicPlayer.play(source);
    } catch (e) {
      if (kDebugMode) {
        print('AudioManager: Error playing background music: $e');
      }
    }
  }

  /// Play a sound effect (can be looped or one-shot).
  /// Provide asset path like 'assets/audios/music.mp3' (placeholder SFX).
  Future<void> playSfx({required String assetPath, bool loop = false}) async {
    if (!_initialized) {
      await init();
    }
    try {
      // Stop any currently playing SFX first
      await _sfxPlayer.stop();
      // Set release mode based on loop parameter
      await _sfxPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);
      await _sfxPlayer.setVolume(_sfxVolume);
      
      final source = AssetSource(_stripAssetPrefix(assetPath));
      await _sfxPlayer.play(source);
    } catch (e) {
      if (kDebugMode) {
        print('AudioManager: Error playing sfx: $e');
      }
    }
  }

  /// Update music volume (0.0 - 1.0) and persist.
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = _clamp01(volume);
    try {
      await _musicPlayer.setVolume(_musicVolume);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_musicVolumeKey, _musicVolume);
    } catch (e) {
      if (kDebugMode) {
        print('AudioManager: Failed setting music volume: $e');
      }
    }
  }

  /// Update SFX volume (0.0 - 1.0) and persist.
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = _clamp01(volume);
    try {
      await _sfxPlayer.setVolume(_sfxVolume);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_sfxVolumeKey, _sfxVolume);
    } catch (e) {
      if (kDebugMode) {
        print('AudioManager: Failed setting sfx volume: $e');
      }
    }
  }

  /// Stop all audio when needed (e.g., leaving game or app closing).
  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      await _sfxPlayer.stop();
    } catch (_) {}
  }

  /// Check if background music is currently playing
  bool get isMusicPlaying => _musicPlayer.state == PlayerState.playing;

  /// Check if SFX is currently playing
  bool get isSfxPlaying => _sfxPlayer.state == PlayerState.playing;

  /// Restart both audio files (useful when app resumes)
  Future<void> restartBothAudio() async {
    if (!_initialized) {
      await init();
    }
    
    // Restart background music
    await playBackgroundMusic(assetPath: 'assets/audios/game_music.mp3');
    
    // Restart SFX
    await playSfx(assetPath: 'assets/audios/music.mp3', loop: true);
  }

  /// Dispose players, typically on app exit.
  Future<void> dispose() async {
    try {
      await _musicPlayer.dispose();
      await _sfxPlayer.dispose();
    } catch (_) {}
    _initialized = false;
  }

  // Helpers
  String _stripAssetPrefix(String path) {
    // AssetSource expects relative path within assets directory when using audioplayers 6.x
    // If the full path was given, strip the leading 'assets/'.
    if (path.startsWith('assets/')) {
      return path.substring('assets/'.length);
    }
    return path;
  }

  double _clamp01(double v) => v.clamp(0.0, 1.0);
}


