import 'dart:io';

import 'package:celer/celer.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('A group of tests', () {
    // var max;
    // var dir;
    const max = 1000;

    final futures = <Future>[];
    late String file;

    setUp(() async {
      final dir = await Directory.systemTemp.createTemp('celer-test-');
      file = p.join(dir.path, 'tmp.txt');

      final writer = CelerWriter(file);
      // Test race condition
      for (int i = 1; i <= max; ++i) {
        futures.add(writer.write(i.toString()));
      }
    });

    test('First Test', () async {
      // All promises should resolve
      await Future.wait(futures);
      final contents = int.parse(File(file).readAsStringSync());
      print(contents);
      expect(max, contents);
    });
  });
}



  
// import { strictEqual as equal } from 'assert'
// import fs from 'fs'
// import os from 'os'
// import path from 'path'

// import { Writer } from './index.js'

// export async function testSteno(): Promise<void> {
//   const max = 1000
//   const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'steno-test-'))
//   const file = path.join(dir, 'tmp.txt')

//   const writer = new Writer(file)
//   const promises = []

//   // Test race condition
//   for (let i = 1; i <= max; ++i) {
//     promises.push(writer.write(String(i)))
//   }

//   // All promises should resolve
//   await Promise.all(promises)
//   equal(parseInt(fs.readFileSync(file, 'utf-8')), max)
// }