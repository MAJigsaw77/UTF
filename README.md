## UTF ![](https://raw.githubusercontent.com/MAJigsaw77/UTF/main/icon.svg)

![](https://img.shields.io/github/repo-size/MAJigsaw77/UTF) ![](https://badgen.net/github/open-issues/MAJigsaw77/UTF) ![](https://badgen.net/badge/license/Apache-2.0/green)

A engine for [Undertale](https://undertale.com) made with [HaxeFlixel](https://haxeflixel.com).

> **Note**
> The engine is very early in development.

### Download

> The latest builds of the engine can be found in the [Actions](https://github.com/MAJigsaw77/UTF/actions) tab.

### Compiling

![](https://raw.githubusercontent.com/HaxeFoundation/haxe/development/extra/images/Readme.png)

Install [`Haxe`](https://haxe.org/download).

#### Windows

1. Download [`Visual Studio Build Tools`](https://aka.ms/vs/17/release/vs_BuildTools.exe)
2. Wait for the Visual Studio Installer to install
3. On the Visual Studio installer screen, go to the "Individual components" tab and only select those options:
    - MSVC v143 VS 2022 C++ x64/x86 build tools.
    - Windows 10/11 SDK.
4. This is what your Installation details panel should look like. Once correct, press "Install".
    > **Warning**
    > This will download around 1.07 GB of data from the internet, and will require around 5.5 GB of available space on your computer.
5. Once the installation is done, close Visual Studio Installer.
6. Download and install [`git-scm`](https://git-scm.com/download/win).
    - Leave all installation options as default.
7. Open up a `Command Prompt/PowerShell` window in `UTF` folder and type `haxelib install hmm` after it finishes, simply type `haxelib run hmm install` in order to install all the needed libraries.
8. Run `haxelib run lime test windows` to compile and launch the game.
    - You can run `haxelib run lime setup` to make the lime command global, allowing you to execute `lime test windows` directly.

#### Linux

1. Install `g++`, if not present already.
2. Download and install [`git-scm`](https://git-scm.com/download/linux).
3. Open up a `Terminal` window in `UTF` folder and type `haxelib install hmm` after it finishes, simply type `haxelib run hmm install` in order to install all the needed libraries.
4. Run `haxelib run lime test linux` to compile and launch the game.
    - You can run `haxelib run lime setup` to make the lime command global, allowing you to execute `lime test linux` directly.

#### MacOS

1. Install `XCode` to allow C++ app building.
2. Download and install [`git-scm`](https://git-scm.com/download/mac).
3. Open up a `Terminal` window in `UTF` folder and type `haxelib install hmm` after it finishes, simply type `haxelib run hmm install` in order to install all the needed libraries.
4. Run `haxelib run lime test mac` to compile and launch the game.
   - You can run `haxelib run lime setup` to make the lime command global, allowing you to execute `lime test mac` directly.
 
### Licensing

**UTF** is made available under the **Apache 2.0 License**. Check [LICENSE](./LICENSE) for more information.

### Credits

| Avatar | UserName | Involvement |
| ------ | -------- | ----------- |
| ![](https://github.com/MAJigsaw77/UTF/assets/45212377/beaacae9-abcf-4a70-bf2a-59511c5b007c) | [Toby Fox](https://twitter.com/tobyfox) | Creator of [**Undertale**](https://undertale.com).
| ![](https://avatars.githubusercontent.com/u/77043862?s=64) | [MAJigsaw77](https://github.com/MAJigsaw77) | Creator of **UTF**.
| ![](https://avatars.githubusercontent.com/u/23155359?s=64) | [Ne_Eo](https://github.com/NeeEoo) | Programmer.
| ![](https://avatars.githubusercontent.com/u/45212377?s=64) | [CrowPlexus](https://github.com/CrowPlexus) | Programmer.
