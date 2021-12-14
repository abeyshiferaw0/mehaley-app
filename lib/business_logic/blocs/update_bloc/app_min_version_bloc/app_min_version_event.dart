part of 'app_min_version_bloc.dart';

abstract class AppMinVersionEvent extends Equatable {
  const AppMinVersionEvent();
}

class CheckAppMinVersionEvent extends AppMinVersionEvent {
  @override
  List<Object?> get props => [];
}
