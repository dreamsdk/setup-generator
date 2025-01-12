[Icons]

; Main shortcuts (group)
Name: "{group}\{#FullAppMainName}"; Filename: "{code:GetApplicationComponentShellFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#FullAppManagerName}"; Filename: "{code:GetApplicationComponentManagerFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{code:GetApplicationSupportPath}\uninst.ico"; IconIndex: 0; Comment: "{cm:UninstallPackage}"

; Installation directory main shortcuts (app)
Name: "{app}\{#FullAppMainName}"; Filename: "{code:GetApplicationComponentShellFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{app}\{#FullAppManagerName}"; Filename: "{code:GetApplicationComponentManagerFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{app}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{code:GetApplicationSupportPath}\uninst.ico"; Comment: "{cm:UninstallPackage}"

; Additional shortcuts (based on tasks)
Name: "{commondesktop}\{#FullAppMainName}"; Filename: "{code:GetApplicationComponentShellFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{code:GetApplicationComponentShellFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{code:GetApplicationComponentShellFilePath}"; WorkingDir: "{code:GetApplicationMainPath}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

;
; Post-Windows 8 shortcuts
;

; Documentation
Name: "{group}\{cm:DocumentationGroupDirectory}"; Filename: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}\{cm:GettingStarted}"; Filename: "{code:GetApplicationComponentGettingStartedFilePath}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{code:GetApplicationSupportPath}\license.rtf"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{code:GetApplicationComponentHelpFilePath}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}\{cm:KallistiOfficialDocumentation}"; Filename: "http://gamedev.allusion.net/docs/kos-2.0.0/"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:DocumentationGroupDirectory}\{cm:SegaDreamcastWikiDocumentation}"; Filename: "https://dreamcast.wiki"; MinVersion: 0,6.2

; Useful Links
Name: "{group}\{cm:UsefulLinksGroupDirectory}"; Filename: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAwesomeDreamcast}"; Filename: "https://github.com/dreamcastdevs/awesome-dreamcast"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkCodeBlocks}"; Filename: "http://www.codeblocks.org"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulation}"; Filename: "https://dcemulation.org"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulationProgrammingDiscussion}"; Filename: "https://dcemulation.org/phpBB/viewforum.php?f=29"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAppGitHub}"; Filename: "https://github.com/dreamsdk"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkMarcusDreamcast}"; Filename: "http://mc.pp.se/dc"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSegaDreamcastGitHub}"; Filename: "https://github.com/sega-dreamcast"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSimulantDiscordChannel}"; Filename: "https://discord.gg/TRx94EV"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSiZiOUS}"; Filename: "http://www.sizious.com"; MinVersion: 0,6.2
Name: "{code:GetApplicationShortcutsPath}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDreamcastWiki}"; Filename: "https://dreamcast.wiki"; MinVersion: 0,6.2

; Tools
Name: "{group}\{cm:ToolsGroupDirectory}"; Filename: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2

; Tools: 1ST_READ.BIN Checker
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkChecker}"; Filename: "{code:GetApplicationToolsPath}\checker\checker.exe"; WorkingDir: "{code:GetApplicationToolsPath}\checker"; Comment: "{cm:ComponentUtilities_checker}"; MinVersion: 0,6.2; Components: tools\checker
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkCheckerReadme}"; Filename: "{code:GetApplicationToolsPath}\checker\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\checker"; MinVersion: 0,6.2; Components: tools\checker

; Tool: BootDreams
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkBootDreams}"; Filename: "{code:GetApplicationToolsPath}\bdreams\BootDreams.exe"; WorkingDir: "{code:GetApplicationToolsPath}\bdreams"; Comment: "{cm:ComponentUtilities_bdreams}"; MinVersion: 0,6.2; Components: tools\bdreams
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkBootDreamsHelp}"; Filename: "{code:GetApplicationToolsPath}\bdreams\BootDreams.chm"; WorkingDir: "{code:GetApplicationToolsPath}\bdreams"; MinVersion: 0,6.2; Components: tools\bdreams

; Tool: IP.BIN Writer
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkIpWriter}"; Filename: "{code:GetApplicationToolsPath}\ipwriter\ipwriter.exe"; WorkingDir: "{code:GetApplicationToolsPath}\ipwriter"; Comment: "{cm:ComponentUtilities_ipwriter}"; MinVersion: 0,6.2; Components: tools\ipwriter
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkIpWriterHelp}"; Filename: "{code:GetApplicationToolsPath}\ipwriter\ipwriter.chm"; WorkingDir: "{code:GetApplicationToolsPath}\ipwriter"; MinVersion: 0,6.2; Components: tools\ipwriter

