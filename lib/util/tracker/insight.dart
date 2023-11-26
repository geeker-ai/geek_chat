import 'dart:async';

import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:flutter/foundation.dart';

Future<void> submitErrorAsTelemetry({
  required bool isFatal,
  required Object error,
  required StackTrace trace,
}) async {
  debugPrint('reporting ${isFatal ? 'fatal' : 'non-fatal'} error: $error');
  debugPrint('$trace');

  try {
    // Get your TelemetryClient instance here, perhaps by DI or some other mechanism.
    final telemetryClient = ...;

    // Get any additional properties for the crash report here, such as device information.
    final errorProperties = ...;

    // Write an error telemetry item.
    telemetryClient.trackError(
      error: error,
      stackTrace: trace,
      severity: isFatal ? Severity.critical : Severity.error,
      additionalProperties: errorProperties,
    );

    if (isFatal) {
      await telemetryClient.flush();
    }
  } on Object catch (e, t) {
    // We print synchronously here to ensure the output is written in the case we force exit.
    debugPrintSynchronously('Sending error telemetry failed: $e\r\n$t');
    debugPrintSynchronously('Original error: $error');
  } finally {
    if (isFatal && kReleaseMode) {
      debugPrintSynchronously('Forcing exit');
    }
  }
}

Future<void> runWithCrashReporting({
  required VoidCallback codeToExecute,
}) async {
  // Hook into Flutter error handling.
  FlutterError.onError = (details) => submitErrorAsTelemetry(
        isFatal: true,
        error: details.exception,
        trace: details.stack!,
      );

  // Run the code to execute in a zone and handle all errors within.
  runZonedGuarded(
    codeToExecute,
    (error, trace) => submitErrorAsTelemetry(
      isFatal: true,
      error: error,
      trace: trace,
    ),
  );
}