import 'dart:convert';

import 'package:apexive/core/failure.dart';
import 'package:apexive/core/request.dart';
import 'package:apexive/core/service_locator.dart';
import 'package:apexive/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:apexive/features/auth/data/models/auth_user.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  late MockRequest mockRequest;
  late AuthRemoteDataSourceImpl loginRemoteDataSource;
  setUpAll(
    () {
      mockRequest = MockRequest();
      serviceLocator.registerFactory<Request>(() => mockRequest);
      loginRemoteDataSource = AuthRemoteDataSourceImpl();
    },
  );
  tearDownAll(() async {
    await serviceLocator.reset(dispose: true);
  });
  final AuthUser user = AuthUser.fromJson(jsonDecode(fixture('user_response.json')));
  test(
    'should return user model on successful login',
    () async {
      when(
        () => mockRequest.post(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          data: user.toJson(),
          requestOptions: RequestOptions(
            baseUrl: '',
            path: '',
          ),
        ),
      );

      final response = await loginRemoteDataSource.loginUser(user: AuthUser.fromJson({}));

      expect(response, Right(user));
    },
  );
  test(
    'should return connection failure on login failed',
    () async {
      const String message = 'Unable to connect';
      when(
        () => mockRequest.post(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          statusCode: 400,
          data: {'message': message},
          requestOptions: RequestOptions(
            baseUrl: '',
            path: '',
          ),
        ),
      );

      final response = await loginRemoteDataSource.loginUser(user: AuthUser.fromJson({}));

      expect(
        response,
        const Left(
          ConnectionFailure(message),
        ),
      );
    },
  );
}

class MockRequest extends Mock implements Request {}
