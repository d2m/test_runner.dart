# Test Runner for Dart

Test Runner for Dart (TRD) is a command line Test Runner for Dart test files.
TRD will automatically detect and run all the tests in your Dart project in the
correct environment (VM or Browser).

## Installation and usage

TRD is available for download on the
[Pub Package Manager](https://pub.dartlang.org/packages/test_runner) (NOT YET! for now download locally and run: `dart <path_to_coureur>/bin/coureur.dart`)

To install TRD use this command:

    pub global activate test_runner (NOT YET!)

To run TRD use this command from within the root of your Dart project:

    pub global run test_runner (NOT YET!)

Alternatively you can add the pub cache `bin` directory to your PATH:
`~/.pub-cache/bin`. Then you will be able to simply use:

    run_tests -c

For a list of options and to learn more use:

    run_tests --help

### Result

Here is an example of output from the Dart test runner:

    bash> run_tests

    Checking Dart binaries...
    Dart binaries OK.

    Looking for Dart project in "./"...
    Found project "test-runner".

    Looking for test files...
    Found 5 test files:
     - 3 Standalone VM
     - 2 Dartium

    Running all tests...
    Test passed: /browser_ok_test.dart
    Test passed: /browser_ok_with_html_test.dart
    Test passed: /subdir/vm_in_subdir_ok_test.dart
    Test passed: /vm_ok_test.dart
    Test failed: /vm_fail_test.dart

    SUMMARY: 1 TEST FILES FAILED. 4 TEST FILES PASSED.

TIP: use the `-c` option to get a nice colored output

The exit code will be:

 - If all tests passed: `0`
 - If a test file has failed: `1`
 - If a test runner error happened: `2`

## Test files detection and conventions

Your tests have to follow certain conventions to be reliably detected by TRD.
Please make sure that:

 - Your tests files are suffixed with `_test.dart`
 - Your test contain a `main()` that runs all your unit tests.

Depending on the environment into which your test runs there are additional
requirements listed below.

### Standalone VM tests

Standalone VM tests are tests that can be run from the command line using
'dart'. The executable of the test needs to return an exit code of 1 if there
was an error and 0 if all tests were successful.

NOTE: Typically if you wrote browser tests using the
[unittest package](https://pub.dartlang.org/packages/unittest) you should be all
set.

### Browser tests

Browser tests are tests that need to be ran in a browser environment such as
dartium.

Browser tests will be executed in a headless version of Chromium for Dart called
Content Shell.

If all tests have passed your test needs to print `PASS\n` ("PASS" followed by a
line break).

You can provide an HTML file for a Browser Test. The HTML file needs to
have the same base name (for `my_test.dart` use `my_test.html`).

You don't have to write an HTML file associated to your browser tests. The Dart
test runner will automatically use a default HTML file and run your Browser
tests in it if you didn;t provide a custom one.

TRD will automatically detect if a test file needs to be ran inside a Browser if
there is no associated HTML file.

NOTE: Typically if you wrote browser tests using the
[unittest package](https://pub.dartlang.org/packages/unittest) you should be all
set as the Dart test runner will automatically and transparently set an
appropriate test `Configuration` and will import
`packages/unittest/test_controller.js` into the HTML page.

## Tools and environment

TRD only runs on Linux and Mac OS X. We're looking into enabling Windows at a
later date. TRD also needs the following tools installed:

 - Content Shell: A headless version of Dartium.
 - Dart SDK: Especially the `pub` command which will be used to run and serve
   tests and `dart2js` which is used to detect browser tests.

Ideally make sure that these tools are available in your PATH as `pub`,
`dart2js` and `content_shell`. You can also specify the path to these tools
executable with `--content-shell-bin`, `--pub-bin` and `--dart2js-bin`.

## Options and examples

### Usage

Generic usage of TRD:

    run_tests [options] [<project-or-tests>...]

Where `<project-or-tests>` is the path to the project root/test folder or a list
of path to individual test files to run. If omitted all tests of the current project will be discovered and ran.

### Options

`--content-shell-bin`: Path to the Content Shell executable. If omitted "content_shell" from env is used.

`--pub-bin`: Path to the Pub executable. If omitted "pub" from env is used.

`--dart2js`: Path to the dart2js executable. If omitted "dart2js" from env is used.

`-c` or `--color`: Prints the output in color in a shell.

`-v` or `--verbose`: Prints all tests results instead of just the summary.

`-h` or `--help`: Print usage information.

### Examples

Runs all unit tests of the project in the current directory with a colored output:

    run_tests -c

Runs the specified two unit test files:

    run_tests test/my_first_test.dart test/my_second_test.dart

Runs all unit tests of the Dart project located at `~/my_project/`:

    run_tests ~/my_project/

Runs all tests of the project located at `~/my_project/` and use
`~/dartium/content_hell` as the Dartium executable.

    run_tests --content-shell-bin ~/dartium/content_hell ~/my_project/

## License

BSD 3-Clause License.
See [LICENSE](LICENSE) file.