import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";

import "package:amos_environment_runner/entity/.index.dart" as entity;

final class EnvironmentRunner extends Cubit<RunnerState> {
  EnvironmentRunner() : super(RunnerInitial());

  void pick(entity.Environment environment) {
    emit(RunnerPrepare(
      environment.directory,
      environment.executable,
    ));
  }

  void execute(String target) async {
    emit(RunnerLoading());

    try {
      await Process.run(target, []).then((_) {
        emit(RunnerSuccess());
      });
    } catch (e) {
      emit(RunnerFailure("Can't execute $target"));
    }
  }
}

sealed class RunnerState {}

final class RunnerInitial extends RunnerState {}

final class RunnerLoading extends RunnerState {}

final class RunnerPrepare extends RunnerState {
  final String directory;
  final String executable;

  RunnerPrepare(this.directory, this.executable);
}

final class RunnerFailure extends RunnerState {
  final String message;

  RunnerFailure(this.message);
}

final class RunnerSuccess extends RunnerState {}
