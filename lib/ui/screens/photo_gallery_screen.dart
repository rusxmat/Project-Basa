import 'dart:io';
import 'package:basa_proj_app/ui/screens/book_create_screen.dart';
import 'package:basa_proj_app/ui/widgets/custom_floatingaction_btn.dart';
import 'package:basa_proj_app/ui/widgets/nophotos_warning_card.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';

class PhotoGalleryScreen extends StatefulWidget {
  final List<XFile> photos;
  const PhotoGalleryScreen({super.key, required this.photos});

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

  void _submitPhotos() {
    if (photos.isEmpty) {
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookCreateScreen(
          photos: photos,
        ),
      ),
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BookCreateScreen(
    //       photos: photos,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantUI.customYellow,
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
          'Mga Larawan',
          style: TextStyle(
            fontFamily: ITIM_FONTNAME,
            color: Colors.white,
          ),
        ),
        actions: [
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
                  icon: const Icon(
                    Icons.delete,
                    color: ConstantUI.customPink,
                  ))
              : Container(),
          IconButton(
            disabledColor: Colors.grey,
            icon: (!isSelecting)
                ? const Icon(
                    Icons.select_all,
                    color: ConstantUI.customYellow,
                  )
                : const Icon(
                    Icons.close,
                    color: ConstantUI.customYellow,
                  ),
            onPressed: (photos.isNotEmpty)
                ? () {
                    setState(() {
                      isSelecting = !isSelecting; // Toggle the selection mode
                    });
                  }
                : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
        child: (photos.isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: const EdgeInsets.all(10),
                child: ReorderableGridView.count(
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
                                  selectedPhotos[index] =
                                      !selectedPhotos[index];
                                });
                              }
                            : null,
                        child: Image.file(
                          File(photos[index].path),
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(
                              ((isSelecting && selectedPhotos[index]) ||
                                      !isSelecting)
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
              )
            : const NoPhotosWarningCard(),
      ),
      floatingActionButton: CustomFloatingAction(
        btnIcon: FORWARD_ICON,
        onPressed: (photos.isNotEmpty) ? _submitPhotos : null,
        btnColor: Colors.white,
      ),
    );
  }
}
