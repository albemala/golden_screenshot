/// This file contains the tests that take screenshots of the app.
///
/// Run it with `flutter test --update-goldens` to generate the screenshots
/// or `flutter test` to compare the screenshots to the golden files.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:golden_screenshot_example/main.dart';

void main() {
  group('Screenshot:', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    final homePageTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    );
    final homePageFrameColors = ScreenshotFrameColors(
      topBar: homePageTheme.colorScheme.inversePrimary,
      bottomBar: homePageTheme.colorScheme.surface,
    );

    _screenshotWidget(
      counter: 100,
      frameColors: homePageFrameColors,
      theme: homePageTheme,
      goldenFileName: '1_counter_100',
      child: const MyHomePage(
        title: 'Golden screenshot demo',
      ),
    );

    _screenshotWidget(
      counter: 998,
      frameColors: homePageFrameColors,
      theme: homePageTheme,
      goldenFileName: '2_counter_998',
      child: const MyHomePage(
        title: 'Golden screenshot demo',
      ),
    );

    _screenshotWidget(
      counter: 998,
      frameColors: homePageFrameColors,
      theme: homePageTheme,
      goldenFileName: '3_dialog',
      child: const MyHomePage(
        title: 'Golden screenshot dialog demo',
        showDialog: true,
      ),
    );
  });
}

void _screenshotWidget({
  int counter = 0,
  ScreenshotFrameColors? frameColors,
  ThemeData? theme,
  required String goldenFileName,
  required Widget child,
}) {
  group(goldenFileName, () {
    for (final goldenDevice in GoldenScreenshotDevices.values) {
      testWidgets('for ${goldenDevice.name}', (tester) async {
        final device = goldenDevice.device;

        // Enable shadows which are normally disabled in golden tests.
        // Make sure to disable them again at the end of the test.
        debugDisableShadows = false;

        final widget = ScreenshotApp(
          theme: theme,
          device: device,
          frameColors: frameColors,
          child: child,
        );
        await tester.pumpWidget(widget);

        tester.state<MyHomePageState>(find.byType(MyHomePage)).counter =
            counter;

        // Precache the images and fonts
        // so they're ready for the screenshot.
        await tester.precacheImagesInWidgetTree();
        await tester.precacheTopbarImages();
        await tester.loadFonts();

        // Pump the widget for a second to ensure animations are complete.
        await tester.pumpFrames(widget, const Duration(seconds: 1));

        // Take the screenshot and compare it to the golden file.
        await tester.expectScreenshot(device, goldenFileName);

        debugDisableShadows = true;
      });
    }
  });
}
