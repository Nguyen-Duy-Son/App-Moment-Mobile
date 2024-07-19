class MomentModel{

  final String? userID;
  final String? image;
  final String? uploadLocation;
  final bool? isDeleted;
  final DateTime? createAt;
  final DateTime? updateAt;
  final String? momentID;
  final String? content;
  final String? weather;

  MomentModel({
    this.userID,
    this.image,
    this.uploadLocation,
    this.isDeleted,
    this.createAt,
    this.updateAt,
    this.momentID,
    this.content,
    this.weather
  });

  factory MomentModel.fromJson(Map<String, dynamic> json){
    return MomentModel(
      momentID: json['momentId'],
      userID: json['userId'],
      uploadLocation: json['uploadLocation'],
      isDeleted: json['isDeleted'],
      image: json['image'],
      // content: json['momentId'],
      // weather: json['momentId'],
      createAt: DateTime.parse(json['createdAt']),
      updateAt: DateTime.parse(json['updatedAt']),

    );
  }


}