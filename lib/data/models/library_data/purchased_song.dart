import 'package:mehaley/data/models/song.dart';

class PurchasedSong {
  final int paymentId;
  final Song song;
  final DateTime paymentDate;

  PurchasedSong({
    required this.paymentId,
    required this.song,
    required this.paymentDate,
  });

  factory PurchasedSong.fromMap(Map<String, dynamic> map) {
    return PurchasedSong(
      paymentId: map['payment_id'],
      song: Song.fromMap(map['song']),
      paymentDate: DateTime.parse(map['payment_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment_id': this.paymentId,
      'song': this.song,
      'payment_date': this.paymentDate.toIso8601String(),
    };
  }
}
