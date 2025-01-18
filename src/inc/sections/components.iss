[Types]
Name: "fullwithoutide"; Description: "{cm:TypeFullInstallationWithoutIDE}"
Name: "full"; Description: "{cm:TypeFullInstallation}"
Name: "compact"; Description: "{cm:TypeCompactInstallation}"
Name: "custom"; Description: "{cm:TypeCustomInstallation}"; Flags: iscustom

[Components]
; Main
Name: "main"; Description: "{cm:ComponentMain}"; Types: full compact custom fullwithoutide; Flags: fixed
Name: "main\base"; Description: "{cm:ComponentBase}"; Types: full compact custom fullwithoutide; Flags: fixed
Name: "main\toolchains"; Description: "{cm:ComponentToolchains}"; Types: full compact custom fullwithoutide; Flags: fixed
Name: "main\kos"; Description: "{cm:ComponentKOS}"; Types: full compact custom fullwithoutide; Flags: fixed

; IDE
Name: "{#IdeComponentsListName}"; Description: "{cm:ComponentIDE}"; Types: full
Name: "{#IdeComponentsListName}\codeblocks"; Description: "{cm:ComponentIDE_CodeBlocks}"; ExtraDiskSpaceRequired: 52428800; Types: full

; Addons
Name: "addons"; Description: "{cm:ComponentAdditionalTools}"; Types: full fullwithoutide
Name: "addons\elevate"; Description: "{cm:ComponentAdditionalTools_elevate}"; Types: full fullwithoutide
Name: "addons\pvr2png"; Description: "{cm:ComponentAdditionalTools_pvr2png}"; Types: full fullwithoutide
Name: "addons\txfutils"; Description: "{cm:ComponentAdditionalTools_txfutils}"; Types: full fullwithoutide
Name: "addons\txfutils\txflib"; Description: "{cm:ComponentAdditionalTools_txfutils_txflib}"; Types: full fullwithoutide
Name: "addons\vmutool"; Description: "{cm:ComponentAdditionalTools_vmutool}"; Types: full fullwithoutide

; Tools
Name: "tools"; Description: "{cm:ComponentUtilities}"; Types: full fullwithoutide
Name: "tools\checker"; Description: "{cm:ComponentUtilities_checker}"; Types: full fullwithoutide
Name: "tools\bdreams"; Description: "{cm:ComponentUtilities_bdreams}"; Types: full fullwithoutide
Name: "tools\ipwriter"; Description: "{cm:ComponentUtilities_ipwriter}"; Types: full fullwithoutide
Name: "tools\ipwriter\iplogos"; Description: "{cm:ComponentUtilities_ipwriter_iplogos}"; Types: full fullwithoutide
Name: "tools\mrwriter"; Description: "{cm:ComponentUtilities_mrwriter}"; Types: full fullwithoutide
Name: "tools\buildsbi"; Description: "{cm:ComponentUtilities_buildsbi}"; Types: full fullwithoutide
Name: "tools\sbinducr"; Description: "{cm:ComponentUtilities_sbinducr}"; Types: full fullwithoutide
Name: "tools\vmutool"; Description: "{cm:ComponentUtilities_vmutool}"; Types: full fullwithoutide
