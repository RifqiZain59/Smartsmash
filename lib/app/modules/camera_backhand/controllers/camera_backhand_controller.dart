import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void logInfo(String msg) {
  if (kDebugMode) debugPrint('[INFO] $msg');
}

void logError(String msg) {
  if (kDebugMode) debugPrint('[ERROR] $msg');
}

class CameraBackhandController {
  late Interpreter interpreter;
  List<String> labels = [];

  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  ValueNotifier<bool> isCameraInitialized = ValueNotifier(false);
  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  ValueNotifier<String> predictedLabel = ValueNotifier('');
  ValueNotifier<double> predictedConfidence = ValueNotifier(0.0);
  ValueNotifier<double> accuracyPercentage = ValueNotifier(0.0);
  ValueNotifier<String> correctnessStatus = ValueNotifier('');
  ValueNotifier<double> accuracyValue = ValueNotifier(0.0);

  ValueNotifier<String> recordingCounter = ValueNotifier('00:00');
  int _elapsedSeconds = 0;
  Timer? _recordingTimer;

  bool _isProcessingFrame = false;
  final ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);

  // Variabel untuk waktu yang akan menghitung maju
  ValueNotifier<String> timeLeft = ValueNotifier(
    '00:00',
  ); // <-- Diubah menjadi ValueNotifier<String>

  static const double _displayConfidenceThreshold = 0.70;

  Future<void> initialize() async {
    try {
      await loadModel();
      await _startCameraSetup();
      logInfo("CameraBackhandController initialized successfully.");
    } catch (e) {
      logError("Error during CameraBackhandController initialization: $e");
      isCameraInitialized.value = false;
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      timeLeft.value = '00:00'; // <-- Diubah ke String
    }
  }

  @override
  Future<void> dispose() async {
    logInfo("Disposing CameraBackhandController...");
    await stopCamera();
    interpreter.close();
    await poseDetector.close();
    stopRecordingCounter();
    isCameraInitialized.dispose();
    predictedLabel.dispose();
    predictedConfidence.dispose();
    accuracyPercentage.dispose();
    correctnessStatus.dispose();
    accuracyValue.dispose();
    recordingCounter.dispose();
    isRecording.dispose();
    timeLeft.dispose(); // Dispose timeLeft
    logInfo("CameraBackhandController disposed.");
  }

  void toggleRecording() {
    isRecording.value = !isRecording.value;
    if (isRecording.value) {
      logInfo("Recording started.");
      startRecordingCounter();
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      // timeLeft akan diperbarui oleh startRecordingCounter
    } else {
      logInfo("Recording paused and reset.");
      stopRecordingCounter();
      _elapsedSeconds = 0;
      recordingCounter.value = '00:00';
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      timeLeft.value = '00:00'; // <-- Diubah ke String
    }
  }

  void startRecordingCounter() {
    _elapsedSeconds = 0;
    recordingCounter.value = '00:00';
    timeLeft.value = '00:00'; // <-- Diubah ke String
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      int minutes = _elapsedSeconds ~/ 60;
      int seconds = _elapsedSeconds % 60;

      // Update recordingCounter (format MM:SS)
      recordingCounter.value =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      // Update timeLeft (format MM:SS)
      timeLeft.value =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'; // <-- Langsung set ke String MM:SS
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
      final labelData = await rootBundle.loadString(
        'assets/labels/label_backhand.txt',
      );
      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();
      logInfo('Model loaded with ${labels.length} labels');
    } catch (e) {
      logError('Error loading model or labels: $e');
      rethrow;
    }
  }

  Future<void> _startCameraSetup() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        logError("No cameras found");
        isCameraInitialized.value = false;
        predictedLabel.value = '';
        accuracyPercentage.value = 0.0;
        correctnessStatus.value = '';
        accuracyValue.value = 0.0;
        timeLeft.value = '00:00'; // <-- Diubah ke String
        return;
      }
      await _initializeCamera(selectedCameraIndex);
    } catch (e) {
      logError("Error setting up camera: $e");
      isCameraInitialized.value = false;
      predictedLabel.value = '';
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      timeLeft.value = '00:00'; // <-- Diubah ke String
      rethrow;
    }
  }

  Future<void> stopCamera() async {
    try {
      if (cameraController != null &&
          cameraController!.value.isStreamingImages) {
        await cameraController!.stopImageStream();
      }
      if (cameraController != null) {
        await cameraController!.dispose();
      }
    } catch (e) {
      logError("Error stopping camera: $e");
    } finally {
      cameraController = null;
      isCameraInitialized.value = false;
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      stopRecordingCounter();
      isRecording.value = false;
      _elapsedSeconds = 0;
      recordingCounter.value = '00:00';
      timeLeft.value = '00:00'; // <-- Diubah ke String
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
    predictedLabel.value = '';
    predictedConfidence.value = 0.0;
    accuracyPercentage.value = 0.0;
    correctnessStatus.value = '';
    accuracyValue.value = 0.0;
    timeLeft.value = '00:00'; // <-- Diubah ke String

    if (cameraController != null) {
      if (cameraController!.value.isStreamingImages) {
        await cameraController!.stopImageStream();
      }
      await cameraController!.dispose();
      cameraController = null;
    }
    isCameraInitialized.value = false;

    await Future.delayed(const Duration(milliseconds: 300));

    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    try {
      await _initializeCamera(selectedCameraIndex);
      logInfo('Switched camera to ${cameras[selectedCameraIndex].name}');

      if (wasRecording) {
        isRecording.value = true;
        startRecordingCounter();
        predictedLabel.value = '';
        correctnessStatus.value = '';
      } else {
        _elapsedSeconds = 0;
        recordingCounter.value = '00:00';
        predictedLabel.value = '';
        accuracyPercentage.value = 0.0;
        correctnessStatus.value = '';
        accuracyValue.value = 0.0;
        timeLeft.value = '00:00'; // <-- Diubah ke String
      }
    } catch (e) {
      logError('Error switching camera: $e');
      isCameraInitialized.value = false;
      isRecording.value = false;
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      _elapsedSeconds = 0;
      recordingCounter.value = '00:00';
      timeLeft.value = '00:00'; // <-- Diubah ke String
    }
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    try {
      final camera = cameras[cameraIndex];
      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup:
            Platform.isAndroid
                ? ImageFormatGroup.nv21
                : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();

      if (!cameraController!.value.isInitialized) {
        throw Exception("Camera controller failed to initialize.");
      }

      await cameraController!.startImageStream(_processCameraImage);
      isCameraInitialized.value = true;
      logInfo('Camera initialized: ${camera.name}');
    } catch (e) {
      logError('Camera initialization error: $e');
      isCameraInitialized.value = false;
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
      timeLeft.value = '00:00'; // <-- Diubah ke String
      rethrow;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      logError(
        "Camera controller is not initialized for _inputImageFromCameraImage.",
      );
      return null;
    }

    final camera = cameraController!.description;
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
        InputImageRotation.rotation0deg;

    if (Platform.isAndroid && image.format.group == ImageFormatGroup.nv21) {
      return InputImage.fromBytes(
        bytes: image.planes[0].bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } else if (Platform.isIOS &&
        image.format.group == ImageFormatGroup.bgra8888) {
      final allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } else {
      final allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) {
        logError("Unsupported image format for ML Kit: ${image.format.raw}");
        return null;
      }

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!isRecording.value || _isProcessingFrame) return;

    _isProcessingFrame = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        logError("Failed to create InputImage from CameraImage.");
        predictedLabel.value = '';
        predictedConfidence.value = 0.0;
        accuracyPercentage.value = 0.0;
        correctnessStatus.value = '';
        accuracyValue.value = 0.0;
        return;
      }

      final poses = await poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) {
        final keypoints = <double>[];
        for (var lmType in PoseLandmarkType.values) {
          final lm = poses.first.landmarks[lmType];
          final normalizedX = lm?.x != null ? lm!.x / image.width : 0.0;
          final normalizedY = lm?.y != null ? lm!.y / image.height : 0.0;
          final normalizedZ = lm?.z != null ? lm!.z / 1000.0 : 0.0;
          keypoints.addAll([normalizedX, normalizedY, normalizedZ]);
        }

        final expectedKeypointsLength = interpreter.getInputTensor(0).shape[1];
        if (keypoints.length == expectedKeypointsLength) {
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
            predictedLabel.value =
                labels[maxIndex]; // Always display the label if detected
            predictedConfidence.value = maxValue;
            accuracyPercentage.value = maxValue * 100;
            accuracyValue.value = maxValue;

            if (maxValue >= _displayConfidenceThreshold) {
              correctnessStatus.value = 'Benar';
            } else {
              correctnessStatus.value = 'Salah';
            }

            logInfo(
              "Predicted pose: ${labels[maxIndex]} (Confidence: ${maxValue.toStringAsFixed(2)}) - Accuracy: ${accuracyPercentage.value.toStringAsFixed(0)}% - Status: ${correctnessStatus.value}",
            );
          } else {
            predictedLabel.value = '';
            predictedConfidence.value = 0.0;
            accuracyPercentage.value = 0.0;
            correctnessStatus.value = '';
            accuracyValue.value = 0.0;
            logError(
              "Predicted index out of bounds: $maxIndex (Labels count: ${labels.length})",
            );
          }
        } else {
          logError(
            "Keypoints length mismatch: Expected $expectedKeypointsLength, got ${keypoints.length}",
          );
          predictedLabel.value = '';
          predictedConfidence.value = 0.0;
          accuracyPercentage.value = 0.0;
          correctnessStatus.value = '';
          accuracyValue.value = 0.0;
        }
      } else {
        predictedLabel.value = '';
        predictedConfidence.value = 0.0;
        accuracyPercentage.value = 0.0;
        correctnessStatus.value = '';
        accuracyValue.value = 0.0;
      }
    } catch (e) {
      logError("Pose detection or inference error: $e");
      predictedLabel.value = '';
      predictedConfidence.value = 0.0;
      accuracyPercentage.value = 0.0;
      correctnessStatus.value = '';
      accuracyValue.value = 0.0;
    } finally {
      _isProcessingFrame = false;
    }
  }
}
