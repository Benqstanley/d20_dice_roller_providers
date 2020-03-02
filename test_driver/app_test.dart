// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Dice Roller', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final addRowButtonFinder = find.byValueKey('addRowButton');
    final clearButtonFinder = find.byValueKey('clearButtonKey');
    final rollButtonFinder = find.byValueKey('rollButton');
    final singleTypeCollectionRowFinder = find.byType('CollectionRow');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('buttons appear', () async {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(clearButtonFinder);
        await driver.waitFor(addRowButtonFinder);
        await driver.waitFor(rollButtonFinder);
      });

    });

    test('starts with 1 row', () async {
      await driver.waitFor(singleTypeCollectionRowFinder);
    });

  });
}
