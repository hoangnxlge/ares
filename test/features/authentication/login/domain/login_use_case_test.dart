import 'package:flutter_test/flutter_test.dart';
import 'package:ares/features/authentication/login/login_exports.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_use_case_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LoginRepository>()])
void main() {
  late LoginUseCase useCase;
  late MockLoginRepository repo;
  setUp(() {
    repo = MockLoginRepository();
    useCase = LoginUseCase(repo);
  });

  const tLoginParam = LoginParams(
    username: 'hello',
    password: 'hello',
  );

  group('Login use case', () {
    test('should call login from repo', () async {
      useCase(tLoginParam);
      verify(
        repo.login(
          username: tLoginParam.username,
          password: tLoginParam.password,
        ),
      );
    });
  });
}
