#include "include/dynamic_chnage_base_url_and_force_update/dynamic_chnage_base_url_and_force_update_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "dynamic_chnage_base_url_and_force_update_plugin.h"

void DynamicChnageBaseUrlAndForceUpdatePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  dynamic_chnage_base_url_and_force_update::DynamicChnageBaseUrlAndForceUpdatePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
