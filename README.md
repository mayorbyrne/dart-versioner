## Dart_Versioner

A utility to auto-increment a pubspec.yaml, similar to `npm version`.

### Installation

`dart pub global activate dart_versioner`

### Usage

`dart_versioner [type]`

Where `[type]` is one of `major`, `minor`, or `patch`.

  - `major` will increment the major version number.
  - `minor` will increment the minor version number.
  - `patch` will increment the patch version number.

The program will automatically increment the pubspec.yaml version number, and also automatically commit the change to git with the new version number as the commit message.
