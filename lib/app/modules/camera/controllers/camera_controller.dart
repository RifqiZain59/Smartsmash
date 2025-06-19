// smartsmashapp/app/modules/camera/controllers/camera_controller.dart

import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void logInfo(String msg) => debugPrint('[INFO] $msg');
void logError(String msg) => debugPrint('[ERROR] $msg');

class PoseCameraController {
  late Interpreter interpreter;
  List<String> labels = [];

  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  ValueNotifier<bool> isCameraInitialized = ValueNotifier(false);
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  ValueNotifier<String> predictedLabel = ValueNotifier('unknown');
  ValueNotifier<double> predictedConfidence = ValueNotifier(0.0);
  ValueNotifier<String> correctnessStatus = ValueNotifier('...');

  // --- ENSURE THIS IS ValueNotifier<String> ---
  ValueNotifier<String> recordingCounter = ValueNotifier('00:00');
  int _elapsedSeconds = 0; // This is an internal int, which is fine
  Timer? _recordingTimer;

  bool _isProcessingFrame = false;
  final ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);

  static const double correctnessThreshold = 0.8;

  Future<void> initialize() async {
    await loadModel();
    await _startCameraSetup();
  }

  @override
  Future<void> dispose() async {
    await stopCamera();
    interpreter.close();
    await poseDetector.close();
    stopRecordingCounter();
    isCameraInitialized.dispose();
    predictedLabel.dispose();
    predictedConfidence.dispose();
    correctnessStatus.dispose();
    recordingCounter.dispose(); // Ensure this disposes the String notifier
    isRecording.dispose();
  }

  void toggleRecording() {
    isRecording.value = !isRecording.value;
    if (isRecording.value) {
      logInfo("Recording started.");
      startRecordingCounter();
      predictedLabel.value = 'Detecting...';
      predictedConfidence.value = 0.0;
      correctnessStatus.value = '...';
    } else {
      logInfo("Recording paused and reset.");
      stopRecordingCounter();
      _elapsedSeconds = 0; // Reset internal counter
      recordingCounter.value = '00:00'; // Reset displayed time (String)
      predictedLabel.value = 'Paused';
      predictedConfidence.value = 0.0;
      correctnessStatus.value = 'Paused';
    }
  }

  void startRecordingCounter() {
    _elapsedSeconds = 0; // Reset the internal counter
    recordingCounter.value = '00:00'; // Set initial display to String
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      int minutes = _elapsedSeconds ~/ 60;
      int seconds = _elapsedSeconds % 60;
      // Ensure the value assigned is a String
      recordingCounter.value =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  void stopRecordingCounter() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(
        'assets/models/body_model.tflite',
        options: InterpreterOptions()..threads = 2,
      );
      final labelData = await rootBundle.loadString('assets/labels/label.txt');
      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();
      logInfo('Model loaded with ${labels.length} labels');
    } catch (e) {
      logError('Error loading model: $e');
    }
  }

  Future<void> _startCameraSetup() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        logError("No cameras found");
        return;
      }
      await _initializeCamera(selectedCameraIndex);
    } catch (e) {
      logError("Error setting up camera: $e");
      isCameraInitialized.value = false;
    }
  }

  Future<void> stopCamera() async {
    try {
      await cameraController?.stopImageStream();
      await cameraController?.dispose();
    } catch (e) {
      logError("Error stopping camera: $e");
    } finally {
      cameraController = null;
      isCameraInitialized.value = false;
      predictedLabel.value = 'unknown';
      predictedConfidence.value = 0.0;
      correctnessStatus.value = 'Stopped';
      stopRecordingCounter();
      isRecording.value = false;
      _elapsedSeconds = 0; // Reset internal counter
      recordingCounter.value = '00:00'; // Reset displayed time (String)
    }
  }

  Future<void> switchCamera() async {
    if (cameras.length < 2) {
      logInfo("Only one camera available, cannot switch.");
      return;
    }
    bool wasRecording = isRecording.value;
    stopRecordingCounter();
    isRecording.value = false;
    predictedLabel.value = 'Switching...';
    predictedConfidence.value = 0.0;
    correctnessStatus.value = 'Switching...';

    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    try {
      await cameraController?.stopImageStream();
      await cameraController?.dispose();
      cameraController = null;
      isCameraInitialized.value = false;
      await Future.delayed(const Duration(milliseconds: 300));
      await _initializeCamera(selectedCameraIndex);
      logInfo('Switched camera to ${cameras[selectedCameraIndex].name}');
      if (wasRecording) {
        isRecording.value = true;
        startRecordingCounter(); // Restart timer from 00:00 if it was recording
        predictedLabel.value = 'Detecting...';
        correctnessStatus.value = '...';
      } else {
        _elapsedSeconds = 0; // Reset internal counter if paused
        recordingCounter.value = '00:00'; // Reset displayed time if paused
        predictedLabel.value = 'Paused';
        correctnessStatus.value = 'Paused';
      }
    } catch (e) {
      logError('Error switching camera: $e');
      isCameraInitialized.value = false;
      isRecording.value = false;
      predictedLabel.value = 'Error';
      predictedConfidence.value = 0.0;
      correctnessStatus.value = 'Error';
      _elapsedSeconds = 0; // Reset on error
      recordingCounter.value = '00:00'; // Reset on error
    }
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    try {
      final camera = cameras[cameraIndex];
      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await cameraController!.initialize();
      cameraController!.startImageStream(_processCameraImage);
      isCameraInitialized.value = true;
      logInfo('Camera initialized: ${camera.name}');
    } catch (e) {
      logError('Camera initialization error: $e');
      isCameraInitialized.value = false;
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!isRecording.value || _isProcessingFrame) return;
    _isProcessingFrame = true;

    try {
      final allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final rotation =
          InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) {
        logError("Unsupported image format: ${image.format.raw}");
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) {
        final keypoints = <double>[];
        for (var lmType in PoseLandmarkType.values) {
          final lm = poses.first.landmarks[lmType];
          keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
        }

        if (keypoints.length == 99) {
          final input = [keypoints];
          final outputTensor = interpreter.getOutputTensor(0);
          final output = List.generate(
            1,
            (_) => List.filled(outputTensor.shape[1], 0.0),
          );

          interpreter.run(input, output);

          final predictions = output[0];
          final maxValue = predictions.reduce(max);
          final maxIndex = predictions.indexWhere((e) => e == maxValue);

          if (maxIndex >= 0 && maxIndex < labels.length) {
            predictedLabel.value = labels[maxIndex];
            predictedConfidence.value = maxValue;

            if (maxValue >= correctnessThreshold) {
              correctnessStatus.value = 'Benar';
            } else {
              correctnessStatus.value = 'Salah';
            }

            // *** AKTIFKAN BARIS INI UNTUK MUNCUL DI TERMINAL ***
            logInfo(
              "Predicted pose: ${labels[maxIndex]} (Confidence: ${maxValue.toStringAsFixed(2)}) - Status: ${correctnessStatus.value}",
            );
          } else {
            predictedLabel.value = 'unknown (invalid index)';
            predictedConfidence.value = 0.0;
            correctnessStatus.value = 'N/A';
          }
        } else {
          // *** AKTIFKAN BARIS INI JUGA JIKA INGIN MELIHAT ERROR KEYPOINTS ***
          logError(
            "Keypoints length mismatch: Expected 99, got ${keypoints.length}",
          );
          predictedLabel.value = 'unknown (keypoints mismatch)';
          predictedConfidence.value = 0.0;
          correctnessStatus.value = 'Error';
        }
      } else {
        predictedLabel.value = 'No pose detected';
        predictedConfidence.value = 0.0;
        correctnessStatus.value = 'No pose';
      }
    } catch (e) {
      logError("Pose detection or inference error: $e");
    } finally {
      _isProcessingFrame = false;
    }
  }
}
