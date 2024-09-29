import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';
import 'dart:io';

void incrementVersion(List<String> args) {
  File('./pubspec.yaml').readAsString().then((String contents) async {
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

    await _addPubspec();
    await _gitCommit("v$major.$minor.$patch");

    print("Done");
  });
}

Future<void> _addPubspec() async {
  print('Adding pubspec.yaml to git');
  print('============');
  await _execute("git", ["add", "./pubspec.yaml"]);
}

Future<void> _gitCommit(String msg) async {
  print("Committing with msg: $msg");
  print('============');
  await _execute("git", ["commit", "-m", msg]);
}

Future<void> _execute(String executable, List<String> arguments) async {
  final process = await Process.start(executable, arguments, runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  final exitCode = await process.exitCode;
  print('============');
  print('Exit code: $exitCode');
}

