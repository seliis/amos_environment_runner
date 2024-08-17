import "dart:convert";

import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:amos_environment_runner/entity/.index.dart" as entity;

final class ConfigurationImporter extends Cubit<ConfigurationImporterState> {
  ConfigurationImporter() : super(ConfigurationImportInitial());

  void import() async {
    emit(ConfigurationImporterLoading());

    try {
      final String response = await rootBundle.loadString("assets/config.json");
      final entity.Configuration config = entity.Configuration.fromJson(json.decode(response) as Map<String, dynamic>);
      emit(ConfigurationImporterSuccess(config: config));
    } catch (error) {
      emit(ConfigurationImporterFailure(error: error));
    }
  }
}

sealed class ConfigurationImporterState {
  const ConfigurationImporterState();
}

final class ConfigurationImportInitial extends ConfigurationImporterState {}

final class ConfigurationImporterLoading extends ConfigurationImporterState {}

final class ConfigurationImporterFailure extends ConfigurationImporterState {
  const ConfigurationImporterFailure({
    required this.error,
  });

  final Object error;
}

final class ConfigurationImporterSuccess extends ConfigurationImporterState {
  const ConfigurationImporterSuccess({
    required this.config,
  });

  final entity.Configuration config;
}
