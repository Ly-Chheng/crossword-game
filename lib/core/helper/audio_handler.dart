import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioController extends GetxController {
  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _effectsPlayer;
  
  // Reactive state variables
  final RxBool _isPlaying = false.obs;
  final RxBool _isPaused = false.obs;
  final RxString _currentTrack = ''.obs;
  final RxDouble _volume = 1.0.obs;
  final RxBool _isGloballyPaused = false.obs;
  final RxBool _isMuted = false.obs;
  final RxBool _isBackgroundMusicDisabled = false.obs;
  final RxBool _isSoundEffectsDisabled = false.obs;
  
  // Store volume before muting
  double _volumeBeforeMute = 1.0;
  
  // Getters for reactive state
  bool get isPlaying => _isPlaying.value;
  bool get isPaused => _isPaused.value;
  String get currentTrack => _currentTrack.value;
  double get volume => _volume.value;
  bool get isGloballyPaused => _isGloballyPaused.value;
  bool get isMuted => _isMuted.value;
  bool get isBackgroundMusicDisabled => _isBackgroundMusicDisabled.value;
  bool get isSoundEffectsDisabled => _isSoundEffectsDisabled.value;

  @override
  void onInit() {
    super.onInit();
    _backgroundPlayer = AudioPlayer();
    _effectsPlayer = AudioPlayer();
    _initializePlayerListeners();
  }

  void _initializePlayerListeners() {
    // Listen to background player state changes
    _backgroundPlayer.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
      _isPaused.value = state.processingState == ProcessingState.ready && !state.playing;
    });
  }

  // Play sound effects (won't interrupt background music)
  Future<void> soundEffect(String audioPath, {bool loop = false, double volume = 1.0}) async {
    if (audioPath.isEmpty) {
      log("Error: Audio path is empty");
      return;
    }
    
    // Don't play sound effects if globally paused, muted, or sound effects disabled
    if (_isGloballyPaused.value || _isMuted.value || _isSoundEffectsDisabled.value) {
      log("Sound effects disabled: globally paused, muted, or sound effects turned off");
      return;
    }
    
    try {
      await _effectsPlayer.setAsset(audioPath);
      await _effectsPlayer.play();
    } catch (e) {
      log("Error playing soundEffect: $e");
    }
  }

  // Start background music or long-playing sounds
  Future<void> startSound(String audioPath, {bool loop = false, double volume = 1.0}) async {
    if (audioPath.isEmpty) {
      log("Error: Audio path is empty");
      return;
    }
    
    // Don't start background music if it's disabled globally
    if (_isBackgroundMusicDisabled.value) {
      log("Background music is disabled globally");
      return;
    }
    
    try {
      await _backgroundPlayer.setVolume(volume);
      await _backgroundPlayer.setAsset(audioPath);
      
      // Set loop mode
      await _backgroundPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      
      // Only play if not globally paused
      if (!_isGloballyPaused.value) {
        await _backgroundPlayer.play();
      }
      
      _currentTrack.value = audioPath;
      _volume.value = volume;
    } catch (e) {
      log("Error starting sound: $e");
    }
  }

  Future<void> pauseSound() async {
    try {
      await _backgroundPlayer.pause();
    } catch (e) {
      log("Error pausing sound: $e");
    }
  }

  Future<void> resumeSound() async {
    try {
      // Only resume if not globally paused
      if (!_isGloballyPaused.value) {
        await _backgroundPlayer.play();
      }
    } catch (e) {
      log("Error resuming sound: $e");
    }
  }

  Future<void> stopSound() async {
    try {
      await _backgroundPlayer.stop();
      _currentTrack.value = '';
    } catch (e) {
      log("Error stopping sound: $e");
    }
  }

  // GLOBAL PAUSE FUNCTIONALITY FOR ALL GAME SCREENS
  
  /// Pause all audio across the entire game
  Future<void> pauseAllSounds() async {
    try {
      _isGloballyPaused.value = true;
      
      // Pause background music
      if (_backgroundPlayer.playing) {
        await _backgroundPlayer.pause();
      }
      
      // Stop any currently playing sound effects
      if (_effectsPlayer.playing) {
        await _effectsPlayer.stop();
      }
      
      log("All sounds paused globally");
    } catch (e) {
      log("Error pausing all sounds: $e");
    }
  }
  
  /// Pause only background music (sound effects will continue to work)
  Future<void> pauseAllSoundsBackground() async {
    try {
      _isBackgroundMusicDisabled.value = true;
      
      // Pause current background music
      if (_backgroundPlayer.playing) {
        await _backgroundPlayer.pause();
      }
      
      log("Background music disabled globally (sound effects still active)");
    } catch (e) {
      log("Error disabling background music: $e");
    }
  }
  
  /// Resume only background music
  Future<void> resumeAllSoundsBackground() async {
    try {
      _isBackgroundMusicDisabled.value = false;
      
      // Resume background music if there was a track playing and not globally paused
      if (_currentTrack.value.isNotEmpty && !_backgroundPlayer.playing && !_isGloballyPaused.value) {
        await _backgroundPlayer.play();
      }
      
      log("Background music enabled globally");
    } catch (e) {
      log("Error enabling background music: $e");
    }
  }
  
  /// Disable sound effects globally
  Future<void> disableSoundEffects() async {
    try {
      _isSoundEffectsDisabled.value = true;
      
      // Stop any currently playing sound effects
      if (_effectsPlayer.playing) {
        await _effectsPlayer.stop();
      }
      
      log("Sound effects disabled globally");
    } catch (e) {
      log("Error disabling sound effects: $e");
    }
  }
  
  /// Enable sound effects globally  
  Future<void> enableSoundEffects() async {
    try {
      _isSoundEffectsDisabled.value = false;
      log("Sound effects enabled globally");
    } catch (e) {
      log("Error enabling sound effects: $e");
    }
  }
  
  /// Resume all audio across the entire game
  Future<void> resumeAllSounds() async {
    try {
      _isGloballyPaused.value = false;
      
      // Resume background music if there was a track playing
      if (_currentTrack.value.isNotEmpty && !_backgroundPlayer.playing) {
        await _backgroundPlayer.play();
      }
      
      log("All sounds resumed globally");
    } catch (e) {
      log("Error resuming all sounds: $e");
    }
  }
  
  /// Toggle global pause/resume
  Future<void> toggleGlobalPause() async {
    if (_isGloballyPaused.value) {
      await resumeAllSounds();
    } else {
      await pauseAllSounds();
    }
  }
  
  /// Mute all audio (including sound effects)
  Future<void> muteAll() async {
    try {
      if (!_isMuted.value) {
        _volumeBeforeMute = _volume.value;
        await _backgroundPlayer.setVolume(0);
        await _effectsPlayer.setVolume(0);
        _isMuted.value = true;
        log("All audio muted");
      }
    } catch (e) {
      log("Error muting all audio: $e");
    }
  }
  
  /// Unmute all audio
  Future<void> unmuteAll() async {
    try {
      if (_isMuted.value) {
        await _backgroundPlayer.setVolume(_volumeBeforeMute);
        await _effectsPlayer.setVolume(1.0);
        _volume.value = _volumeBeforeMute;
        _isMuted.value = false;
        log("All audio unmuted");
      }
    } catch (e) {
      log("Error unmuting all audio: $e");
    }
  }
  
  /// Toggle mute/unmute for all audio
  Future<void> toggleMuteAll() async {
    if (_isMuted.value) {
      await unmuteAll();
    } else {
      await muteAll();
    }
  }

  // Volume control
  Future<void> setVolume(double volume) async {
    try {
      volume = volume.clamp(0.0, 1.0);
      await _backgroundPlayer.setVolume(volume);
      _volume.value = volume;
      
      // Update stored volume for unmute functionality
      if (!_isMuted.value) {
        _volumeBeforeMute = volume;
      }
    } catch (e) {
      log("Error setting volume: $e");
    }
  }

  // Seek functionality
  Future<void> seekTo(Duration position) async {
    try {
      await _backgroundPlayer.seek(position);
    } catch (e) {
      log("Error seeking: $e");
    }
  }

  // Get current position
  Stream<Duration> get positionStream => _backgroundPlayer.positionStream;
  
  // Get duration
  Stream<Duration?> get durationStream => _backgroundPlayer.durationStream;

  // Original mute/unmute for background music only
  Future<void> toggleMute() async {
    try {
      final currentVolume = _backgroundPlayer.volume;
      if (currentVolume > 0) {
        await _backgroundPlayer.setVolume(0);
      } else {
        await _backgroundPlayer.setVolume(_volume.value);
      }
    } catch (e) {
      log("Error toggling mute: $e");
    }
  }

  void buttonClick() {
    soundEffect('assets/audio/btn_effect_2.mp3');
  }

  void soundLevelUp() {
    soundEffect('assets/audio/sound_level_up.mp3');
  }

  @override
  void onClose() {
    _backgroundPlayer.dispose();
    _effectsPlayer.dispose();
    super.onClose();
  }
}