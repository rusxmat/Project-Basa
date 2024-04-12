import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:basa_proj_app/ui/screens/photo_gallery_screen.dart';

class IbasaScreen extends StatefulWidget {
  @override
  _IbasaScreenState createState() => _IbasaScreenState();
}

class _IbasaScreenState extends State<IbasaScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<XFile>? _capturedImages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    // Create a CameraController
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.max,
    );

    // Initialize the controller future
    _initializeControllerFuture = _controller!.initialize();

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
      } catch (e) {
        print('Error capturing photo: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _capturePhoto,
                    child: const Text('Capture Photo'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoGalleryScreen(
                            photos: _capturedImages!,
                          ),
                        ),
                      );
                    },
                    child: const Text('Done'),
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

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// // import 'package:path_provider/path_provider.dart';

// class IbasaScreen extends StatefulWidget {
//   @override
//   _IbasaScreenState createState() => _IbasaScreenState();
// }

// class _IbasaScreenState extends State<IbasaScreen> {
//   CameraController? _controller;
//   Future<void>? _initializeControllerFuture;
//   List<CameraDescription>? _cameras;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     // Get available cameras
//     _cameras = await availableCameras();

//     // Initialize controller for the first camera (or handle selection)
//     if (_cameras!.isNotEmpty) {
//       _controller = CameraController(_cameras![0], ResolutionPreset.medium);
//       _initializeControllerFuture = _controller!.initialize();
//       setState(() {});
//     } else {
//       // Handle no cameras available scenario
//       print('No cameras found on device');
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_initializeControllerFuture == null) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return FutureBuilder<void>(
//       future: _initializeControllerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             children: [
//               // Display camera preview
//               CameraPreview(_controller!),
//               // Add your button or widget for camera selection (optional)
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
