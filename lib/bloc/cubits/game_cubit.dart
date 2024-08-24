import 'dart:math';

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
      _performAIMove();
    }
  }

  void selectCell(Cell? newCell) {
    emit(state.copyWith(
      selectedCell: newCell,
      availablePositionsHash: state.board.getAvailablePositionsHash(newCell),
    ));
  }

  void moveFigure(Cell toCell) {
    if (state.selectedCell == null) return;

    _performMove(state.selectedCell!, toCell);

    // Check if it's AI's turn after the player's move
    if (_getSettings().hasAI) {
      final nextColor = state.activeColor;
      final nextPlayer = _getSettings().getPlayerByColor(nextColor);

      if (!nextPlayer.isHuman) {
        _performAIMove();
      }
    }
  }

  void _performMove(Cell fromCell, Cell toCell) {
    state.board.movePiece(fromCell, toCell);

    emit(state.copyWith(
      board: state.board.copyThis(),
      activeColor: state.activeColor.getOpposite(),
      selectedCell: null,
      availablePositionsHash: {},
    ));
  }

  void _performAIMove() {
    emit(state.copyWith(isAIthinking: true));

    // Simulate AI thinking time
    Future.delayed(Duration(seconds: 1), () {
      // Simple AI: randomly select a piece and make a valid move
      final aiColor = state.activeColor;
      final aiPieces = state.board.cells
          .expand((row) => row)
          .where((cell) => cell.occupied && cell.getFigure()!.color == aiColor)
          .toList();

      if (aiPieces.isEmpty) {
        emit(state.copyWith(isAIthinking: false));
        return; // Game over
      }
      final random = Random();
      bool moveMade = false;

      while (!moveMade && aiPieces.isNotEmpty) {
        final randomPieceIndex = random.nextInt(aiPieces.length);
        final selectedPiece = aiPieces[randomPieceIndex];

        final availableMoves =
            state.board.getAvailablePositionsHash(selectedPiece);

        if (availableMoves.isNotEmpty) {
          final randomMoveIndex = random.nextInt(availableMoves.length);
          final targetPosition =
              availableMoves.elementAt(randomMoveIndex).split('-');
          final targetCell = state.board.getCellAt(
              int.parse(targetPosition[0]), int.parse(targetPosition[1]));

          _performMove(selectedPiece, targetCell);
          moveMade = true;
        } else {
          aiPieces.removeAt(randomPieceIndex);
        }
      }
      if (!moveMade) {
        // No valid moves available for AI, game might be over
        // You may want to handle this case (e.g., checkmate, stalemate)
      }

      emit(state.copyWith(isAIthinking: false));
    });
  }

  SettingsState _getSettings() {
    return GetIt.I<SettingsCubit>().state;
  }
}
