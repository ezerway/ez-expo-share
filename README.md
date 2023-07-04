# ez-expo-share

> **Warning** This plugin is a work in progress so there may be some bugs. Please feel free to contribute by reporting any issues or opening a PR.

## What is it?

An [Expo Config Plugin](https://docs.expo.dev/guides/config-plugins/) that allows you to add a Share Extension to your iOS apps.

> **Note** Not sure what Share Extensions are? Check out [Apple's Share Extension documentation](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html) to learn more.

## Getting Started

1. Install the plugin

```console
npx expo install ez-expo-share
```

2. Configure the plugin in your `app.json`. Specify a `folderName` for where your extension files will live.

```json
{
  "expo": {
    "name": "myApp",
    "plugins": [
      ["ez-expo-share", { "folderName": "MyExtension", "swift": false }]
    ]
  }
}
```

3. Add your extension files to a folder with the name provided above (this folder should be in the root of your project). You can use one of the examples in the `_extensions` directory as a reference.

```console

├── app.json
├── MyExtension # <-- the folder name you provided in the plugin config
│   ├── MainInterface.storyboard
│   └── Info.plist
│   └── ShareViewController.h
│   └── ShareViewController.m
├── node_modules/
├── package.json
└── ...
```

3. If you are using an Expo managed workflow, run a build using EAS. Before it builds, it will run the prebuild step, which triggers the plugin and any others you have specified. If you are using a bare workflow, run `npx expo prebuild -p ios` to run the plugin manually, then run `npx expo run:ios`.

4. Once the app has successfully run, open the Safari app, navigate to any webpage, and press the `AA` button in the address bar. This will open a context menu. Select `Manage Extensions` and enable your extension by switching the toggle on. You should now see your extension as an option in the context menu below Manage Extensions. Click on your extension to open it.

## Acknowledgements

This was heavily inspired by [Andrew Levy](https://github.com/andrew-levy)'s [React Native Safari Extension](https://github.com/andrew-levy/react-native-safari-extension).
