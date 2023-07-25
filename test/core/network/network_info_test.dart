import 'package:ares/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])
void main() {
  late NetworkInfo networkInfo;
  late MockInternetConnectionChecker internetChecker;
  setUp(() {
    internetChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(internetChecker);
  });
  group('NetworkInfo', () {
    test('should forward the call to Internet connection checker', () {
      final tHasConnection = Future.value(true);
      when(internetChecker.hasConnection).thenAnswer((_) => tHasConnection);
      final actual = networkInfo.isConnected;
      expect(actual, tHasConnection);
    });
  });
}
