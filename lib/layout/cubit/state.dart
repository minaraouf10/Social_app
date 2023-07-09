abstract class SocialStates {}

class SocialInitialState extends SocialStates{}

class SocialGetUserLoadingSuccessState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates
{
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUserLoadingSuccessState extends SocialStates{}

class SocialGetAllUserSuccessState extends SocialStates{}

class SocialGetAllUserErrorState extends SocialStates
{
  final String error;

  SocialGetAllUserErrorState(this.error);
}

class SocialGetPostsLoadingSuccessState extends SocialStates{}

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates
{
  final String error;

  SocialGetPostsErrorState(this.error);
}

class SocialLikePostSuccessState extends SocialStates{}

class SocialLikePostErrorState extends SocialStates
{
  final String error;

  SocialLikePostErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}

class SocialProfileImagePackedSuccessState extends SocialStates{}

class SocialProfileImagePackedErrorState extends SocialStates{}

class SocialCoverImagePackedSuccessState extends SocialStates{}

class SocialCoverImagePackedErrorState extends SocialStates{}

class SocialUploadProfileImageSuccessState extends SocialStates{}

class SocialUploadProfileImageErrorState extends SocialStates{}

class SocialUploadCoverImageSuccessState extends SocialStates{}

class SocialUploadCoverImageErrorState extends SocialStates{}

class SocialUserUpdateLoadingState extends SocialStates{}

class SocialUserUpdateErrorState extends SocialStates{}

class SocialCreatePostLoadingState extends SocialStates{}

class SocialCreatePostSuccessState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates{}

class SocialPostImagePackedSuccessState extends SocialStates{}

class SocialPostImagePackedErrorState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}

class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates{}

class SocialGetMessageSuccessState extends SocialStates{}
