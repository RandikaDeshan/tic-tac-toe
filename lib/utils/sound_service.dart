import 'package:just_audio/just_audio.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _bgPlayer = AudioPlayer();

  /// Play short effects
  Future<void> playEffect(String assetPath) async {
    try {
      await _player.setAsset(assetPath);
      _player.play();
    } catch (e) {
      print("Error playing effect: $e");
    }
  }

  /// Start looping background music
  Future<void> startBackground(String assetPath) async {
    try {
      await _bgPlayer.setAsset(assetPath);
      _bgPlayer.setLoopMode(LoopMode.all);
      _bgPlayer.play();
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> stopBackground() async {
    await _bgPlayer.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _bgPlayer.dispose();
  }
}
