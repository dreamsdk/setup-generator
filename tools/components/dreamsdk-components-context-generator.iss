[Setup]
AppName=DreamSDK Components Context Generator
AppVersion=0.0
DefaultDirName={pf}
DisableProgramGroupPage=yes
DisableReadyPage=yes
DisableFinishedPage=yes
CreateUninstallRegKey=no
Uninstallable=no
PrivilegesRequired=lowest
OutputDir=.
OutputBaseFilename=dreamsdk-components-context-generator

#define MyAppID ""
#define MyAppEnvironmentVariable ""
#define SourceDirectoryBase ".sources-fake"

#include "../../src/inc/options.iss"
#include "../../src/inc/const.iss"

#define InstallerMode PREPARE

#undef GENERATED_COMPONENTS_LIST_PATH
#define GENERATED_COMPONENTS_LIST_PATH "../../.context"

#include "../../src/inc/utils/utils.iss"
#include "../../src/inc/utils/winver.iss"
#include "../../src/inc/utils/components.iss"
#include "../../src/inc/utils/registry.iss"

#include "../../src/inc/global.iss"

#include "../../src/inc/paths/targets.iss"

#include "../../src/inc/helpers/components.iss"

#include "../../src/inc/sections/components.iss"
#include "../../src/inc/sections/labels.iss"   
                            
[Code]
procedure InitializeWizard();
begin
  ComponentsListInitialize(True);
  Abort;
end;
