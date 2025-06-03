//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dynamic_chnage_base_url_and_force_update/dynamic_chnage_base_url_and_force_update_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dynamic_chnage_base_url_and_force_update_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DynamicChnageBaseUrlAndForceUpdatePlugin");
  dynamic_chnage_base_url_and_force_update_plugin_register_with_registrar(dynamic_chnage_base_url_and_force_update_registrar);
}
