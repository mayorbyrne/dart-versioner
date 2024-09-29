import "package:test/test.dart";
import 'package:dart_versioner/dart_versioner.dart' as versioner;

void main() {
  test("versioner", () {
    // the incrementVersion function should exist
    expect(versioner.incrementVersion, isNotNull);
  });
}
