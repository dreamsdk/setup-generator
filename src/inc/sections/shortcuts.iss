[Icons]

; Main shortcuts
Name: "{group}\{#FullAppMainName}"; Filename: "{code:GetMsysInstallationPath}\{#AppMainExeName}"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{group}\{#FullAppManagerName}"; Filename: "{code:GetMsysInstallationPath}\{#AppManagerExeName}"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{app}\{#AppSupportDirectory}\uninst.ico"; IconIndex: 0; Comment: "{cm:UninstallPackage}"

; Installation directory main shortcuts
Name: "{app}\{#FullAppMainName}"; Filename: "{code:GetMsysInstallationPath}\{#AppMainExeName}"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"
Name: "{app}\{#FullAppManagerName}"; Filename: "{code:GetMsysInstallationPath}\{#AppManagerExeName}"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppMainDirectory}"; Comment: "{cm:ExecuteManagerApplication}"
Name: "{app}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{app}\{#AppSupportDirectory}\uninst.ico"; Comment: "{cm:UninstallPackage}"

; Additional shortcuts (based on tasks)
Name: "{commondesktop}\{#FullAppMainName}"; Filename: "{#AppMainExeName}"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppMainDirectory}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: desktopicon
Name: "{commonappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{code:GetMsysInstallationPath}\{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#FullAppMainName}"; Filename: "{code:GetMsysInstallationPath}\{#AppMainExeName}"; Comment: "{cm:ExecuteMainApplication}"; Tasks: quicklaunchicon

;
; Post-Windows 8 shortcuts
;

; Documentation
Name: "{group}\{cm:DocumentationGroupDirectory}"; Filename: "{app}\{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:GettingStarted}"; Filename: "{code:GetMsysInstallationPath}\{#AppGettingStartedFile}"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{app}\{#AppSupportDirectory}\license.rtf"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppHelpFile}"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:KallistiOfficialDocumentation}"; Filename: "http://gamedev.allusion.net/docs/kos-2.0.0/"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:DocumentationGroupDirectory}\{cm:SegaDreamcastWikiDocumentation}"; Filename: "https://dreamcast.wiki"; MinVersion: 0,6.2

; Useful Links
Name: "{group}\{cm:UsefulLinksGroupDirectory}"; Filename: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAwesomeDreamcast}"; Filename: "https://github.com/dreamcastdevs/awesome-dreamcast"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkCodeBlocks}"; Filename: "http://www.codeblocks.org"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulation}"; Filename: "https://dcemulation.org"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDCEmulationProgrammingDiscussion}"; Filename: "https://dcemulation.org/phpBB/viewforum.php?f=29"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkAppGitHub}"; Filename: "https://github.com/dreamsdk"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkMarcusDreamcast}"; Filename: "http://mc.pp.se/dc"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSegaDreamcastGitHub}"; Filename: "https://github.com/sega-dreamcast"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSimulantDiscordChannel}"; Filename: "https://discord.gg/TRx94EV"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkSiZiOUS}"; Filename: "http://www.sizious.com"; MinVersion: 0,6.2
Name: "{app}\{#AppShortcutsDirectory}\{cm:UsefulLinksGroupDirectory}\{cm:LinkDreamcastWiki}"; Filename: "https://dreamcast.wiki"; MinVersion: 0,6.2

; Tools
Name: "{group}\{cm:ToolsGroupDirectory}"; Filename: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}"; Flags: preventpinning excludefromshowinnewinstall; MinVersion: 0,6.2

; Tools: 1ST_READ.BIN Checker
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkChecker}"; Filename: "{#AppToolsDirectory}\checker\checker.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker"; Comment: "{cm:ComponentUtilities_checker}"; MinVersion: 0,6.2; Components: tools\checker
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkCheckerReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker"; MinVersion: 0,6.2; Components: tools\checker

; Tool: BootDreams
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkBootDreams}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams\BootDreams.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams"; Comment: "{cm:ComponentUtilities_bdreams}"; MinVersion: 0,6.2; Components: tools\bdreams
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkBootDreamsHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams\BootDreams.chm"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams"; MinVersion: 0,6.2; Components: tools\bdreams

; Tool: IP.BIN Writer
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkIpWriter}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter\ipwriter.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter"; Comment: "{cm:ComponentUtilities_ipwriter}"; MinVersion: 0,6.2; Components: tools\ipwriter
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkIpWriterHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter\ipwriter.chm"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter"; MinVersion: 0,6.2; Components: tools\ipwriter

