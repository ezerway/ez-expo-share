package expo.modules.ezexposhare

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle

class EzExpoShareReceiveImageReceiver(private val sendEvent: (name: String, body: Bundle) -> Unit) : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    Uri fileUri = intent.getParcelableExtra(Intent.EXTRA_STREAM);

    if (fileUri != null) {
      sendEvent("onChange", 
        Bundle().apply {
          putInt("image_uri", fileUri.toString())
        }
      )
    }
  }
}