import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier{
	List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 二级导航高亮索引

  // 大类切换逻辑
  getChildCategory(List<BxMallSubDto> list) {
    
    childIndex = 0;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }
  
  // 改变二级当行索引
  changeChildIndex(index) {
    childIndex = index;
    notifyListeners();
  }
}