; Tool: MR Writer
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkMRWriter}"; Filename: "{code:GetApplicationToolsPath}\mrwriter\mrwriter.exe"; WorkingDir: "{code:GetApplicationToolsPath}\mrwriter"; Comment: "{cm:ComponentUtilities_mrwriter}"; MinVersion: 0,6.2; Components: tools\mrwriter
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkMRWriterReadme}"; Filename: "{code:GetApplicationToolsPath}\mrwriter\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\mrwriter"; MinVersion: 0,6.2; Components: tools\mrwriter

; Tool: SBI Builder
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkSbiBuilder}"; Filename: "{code:GetApplicationToolsPath}\buildsbi\buildsbi.exe"; WorkingDir: "{code:GetApplicationToolsPath}\buildsbi"; Comment: "{cm:ComponentUtilities_buildsbi}"; MinVersion: 0,6.2; Components: tools\buildsbi
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderChanges}"; Filename: "{code:GetApplicationToolsPath}\buildsbi\docs\changes.txt"; WorkingDir: "{code:GetApplicationToolsPath}\buildsbi"; MinVersion: 0,6.2; Components: tools\buildsbi
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderReadme}"; Filename: "{code:GetApplicationToolsPath}\buildsbi\docs\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\buildsbi"; MinVersion: 0,6.2; Components: tools\buildsbi

; Tool: Selfboot Inducer
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkSelfbootInducer}"; Filename: "{code:GetApplicationToolsPath}\sbinducr\sbinducr.exe"; WorkingDir: "{code:GetApplicationToolsPath}\sbinducr"; Comment: "{cm:ComponentUtilities_sbinducr}"; MinVersion: 0,6.2; Components: tools\sbinducr
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerReadme}"; Filename: "{code:GetApplicationToolsPath}\sbinducr\docs\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\sbinducr"; MinVersion: 0,6.2; Components: tools\sbinducr
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerChanges}"; Filename: "{code:GetApplicationToolsPath}\sbinducr\docs\whatsnew.txt"; WorkingDir: "{code:GetApplicationToolsPath}\sbinducr"; MinVersion: 0,6.2; Components: tools\sbinducr

; Tool: VMU Tool PC
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:LinkVmuTool}"; Filename: "{code:GetApplicationToolsPath}\vmutool\vmutool.exe"; WorkingDir: "{code:GetApplicationToolsPath}\vmutool"; Comment: "{cm:ComponentUtilities_vmutool}"; MinVersion: 0,6.2; Components: tools\vmutool
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolHelp}"; Filename: "{code:GetApplicationToolsPath}\vmutool\help\vmutool.chm"; WorkingDir: "{code:GetApplicationToolsPath}\vmutool"; MinVersion: 0,6.2; Components: tools\vmutool
Name: "{code:GetApplicationShortcutsPath}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolReadme}"; Filename: "{code:GetApplicationToolsPath}\vmutool\help\readme.rtf"; WorkingDir: "{code:GetApplicationToolsPath}\vmutool"; MinVersion: 0,6.2; Components: tools\vmutool

;
; Pre-Windows 8 shortcuts below
;

; Documentation
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:GettingStarted}"; Filename: "{code:GetApplicationComponentGettingStartedFilePath}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{code:GetApplicationSupportPath}\license.rtf"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{code:GetApplicationComponentHelpFilePath}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:KallistiOfficialDocumentation}"; Filename: "http://gamedev.allusion.net/docs/kos-2.0.0/"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:SegaDreamcastWikiDocumentation}"; Filename: "https://dreamcast.wiki"; OnlyBelowVersion: 0,6.2

; Useful Links
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAwesomeDreamcast}"; Filename: "https://github.com/dreamcastdevs/awesome-dreamcast"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkCodeBlocks}"; Filename: "http://www.codeblocks.org"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulation}"; Filename: "https://dcemulation.org"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulationProgrammingDiscussion}"; Filename: "https://dcemulation.org/phpBB/viewforum.php?f=29"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAppGitHub}"; Filename: "https://github.com/dreamsdk"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkMarcusDreamcast}"; Filename: "http://mc.pp.se/dc"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSegaDreamcastGitHub}"; Filename: "https://github.com/sega-dreamcast"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSimulantDiscordChannel}"; Filename: "https://discord.gg/TRx94EV"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSiZiOUS}"; Filename: "http://www.sizious.com"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDreamcastWiki}"; Filename: "https://dreamcast.wiki"; OnlyBelowVersion: 0,6.2

