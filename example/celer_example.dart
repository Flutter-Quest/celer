import 'dart:io';
import 'package:celer/celer.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  /// setup codes
  final dir = await Directory.systemTemp.createTemp('celer-test-');
  final celerFile = File(p.join(dir.path, 'celer.txt'));
  final data = String.fromCharCodes(List.filled(1024, 'x'.codeUnitAt(0)));
  final dataset = List.generate(1000, (index) => data);

  /// usage
  final celer = CelerWriter(celerFile.path);
  await Future.wait(dataset.map((e) => celer.write(e)));
}
