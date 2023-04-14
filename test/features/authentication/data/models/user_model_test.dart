import 'dart:convert';

import 'package:apexive/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  final User user = User(firstName: 'Zain', lastName: 'Abbas');
  group(
    'json serialization ',
    () {
      test(
        'fromJson should return UserModel object ',
        () {
          //arrange
          final jsonData = fixture('test_response.json');
          //act
          final userModel = User.fromJson(jsonDecode(jsonData));
          // assert
          expect(userModel, user);
        },
      );
      test(
        'toJson should return json string ',
        () {
          //act
          final jsonData = user.toJson();
          // assert
          final expextMap = {
            'id': 0,
            'username': '',
            'password': '',
            'email': '',
            'firstName': 'Zain',
            'lastName': 'Abbas',
            'gender': '',
            'image': '',
            'token': ''
          };
          expect(expextMap, jsonData);
        },
      );
    },
  );
}
