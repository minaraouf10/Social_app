import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/state.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel!;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = userModel.name!;
        emailController.text = userModel.email!;
        phoneController.text = userModel.phone!;
        passwordController.text = userModel.password!;
        bioController.text = userModel.bio!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                function: () {
                  SocialCubit.get(context).updateUser(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    password: passwordController.text,
                    bio: bioController.text,
                  );
                },
                text: 'Update',
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    const SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(
                                        '${userModel.image}',
                                      )
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(children: [
                              defaultButton(
                                function: () {
                                  SocialCubit.get(context).uploadProfileImage(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                    bio: bioController.text,
                                  );
                                },
                                text: 'upload profile ',
                              ),
                              if (state is SocialUserUpdateLoadingState)
                                const SizedBox(
                                height: 5.0,
                              ),
                              if (state is SocialUserUpdateLoadingState)
                                LinearProgressIndicator(),
                            ]),
                          ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                              child: Column(children: [
                                defaultButton(
                              function: () {
                                SocialCubit.get(context).uploadCoverImage(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                  bio: bioController.text,
                                );
                              },
                              text: 'upload cover ',
                            ),
                                if (state is SocialUserUpdateLoadingState)
                                    const SizedBox(
                                       height: 5.0,
                             ),
                                if (state is SocialUserUpdateLoadingState)
                                    LinearProgressIndicator(),
                          ])),
                      ],
                    ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    const SizedBox(
                      height: 20.0,
                    ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'name must not empty';
                      }
                      return null;
                    },
                    label: 'Name',
                    prefix: IconBroken.Profile,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'email must not empty';
                      }
                      return null;
                    },
                    label: 'email',
                    prefix: IconBroken.Message,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'phone number must not empty';
                      }
                      return null;
                    },
                    label: 'phone',
                    prefix: IconBroken.Call,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'password must not empty';
                      }
                      return null;
                    },
                    label: 'password',
                    prefix: IconBroken.Password,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'bio must not empty';
                      }
                      return null;
                    },
                    label: 'bio',
                    prefix: IconBroken.Info_Circle,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
