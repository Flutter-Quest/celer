import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';

import 'benchmark_helper/colored_score_emitter.dart';

class IoBenchmark extends AsyncBenchmarkBase {
  IoBenchmark(this.ioFile, this.data, [this.msg])
      : super(
          "io",
          emitter: ColoredScoreEmitter(
            62,
            79,
            176,
          ),
        );

  final File ioFile;
  final String data;
  final String? msg;

  late List<String> dataset;

  @override
  Future<void> setup() async {
    await ioFile.create();

    /// 1000 times run
    dataset = List.generate(1000, (index) => data);
  }

  @override
  Future<void> run() async {
    await Future.wait(dataset.map((e) => ioFile.writeAsString(e)));

    // await ioFile.writeAsString(data);
  }

  @override
  Future<void> teardown() async {
    // await ioFile.delete();
  }
}
