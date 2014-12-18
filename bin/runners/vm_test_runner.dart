// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of test_runner;

/// Runs Dart tests that can be run in the command line/VM.
class VmTestRunner extends TestRunner {

  /// Pointers to all Dart SDK binaries.
  final DartBinaries dartBinaries;

  /// Pointers to the Dart Project containing the tests.
  final DartProject dartProject;

  /// Constructor.
  VmTestRunner(this.dartBinaries, this.dartProject);

  @override
  Future<TestExecutionResult> runTest(TestConfiguration test) {

    Completer<TestExecutionResult> completer =
        new Completer<TestExecutionResult>();

    // Generate the file that will force the [VmTestConfiguration] for unittest.
    VmTestRunnerCodeGenerator codeGenerator
        = new VmTestRunnerCodeGenerator(dartProject);
    codeGenerator.createTestDartFile(test.testFileName);

    String newTestFilePath =
        "./test/" + TestRunnerCodeGenerator.GENERATED_TEST_FILES_DIR_NAME
        + "/" + test.testFileName;

    Process
        .run(dartBinaries.pubBin,
             ["run", newTestFilePath],
             runInShell: false, workingDirectory: dartProject.projectPath)
        .then(
        (ProcessResult testProcess) {
          TestExecutionResult result = new TestExecutionResult(test);
          result.success = testProcess.exitCode == 0;
          result.testOutput = testProcess.stdout;
          result.testErrorOutput = testProcess.stderr;
          completer.complete(result);
        }
    );

    return completer.future;
  }
}

/// Generates the files necessary for the Browser Tests tu run.
class VmTestRunnerCodeGenerator extends TestRunnerCodeGenerator {

  /// Dart test file that sets the test Configuration before starting the unit
  /// tests.
  static const String DART_TEST_FILE_TEMPLATE_PATH =
      "./runners/vm_templates/vm_test.dart.template";

  /// Constructor.
  VmTestRunnerCodeGenerator(dartProject) : super(dartProject);

  /// Creates the intermediary Dart file that sets the unittest [Configuration].
  Future createTestDartFile(String testFileName) {
    Completer completer = new Completer();

    // Read the content fo the template Dart file.
    File intermediaryDartFile = new File(
        Platform.script.resolve(DART_TEST_FILE_TEMPLATE_PATH).toFilePath());
    intermediaryDartFile.readAsString().then((String dartFileString) {

      // Replaces templated values.
      dartFileString =
          dartFileString.replaceAll("{{test_file_name}}", testFileName);

      // Create the file (and delete it if it already exists).
      String generatedFilePath = '${generatedTestFilesDirectory.path}/'
          + '$testFileName';
      File generatedFile = new File(generatedFilePath);
      if (generatedFile.existsSync()) {
        generatedFile.deleteSync();
      }
      generatedFile.createSync(recursive: true);

      // Write into the [File].
      generatedFile.writeAsStringSync(dartFileString);
      completer.complete();
    });

    return completer.future;
  }
}
