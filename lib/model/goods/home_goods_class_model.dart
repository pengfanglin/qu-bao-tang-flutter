class HomeGoodsClassModel {
	int classId;
	String className;
	String classImg;

	HomeGoodsClassModel({this.classId, this.className, this.classImg});

	HomeGoodsClassModel.fromJson(Map<String, dynamic> json) {
		classId = json['classId'];
		className = json['className'];
		classImg = json['classImg'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['classId'] = this.classId;
		data['className'] = this.className;
		data['classImg'] = this.classImg;
		return data;
	}
}
