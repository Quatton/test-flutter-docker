# Flutter Docker

A practice repository for creating a Dockerfile and devcontainer for Flutter development. This repository is based on the [Flutter Dockerfile](https://blog.codemagic.io/how-to-dockerize-flutter-apps/) by [Codemagic](https://codemagic.io/).

## Changes

`Dockerfile` and `devcontainer` are already configured for you. You can use the `Dockerfile` to build a Docker image and use the `devcontainer` to create a development container.

Here are minor changes I made to the original devcontainer:

Because

```json
"settings": {
    "terminal.integrated.shell.linux": null
  },
```

is deprecated, and I don't know what's the purpose of it. Setting it to `terminal.integrated.defaultProfile.linux: null` is not working. So I removed it.

And, also

```json
"extensions": ["dart-code.flutter"],
```

is not a recommended way to install extensions, I changed to the following:

```json
"customizations": {
    "vscode": {
      "extensions": ["dart-code.flutter"]
    }
  },
```

**Note:** I don't know if `defaultProfile.linux` is the right setting to replace `shell.linux`. I just found it in the [VS Code documentation](https://code.visualstudio.com/docs/editor/integrated-terminal#_configuration). So maybe it does serve its purpose.

For the Dockerfile, I instead based it on the `cirrusci/android-sdk` image, which facilitates the installation of Android SDK. Then we just customize the flutter installation ourselves.

## Usage

1. Install VSCode extensions: Docker and Remote Development.
2. Run the command: Dev Containers: Open Folder in Container... and select the folder `workspace` of this repository.
3. It should take a while (mine took >10 min) to build the image and start the container. But after the first time, it should be faster with cache. (And, that's the beauty of Docker!) 🐳

However, if it fails somewhere in the middle, (which it did multiple times until I troubleshooting it and debugged the Dockerfile), you can try to

1. Try to run `docker build .` If it fails and literally says `ERROR`, then the log should help you with that.
2. If it fails at `flutter doctor` but everything works fine, then you should access the terminal in the container and try to debug inside it. Depending on the error, you might need to install some packages or something.
3. IT SHOULDN'T FAIL THO, BECAUSE IT'S LITERALLY BUILT TO TACKLE THE PROBLEM "BUT IT WORKS ON MY MACHINE!"

## Working in `workspace`

### Connecting to an android device

Because Windows and MacOS cannot port the USB device to the container, you will need an Android device, then remote connect to it with adb.

1. Make sure you have `adb` installed. You can download it from [here](https://developer.android.com/studio/releases/platform-tools).

2. Connect the device to your computer. Make sure you have turned on USB debugging.

3. Run `adb devices` to see if your device is connected. Then you would see something like this:

```bash
List of devices attached
ac5ac6da        device
```

4. Run `adb tcpip 5555` to enable TCP/IP connection.
5. Then connect it by running `adb connect [IP Address in the Wi-Fi settings]:5555` and run `adb devices` again to see if it is connected.

```bash
List of devices attached
ac5ac6da        device
192.168.2.106:5555      device
```

6. You can remove the device!
7. I believe that we could've just run `adb connect [IP Address in the Wi-Fi settings]:5555` without connecting the device with USB. But this is for checking that the device can be connected.
8. You can use `adb kill-server` to terminate the session.
