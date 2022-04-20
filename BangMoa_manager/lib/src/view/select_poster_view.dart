import 'dart:io';
import 'dart:typed_data';

import 'package:bangmoa_manager/src/provider/selected_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class SelectPosterView extends StatefulWidget {
  const SelectPosterView({Key? key}) : super(key: key);

  @override
  State<SelectPosterView> createState() => _SelectPosterViewState();
}

class _SelectPosterViewState extends State<SelectPosterView> {
  List<AssetEntity> everyMediaList = [];
  List<AssetEntity> currentMediaList = [];
  List<File> photoFiles = [];

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
    currentMediaList = everyMediaList;
  }

  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(hasAll: true);
      List<AssetEntity> media = await albums[0].getAssetListPaged(page: 0, size: 30);
      setState(() {
        everyMediaList.addAll(media);
      });
    }
  }

  _setPhotoFileList(List<AssetEntity> medias) async {
    for (int i = 0; i < medias.length; i++) {
      File? file = await medias[i].file; // image file
      photoFiles.add(file!);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (photoFiles.isEmpty) {
      _setPhotoFileList(currentMediaList);
    }

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('포스터 선택'),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              itemCount: currentMediaList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1,crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder(
                  future: currentMediaList[index].thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                  builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return InkWell(
                        child: Image.memory(snapshot.data!, fit: BoxFit.fill,),
                        onTap: () {
                          Provider.of<SelectedImageProvider>(context, listen: false).selectImage(photoFiles[index]);
                          Provider.of<SelectedImageProvider>(context, listen: false).select();
                        },
                      );
                    }
                    return Container();
                  }
                );
              }
            )
          ),
        ],
      ),
    );
  }
}
