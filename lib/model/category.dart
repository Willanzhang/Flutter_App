// class CategoryModel {
// 	String mallCategoryId; // 类别编号
// 	String mallCategoryName; // 类别名称
// 	List<dynamic> bxMallSubDto;
// 	Null comments;
// 	String image;

// 	CategoryModel({
// 		this.mallCategoryId,
// 		this.mallCategoryName,
// 		this.bxMallSubDto,
// 		this.comments,
// 		this.image,
// 	});

// 	// 工厂构造模式 不用使用new 也是给 类添加一个fromJson的静态方法而已 fromJson是自己定义的
// 	factory CategoryModel.fromJson(dynamic json){
// 		return CategoryModel(
// 			mallCategoryId: json['mallCategoryId'],
// 			mallCategoryName: json['mallCategoryName'],
// 			bxMallSubDto: json['bxMallSubDto'],
// 			comments: json['comments'],
// 			image: json['image'],
// 		);
// 	}
// }

// class CategoryListModel {
// 	List<CategoryModel> data;
// 	CategoryListModel(this.data);

// 	factory CategoryListModel.fromJson(List json) {
// 		return CategoryListModel(
// 			// CategoryModel.fromJson((i))  这么写的原因是 CategoryModel？
// 			json.map((i)=>CategoryModel.fromJson(i)).toList()
// 		);
// 	}
// }


class CategoryModel {
  String code;
  String message;
  List<CategoryData> data;

  CategoryModel({this.code, this.message, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CategoryData>();
      json['data'].forEach((v) {
        data.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  String mallCategoryId;
  String mallCategoryName;
  List<BxMallSubDto> bxMallSubDto;
  Null comments;
  String image;

  CategoryData(
      {this.mallCategoryId,
      this.mallCategoryName,
      this.bxMallSubDto,
      this.comments,
      this.image});

  CategoryData.fromJson(Map<String, dynamic> json) {
    mallCategoryId = json['mallCategoryId'];
    mallCategoryName = json['mallCategoryName'];
    if (json['bxMallSubDto'] != null) {
      bxMallSubDto = new List<BxMallSubDto>();
      json['bxMallSubDto'].forEach((v) {
        bxMallSubDto.add(new BxMallSubDto.fromJson(v));
      });
    }
    comments = json['comments'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallCategoryId'] = this.mallCategoryId;
    data['mallCategoryName'] = this.mallCategoryName;
    if (this.bxMallSubDto != null) {
      data['bxMallSubDto'] = this.bxMallSubDto.map((v) => v.toJson()).toList();
    }
    data['comments'] = this.comments;
    data['image'] = this.image;
    return data;
  }
}

class BxMallSubDto {
  String mallSubId;
  String mallCategoryId;
  String mallSubName;
  String comments;

  BxMallSubDto(
      {this.mallSubId, this.mallCategoryId, this.mallSubName, this.comments});

  BxMallSubDto.fromJson(Map<String, dynamic> json) {
    mallSubId = json['mallSubId'];
    mallCategoryId = json['mallCategoryId'];
    mallSubName = json['mallSubName'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallSubId'] = this.mallSubId;
    data['mallCategoryId'] = this.mallCategoryId;
    data['mallSubName'] = this.mallSubName;
    data['comments'] = this.comments;
    return data;
  }
}