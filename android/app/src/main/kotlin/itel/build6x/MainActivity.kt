package itel.build6x

import android.app.ActionBar
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.Window
import android.view.WindowManager
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
//import sun.jvm.hotspot.utilities.IntArray


class MainActivity : FlutterActivity() {

    companion object {

        const val LINK_CHANNEL = "itel.build6x.link_channel";
        const val INITIAL_LINK = "initialLink"

        const val LINK_EVENTS = "itel.build6x.link_events"
        var linksReceiver: BroadcastReceiver? = null

        const val VIDEO_CHANNEL = "itel.build6x.video_channel";
        const val KEY_NATIVE = "showNativeView"

        private var startString: String? = null

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        var intent = intent
        var data = intent.data

        //var startString: String

        MethodChannel(flutterView, LINK_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == INITIAL_LINK) {
                result.success(startString)
            } else {
                result.notImplemented()
            }
        }//end Method L_Channel


        EventChannel(flutterView, LINK_EVENTS).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventSink) {
                        linksReceiver = createChangeReceiver(events)
                    }

                    override fun onCancel(args: Any?) {
                        linksReceiver = null
                    }
                }
        )//end EventChannel

        if (data != null) {
            startString = data.toString();
            linksReceiver?.onReceive(this.getApplicationContext(), intent)
        }//end data != null



        MethodChannel(flutterView, VIDEO_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == KEY_NATIVE) {
                //val intent = Intent(this, NativeAndroidActivity::class.java)

                var tokapikey = call.argument("tokapikey") as? String
                var toksessionid = call.argument("toksessionid") as? String
                var toktoken = call.argument("toktoken") as? String

                val opentok = Intent(this, VideoActivity::class.java)

                opentok.putExtra("apikey", tokapikey)
                opentok.putExtra("session_id", toksessionid)
                opentok.putExtra("token", toktoken)

                //startActivity(opentok)

                var REQUEST_CODE = 1; //Exit Video
                startActivityForResult(opentok, REQUEST_CODE)
                result.success(true)

            } else {
                result.notImplemented()
            }
        }//end Method V_Channel


    }//end onCreate(savedInstanceState: Bundle?)

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        if ((requestCode == 1) &&
                (resultCode == RESULT_OK)) {

            if (data.hasExtra("returnString1")) {
                val returnString = data.extras.getString("returnString1")
                Log.d("***Video Exit Return***",returnString )
            }

            MethodChannel(flutterView, VIDEO_CHANNEL).invokeMethod("message", " *** Patient Exits Video ***")

        }
    }//end onActivityResult

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action === Intent.ACTION_VIEW && linksReceiver != null) {
            linksReceiver!!.onReceive(this.applicationContext, intent)
        }
    }//end onNewIntent */


    private fun createChangeReceiver(events: EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent) { // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW
                val dataString = intent.dataString
                if (dataString == null) {
                    events.error("UNAVAILABLE", "Link unavailable", null)
                } else {
                    events.success(dataString)
                }
            }
        }
    }//end createChangeReceiver


}//end MAIN
