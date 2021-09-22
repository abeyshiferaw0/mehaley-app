import 'package:equatable/equatable.dart';

class LyricItem extends Equatable {
  final int index;
  final double startTimeMillisecond;
  final String content;

  LyricItem(
      {required this.index,
      required this.startTimeMillisecond,
      required this.content});

  @override
  List<Object?> get props => [
        index,
        startTimeMillisecond,
        content,
      ];
}
