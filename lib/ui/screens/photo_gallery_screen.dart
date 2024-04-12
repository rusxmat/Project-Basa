import 'dart:io';
import 'package:basa_proj_app/ui/screens/book_create_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryScreen extends StatefulWidget {
  List<XFile> photos;
  PhotoGalleryScreen({super.key, required this.photos});

  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  List<XFile> photos = [];
  bool isSelecting = false;
  List<bool> selectedPhotos = [];

  @override
  void initState() {
    super.initState();
    photos = widget.photos;
    selectedPhotos = List<bool>.filled(photos.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
        actions: [
          IconButton(
            icon: (!isSelecting) ? Icon(Icons.select_all) : Icon(Icons.close),
            onPressed: () {
              setState(() {
                isSelecting = !isSelecting; // Toggle the selection mode
              });
            },
          ),
          (isSelecting)
              ? IconButton(
                  onPressed: () {
                    setState(
                      () {
                        List<XFile> selected = [];
                        for (int i = 0; i < selectedPhotos.length; i++) {
                          if (selectedPhotos[i]) {
                            selected.add(photos[i]);
                          }
                        }
                        setState(() {
                          photos
                              .removeWhere((photo) => selected.contains(photo));
                          selectedPhotos =
                              List<bool>.filled(photos.length, false);
                          isSelecting = false; // Reset the selection mode
                        });
                      },
                    );
                  },
                  icon: Icon(Icons.delete))
              : Container(),
        ],
      ),
      body: ReorderableGridView.count(
        dragEnabled: !isSelecting,
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: List.generate(
          photos.length,
          (index) {
            return GestureDetector(
              key: ValueKey(photos[index]),
              onTap: (isSelecting)
                  ? () {
                      setState(() {
                        selectedPhotos[index] = !selectedPhotos[index];
                      });
                    }
                  : null,
              child: Image.file(
                File(photos[index].path),
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(
                    ((isSelecting && selectedPhotos[index]) || !isSelecting)
                        ? 1.0
                        : 0.5),
              ),
            );
          },
        ),
        onReorder: (oldIndex, newIndex) {
          setState(
            () {
              final element = photos.removeAt(oldIndex);
              photos.insert(newIndex, element);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookCreateScreen(
                photos: photos,
              ),
            ),
          );
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
