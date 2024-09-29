import "package:test/test.dart";
import 'package:versioner/versioner.dart' as versioner;

void main() {
  test("versioner", () {
    // the incrementVersion function should exist
    expect(versioner.incrementVersion, isNotNull);
  });
}
