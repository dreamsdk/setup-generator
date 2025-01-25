[Code]
var
  X: Integer;

procedure Y;
begin
  X := 1;
end;

[CustomMessages]
ToolchainsStable=Stable
ToolchainsStableDisabled= (unsupported on your OS)
LabelToolchainsDescriptionStable=Stable toolchains are based on GCC {#ToolchainsStableVersionSuperH} with Newlib {#ToolchainsStableVersionNewlib} for SuperH and GCC {#ToolchainsStableVersionAICA} for AICA. It's the current toolchains officially supported.
ToolchainsLegacy=Legacy
ToolchainsLegacyConfirmation=Legacy toolchains are pretty old, are you sure to continue? You can change that later in {#FullAppManagerName}.
LabelToolchainsDescriptionLegacy=Legacy toolchains are based on GCC {#ToolchainsLegacyVersion} with Newlib {#ToolchainsLegacyVersionNewlib}. This was the previous, officially supported toolchains for the past decade.
ToolchainsOldStable=Old Stable
LabelToolchainsDescriptionOldStable=Old stable toolchains are based on GCC {#ToolchainsOldStableVersionSuperH} with Newlib {#ToolchainsOldStableVersionNewlib} for SuperH and GCC {#ToolchainsOldStableVersionAICA} for AICA. It's the previous stable toolchains.

[Components]
Name: "main\toolchains\stable"; Description: "{cm:ToolchainsStable}"; Flags: exclusive fixed
Name: "main\toolchains\oldstable"; Description: "{cm:ToolchainsOldStable}"; Flags: exclusive fixed
Name: "main\toolchains\legacy"; Description: "{cm:ToolchainsLegacy}"; Flags: exclusive fixed
