import 'package:mehaley/data/data_providers/quotes_data_provider.dart';

import '../verse.dart';

class QuotesDataRepository {
  final QuotesDataProvider quotesDataProvider;

  const QuotesDataRepository({required this.quotesDataProvider});

  List<Verse> getRandomVerses(int limit) {
    return quotesDataProvider.getRandomVerses(limit);
  }
}
