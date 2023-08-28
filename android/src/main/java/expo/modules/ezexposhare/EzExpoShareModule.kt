package expo.modules.ezexposhare

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import android.content.Intent
import android.os.Bundle
import android.net.Uri
import android.os.Build
import android.os.Build.VERSION
import android.os.Parcelable

class EzExpoShareModule : Module() {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('EzExpoShare')` in JavaScript.
    Name("EzExpoShare")

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    OnNewIntent { intent ->
      val uri = if (VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        intent.getParcelableExtra(Intent.EXTRA_STREAM, Parcelable::class.java) as? Uri
      } else {
        intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri
      }

      sendEvent("onChange",
        Bundle().apply {
          putString("image_uri", uri.toString())
        }
      )
    }
  }
}
