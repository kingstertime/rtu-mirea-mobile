import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/announce_model.dart';
import 'package:rtu_mirea_app/data/models/user_model.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';

abstract class UserRemoteData {
  Future<String> auth(String login, String password);
  Future<UserModel> getProfileData(String token);
  Future<List<AnnounceModel>> getAnnounces(String token);
}

class UserRemoteDataImpl implements UserRemoteData {
  static const _apiUrl = 'https://lk.mirea.ru/local/ajax/mrest.php';

  final Dio httpClient;

  UserRemoteDataImpl({required this.httpClient});

  @override
  Future<String> auth(String login, String password) async {
    final data = {"action": "login", "login": login, "password": password};
    final response = await httpClient.get(_apiUrl, queryParameters: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.data);
      if (jsonResponse.containsKey('errors')) {
        throw ServerException(jsonResponse['errors'][0]);
      }
      return jsonResponse['token'];
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<UserModel> getProfileData(String token) async {
    final response = await httpClient.get(
      _apiUrl + '?action=getData&url=https://lk.mirea.ru/profile/',
      options: Options(
        headers: {'Authorization': token},
      ),
    );
    var jsonResponse = json.decode(response.data);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }
    if (response.statusCode == 200) {
      return UserModel.fromRawJson(response.data);
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<AnnounceModel>> getAnnounces(String token) async {
    final response = await httpClient.get(
      _apiUrl + '?action=getData&url=https://lk.mirea.ru/livestream/',
      options: Options(
        headers: {'Authorization': token},
      ),
    );

    var jsonResponse = json.decode(response.data);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      List<AnnounceModel> announces = [];
      for (final announce in jsonResponse["ANNOUNCES"]) {
        announces.add(AnnounceModel.fromJson(announce));
      }
      return announces;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
