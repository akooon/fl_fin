import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final List<String> dataList;
  final bool isLoading;

  const MainState({
    required this.dataList,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [dataList, isLoading];

  MainState copyWith({
    List<String>? dataList,
    bool? isLoading,
  }) {
    return MainState(
      dataList: dataList ?? this.dataList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
