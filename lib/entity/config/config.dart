final class Configuration {
  const Configuration({
    required this.environments,
  });

  final List<Environment> environments;

  factory Configuration.fromJson(Map<String, dynamic> json) {
    final List<Environment> environments = <Environment>[];

    for (final dynamic environment in json["environments"] as List<dynamic>) {
      environments.add(
        Environment.fromJson(environment as Map<String, dynamic>),
      );
    }

    return Configuration(
      environments: environments,
    );
  }
}

final class Environment {
  const Environment({
    required this.title,
    required this.directory,
    required this.executable,
  });

  final String title;
  final String directory;
  final String executable;

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      title: json["title"] as String,
      directory: json["directory"] as String,
      executable: json["executable"] as String,
    );
  }
}
