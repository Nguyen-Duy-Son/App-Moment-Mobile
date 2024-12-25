import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraService {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  /// Initializes the camera
  Future<void> initCamera(int direction) async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return; // Nếu đã khởi tạo thì không làm gì cả
    }

    try {
      // Get the list of available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        debugPrint("No cameras available");
        return;
      }

      // Create a CameraController for the specified direction
      _cameraController = CameraController(
        _cameras![direction],
        ResolutionPreset.high, // Choose resolution
        enableAudio: false,    // Disable audio
      );

      // Initialize the camera
      await _cameraController!.initialize();
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  /// Pause the camera preview
  Future<void> pausePreview() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.pausePreview();
      } catch (e) {
        debugPrint("Error pausing camera preview: $e");
      }
    }
  }

  /// Resume the camera preview
  Future<void> resumePreview() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        await _cameraController!.resumePreview();
      } catch (e) {
        debugPrint("Error resuming camera preview: $e");
      }
    }
  }

  /// Take a picture and save it to the specified path
  Future<XFile?> takePicture() async {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_cameraController!.value.isTakingPicture) {
      try {
        return await _cameraController!.takePicture();
      } catch (e) {
        debugPrint("Error taking picture: $e");
        return null;
      }
    }
    return null;
  }

  /// Switch to a different camera (front/back)
  Future<void> switchCamera(int direction) async {
    await disposeCamera(); // Dispose the current controller
    await initCamera(direction); // Initialize with new camera direction
  }

  /// Dispose the camera controller
  Future<void> disposeCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
    }
  }

  /// Get the CameraController instance
  CameraController? get cameraController => _cameraController;

  /// Check if the camera is initialized
  bool get isInitialized =>
      _cameraController != null && _cameraController!.value.isInitialized;
}
