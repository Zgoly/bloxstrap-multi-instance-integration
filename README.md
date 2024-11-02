> [!WARNING]
> ### After one of the Bloxstrap updates, this integration stopped working.
> 
> ## [A new solution is highly recommended - MultiBloxy](https://github.com/Zgoly/MultiBloxy)

# 🎮 Bloxstrap Multi-instance Integration 🎮
Unleash the power of multiple instances with this fantastic integration for [Bloxstrap](https://github.com/pizzaboxer/bloxstrap)! After the [recent update](https://github.com/pizzaboxer/bloxstrap/releases/tag/v2.6.0) that [removed the ability to use multiple instances](https://github.com/pizzaboxer/bloxstrap/wiki/Plans-to-remove-multi%E2%80%90instance-launching-from-Bloxstrap) of Roblox, this integration brings back that functionality. 🎉

<img src="https://raw.githubusercontent.com/Zgoly/hosts/main/bloxstrap-multi-instance-integration_banner.png"/>

## 🔧 Installation
1. Grab the [latest source code](https://github.com/Zgoly/bloxstrap-multi-instance-integration/archive/refs/heads/main.zip)
2. Unzip the downloaded archive and place the folder anywhere you like, preferably without spaces in the final path:
   * ❌ `C:\Users\User\Desktop\Some Secret Folder\bloxstrap-multi-instance-integration-main`
   * ✅ `C:\Users\User\Desktop\bloxstrap-multi-instance-integration-main`
3. Run `Install.bat` to begin the installation process.

## 🛠️ Uninstallation
1. Follow the first two steps from the Installation.
2. Run `Uninstall.bat` to begin the uninstallation process.

## 🚀 Usage
Launch the game/experience through Bloxstrap, and voilà! You're all set! 🎉

Before launching Roblox, you should see a console window that will notify you of the successful activation. Don't close this window; it will close itself when you close Roblox. 🎈

## 🧩 How This Integration Works
In a nutshell, Roblox uses a `Mutex` to manage multiple instances. Our integration creates the same `Mutex` with an identical name, passing `true` as the first parameter. This action makes the calling thread the original owner of the mutex, preventing Roblox from using it. Simple yet effective!

## 🔒 Safety and Legality
* **Safety**: Absolutely! The source code is open to everyone, and since it's powered by PowerShell, you can inspect it anytime. 🔍
* **Legality**: Yes, as long as you're not using automated accounts. Play fair and have fun! 🤗
