#ifndef FLUTTER_PLUGIN_FLUTTER_FORM_ENGINE_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_FORM_ENGINE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_form_engine {

class FlutterFormEnginePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterFormEnginePlugin();

  virtual ~FlutterFormEnginePlugin();

  // Disallow copy and assign.
  FlutterFormEnginePlugin(const FlutterFormEnginePlugin&) = delete;
  FlutterFormEnginePlugin& operator=(const FlutterFormEnginePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_form_engine

#endif  // FLUTTER_PLUGIN_FLUTTER_FORM_ENGINE_PLUGIN_H_
