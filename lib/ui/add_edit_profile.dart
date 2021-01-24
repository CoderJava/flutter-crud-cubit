import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_cubit/cubit/profile_cubit.dart';
import 'package:flutter_crud_cubit/cubit/profile_state.dart';
import 'package:flutter_crud_cubit/helper/dio_helper.dart';
import 'package:flutter_crud_cubit/model/profile_data.dart';

class AddEditProfile extends StatefulWidget {
  final ProfileData profileData;

  AddEditProfile({
    this.profileData,
  });

  @override
  _AddEditProfileState createState() => _AddEditProfileState();
}

class _AddEditProfileState extends State<AddEditProfile> {
  final profileCubit = ProfileCubit(DioHelper());
  final scaffoldState = GlobalKey<ScaffoldState>();
  final formState = GlobalKey<FormState>();
  final focusNodeButtonSubmit = FocusNode();
  var controllerName = TextEditingController();
  var controllerEmail = TextEditingController();
  var controllerAge = TextEditingController();
  var isEdit = false;
  var isSuccess = false;

  @override
  void initState() {
    isEdit = widget.profileData != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSuccess) {
          Navigator.pop(context, true);
        }
        return true;
      },
      child: Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text(widget.profileData == null ? 'Add Profile' : 'Edit Profile'),
        ),
        body: BlocProvider<ProfileCubit>(
          create: (_) => profileCubit,
          child: BlocListener<ProfileCubit, ProfileState>(
            listener: (_, state) {
              if (state is SuccessSubmitProfileState) {
                isSuccess = true;
                if (isEdit) {
                  Navigator.pop(context, true);
                } else {
                  scaffoldState.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Profile addes successfully'),
                    ),
                  );
                  setState(() {
                    controllerName.clear();
                    controllerEmail.clear();
                    controllerAge.clear();
                  });
                }
              }
            },
            child: Stack(
              children: [
                _buildWidgetForm(),
                _buildWidgetLoading(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetForm() {
    return Form(
      key: formState,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controllerName,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                return value == null || value.isEmpty ? 'Enter a name' : null;
              },
              keyboardType: TextInputType.name,
            ),
            TextFormField(
              controller: controllerEmail,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                debugPrint('value email: $value');
                return value == null || value.isEmpty ? 'Enter email' : null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              controller: controllerAge,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
              validator: (value) {
                return value == null || value.isEmpty ? 'Enter age' : null;
              },
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('SUBMIT'),
                textColor: Colors.white,
                color: Colors.blue,
                focusNode: focusNodeButtonSubmit,
                onPressed: () {
                  focusNodeButtonSubmit.requestFocus();
                  if (formState.currentState.validate()) {
                    var name = controllerName.text.trim();
                    var email = controllerEmail.text.trim();
                    var age = controllerAge.text.trim();
                    var profileData = ProfileData(
                      name: name,
                      email: email,
                      age: int.parse(age),
                    );
                    profileCubit.addProfile(profileData);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetLoading() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (_, state) {
        if (state is LoadingProfileState) {
          return Container(
            color: Colors.black.withOpacity(.5),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
