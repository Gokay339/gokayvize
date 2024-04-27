import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/storage.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/page/boarding_item.dart';

import 'package:preload_page_view/preload_page_view.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final boardingData = [
    {
      "image": "assets/images/OIG4.jpg",
      "title": "Ne Alırsan Al !",
      "description": "E Ticaret Uygulaması",
    },
    {
      "image": "assets/images/resim.jpg",
      "title": "Ne Alırsan Al !",
      "description": "E Ticaret Uygulaması",
    },
    {
      "image": "assets/images/resim.jpg",
      "title": "Ne Alırsan Al !",
      "description": "E Ticaret Uygulaması",
    },
  ];
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: InkWell(
              onTap: () async {
                final storage = Storage();
                await storage.firstLauched();
                GoRouter.of(context).replace("/login");
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: page == 2 ? const Text("BİTTİ") : const Text("ATLA"),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: PreloadPageView.builder(
          itemCount: boardingData.length,
          preloadPagesCount: boardingData.length,
          onPageChanged: (value) {
            setState(() {
              page = value;
            });
          },
          itemBuilder: (context, index) => BoardingItem(
              image: boardingData[index]["image"]!,
              title: boardingData[index]["title"]!,
              description: boardingData[index]["description"]!),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Align(
          alignment: Alignment.center,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: boardingData.length,
            itemBuilder: (context, index) => Icon(page == index
                ? CupertinoIcons.circle_filled
                : CupertinoIcons.circle),
          ),
        ),
      ),
    );
  }
}