; Tool: MR Writer
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkMRWriter}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter\mrwriter.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter"; Comment: "{cm:ComponentUtilities_mrwriter}"; MinVersion: 0,6.2; Components: tools\mrwriter
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkMRWriterReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter"; MinVersion: 0,6.2; Components: tools\mrwriter

; Tool: SBI Builder
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkSbiBuilder}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi\buildsbi.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi"; Comment: "{cm:ComponentUtilities_buildsbi}"; MinVersion: 0,6.2; Components: tools\buildsbi
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderChanges}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi\docs\changes.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi"; MinVersion: 0,6.2; Components: tools\buildsbi
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi\docs\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi"; MinVersion: 0,6.2; Components: tools\buildsbi

; Tool: Selfboot Inducer
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkSelfbootInducer}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr\sbinducr.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr"; Comment: "{cm:ComponentUtilities_sbinducr}"; MinVersion: 0,6.2; Components: tools\sbinducr
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr\docs\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr"; MinVersion: 0,6.2; Components: tools\sbinducr
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerChanges}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr\docs\whatsnew.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr"; MinVersion: 0,6.2; Components: tools\sbinducr

; Tool: VMU Tool PC
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:LinkVmuTool}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool\vmutool.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool"; Comment: "{cm:ComponentUtilities_vmutool}"; MinVersion: 0,6.2; Components: tools\vmutool
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool\help\vmutool.chm"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool"; MinVersion: 0,6.2; Components: tools\vmutool
Name: "{app}\{#AppShortcutsDirectory}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool\help\readme.rtf"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool"; MinVersion: 0,6.2; Components: tools\vmutool

;
; Pre-Windows 8 shortcuts below
;

; Documentation
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:GettingStarted}"; Filename: "{#AppGettingStartedFile}"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:LicenseInformation}"; Filename: "{#AppSupportDirectory}\license.rtf"; OnlyBelowVersion: 0,6.2
Name: "{group}\{cm:DocumentationGroupDirectory}\{cm:ProgramHelp}"; Filename: "{#AppHelpFile}"; OnlyBelowVersion: 0,6.2
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
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkChecker}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker\checker.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker"; Comment: "{cm:ComponentUtilities_checker}"; OnlyBelowVersion: 0,6.2; Components: tools\checker
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkCheckerReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\checker"; OnlyBelowVersion: 0,6.2; Components: tools\checker

; Tool: BootDreams
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkBootDreams}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams\BootDreams.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams"; Comment: "{cm:ComponentUtilities_bdreams}"; OnlyBelowVersion: 0,6.2; Components: tools\bdreams
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkBootDreamsHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams\BootDreams.chm"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\bdreams"; OnlyBelowVersion: 0,6.2; Components: tools\bdreams

; Tool: IP.BIN Writer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkIpWriter}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter\ipwriter.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter"; Comment: "{cm:ComponentUtilities_ipwriter}"; OnlyBelowVersion: 0,6.2; Components: tools\ipwriter
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkIpWriterHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter\ipwriter.chm"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\ipwriter"; OnlyBelowVersion: 0,6.2; Components: tools\ipwriter

; Tool: MR Writer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkMRWriter}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter\mrwriter.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter"; Comment: "{cm:ComponentUtilities_mrwriter}"; OnlyBelowVersion: 0,6.2; Components: tools\mrwriter
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkMRWriterReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\mrwriter"; OnlyBelowVersion: 0,6.2; Components: tools\mrwriter

; Tool: SBI Builder
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkSbiBuilder}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi\buildsbi.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi"; Comment: "{cm:ComponentUtilities_buildsbi}"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderChanges}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi\docs\changes.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSbiBuilderReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi\docs\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\buildsbi"; OnlyBelowVersion: 0,6.2; Components: tools\buildsbi

; Tool: Selfboot Inducer
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkSelfbootInducer}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr\sbinducr.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr"; Comment: "{cm:ComponentUtilities_sbinducr}"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr\docs\readme.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkSelfbootInducerChanges}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr\docs\whatsnew.txt"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\sbinducr"; OnlyBelowVersion: 0,6.2; Components: tools\sbinducr

; Tool: VMU Tool PC
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:LinkVmuTool}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool\vmutool.exe"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool"; Comment: "{cm:ComponentUtilities_vmutool}"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolHelp}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool\help\vmutool.chm"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
Name: "{group}\{cm:ToolsGroupDirectory}\{cm:ToolsDocumentationGroupDirectory}\{cm:LinkVmuToolReadme}"; Filename: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool\help\readme.rtf"; WorkingDir: "{code:GetMsysInstallationPath}\{#AppToolsDirectory}\vmutool"; OnlyBelowVersion: 0,6.2; Components: tools\vmutool
