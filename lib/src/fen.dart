import 'package:flutter/widgets.dart';
import 'models.dart';

Pieces readFen(String fen) {
  final Pieces pieces = {};
  int row = 7;
  int col = 0;
  for (final c in fen.characters) {
    switch (c) {
      case ' ':
      case '[':
        return pieces;
      case '/':
        --row;
        if (row < 0) return pieces;
        col = 0;
        break;
      case '~':
        final sid = Coord(x: col - 1, y: row).squareId;
        final piece = pieces[sid];
        if (piece != null) {
          pieces[sid] = piece.copyWith(promoted: true);
        }
        break;
      default:
        final code = c.codeUnitAt(0);
        if (code < 57) {
          col += code - 48;
        } else {
          final roleLetter = c.toLowerCase();
          final sid = Coord(x: col, y: row).squareId;
          pieces[sid] = Piece(
            role: _roles[roleLetter]!,
            color: c == roleLetter ? Side.black : Side.white,
          );
          ++col;
        }
    }
  }
  return pieces;
}

const _roles = {
  'p': Role.pawn,
  'r': Role.rook,
  'n': Role.knight,
  'b': Role.bishop,
  'q': Role.queen,
  'k': Role.king,
};
