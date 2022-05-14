import '../album.dart';

class PurchasedAlbum {
  final int paymentId;
  final Album album;
  final DateTime paymentDate;

  PurchasedAlbum({
    required this.paymentId,
    required this.album,
    required this.paymentDate,
  });

  factory PurchasedAlbum.fromMap(Map<String, dynamic> map) {
    return PurchasedAlbum(
      paymentId: map['payment_id'],
      album: Album.fromMap(map['album']),
      paymentDate: DateTime.parse(map['payment_date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment_id': this.paymentId,
      'album': this.album,
      'payment_date': this.paymentDate.toIso8601String(),
    };
  }
}
