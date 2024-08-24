import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:newchess/models/board.dart';
import 'package:newchess/models/cell.dart';

import '../../models/game_colors.dart';

part 'game_state.freezed.dart';

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required Board board,
    required Cell? selectedCell,
    required Set<String> availablePositionsHash,
    required GameColors activeColor,
    required bool isAIthinking,
  }) = _GameState;
}
