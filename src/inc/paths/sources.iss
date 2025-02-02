// Source directories
#if SourceMode == RELEASE
#define SourceDirectoryBase "..\.sources"
#else
#define SourceDirectoryBase "..\.sources-dev"
#endif

// Foundation: MinGW
#define SourceDirectoryMinGW SourceDirectoryBase + "\mingw-base"
#define SourceDirectoryMSYS SourceDirectoryBase + "\msys-base"
#define SourceDirectoryAppSystemObjectsMSYS SourceDirectoryBase + "\msys-system-objects"
#define SourceDirectoryAppSystemObjectsConfiguration SourceDirectoryBase + "\msys-system-objects-configuration"

// Foundation: MinGW64
#define SourceDirectoryMinGW64 SourceDirectoryBase + "\mingw64-base"
#define SourceDirectoryMSYS2 SourceDirectoryBase + "\msys2-base"
#define SourceDirectoryAppSystemObjectsMSYS2 SourceDirectoryBase + "\msys2-system-objects"

// Foundation: Common
#define SourceDirectoryAddons SourceDirectoryBase + "\addons-cmd"
#define SourceDirectoryTools SourceDirectoryBase + "\addons-gui"
#define SourceDirectoryAppBinaries SourceDirectoryBase + "\dreamsdk-binaries"
#define SourceDirectoryAppCommonObjects SourceDirectoryBase + "\dreamsdk-objects"
#define SourceDirectorySystemUtilities SourceDirectoryBase + "\utilities"

// GDB
#define SourceDirectoryGdb SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-no-python"
#define SourceDirectoryGdbPython27 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-2.7"
#define SourceDirectoryGdbPython33 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.3"
#define SourceDirectoryGdbPython34 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.4"
#define SourceDirectoryGdbPython35 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.5"
#define SourceDirectoryGdbPython36 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.6"
#define SourceDirectoryGdbPython37 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.7"
#define SourceDirectoryGdbPython38 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.8"
#define SourceDirectoryGdbPython39 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.9"
#define SourceDirectoryGdbPython310 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.10"
#define SourceDirectoryGdbPython311 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.11"
#define SourceDirectoryGdbPython312 SourceDirectoryBase + "\sh-elf-gdb\sh-elf-gdb-python-3.12"

// Embedded libraries
#define SourceDirectoryEmbedded SourceDirectoryBase + "\lib-embedded"
#define SourceDirectoryEmbeddedKallisti SourceDirectoryEmbedded + "\lib"
#define SourceDirectoryEmbeddedRuby SourceDirectoryEmbedded + "\ruby"

// Packages
#define SourcePackagesBinary SourceDirectoryBase + "\binary-packages"
#define SourcePackagesSource SourceDirectoryBase + "\source-packages"
