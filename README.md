# SM64 Lua Mod: Honorable Mentions

A Super Mario 64 mod for SM64CoopDX that displays "Honorable Mentions" at the end of each multiplayer round, inspired by GoldenEye 007. Awards players with titles like "Most Tags" based on performance.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Jackafur/sm64-lua-mod.git
   ```

2. Copy the `honorable-mentions` folder to your SM64CoopDX mods directory:
   ```bash
   cp -r honorable-mentions /home/sm64sock/sm64coopdx/mods/honorable-mentions/
   ```

3. Alternatively, use the install script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

4. Launch SM64CoopDX and enable the mod in the server settings.

## Requirements

- SM64CoopDX (e.g., v1.3.1 or later)
- Lua 5.3 or later

## Usage

At the end of a multiplayer round, the mod displays awards such as:

- "Most Tags": Player with the most tag interactions.
- [Add other awards, e.g., "Most Coins" or "Fastest Completion"]

## Scripts

- `client.lua`: Handles client-side multiplayer logic.
- `hud.lua`: Displays real-time stats on the HUD.
- `main.lua`: Initializes the mod and coordinates scripts.
- `stats.lua`: Tracks and calculates stats for awards.

## Contributing

Submit issues or pull requests on GitHub to improve the mod. Also just so you know I have no idea wtf Im doing. So be paitient with me. 

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
