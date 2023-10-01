![](https://haxe.org/img/branding/haxe-logo-outline-orange.png)

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

1. Install [`Xcode`](https://developer.apple.com/documentation/xcode) to allow C++ app building.
2. Download and install [`git-scm`](https://git-scm.com/download/mac).
3. Open up a `Terminal` window in `UTF` folder and type `haxelib install hmm` after it finishes, simply type `haxelib run hmm install` in order to install all the needed libraries.
4. Run `haxelib run lime test mac` to compile and launch the game.
   - You can run `haxelib run lime setup` to make the lime command global, allowing you to execute `lime test mac` directly.
