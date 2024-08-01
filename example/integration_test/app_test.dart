
import 'package:integration_test/integration_test.dart';
import '_app_test.dart' as test_app;

void main() {
  // enableFlutterDriverExtension();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  test_app.main();
}