class SocialUserModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? uId;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  SocialUserModel({
    this.name,
    this.email,
    this.password,
    this.phone,
    this.uId,
    this.bio,
    this.image,
    this.cover,
    this.isEmailVerified,
  });

  SocialUserModel.fromJson(Map<String, dynamic>? json){
    name= json!['name'];
    email= json['email'];
    password= json['password'];
    phone= json['phone'];
    uId= json['uId'];
    bio= json['bio'];
    image= json['image'];
    cover= json['cover'];
    isEmailVerified= json['isEmailVerified'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'email':email,
      'password':password,
      'phone':phone,
      'uId':uId,
      'bio':bio,
      'image':image,
      'cover':cover,
      'isEmailVerified':isEmailVerified,
    };
  }
}
