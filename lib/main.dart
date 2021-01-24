import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'helper/dio_helper.dart';
import 'ui/add_edit_profile.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListProfilePage(),
    );
  }
}

class ListProfilePage extends StatefulWidget {
  @override
  _ListProfilePageState createState() => _ListProfilePageState();
}

class _ListProfilePageState extends State<ListProfilePage> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  ProfileCubit profileCubit;

  @override
  void initState() {
    profileCubit = ProfileCubit(DioHelper());
    profileCubit.getAllProfiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text('Flutter CRUD Cubit'),
      ),
      body: BlocProvider<ProfileCubit>(
        create: (_) => profileCubit,
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (_, state) {
            if (state is FailureLoadAllProfileState) {
              scaffoldState.currentState.showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            } else if (state is FailureDeleteProfileState) {
              scaffoldState.currentState.showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            } else if (state is SuccessLoadAllProfileState) {
              if (state.message != null && state.message.isNotEmpty)
              scaffoldState.currentState.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (_, state) {
              if (state is LoadingProfileState) {
                return Center(
                  child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
                );
              } else if (state is FailureLoadAllProfileState) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is SuccessLoadAllProfileState) {
                var listProfiles = state.listProfiles;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: listProfiles.length,
                  itemBuilder: (_, index) {
                    var profileData = listProfiles[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData.name,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              profileData.email,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              '${profileData.age}',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                  child: Text('DELETE'),
                                  textColor: Colors.red,
                                  onPressed: () async {
                                    var dialogConfirmDelete = Platform.isIOS
                                        ? await showCupertinoDialog<bool>(
                                            context: context,
                                            builder: (_) {
                                              return CupertinoAlertDialog(
                                                title: Text('Warning'),
                                                content: Text(
                                                  'Are you sure you want to delete ${profileData.name}\'s data?',
                                                ),
                                                actions: [
                                                  CupertinoDialogAction(
                                                    child: Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                    isDestructiveAction: true,
                                                  ),
                                                  CupertinoDialogAction(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context, false);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : await showDialog<bool>(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text('Warning'),
                                                content: Text(
                                                  'Are you sure you want to delete ${profileData.name}\'s data?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(color: Colors.blue),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context, false);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                    if (dialogConfirmDelete != null && dialogConfirmDelete) {
                                      profileCubit.deleteProfile(profileData.id);
                                    }
                                  },
                                ),
                                FlatButton(
                                  child: Text('EDIT'),
                                  textColor: Colors.blue,
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddEditProfile(
                                          profileData: profileData,
                                        ),
                                      ),
                                    );
                                    if (result != null) {
                                      profileCubit.getAllProfiles();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditProfile(),
            ),
          );
          if (result != null) {
            profileCubit.getAllProfiles();
          }
        },
      ),
    );
  }
}
