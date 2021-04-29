# SMC-Console
A debugging tool for SMC Computer.
Can be used as a BIOS (default setting), or as a program in EarthOS (to debug EMC) - with some changes in the source code.

## Building from source

Clone this repository using this command:

`git clone https://github.com/adazem009/SMC-Console`

Then, go to the source code directory:

`cd SMC-Console`

Before the build process, you need to clone the PowerSlash compiler too:

`chmod +x sync.sh && ./sync.sh`

To build,

`./build.sh`


The binary will be saved in the `image` file.

## Reduce output

You can reduce the output by putting `1` in the `reduce` file:
`echo 1 > reduce`

## Configuration

You can use the `CONFIG` file to change the compilation behavior.

`CONFIG_COMPILER_URL` - compiler repository URL, in case you need a custom PowerSlash compiler
`CONFIG_COMPILER_PATH` - compiler directory - should not be changed
`CONFIG_VERSION` - version of the program (will be automatically updated in the source code)
`CONFIG_CONVERT` - values `y` or `n`; if enabled, the build script will create a BIOS image
