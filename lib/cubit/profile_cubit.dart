import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_cubit/model/profile_data.dart';

import '../helper/dio_helper.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final DioHelper dioHelper;

  ProfileCubit(this.dioHelper) : super(InitialProfileState());

  void getAllProfiles() async {
    emit(LoadingProfileState());
    var result = await dioHelper.getAllProfiles();
    result.fold(
      (errorMessage) => emit(FailureLoadAllProfileState(errorMessage)),
      (listProfiles) => emit(SuccessLoadAllProfileState(listProfiles)),
    );
  }

  void addProfile(ProfileData profileData) async {
    emit(LoadingProfileState());
    var result = await dioHelper.addProfile(profileData);
    result.fold(
      (errorMessage) => emit(FailureSubmitProfileState(errorMessage)),
      (_) => emit(SuccessSubmitProfileState()),
    );
  }

  void editProfile(ProfileData profileData) async {
    emit(LoadingProfileState());
    var result = await dioHelper.editProfile(profileData);
    result.fold(
      (errorMessage) => emit(FailureSubmitProfileState(errorMessage)),
      (_) => emit(SuccessSubmitProfileState()),
    );
  }

  void deleteProfile(int id) async {
    emit(LoadingProfileState());
    var result = await dioHelper.deleteProfile(id);
    result.fold(
      (errorMessage) => emit(FailureDeleteProfileState(errorMessage)),
      (_) => emit(SuccessDeleteProfileState()),
    );
  }
}
