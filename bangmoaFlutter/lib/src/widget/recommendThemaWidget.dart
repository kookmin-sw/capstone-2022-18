import 'package:bangmoa/src/models/themaModel.dart';
import 'package:flutter/material.dart';

Widget RecommendThemaWidget(BuildContext context, List<Thema> recommendThema) {
  if (recommendThema.isEmpty) {
    return Container();
  }
  else {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("추천 테마", style: TextStyle(fontSize: 15)),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(recommendThema[index].poster, height: 100, width: 70, fit: BoxFit.fill,),
                    );
                  },
                  itemCount: recommendThema.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}