;
; Tools
;

; Tools: 1ST_READ.BIN Checker
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkChecker}"; Filename: "{code:GetApplicationToolsPath}\checker\checker.exe"; WorkingDir: "{code:GetApplicationToolsPath}\checker"; Comment: "{cm:ComponentUtilities_checker}"; OnlyBelowVersion: 0,6.2; Components: tools\checker
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkCheckerReadme}"; Filename: "{code:GetApplicationToolsPath}\checker\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\checker"; OnlyBelowVersion: 0,6.2; Components: tools\checker

; Tool: BootDreams
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkBootDreams}"; Filename: "{code:GetApplicationToolsPath}\bdreams\BootDreams.exe"; WorkingDir: "{code:GetApplicationToolsPath}\bdreams"; Comment: "{cm:ComponentUtilities_bdreams}"; OnlyBelowVersion: 0,6.2; Components: tools\bdreams
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkBootDreamsHelp}"; Filename: "{code:GetApplicationToolsPath}\bdreams\BootDreams.chm"; WorkingDir: "{code:GetApplicationToolsPath}\bdreams"; OnlyBelowVersion: 0,6.2; Components: tools\bdreams

; Tool: IP.BIN Writer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkIpWriter}"; Filename: "{code:GetApplicationToolsPath}\ipwriter\ipwriter.exe"; WorkingDir: "{code:GetApplicationToolsPath}\ipwriter"; Comment: "{cm:ComponentUtilities_ipwriter}"; OnlyBelowVersion: 0,6.2; Components: tools\ipwriter
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkIpWriterHelp}"; Filename: "{code:GetApplicationToolsPath}\ipwriter\ipwriter.chm"; WorkingDir: "{code:GetApplicationToolsPath}\ipwriter"; OnlyBelowVersion: 0,6.2; Components: tools\ipwriter

; Tool: MR Writer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkMRWriter}"; Filename: "{code:GetApplicationToolsPath}\mrwriter\mrwriter.exe"; WorkingDir: "{code:GetApplicationToolsPath}\mrwriter"; Comment: "{cm:ComponentUtilities_mrwriter}"; OnlyBelowVersion: 0,6.2; Components: tools\mrwriter
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkMRWriterReadme}"; Filename: "{code:GetApplicationToolsPath}\mrwriter\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\mrwriter"; OnlyBelowVersion: 0,6.2; Components: tools\mrwriter

; Tool: SBI Builder
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkSbiBuilder}"; Filename: "{code:GetApplicationToolsPath}\buildsbi\buildsbi.exe"; WorkingDir: "{code:GetApplicationToolsPath}\buildsbi"; Comment: "{cm:ComponentUtilities_buildsbi}"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderChanges}"; Filename: "{code:GetApplicationToolsPath}\buildsbi\docs\changes.txt"; WorkingDir: "{code:GetApplicationToolsPath}\buildsbi"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderReadme}"; Filename: "{code:GetApplicationToolsPath}\buildsbi\docs\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\buildsbi"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi

; Tool: Selfboot Inducer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkSelfbootInducer}"; Filename: "{code:GetApplicationToolsPath}\sbinducr\sbinducr.exe"; WorkingDir: "{code:GetApplicationToolsPath}\sbinducr"; Comment: "{cm:ComponentUtilities_sbinducr}"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerReadme}"; Filename: "{code:GetApplicationToolsPath}\sbinducr\docs\readme.txt"; WorkingDir: "{code:GetApplicationToolsPath}\sbinducr"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerChanges}"; Filename: "{code:GetApplicationToolsPath}\sbinducr\docs\whatsnew.txt"; WorkingDir: "{code:GetApplicationToolsPath}\sbinducr"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr

; Tool: VMU Tool PC
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkVmuTool}"; Filename: "{code:GetApplicationToolsPath}\vmutool\vmutool.exe"; WorkingDir: "{code:GetApplicationToolsPath}\vmutool"; Comment: "{cm:ComponentUtilities_vmutool}"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolHelp}"; Filename: "{code:GetApplicationToolsPath}\vmutool\help\vmutool.chm"; WorkingDir: "{code:GetApplicationToolsPath}\vmutool"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolReadme}"; Filename: "{code:GetApplicationToolsPath}\vmutool\help\readme.rtf"; WorkingDir: "{code:GetApplicationToolsPath}\vmutool"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
