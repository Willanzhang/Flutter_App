class CategoryModel {
	String mallCategoryId; // 类别编号
	String mallCategoryName; // 类别名称
	List<dynamic> bxMallSubDto;
	Null comments;
	String image;

	CategoryModel({
		this.mallCategoryId,
		this.mallCategoryName,
		this.bxMallSubDto,
		this.comments,
		this.image,
	});

	// 工厂构造模式 不用使用new 也是给 类添加一个fromJson的静态方法而已 fromJson是自己定义的
	factory CategoryModel.fromJson(dynamic json){
		return CategoryModel(
			mallCategoryId: json['mallCategoryId'],
			mallCategoryName: json['mallCategoryName'],
			bxMallSubDto: json['bxMallSubDto'],
			comments: json['comments'],
			image: json['image'],
		);
	}
}

class CategoryListModel {
	List<CategoryModel> data;
	CategoryListModel(this.data);

	factory CategoryListModel.fromJson(List json) {
		return CategoryListModel(
			// CategoryModel.fromJson((i))  这么写的原因是 CategoryModel？
			json.map((i)=>CategoryModel.fromJson(i)).toList()
		);
	}
}
