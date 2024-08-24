import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:newchess/bloc/cubits/settings_cubit.dart';
import 'package:newchess/bloc/states/game_state.dart';
import 'package:newchess/bloc/states/settings_state.dart';
import 'package:newchess/models/board.dart';
import 'package:newchess/models/cell.dart';
import 'package:newchess/models/game_colors.dart';
import 'package:newchess/models/lost_figures.dart';
import 'package:newchess/services/ai/ai_manager.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(GameState initialState) : super(initialState);

  factory GameCubit.initial() {
    final board =
        Board(cells: [], whiteLost: LostFigures(), blackLost: LostFigures());
    board.createCells();
    board.putFigures();

    return GameCubit(GameState(
      activeColor: GameColors.white,
      selectedCell: null,
      board: board,
      isAIthinking: false,
      availablePositionsHash: {},
    ));
  }

  void startBattle() {
    final settings = _getSettings();

    if (settings.hasAI && settings.whitePlayer.isHuman) {
      _scheduleAIMove();
    }
  }

  void selectCell(Cell? newCell) {
    emit(state.copyWith(
      selectedCell: newCell,
      availablePositionsHash: state.board.getAvailablePositionsHash(newCell),
    ));
  }

  void moveFigure(Cell toCell) async {
    if (state.selectedCell == null) {
      return;
    }

    state.selectedCell!.moveFigure(toCell);

    if (_getSettings().hasAI) {
      final nextColor = state.activeColor.getOpposite();
      final nextPlayer = _getSettings().getPlayerByColor(nextColor);

      if (!nextPlayer.isHuman) {
        await _scheduleAIMove();
      }
    }

    emit(state.copyWith(
      board: state.board.copyThis(),
      activeColor: state.activeColor.getOpposite(),
    ));

    selectCell(null);
  }

  Future<void> _scheduleAIMove() async {
    emit(state.copyWith(isAIthinking: true));
    // Simulate AI thinking time
    await Future.delayed(Duration(seconds: 1)); // Adjust duration as needed
    // Perform AI move logic here
    // Example:
    // final aiMove = await performAIMove();
    // state.board.applyMove(aiMove);
    StockFishAIManager;
    emit(state.copyWith(isAIthinking: false));
  }

  SettingsState _getSettings() {
    return GetIt.I<SettingsCubit>().state;
  }
}
