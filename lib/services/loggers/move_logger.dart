import 'package:newchess/models/cell.dart';
import 'package:newchess/services/loggers/i_logger.dart';

class MoveLogger implements ILogger<Cell> {
  final List<Cell> _movements = [];

  @override
  add(note) {
    _movements.add(note);
  }

  @override
  clear() {
    _movements.clear();
  }

  @override
  remove(note) {
    _movements.remove(note);
  }

  @override
  List<Cell> getAll() {
    return _movements;
  }
}

MoveLogger createMoveLogger() {
  return MoveLogger();
}
