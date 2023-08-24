package expo.modules.ezexposhare

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.net.Uri
import android.os.Parcelable

class EzExpoShareReceiveImageReceiver(private val sendEvent: (name: String, body: Bundle) -> Unit) : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    (intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri)?.let {
      sendEvent("onChange", 
        Bundle().apply {
          putString("image_uri", it.toString())
        }
      )
    }
  }
}