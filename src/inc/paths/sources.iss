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

// Addons
#define SourceDirectoryAddons SourceDirectoryBase + "\addons-cmd"
#define SourceDirectoryTools SourceDirectoryBase + "\addons-gui"

// DreamSDK Common
#define SourceDirectoryAppCommonObjects SourceDirectoryBase + "\dreamsdk-objects"
#define SourceDirectorySystemUtilities SourceDirectoryBase + "\utilities"

// DreamSDK Binaries: x86
#define SourceDirectoryAppBinaries SourceDirectoryBase + "\dreamsdk-binaries"
#define SourcePackagesBinary SourceDirectoryBase + "\binary-packages"

// DreamSDK Binaries: x64
#define SourceDirectoryAppBinaries64 SourceDirectoryBase + "\dreamsdk-binaries-x64"
#define SourcePackagesBinary64 SourceDirectoryBase + "\binary-packages-x64"

// Source Packages
#define SourcePackagesSource SourceDirectoryBase + "\source-packages"

// Embedded Libraries
#define SourceDirectoryEmbedded SourceDirectoryBase + "\lib-embedded"
#define SourceDirectoryEmbeddedKallisti SourceDirectoryEmbedded + "\lib"
