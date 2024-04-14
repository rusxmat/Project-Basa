import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:basa_proj_app/ui/screens/photo_gallery_screen.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';

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
