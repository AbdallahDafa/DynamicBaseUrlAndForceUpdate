//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dynamic_base_url_and_force_update/dynamic_chnage_base_url_and_force_update_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dynamic_base_url_and_force_update_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DynamicChnageBaseUrlAndForceUpdatePlugin");
  dynamic_chnage_base_url_and_force_update_plugin_register_with_registrar(dynamic_base_url_and_force_update_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
