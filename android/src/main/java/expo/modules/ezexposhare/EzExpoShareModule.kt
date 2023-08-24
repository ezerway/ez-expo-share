package expo.modules.ezexposhare

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import expo.modules.kotlin.exception.Exceptions
import expo.modules.kotlin.types.Enumerable
import java.lang.ref.WeakReference

class EzExpoShareModule : Module() {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('EzExpoShare')` in JavaScript.
    Name("EzExpoShare")

    Constants("isSupported" to true)

    // Defines event names that the module can send to JavaScript.
    Events("onChange")

    OnCreate {
      registerBroadcastReceivers(context)
    }

    OnDestroy {
      unregisterBroadcastReceivers(context)
    }
  }

  private val context: Context
    get() = appContext.reactContext ?: throw Exceptions.ReactContextLost()

  private val broadcastReceivers = mutableListOf<BroadcastReceiver>()

  private inline fun accessBroadcastReceivers(block: MutableList<BroadcastReceiver>.() -> Unit) {
    synchronized(broadcastReceivers) {
      block.invoke(broadcastReceivers)
    }
  }

  private fun unregisterBroadcastReceivers(context: Context) {
    accessBroadcastReceivers {
      forEach {
        context.unregisterReceiver(it)
      }
      clear()
    }
  }

  private fun registerBroadcastReceivers(context: Context) {
    accessBroadcastReceivers {
      if (isNotEmpty()) {
        return
      }
    }

    val weakModule = WeakReference(this@EzExpoShareModule)
    val emitEvent = { name: String, body: Bundle ->
      try {
        // It may thrown, because RN event emitter may not be available
        // we can just ignore those cases
        weakModule.get()?.sendEvent(name, body)
      } catch (_: Throwable) {
      }
      Unit
    }
    val receiveImageReceiver = EzExpoShareReceiveImageReceiver(emitEvent)

    context.registerReceiver(receiveImageReceiver, IntentFilter("android.intent.action.SEND"))

    accessBroadcastReceivers {
      add(receiveImageReceiver)
    }
  }
}
