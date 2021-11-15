import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/remote_image.dart';
import 'package:mehaley/data/models/text_lan.dart';

class Chart extends Equatable {
  final int chartId;
  final TextLan chartNameText;
  final TextLan chartDescText;
  final DateTime chartDateCreated;
  final DateTime chartDateUpdated;

  const Chart({
    required this.chartId,
    required this.chartNameText,
    required this.chartDescText,
    required this.chartDateCreated,
    required this.chartDateUpdated,
  });

  @override
  List<Object?> get props => [
        chartId,
        chartNameText,
        chartDescText,
        chartDateCreated,
        chartDateUpdated,
      ];

  factory Chart.fromMap(Map<String, dynamic> map) {
    return new Chart(
      chartId: map['chart_id'] as int,
      chartNameText: TextLan.fromMap(map['chart_name_text_id']),
      chartDescText: TextLan.fromMap(map['chart_desc_text_id']),
      chartDateCreated: DateTime.parse(map['chart_date_created']),
      chartDateUpdated: DateTime.parse(map['chart_date_updated']),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'chart_id': this.chartId,
      'chart_name_text': this.chartNameText,
      'chart_desc_text': this.chartDescText,
      'chart_date_created': this.chartDateCreated,
      'chart_date_updated': this.chartDateUpdated,
    } as Map<String, dynamic>;
  }
}
