#include "include/flutter_form_engine/flutter_form_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_form_engine_plugin.h"

void FlutterFormEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_form_engine::FlutterFormEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
