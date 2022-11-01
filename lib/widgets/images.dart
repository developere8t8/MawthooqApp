import 'dart:io';
import 'package:flutter/material.dart';

class ImagesCollection extends StatefulWidget {
  //final String imgPath;
  final int index;
  final List<File?> img;
  const ImagesCollection({super.key, required this.img, required this.index});

  @override
  State<ImagesCollection> createState() => _ImagesCollectionState();
}

class _ImagesCollectionState extends State<ImagesCollection> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60,
          width: 60,
          margin: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: widget.img.length > 1
                ? Image.file(
                    widget.img[widget.index]!,
                    fit: BoxFit.fill,
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: const Color(0xFF128383).withOpacity(0.15),
                    ),
                  ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 32,
            top: 28,
            right: 0,
            child: IconButton(
                onPressed: () {
                  if (widget.img.length > 1) {
                    setState(() {
                      widget.img.removeAt(widget.index);
                    });
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )))
      ],
    );
  }
}
