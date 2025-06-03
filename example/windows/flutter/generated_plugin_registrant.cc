//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dynamic_chnage_base_url_and_force_update/dynamic_chnage_base_url_and_force_update_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DynamicChnageBaseUrlAndForceUpdatePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicChnageBaseUrlAndForceUpdatePluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
