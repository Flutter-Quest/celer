import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:celer/celer.dart';

import 'benchmark_helper/colored_score_emitter.dart';

class CelerBenchmark extends AsyncBenchmarkBase {
  CelerBenchmark(this.celerFile, this.data, [this.msg])
      : super(
          "celer",
          emitter: ColoredScoreEmitter(
            241,
            85,
            31,
          ),
        );

  final File celerFile;
  final String data;
  String? msg;

  late CelerWriter celer;

  late List<String> dataset;

  @override
  Future<void> setup() async {
    await celerFile.create();

    celer = CelerWriter(celerFile.path);

    /// 1000 times run
    dataset = List.generate(1000, (index) => data);
  }

  @override
  Future<void> run() async {
    await Future.wait(dataset.map((e) => celer.write(e)));
    // await celer.write(data);
  }

  @override
  Future<void> teardown() async {
    // await celerFile.delete();
  }
}
