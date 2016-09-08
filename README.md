# esp8266-arduino-opus
The opus audio codec from XiPH.org, precompiled for platformio-esp8266-arduino.

# Using the git version
The git checkout doesn't contain the precompiled library files, so you have to compile them on your machine.
I'm doing this on a [linux](https://www.kernel.org) box, and I have no idea how to do that on windows (requires a whole bunch of gnu tools...)
I accept PR if someone figure out a better way to do that, anyway.

For those people on [Mac OS X](https://www.apple.com/macos) or [Windows](https://www.microsoft.com/windows), just download the release binary FTM.

for those who are brave enough to compile their own version:

1. make sure you have the `xtensa-lx106-elf` toolchain in your `$PATH`
2. run `script/prepare-xtensa.sh`
3. done!

You may want to tweak around with the environment variables, tho.

# Library usage
**TBD**

# License
- **this library**: [APACHE 2.0](https://github.com/Palatis/esp8266-arduino-opus/blob/master/LICENSE)
- **opus**: [BSD-3](https://opus-codec.org/license/)
- **opusfile**: [BSD-3](https://opus-codec.org/license/)
