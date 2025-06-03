#ifndef FLUTTER_PLUGIN_DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN_H_
#define FLUTTER_PLUGIN_DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace dynamic_chnage_base_url_and_force_update {

class DynamicChnageBaseUrlAndForceUpdatePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DynamicChnageBaseUrlAndForceUpdatePlugin();

  virtual ~DynamicChnageBaseUrlAndForceUpdatePlugin();

  // Disallow copy and assign.
  DynamicChnageBaseUrlAndForceUpdatePlugin(const DynamicChnageBaseUrlAndForceUpdatePlugin&) = delete;
  DynamicChnageBaseUrlAndForceUpdatePlugin& operator=(const DynamicChnageBaseUrlAndForceUpdatePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace dynamic_chnage_base_url_and_force_update

#endif  // FLUTTER_PLUGIN_DYNAMIC_CHNAGE_BASE_URL_AND_FORCE_UPDATE_PLUGIN_H_
