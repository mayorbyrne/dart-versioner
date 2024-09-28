import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';
import 'dart:io';

void main(List<String> args) {
  File('./pubspec.yaml').readAsString().then((String contents) {
    Pubspec pubspec = Pubspec.parse(contents);
    Version version = pubspec.version ?? Version(0, 0, 0);
    String incType = (args.isEmpty ? "major" : args[0]).toLowerCase();

    int major = version.major;
    int minor = version.minor;
    int patch = version.patch;

    if (incType == "major") {
      ++major;
    } else if (incType == "minor") {
      ++minor;
    } else if (incType == "patch") {
      ++patch;
    } else {
      //TODO: create a new version type given the provided version
    }

    contents = contents.replaceAll("version: $version", "version: $major.$minor.$patch");

    File('./pubspec.yaml').writeAsStringSync(contents);

    print("v${Version(major, minor, patch)}");
  });
}
