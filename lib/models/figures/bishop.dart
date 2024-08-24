import 'package:newchess/models/cell.dart';
import 'package:newchess/models/cell_calculator.dart';
import 'package:newchess/models/figure.dart';
import 'package:newchess/models/figure_types.dart';
import 'package:newchess/models/game_colors.dart';

class Bishop extends Figure {
  Bishop({required GameColors color, required Cell cell})
      : super(color: color, cell: cell, type: FigureTypes.bishop);

  @override
  bool availableForMove(Cell to) {
    if (!super.availableForMove(to)) return false;
    return CellCalculator.hasDiagonalWay(cell, to);
  }
}
