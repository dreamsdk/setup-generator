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

// Embedded libraries
#define SourceDirectoryEmbedded SourceDirectoryBase + "\lib-embedded"
#define SourceDirectoryEmbeddedKallisti SourceDirectoryEmbedded + "\lib"

// Packages
#define SourcePackagesBinary SourceDirectoryBase + "\binary-packages"
#define SourcePackagesSource SourceDirectoryBase + "\source-packages"
