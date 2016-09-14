# arduino-opus
The opus audio codec from XiPH.org for arduino

# NOTE
This library is mainly targeted for [Platform.io](https://platformio.org), because I have no idea how to specify compiler flags in Arduino library.

If someone actually DO find a way to do that, I'm open for PR.

# Using the git version
The git checkout doesn't contain the codes from [libogg](https://github.com/xiph/ogg), [libopus](https://github.com/xiph/opus), nor [libopusfile](https://github.com/xiph/opusfile), there is some more step to be done before you can compile your project with platformio.
I'm doing this on a [linux](https://www.kernel.org) box, and I have no idea how to do that on windows (requires a whole bunch of gnu tools...)
I accept PR if someone figure out a better way to do that, anyway.

For those people on [Mac OS X](https://www.apple.com/macos) or [Windows](https://www.microsoft.com/windows), just download the release tarball FTM.

1. `git submodule init`
2. `git submodule update`
3. `git submodule sync`
4. run `script/prepare.sh`
2. done!

# Library usage
**TBD**

# License
- **this library**: [APACHE 2.0](https://github.com/Palatis/esp8266-arduino-opus/blob/master/LICENSE)
- **ogg**: BSD-3 (link wanted!)
- **opus**: [BSD-3](https://opus-codec.org/license/)
- **opusfile**: [BSD-3](https://opus-codec.org/license/)
