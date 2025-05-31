; ==============================================================================
; DreamSDK Setup - Inno Setup Script
; ==============================================================================

; Installer mode [DEBUG|RELEASE]
; If set to DEBUG, this will append the "-dev" suffix to the package release,
; e.g., "DreamSDK R3-dev".
#define InstallerMode RELEASE

; Source mode [DEBUG|RELEASE]
; Specify the source location that will be used when making the installer. If
; this parameter is set to DEBUG, it will use the ".sources-dev" directory
; provided in this repository, mainly used for debugging the installer script.
; If this parameter is set to RELEASE, it will use the real sources files. You
; will need to follow the instructions in the "dreamsdk/dreamsdk" repository
; to generate the proper ".sources" directory.
#define SourceMode RELEASE

; Environment home variable mode [DEBUG|RELEASE]
; If set to DEBUG, the system environment variable will be set to 
; "DREAMSDK_HOME_DEBUG". If set to RELEASE, the variable will be named
; "DREAMSDK_HOME". This feature is only working when InstallerMode is in 
; DEBUG mode.
#define EnvironmentHomeVariableMode RELEASE

; Compression mode [COMPRESSION_ENABLED|COMPRESSION_DISABLED]
; Set this to COMPRESSION_DISABLED if you just want to test the setup generation
; with real files (i.e., using the ".sources" directory). Then set this flag to
; COMPRESSION_ENABLED to compress the files in the installer. This will take a
; while, so do this only if you are happy with your changes.
#define CompressionMode COMPRESSION_ENABLED

; Previous version uninstallation mode [UNINSTALL_REQUIRED|UNINSTALL_IGNORED]
; Set this to UNINSTALL_IGNORED if you want to avoid the automatic
; uninstallation of a previous DreamSDK version. This feature is only working
; when InstallerMode is in DEBUG mode.
#define DebugUninstallHandlingMode UNINSTALL_REQUIRED

; Digital signature mode [SIGNATURE_ENABLED|SIGNATURE_DISABLED]
; This parameter is used for code signing the installer your are generating.
; You will need the SignTool utility from Microsoft.
; See: https://docs.microsoft.com/en-us/windows/win32/seccrypto/signtool
; After installing SignTool, you need to configure the DualSign script provided
; in the "dreamsdk/setup-helpers" repository.
; Then, when using the "mksetup" script from the "dreamsdk/dreamsdk" repository,
; it will sign your installer with the provided signature. Please note, it will
; try to dual-sign the binary with SHA-1 (deprecated) and SHA-256 (current).
#define DigitalSignatureMode SIGNATURE_DISABLED
