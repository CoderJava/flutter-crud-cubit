import 'package:flutter_crud_cubit/model/profile_data.dart';

abstract class ProfileState {}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class FailureLoadAllProfileState extends ProfileState {
  final String errorMessage;

  FailureLoadAllProfileState(this.errorMessage);

  @override
  String toString() {
    return 'FailureLoadAllProfileState{errorMessage: $errorMessage}';
  }
}

class SuccessLoadAllProfileState extends ProfileState {
  final List<ProfileData> listProfiles;
  final String message;

  SuccessLoadAllProfileState(this.listProfiles, {this.message});

  @override
  String toString() {
    return 'SuccessLoadAllProfileState{listProfiles: $listProfiles, message: $message}';
  }
}

class FailureSubmitProfileState extends ProfileState {
  final String errorMessage;

  FailureSubmitProfileState(this.errorMessage);

  @override
  String toString() {
    return 'FailureSubmitProfileState{errorMessage: $errorMessage}';
  }
}

class SuccessSubmitProfileState extends ProfileState {}

class FailureDeleteProfileState extends ProfileState {
  final String errorMessage;

  FailureDeleteProfileState(this.errorMessage);

  @override
  String toString() {
    return 'FailureDeleteProfileState{errorMessage: $errorMessage}';
  }
}
