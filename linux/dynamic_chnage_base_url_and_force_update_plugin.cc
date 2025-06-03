#include "include/dynamic_chnage_base_url_and_force_update/dynamic_chnage_base_url_and_force_update_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "dynamic_chnage_base_url_and_force_update_plugin_private.h"

#define DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), dynamic_chnage_base_url_and_force_update_plugin_get_type(), \
                              DynamicChnageBaseUrlAndForceUpdatePlugin))

struct _DynamicChnageBaseUrlAndForceUpdatePlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(DynamicChnageBaseUrlAndForceUpdatePlugin, dynamic_chnage_base_url_and_force_update_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void dynamic_chnage_base_url_and_force_update_plugin_handle_method_call(
    DynamicChnageBaseUrlAndForceUpdatePlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    response = get_platform_version();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void dynamic_chnage_base_url_and_force_update_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(dynamic_chnage_base_url_and_force_update_plugin_parent_class)->dispose(object);
}

static void dynamic_chnage_base_url_and_force_update_plugin_class_init(DynamicChnageBaseUrlAndForceUpdatePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = dynamic_chnage_base_url_and_force_update_plugin_dispose;
}

static void dynamic_chnage_base_url_and_force_update_plugin_init(DynamicChnageBaseUrlAndForceUpdatePlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  DynamicChnageBaseUrlAndForceUpdatePlugin* plugin = DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN(user_data);
  dynamic_chnage_base_url_and_force_update_plugin_handle_method_call(plugin, method_call);
}

void dynamic_chnage_base_url_and_force_update_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  DynamicChnageBaseUrlAndForceUpdatePlugin* plugin = DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN(
      g_object_new(dynamic_chnage_base_url_and_force_update_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "dynamic_chnage_base_url_and_force_update",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
