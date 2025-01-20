import 'dart:io';

import 'package:bloobin_app/features/recycle/data/recycle_repository.dart';
import 'package:bloobin_app/features/recycle/presentation/pages/confirmation_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecyclePage extends StatefulWidget {
  const RecyclePage({super.key});

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

class _RecyclePageState extends State<RecyclePage> {
  final RecycleRepository _recycleRepository = RecycleRepository();
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  File? _imageFile;
  late CameraDescription _camera;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print("No cameras found");
      return;
    }

    _camera = cameras.first;
    _cameraController = CameraController(
      _camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _initializeControllerFuture = _cameraController!.initialize().then((_) {
      _cameraController!.setFlashMode(FlashMode.off); // Ensure flash is off
    });

    setState(() {});
  }

  Future<void> _captureImage() async {
    if (_isCapturing ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) return;

    setState(() => _isCapturing = true);

    try {
      await _initializeControllerFuture;
      final XFile image = await _cameraController!.takePicture();
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(tempPath);

      setState(() {
        _imageFile = File(tempPath);
      });
    } catch (e) {
      print('Error taking picture: $e');
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      print("Uploading image: ${_imageFile!.path}");
      final result = await _recycleRepository.analyzeImage(_imageFile!);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationPage(
            imageFile: _imageFile!,
            recycleResult: result,
          ),
        ),
      ).then((_) {
        setState(() {
          _imageFile = null; // Reset after returning from confirmation page
        });
      });
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> _setFocus(TapDownDetails details) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition =
        renderBox.globalToLocal(details.globalPosition);
    final Size size = renderBox.size;

    final double x = localPosition.dx / size.width;
    final double y = localPosition.dy / size.height;

    if (x >= 0 && x <= 1 && y >= 0 && y <= 1) {
      try {
        await _cameraController!.setFocusPoint(Offset(x, y));
        await _cameraController!.setExposurePoint(Offset(x, y));
      } catch (e) {
        print("Focus error: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recycle")),
      body: Center(
        child: _imageFile == null
            ? FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GestureDetector(
                      onTapDown: _setFocus,
                      child: CameraPreview(_cameraController!),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            : Image.file(_imageFile!), // Show captured image
      ),
      floatingActionButton: _imageFile == null
          ? FloatingActionButton(
              heroTag: "capture",
              onPressed: _captureImage,
              child: _isCapturing
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.camera),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: "upload",
                  onPressed: _uploadImage,
                  label: const Text("Upload"),
                  icon: const Icon(Icons.upload),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.extended(
                  heroTag: "retake",
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                    });
                  },
                  label: const Text("Retake"),
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
