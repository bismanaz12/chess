import 'dart:async';
import 'dart:convert';
import 'dart:io';

class StockFishAIManager {
  Process? _process;
  final StreamController<String> _outputController = StreamController<String>();

  Future<void> initEngine() async {
    try {
      _process = await Process.start(
        'stockfish', // Ensure this path is correct for your environment
        [],
        mode: ProcessStartMode.normal,
      );

      _process!.stderr.transform(utf8.decoder).listen((error) {
        print('Stockfish error: $error');
      });

      _process!.stdout.transform(utf8.decoder).transform(LineSplitter()).listen(
        (line) {
          _outputController.add(line);
        },
        onError: (error) {
          print('Error reading Stockfish output: $error');
        },
      );

      _sendCommand('uci');
      await _waitForReady();
    } catch (e) {
      print('Failed to start Stockfish: $e');
      rethrow;
    }
  }

  Future<void> _waitForReady() async {
    // Wait for the 'readyok' response from Stockfish
    await for (final line in _outputController.stream) {
      if (line == 'readyok') break;
    }
  }

  void disposeEngine() {
    _sendCommand('quit');
    _process?.kill();
    _outputController.close();
  }

  void _sendCommand(String command) {
    if (_process != null) {
      _process!.stdin.writeln(command);
    } else {
      print('Stockfish process is not running.');
    }
  }

  Stream<String> get outputStream => _outputController.stream;
}
