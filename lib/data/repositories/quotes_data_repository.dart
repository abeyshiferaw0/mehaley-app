import 'package:elf_play/config/app_hive_boxes.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/data/data_providers/payment_provider.dart';
import 'package:elf_play/data/data_providers/quotes_data_provider.dart';
import 'package:elf_play/data/models/enums/app_payment_methods.dart';
import 'package:flutter/material.dart';

import '../verse.dart';

class QuotesDataRepository {
  final QuotesDataProvider quotesDataProvider;

  const QuotesDataRepository({required this.quotesDataProvider});

  List<Verse> getRandomVerses(int limit,Locale locale){
    return quotesDataProvider.getRandomVerses(limit,locale);
  }

}
