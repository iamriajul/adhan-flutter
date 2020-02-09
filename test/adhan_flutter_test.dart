import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adhan_flutter/adhan_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('adhan_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();
}
