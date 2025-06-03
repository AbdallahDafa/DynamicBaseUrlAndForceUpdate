#ifndef FLUTTER_PLUGIN_DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN_H_
#define FLUTTER_PLUGIN_DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _DynamicChnageBaseUrlAndForceUpdatePlugin DynamicChnageBaseUrlAndForceUpdatePlugin;
typedef struct {
  GObjectClass parent_class;
} DynamicChnageBaseUrlAndForceUpdatePluginClass;

FLUTTER_PLUGIN_EXPORT GType dynamic_chnage_base_url_and_force_update_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void dynamic_chnage_base_url_and_force_update_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN_H_
