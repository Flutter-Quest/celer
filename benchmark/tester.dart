import 'dart:io';

import 'package:chalkdart/chalk.dart';
import 'package:path/path.dart' as p;

import 'celer_benchmark.dart';
import 'io_benchmark.dart';

Future<void> main() async {
  // file setup
  final dir = await Directory.systemTemp.createTemp('celer-');
  final ioFile = File(p.join(dir.path, 'io.txt'));
  final celerFile = File(p.join(dir.path, 'celer.txt'));

  const kb = 1024;
  const mb = 1024 * 1024;

  // data setup
  // 1. 1kb sized data
  await kbSizedTest(kb, celerFile, ioFile);

  print('---------------------------------------');

  // 2. 1mb sized data
  await mbSizedTest(mb, celerFile, ioFile);
}

Future<void> mbSizedTest(int mb, File celerFile, File ioFile) async {
  print(chalk.bold("Write 1MB data to the same file x 1000"));

  final mbData = String.fromCharCodes(List.filled(mb, 'x'.codeUnitAt(0)));

  final celerBenchmarkMb = CelerBenchmark(celerFile, mbData);
  await celerBenchmarkMb.report();

  final ioBenchmarkMb = IoBenchmark(ioFile, mbData);
  await ioBenchmarkMb.report();

  final ioFileDataMb = await ioFile.readAsBytes();
  final celerFileDataMb = await celerFile.readAsBytes();

  // print('ioLength : ${ioFileDataMb.lengthInBytes}');
  // print('celerLength : ${celerFileDataMb.lengthInBytes}');

  assert(ioFileDataMb == celerFileDataMb);

  await ioFile.delete();
  await celerFile.delete();
}

Future<void> kbSizedTest(int kb, File celerFile, File ioFile) async {
  print(chalk.bold("Write 1KB data to the same file x 1000"));

  final kbData = String.fromCharCodes(List.filled(kb, 'x'.codeUnitAt(0)));

  final celerBenchmarkKb = CelerBenchmark(celerFile, kbData);
  await celerBenchmarkKb.report();

  final ioBenchmarkKb = IoBenchmark(ioFile, kbData);
  await ioBenchmarkKb.report();

  final ioFileDataKb = await ioFile.readAsBytes();
  final celerFileDataKb = await celerFile.readAsBytes();

  // print('ioLength : ${ioFileDataKb.lengthInBytes}');
  // print('celerLength : ${celerFileDataKb.lengthInBytes}');

  assert(ioFileDataKb == celerFileDataKb);

  await ioFile.delete();
  await celerFile.delete();
}
