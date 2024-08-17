import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

import "package:amos_environment_runner/usecase/.index.dart" as usecase;
import "package:amos_environment_runner/entity/.index.dart" as entity;
import "package:amos_environment_runner/infra/.index.dart" as infra;

final class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: BlocBuilder<infra.ConfigurationImporter, infra.ConfigurationImporterState>(
          builder: (_, state) {
            if (state is infra.ConfigurationImporterSuccess) {
              context.read<usecase.EnvironmentRunner>().pick(state.config.environments.first);

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _DropdownMenu(
                    config: state.config,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const _StatusWindow(),
                  const SizedBox(
                    height: 16,
                  ),
                  const _ExecuteButton(),
                ],
              );
            }

            if (state is infra.ConfigurationImporterFailure) {
              return Center(
                child: Text(
                  state.error.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontWeight: FontWeight.w100,
                  ),
                ),
              );
            }

            if (state is infra.ConfigurationImporterLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Center(
              child: Text(
                "State of ConfigurationImporter is Initial",
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

final class _DropdownMenu extends StatelessWidget {
  const _DropdownMenu({
    required this.config,
  });

  final entity.Configuration config;

  @override
  Widget build(context) {
    return BlocBuilder<usecase.EnvironmentRunner, usecase.RunnerState>(
      builder: (_, state) {
        return DropdownMenu<entity.Environment>(
          enabled: state is! usecase.RunnerLoading,
          label: const Text("Environment"),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w100,
          ),
          initialSelection: config.environments.first,
          dropdownMenuEntries: config.environments
              .map(
                (environment) => DropdownMenuEntry<entity.Environment>(
                  label: environment.title,
                  value: environment,
                ),
              )
              .toList(),
          onSelected: (value) {
            if (value != null) {
              context.read<usecase.EnvironmentRunner>().pick(value);
            }
          },
          expandedInsets: const EdgeInsets.all(0),
        );
      },
    );
  }
}

final class _StatusWindow extends StatelessWidget {
  const _StatusWindow();

  @override
  Widget build(context) {
    return BlocBuilder<usecase.EnvironmentRunner, usecase.RunnerState>(
      builder: (_, state) {
        Text getInfo() {
          const style = TextStyle(
            fontFamily: "Cascadia Code",
            fontWeight: FontWeight.w100,
          );

          if (state is usecase.RunnerPrepare) {
            return Text(
              "${state.directory}/${state.executable}",
              style: style,
            );
          }

          if (state is usecase.RunnerLoading) {
            return const Text(
              "Loading...",
              style: style,
            );
          }

          if (state is usecase.RunnerFailure) {
            return Text(
              state.message,
              style: style,
            );
          }

          if (state is usecase.RunnerSuccess) {
            return const Text(
              "Execution Success",
              style: style,
            );
          }

          return const Text(
            "No Target Selected",
            style: TextStyle(
              fontFamily: "Cascadia Code",
              fontWeight: FontWeight.w100,
            ),
          );
        }

        return Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status Window",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                getInfo(),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _ExecuteButton extends StatelessWidget {
  const _ExecuteButton();

  @override
  Widget build(context) {
    return BlocBuilder<usecase.EnvironmentRunner, usecase.RunnerState>(
      builder: (_, state) {
        return SizedBox(
          height: 48,
          width: double.infinity,
          child: FilledButton(
            onPressed: state is usecase.RunnerPrepare
                ? () {
                    context.read<usecase.EnvironmentRunner>().execute(
                          "${state.directory}/${state.executable}",
                        );
                  }
                : null,
            child: state is usecase.RunnerLoading
                ? Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  )
                : const Text(
                    "Execute",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

final class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Text(
        "Developed by In Son © 2024 Aero K Airlines Ltd. Licensed under the MIT License.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).disabledColor,
          fontWeight: FontWeight.w100,
          fontSize: 10,
        ),
      ),
    );
  }
}
