import 'package:flutter_test/flutter_test.dart';
import 'package:ruok_app_practical_task/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    expect(const RuOkApp(), isNotNull);
  });
}
