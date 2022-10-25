// This is the entrypoint of our custom linter
import 'dart:convert';
import 'dart:isolate';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const defaultMaxLineCount = 500;

// TODO(Zoli): Args are passed here. https://github.com/invertase/dart_custom_lint/blob/f2e09661556745aac59c9a5967312d2b646e0119/packages/custom_lint/lib/src/analyzer_plugin/plugin_link.dart#L58

/// [args] should either be `['projectRoot', '']` or `['projectRoot', '{lineCount: 123}']`
void main(List<String> args, SendPort sendPort) {
  startPlugin(sendPort, _MaxLines(args[0], args[1]));
}

// This class is the one that will analyze Dart files and return lints
class _MaxLines extends PluginBase {
  final String projectRoot;
  late final int maxLineCount;

  _MaxLines(this.projectRoot, String parameters) {
    if (parameters.isNotEmpty) {
      final parsedParameters = jsonDecode(parameters) as Map<String, dynamic>;
      maxLineCount =
          parsedParameters['line_count'] as int? ?? defaultMaxLineCount;
    }
  }

  bool isProjectFile(ResolvedUnitResult resolvedUnitResult, String path) =>
      // resolvedUnitResult.libraryElement.
      path.startsWith(
        '$projectRoot/lib',
      );

  @override
  Stream<Lint> getLints(ResolvedUnitResult resolvedUnitResult) async* {
    final path = resolvedUnitResult.libraryElement.source.fullName;

    if (isProjectFile(resolvedUnitResult, path)) {
      final lineCount = resolvedUnitResult.unit.lineInfo.lineCount;

      if (lineCount > maxLineCount) {
        yield Lint(
          code: 'max_lines',
          message: 'This file is longer than $maxLineCount.',
          // Where your lint will appear within the Dart file.
          // The following code will make appear at the top of the file (offset 0),
          // and be 10 characters long.
          location: resolvedUnitResult.lintLocationFromOffset(0, length: 1),
          severity: LintSeverity.warning,
        );
      }
    }
  }
}
