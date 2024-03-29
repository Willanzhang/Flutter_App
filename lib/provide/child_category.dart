import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier{
	List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 二级导航高亮索引
  String categoryId = '4'; // 大类id 默认4是白酒的
  String subId = ''; // 小类id
  int page = 1; // 列表页页数
  String noMoreText = ''; // 显示没有数据的文字
  

  // 大类切换逻辑
  getChildCategory(List<BxMallSubDto> list, String id) {
    page = 1;
    noMoreText = '';
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
  changeChildIndex(index, String id) {
    page = 1;
    noMoreText = '';
    childIndex = index;
    subId = id;
    notifyListeners();
  }

  // 增加page的方法
  addPage() {
    page++;
    notifyListeners();
  }

  changeNoMoreText(String text) {
    noMoreText = text;
    notifyListeners();
  }
}