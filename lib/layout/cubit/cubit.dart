import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/state.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/Users_screen.dart';
import 'package:social_app/shared/component/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialUserModel? userModel;
  bool isDark = false;

  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = [
    FeedsScreen(),
    const ChatsScreen(),
    const NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) {
      getUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  void getUserData() {
    emit(SocialGetUserLoadingSuccessState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      log(value.data().toString());
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error, stackTrac) {
      log(error.toString());
      log(stackTrac.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  File? profileImage;
  final picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePackedSuccessState());
    } else {
      log('No image selected.');
      emit(SocialProfileImagePackedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    emit(SocialUserUpdateLoadingState());

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePackedSuccessState());
    } else {
      log('No image selected.');
      emit(SocialCoverImagePackedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name: name,
          email: email,
          phone: phone,
          password: password,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImageSuccessState());
        log(value, name: 'image url');
        updateUser(
          name: name,
          email: email,
          phone: phone,
          password: password,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  // void updateUserImage({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String password,
  //   required String bio,
  // }) {
  //   emit(SocialUserUpdateLoadingState());
  //
  //   if (coverImage != null) {
  //     uploadCoverImage();
  //   }
  //   else if (profileImage != null) {
  //     uploadProfileImage();
  //   }
  //   else if (coverImage != null && profileImage != null) {}
  //   else {
  //     SocialUserModel model = SocialUserModel(
  //       name: name,
  //       email: userModel!.email,
  //       password: userModel!.password,
  //       phone: phone,
  //       bio: bio,
  //       cover: userModel!.cover,
  //       image: userModel!.image,
  //       uId: userModel!.uId,
  //       isEmailVerified: false,
  //     );
  //
  //     updateUser(name: name,
  //       phone: phone,
  //       password: password,
  //       email: email,
  //       bio: bio,);
  //   }
  // }

  void updateUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: userModel!.email,
      password: userModel!.password,
      phone: phone,
      bio: bio,
      cover: cover ?? userModel!.cover,
      image: image ?? userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    emit(SocialUserUpdateLoadingState());

    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePackedSuccessState());
    } else {
      log('No image selected.');
      emit(SocialPostImagePackedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('post/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialCreatePostSuccessState());
        log(value, name: 'image url');
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('post')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('post').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          log(element.id, name: 'post Id');
          postsId.add(element.id);
          posts.add(
            PostModel.fromJson(
              element.data(),
            ),
          );
        }).catchError((error) {});
      });

      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('likes')
        .doc(userModel?.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError(
      (error) {
        log(error.toString());
        emit(SocialLikePostErrorState(error.toString()));
      },
    );
  }

  List<SocialUserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel?.uId) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUserErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      senderId: userModel?.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError(
      (e, s) {
        log(e.toString());
        log(s.toString());
        emit(SocialSendMessageErrorState());
      },
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel?.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError(
      (e, s) {
        log(e.toString());
        log(s.toString());
        emit(SocialSendMessageErrorState());
      },
    );
  }

  List<MessageModel> message = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel?.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      message = [];
      event.docs.forEach((element) {
        message.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
