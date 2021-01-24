import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_crud_cubit/model/profile_data.dart';

class DioHelper {
  Dio _dio;

  DioHelper() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://api.bengkelrobot.net:8001/api',
      ),
    );
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<Either<String, List<ProfileData>>> getAllProfiles() async {
    try {
      var response = await _dio.get('/profile');
      var listProfileData = List<ProfileData>.from(response.data.map((e) => ProfileData.fromJson(e)));
      return Right(listProfileData);
    } on DioError catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> addProfile(ProfileData profileData) async {
    try {
      await _dio.post(
        '/profile',
        data: profileData.toJson(),
      );
      return Right(true);
    } on DioError catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> editProfile(ProfileData profileData) async {
    try {
      await _dio.put(
        '/profile/${profileData.id}',
        data: profileData.toJson(),
      );
      return Right(true);
    } on DioError catch (error) {
      return Left('$error');
    }
  }

  Future<Either<String, bool>> deleteProfile(int id) async {
    try {
      await _dio.delete(
        '/profile/$id',
      );
      return Right(true);
    } on DioError catch (error) {
      return Left('$error');
    }
  }
}
