import "dart:io";

import "package:flutter_dotenv/flutter_dotenv.dart";

Future<String> execute(String environment) async {
  final String batchName = "${dotenv.env["BATCH_FILE_NAME"]}${dotenv.env["BATCH_FILE_EXTENSION"]}";
  final String baseDir = dotenv.env["BASE_DIR"]!;
  late String targetPath;

  if (environment == "Acceptance") {
    targetPath = "$baseDir/${dotenv.env["ACCEPTANCE_DIR"]}/$batchName";
  } else if (environment == "Production") {
    targetPath = "$baseDir/${dotenv.env["PRODUCTION_DIR"]}/$batchName";
  } else if (environment == "Training") {
    targetPath = "$baseDir/${dotenv.env["TRAINING_DIR"]}/$batchName";
  }

  try {
    await Process.run(targetPath, []);
  } catch (e) {
    return "Cannot Execute $environment";
  }

  return "$environment is Executed";
}
