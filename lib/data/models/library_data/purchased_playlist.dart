import 'package:mehaley/data/models/playlist.dart';

class PurchasedPlaylist {
  final int paymentId;
  final Playlist playlist;
  final DateTime paymentDate;
  PurchasedPlaylist({
    required this.paymentId,
    required this.playlist,
    required this.paymentDate,
  });

  factory PurchasedPlaylist.fromMap(Map<String, dynamic> map) {
    return PurchasedPlaylist(
      paymentId: map["payment_id"],
      playlist: Playlist.fromMap(map["playlist"]),
      paymentDate: DateTime.parse(map["payment_date"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "payment_id": this.paymentId,
      "playlist": this.playlist,
      "payment_date": this.paymentDate.toIso8601String(),
    };
  }
}
