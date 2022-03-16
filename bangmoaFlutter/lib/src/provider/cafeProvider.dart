import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:flutter/material.dart';

class CafeProvider extends ChangeNotifier {
  List<Cafe> _cafeList = [];
  List<String> regionList = ["홍대", "마포구", "신촌", "서대문구", "강남", "강남구", "서초구", "건대", "광진구", "대학로", "혜화", "종로구", "명동", "부산", "서면", "해운대", "인천", "부천", "대구", "동성로"];
  Map<String, List<String>> regionMapping = {
    "홍대" : ["홍대", "마포구"],
    "신촌" : ["신촌", "서대문구"],
    "강남" : ["강남", "강남구", "서초구"],
    "건대" : ["건대", "광진구"],
    "대학로" : ["대학로", "혜화", "종로구"],
    "명동" : ["명동"],
    "부산" : ["부산", "서면", "해운대"],
    "인천" : ["인천", "부천"],
    "대구" : ["대구", "동성로"],
  };

  List<Cafe> get getCafeList => _cafeList;

  void initCafeList(List<Cafe> cafeList) {
    _cafeList = cafeList;
  }

  List<Cafe> selectCafeByRegion(String inputRegion) {
    List<Cafe> selectedCafeList = [];
    if (inputRegion == "전체") {
      return _cafeList;
    } else if (inputRegion == "기타") {
      for (Cafe cafe in _cafeList){
        for (String regionName in regionList) {
          if (!cafe.name.contains(regionName) && !cafe.destination.contains(regionName)){
            selectedCafeList.add(cafe);
          }
        }
      }
    } else {
      List<String> regionSearchKey = regionMapping[inputRegion]!;
      for (var cafe in _cafeList) {
        for (String regionName in regionSearchKey) {
          if (cafe.name.contains(regionName) || cafe.destination.contains(regionName)) {
            selectedCafeList.add(cafe);
          }
        }
      }
    }
    return selectedCafeList;
  }

}