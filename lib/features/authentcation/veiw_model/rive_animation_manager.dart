import 'package:cureta/core/constants/animation_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveAnimationManager extends ChangeNotifier {
  Artboard? _artboard;
  late RiveAnimationController _controllerIdle;
  late RiveAnimationController _controllerHandsUp;
  late RiveAnimationController _controllerHandsDown;
  late RiveAnimationController _controllerLookLeft;
  late RiveAnimationController _controllerLookRight;
  late RiveAnimationController _controllerSuccess;
  late RiveAnimationController _controllerFail;

  bool _isLookingLeft = false;
  bool _isLookingRight = false;

  Artboard? get artboard => _artboard;

  RiveAnimationManager() {
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    _controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    _controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    _controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    _controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    _controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    _controllerFail = SimpleAnimation(AnimationEnum.fail.name);
  }

  Future<void> initialize() async {
    try {
      final data = await rootBundle.load('assets/images/login_animation.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(_controllerIdle);
      _artboard = artboard;

      notifyListeners(); // Only notify listeners when artboard loads

      debugPrint("✅ Rive artboard loaded successfully");
    } catch (e) {
      debugPrint("❌ Rive file load error: $e");
    }
  }

  void _removeAllControllers() {
    _artboard?.removeController(_controllerIdle);
    _artboard?.removeController(_controllerHandsUp);
    _artboard?.removeController(_controllerHandsDown);
    _artboard?.removeController(_controllerLookLeft);
    _artboard?.removeController(_controllerLookRight);
    _artboard?.removeController(_controllerSuccess);
    _artboard?.removeController(_controllerFail);
    _isLookingLeft = false;
    _isLookingRight = false;
  }

  void _playAnimation(RiveAnimationController controller) {
    _removeAllControllers();
    _artboard?.addController(controller);
  }

  void handleEmailChange(String value) {
    if (value.isNotEmpty && value.length < 16 && !_isLookingLeft) {
      _playAnimation(_controllerLookLeft);
      _isLookingLeft = true;
      _isLookingRight = false;
    } else if (value.isNotEmpty && value.length > 16 && !_isLookingRight) {
      _playAnimation(_controllerLookRight);
      _isLookingLeft = false;
      _isLookingRight = true;
    }
  }

  void playHandsUp() => _playAnimation(_controllerHandsUp);
  void playHandsDown() => _playAnimation(_controllerHandsDown);
  void playSuccess() => _playAnimation(_controllerSuccess);
  void playFail() => _playAnimation(_controllerFail);

  @override
  void dispose() {
    _removeAllControllers();
    super.dispose();
  }
}