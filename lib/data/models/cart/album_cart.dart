import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:mehaley/data/models/album.dart';

part 'album_cart.g.dart';

@HiveType(typeId: 14)
class AlbumCart extends Equatable {
  @HiveField(0)
  final int cartId;
  @HiveField(1)
  final List<Album> items;
  @HiveField(2)
  final double totalPriceEtb;
  @HiveField(3)
  final double totalPriceDollar;
  @HiveField(4)
  final DateTime dateCreated;
  @HiveField(5)
  final DateTime dateUpdated;

  AlbumCart({
    required this.cartId,
    required this.items,
    required this.totalPriceEtb,
    required this.totalPriceDollar,
    required this.dateCreated,
    required this.dateUpdated,
  });

  @override
  List<Object?> get props => [
        cartId,
        items,
        totalPriceEtb,
        totalPriceDollar,
        dateCreated,
        dateUpdated,
      ];

  factory AlbumCart.fromMap(Map<String, dynamic> map) {
    print("mapmap=>  ${map}");
    return new AlbumCart(
      cartId: map['cart_id'] as int,
      items: (map['items'] as List)
          .map((album) => Album.fromMap(album['item']))
          .toList(),
      totalPriceEtb: map['total_price_etb'] as double,
      totalPriceDollar: map['total_price_dollar'] as double,
      dateCreated: DateTime.parse(map['date_created']),
      dateUpdated: DateTime.parse(map['date_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'cart_id': this.cartId,
      'items': this.items,
      'total_price_etb': this.totalPriceEtb,
      'total_price_dollar': this.totalPriceDollar,
      'date_created': this.dateCreated,
      'date_updated': this.dateUpdated,
    } as Map<String, dynamic>;
  }
}
