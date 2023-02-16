<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# celer

Specialized fast async file writer

ported by JS [steno](https://github.com/typicode/steno)

**Celer** means fast in Latin.

## Features

Celer makes writing to the same file often/concurrently fast and safe.

- ⚡ pretty fast under specific situation (see benchmark)
- Included the Benchmark/Test in a flutter way

> **Caution**
>
> in normal situation like single-time write, it rather be slower than the normal dart:io method

## Getting started

nothing needs to be started.

## Usage

```dart
/// data setup codes
final dir = await Directory.systemTemp.createTemp('celer-test-');
final celerFile = File(p.join(dir.path, 'celer.txt'));
final data = String.fromCharCodes(List.filled(1024, 'x'.codeUnitAt(0)));
final dataset = List.generate(1000, (index) => data);

/// usage
/// init celer writer
final celer = CelerWriter(celerFile.path);

/// write
/// Repeatedly write to the same file
await Future.wait(dataset.map((e) => celer.write(e)));
```

## Additional information

In [benchmark](benchmark/tester.dart), We measured and compared the time when writing kb,mb-sized text 1000 times to the same file.

```text
Write 1KB data to the same file x 1000
celer(Runtime): 5820.627906976744 us.
io(Runtime): 115485.27777777778 us.
-----------------------------------
Write 1MB data to the same file x 1000
celer(Runtime): 22048.14285714286 us.
io(Runtime): 7442817.0 us.
```

You can run benchmark yourself by

```shell
dart run benchmark/tester.dart
```

> **Disclaimer**
>
> It can be measured differently on your computer.
