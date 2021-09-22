import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'text_lan.g.dart';

@HiveType(typeId: 8)
class TextLan extends Equatable {
  @HiveField(0)
  final int? textLanguageId;
  @HiveField(1)
  final String textEn;
  @HiveField(2)
  final String textAm;
  @HiveField(3)
  final String textOro;
  @HiveField(4)
  final String textTig;

  const TextLan({
    required this.textLanguageId,
    required this.textEn,
    required this.textAm,
    required this.textOro,
    required this.textTig,
  });

  @override
  List<Object?> get props => [
        textLanguageId,
        textEn,
        textAm,
        textOro,
        textTig,
      ];

  factory TextLan.fromMap(Map<String, dynamic> map) {
    return new TextLan(
      textLanguageId: map['text_language_id'] as int,
      textEn: map['text_en'] as String,
      textAm: map['text_am'] as String,
      textOro: map['text_oro'] as String,
      textTig: map['text_tig'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'text_language_id': this.textLanguageId,
      'text_en': this.textEn,
      'text_am': this.textAm,
      'text_oro': this.textOro,
      'text_tig': this.textTig,
    } as Map<String, dynamic>;
  }
}
