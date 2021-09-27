class CategoriesModel {

  String message;
  bool status;

  List<CategoryData> data;

  String error;

  CategoriesModel({this.message, this.status, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CategoriesModel.withError(String errorMessage) {
    error = errorMessage;
  }

}

class CategoryData {

  int id;
  String categoryName;
  String image;
  String status;
  String createdAt;
  String updatedAt;

  CategoryData(
      {this.id,
        this.categoryName,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }

}



/*
class CategoriesModel {

  String image;
  String name;

  CategoriesModel(this.image, this.name);
}
*/