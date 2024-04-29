import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:basa_proj_app/ui/screens/photo_gallery_screen.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:audioplayers/audioplayers.dart';

class IbasaScreen extends StatefulWidget {
  @override
  _IbasaScreenState createState() => _IbasaScreenState();
}

class _IbasaScreenState extends State<IbasaScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<XFile>? _capturedImages = [];

  AnimationController? _captureController;
  Animation<double>? _captureAnimation;
  AudioPlayer _cameraShutterPlayer = AudioPlayer();

  Future<void> playCaptureSound() async {
    await _cameraShutterPlayer.play(AssetSource('audio/camera_click.mp3'));
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _captureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _captureAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_captureController!);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // Create a CameraController
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.max,
      enableAudio: true,
    );

    // Initialize the controller future
    _initializeControllerFuture = _controller!.initialize();
    _controller!.setFlashMode(FlashMode.off);

    // Rebuild the widget when controller is initialized
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the controller when widget is disposed
    _controller?.dispose();
    super.dispose();
  }

  void _capturePhoto() async {
    if (_controller!.value.isInitialized) {
      try {
        final XFile capturedImage = await _controller!.takePicture();
        setState(() {
          _capturedImages!.add(capturedImage);
        });
        _captureController!.forward();
        await playCaptureSound();
        await Future.delayed(const Duration(milliseconds: 150));
        _captureController!.reverse();
      } catch (e) {
        print('Error capturing photo: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeControllerFuture == null) {
      return const Center(child: CIRCULAR_PROGRESS_INDICATOR);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: ConstantUI.customYellow,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ConstantUI.customBlue,
        title: const Text(
          'Kamera',
          style: TextStyle(
            fontFamily: ITIM_FONTNAME,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: ConstantUI.customYellow,
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Center(
            child: FadeTransition(
              opacity: _captureAnimation!,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 70.0, vertical: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  CustomFloatingAction(
                    btnIcon: const Icon(
                      Icons.circle,
                      color: ConstantUI.customBlue,
                      size: 50,
                    ),
                    onPressed: _capturePhoto,
                    btnColor: Colors.white,
                  ),
                  const Spacer(),
                  CustomFloatingAction(
                    btnIcon: FORWARD_ICON,
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoGalleryScreen(
                            photos: _capturedImages!,
                          ),
                        ),
                      );
                      // _initializeCamera();
                    },
                    btnColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
