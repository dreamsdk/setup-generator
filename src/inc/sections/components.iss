[Types]
Name: "fullwithoutide"; Description: "{cm:TypeFullInstallationWithoutIDE}"
Name: "full"; Description: "{cm:TypeFullInstallation}"
Name: "compact"; Description: "{cm:TypeCompactInstallation}"
Name: "custom"; Description: "{cm:TypeCustomInstallation}"; Flags: iscustom

[Components]
; IDE
Name: "{#IdeComponentsListName}"; Description: "{cm:ComponentIDE}"; Types: full
Name: "{#IdeComponentsListName}\codeblocks"; Description: "{cm:ComponentIDE_CodeBlocks}"; Types: full

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

; Main
Name: "main"; Description: "{cm:ComponentMain}"; Flags: fixed
Name: "main\base"; Description: "{cm:ComponentBase}"; Flags: fixed
Name: "main\base\mingw"; Description: "{cm:ComponentBase32}"; Flags: exclusive fixed
Name: "main\base\mingw64"; Description: "{cm:ComponentBase64}"; Flags: exclusive fixed
Name: "main\toolchains"; Description: "{cm:ComponentToolchains}"; Flags: fixed
#include "../../cfg/toolchains.iss"
Name: "main\gdb"; Description: "{cm:ComponentGdb}"; Flags: fixed
#include "../../cfg/gdb.iss"
Name: "main\kos"; Description: "{cm:ComponentKOS}"; Flags: fixed
