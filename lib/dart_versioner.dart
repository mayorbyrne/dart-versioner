import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';
import 'dart:io';

Future<void> incrementVersion(List<String> args) async {
  // Check if the working tree is clean
  // If not, exit with an error
  await _requireCleanWorkTree();

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

    print("v$major.$minor.$patch");
  });
}

Future<void> _addPubspec() async {
  await _execute("git", ["add", "./pubspec.yaml"]);
}

Future<void> _gitCommit(String msg) async {
  await _execute("git", ["commit", "-m", msg]);
}

Future<void> _execute(String executable, List<String> arguments) async {
  final process = await Process.start(executable, arguments, runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  final exitCode = await process.exitCode;
}

Future<void> _requireCleanWorkTree() async {
  int err = 0;

  // Update the index
  ProcessResult process = await Process.run('git', ["update-index", "--ignore-submodules", "--refresh"], runInShell: true);

  // Disallow unstaged changes in the working tree
  process = await Process.run('git', ["diff-files", "--ignore-submodules", "--"], runInShell: true);
  String? response = process.stdout;

  if (response != null && response.isNotEmpty) {
    err = 1;
    print("Cannot increment version: You have unstaged changes in the working tree.");
  }

  // Disallow uncommitted changes in the index
  process = await Process.run('git', ["diff-index", "--cached", "HEAD", "--ignore-submodules", "--"], runInShell: true);
  response = process.stdout;

  if (response != null && response.isNotEmpty) {
    err = 1;
    print("Cannot increment version: Your index contains uncommitted changes.");
  }

  if (err == 1) {
    print("Please commit or stash them.");
    exit(1);
  }
}
