import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';

String getTempFilename(String file) {
  return join(dirname(file), '.${basename(file)}.tmp');
}

class Result {
  final void Function()? resolve;
  final void Function(Error error)? reject;

  Result(this.resolve, this.reject);
}

class CelerWriter {
  final String _fileName;
  final String _tempFileName;
  bool _locked = false;

  Completer? _prev;
  Completer? _next;
  Future? _nextFuture;
  String? _nextData;

  CelerWriter(this._fileName) : _tempFileName = getTempFilename(_fileName);

  Future write(String data) async {
    return _locked ? _add(data) : _write(data);
  }

  /// File is locked, add data for later
  Future _add(String data) {
    // Only keep most recent data
    _nextData = data;

    // Create a singleton promise to resolve all next promises once next data is written
    _nextFuture ??= Future.sync(() {
      _next = Completer();
    });

    // Return a promise that will resolve at the same time as next promise
    return Future.sync(() => _nextFuture?.then((_) => {}));
  }

  /// File isn't locked, write data
  Future<void> _write(String data) async {
    // Lock file
    _locked = true;

    try {
      // atomic write
      await File(_tempFileName).writeAsString(data, mode: FileMode.write);
      await File(_tempFileName).rename(_fileName);

      // call resolve
      _prev?.complete();
    } on Error catch (e) {
      // call reject
      _prev?.completeError(e);
      rethrow;
    } finally {
      // unlock file
      _locked = false;

      _prev = _next;
      _next = null;
      _nextFuture = null;

      if (_nextData != null) {
        final nextData = _nextData;
        _nextData = null;
        await write(nextData!);
      }
    }
  }
}
