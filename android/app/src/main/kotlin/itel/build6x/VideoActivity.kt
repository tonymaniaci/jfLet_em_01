package itel.build6x

import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel

import android.Manifest
import android.app.AlertDialog
import android.content.Context
import android.opengl.GLSurfaceView
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.opentok.android.*
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.AppSettingsDialog
import pub.devrel.easypermissions.EasyPermissions
import pub.devrel.easypermissions.EasyPermissions.PermissionCallbacks


//import android.support.v7.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatActivity;
//import android.support.annotation.NonNull;
import android.content.DialogInterface;
import android.content.Intent
import android.view.MotionEvent
import androidx.constraintlayout.widget.ConstraintLayout

import kotlinx.coroutines.*
import java.security.AccessController.getContext

import kotlin.system.exitProcess




class VideoActivity: FlutterActivity(), PermissionCallbacks, Session.SessionListener, PublisherKit.PublisherListener, SubscriberKit.SubscriberListener {
    private var mSession: Session? = null
    private var mPublisher: Publisher? = null
    private var mSubscriber: Subscriber? = null
    private var mPublisherViewContainer: FrameLayout? = null
    private var mSubscriberViewContainer: FrameLayout? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        val actionBar: Unit = actionBar.hide()
        
        //requestWindowFeature(Window.FEATURE_NO_TITLE); //will hide the title
        //this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                //WindowManager.LayoutParams.FLAG_FULLSCREEN); //enable full screen*/



        //VideoActivity.Companion.setContext(this);
        //val moose = applicationContext
        var con = this


        val channel = MethodChannel(flutterView, MainActivity.VIDEO_CHANNEL)

        /*val i = getIntent()

        var API_KEY = i.getStringExtra("apikey")
        var SESSION_ID = i.getStringExtra("session_id")
        var TOKEN = i.getStringExtra("token")

        println("EAT CRAP START *********************************************")
        println("API_KEY = ${API_KEY}")
        println("SESSION_ID = ${SESSION_ID}")
        println("TOKEN = ${TOKEN}")
        println("EAT CRAP END ***********************************************")

        //initializeSession(apiKey = API_KEY, sessionId = SESSION_ID, token = TOKEN)*/


        Log.d(LOG_TAG, "onCreate")
        //setContentView(R.layout.activity_main)
        setContentView(R.layout.activity_new_opentok)
        // initialize view objects from your layout
        mPublisherViewContainer = findViewById<View>(R.id.publisher_container) as FrameLayout
        mSubscriberViewContainer = findViewById<View>(R.id.subscriber_container) as FrameLayout

        mPublisherViewContainer!!.setOnTouchListener{v: View,
                                                     m: MotionEvent ->
            handleTouch(m)
            true
        }

        mSubscriberViewContainer !!.setOnTouchListener{v: View,
                                                     m: MotionEvent ->
            handleTouch(m)
            true
        }


        requestPermissions()

    }

    /* Activity lifecycle methods */
    override fun onPause() {
        Log.d(LOG_TAG, "onPause")
        super.onPause()
        if (mSession != null) {
            mSession!!.onPause()
        }
    }

    override fun onResume() {
        Log.d(LOG_TAG, "onResume")
        super.onResume()
        if (mSession != null) {
            mSession!!.onResume()
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this)
    }

    override fun onPermissionsGranted(requestCode: Int, perms: List<String>) {
        Log.d(LOG_TAG, "onPermissionsGranted:" + requestCode + ":" + perms.size)
    }

    override fun onPermissionsDenied(requestCode: Int, perms: List<String>) {
        Log.d(LOG_TAG, "onPermissionsDenied:" + requestCode + ":" + perms.size)
        if (EasyPermissions.somePermissionPermanentlyDenied(this, perms)) {
            AppSettingsDialog.Builder(this)
                    .setTitle(getString(R.string.title_settings_dialog))
                    .setRationale(getString(R.string.rationale_ask_again))
                    .setPositiveButton(getString(R.string.setting))
                    .setNegativeButton(getString(R.string.cancel))
                    .setRequestCode(RC_SETTINGS_SCREEN_PERM)
                    .build()
                    .show()
        }
    }

    @AfterPermissionGranted(RC_VIDEO_APP_PERM)
    private fun requestPermissions() {
        val perms = arrayOf(Manifest.permission.INTERNET, Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO)
        if (EasyPermissions.hasPermissions(this, *perms)) {
            val i = getIntent()
            val API_KEY = i.getStringExtra("apikey")
            val SESSION_ID = i.getStringExtra("session_id")
            val TOKEN = i.getStringExtra("token")
            initializeSession(apiKey = API_KEY, sessionId = SESSION_ID, token = TOKEN)

        } else {
            EasyPermissions.requestPermissions(this, getString(R.string.rationale_video_app), RC_VIDEO_APP_PERM, *perms)
        }
    }

    private fun initializeSession(apiKey:String, sessionId: String, token: String) {
        mSession = Session.Builder(this, apiKey, sessionId).build()
        mSession?.setSessionListener(this)
        mSession?.connect(token)
    }

    /* Session Listener methods */

    override fun onConnected(session: Session) {
        Log.d(LOG_TAG, "onConnected: Connected to session: " + session.sessionId)
        // initialize Publisher and set this object to listen to Publisher events
        mPublisher = Publisher.Builder(this).build()
        mPublisher?.setPublisherListener(this)
        // set publisher video style to fill view
        mPublisher?.getRenderer()?.setStyle(BaseVideoRenderer.STYLE_VIDEO_SCALE,
                BaseVideoRenderer.STYLE_VIDEO_FILL)
        mPublisherViewContainer!!.addView(mPublisher?.getView())
        if (mPublisher?.getView() is GLSurfaceView) {
            (mPublisher?.getView() as GLSurfaceView).setZOrderOnTop(true)
        }
        mSession!!.publish(mPublisher)
    }

    override fun onDisconnected(session: Session) {
        Log.d(LOG_TAG, "onDisconnected: Disconnected from session: " + session.sessionId)
    }

    override fun onStreamReceived(session: Session, stream: Stream) {
        Log.d(LOG_TAG, "onStreamReceived: New Stream Received " + stream.streamId + " in session: " + session.sessionId)
        if (mSubscriber == null) {
            mSubscriber = Subscriber.Builder(this, stream).build()
            mSubscriber?.getRenderer()?.setStyle(BaseVideoRenderer.STYLE_VIDEO_SCALE, BaseVideoRenderer.STYLE_VIDEO_FILL)
            mSubscriber?.setSubscriberListener(this)
            mSession!!.subscribe(mSubscriber)
            mSubscriberViewContainer!!.addView(mSubscriber?.getView())
        }
    }

    override fun onStreamDropped(session: Session, stream: Stream) {
        Log.d(LOG_TAG, "onStreamDropped: Stream Dropped: " + stream.streamId + " in session: " + session.sessionId)
        if (mSubscriber != null) {
            mSubscriber = null
            mSubscriberViewContainer!!.removeAllViews()
        }
    }

    override fun onError(session: Session, opentokError: OpentokError) {
        Log.e(LOG_TAG, "onError: " + opentokError.errorDomain + " : " +
                opentokError.errorCode + " - " + opentokError.message + " in session: " + session.sessionId)
        showOpenTokError(opentokError)
    }

    /* Publisher Listener methods */

    override fun onStreamCreated(publisherKit: PublisherKit, stream: Stream) {
        Log.d(LOG_TAG, "onStreamCreated: Publisher Stream Created. Own stream " + stream.streamId)
    }

    override fun onStreamDestroyed(publisherKit: PublisherKit, stream: Stream) {
        Log.d(LOG_TAG, "onStreamDestroyed: Publisher Stream Destroyed. Own stream " + stream.streamId)
    }

    override fun onError(publisherKit: PublisherKit, opentokError: OpentokError) {
        Log.e(LOG_TAG, "onError: " + opentokError.errorDomain + " : " +
                opentokError.errorCode + " - " + opentokError.message)
        showOpenTokError(opentokError)
    }

    override fun onConnected(subscriberKit: SubscriberKit) {
        Log.d(LOG_TAG, "onConnected: Subscriber connected. Stream: " + subscriberKit.stream.streamId)
    }

    override fun onDisconnected(subscriberKit: SubscriberKit) {
        Log.d(LOG_TAG, "onDisconnected: Subscriber disconnected. Stream: " + subscriberKit.stream.streamId)
    }

    override fun onError(subscriberKit: SubscriberKit, opentokError: OpentokError) {
        Log.e(LOG_TAG, "onError: " + opentokError.errorDomain + " : " +
                opentokError.errorCode + " - " + opentokError.message)
        showOpenTokError(opentokError)
    }

    private fun showOpenTokError(opentokError: OpentokError) {
        Toast.makeText(this, opentokError.errorDomain.name + ": " + opentokError.message + " Please, see the logcat.", Toast.LENGTH_LONG).show()
        finish()
    }

    private fun showConfigError(alertTitle: String, errorMessage: String) {
        Log.e(LOG_TAG, "Error $alertTitle: $errorMessage")
        AlertDialog.Builder(this)
                .setTitle(alertTitle)
                .setMessage(errorMessage)
                .setPositiveButton("ok") { dialog, which -> finish() }
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show()
    }

    companion object {
        val getApplicationContext: Context? = null
        private val LOG_TAG = MainActivity::class.java.simpleName
        private const val RC_SETTINGS_SCREEN_PERM = 123
        private const val RC_VIDEO_APP_PERM = 124

        private var instance: VideoActivity? = null

        fun applicationContext() : Context {
            return instance!!.applicationContext
        }

        /*private lateinit var context: Context

        fun setContext(con: Context) {
            context=con*/
        }

//}//end of VideoActivity




private fun handleTouch(m: MotionEvent) {
    val pointerCount = m.pointerCount

    for (i in 0 until pointerCount)
    {
        val x = m.getX(i)
        val y = m.getY(i)
        val id = m.getPointerId(i)
        val action = m.actionMasked
        val actionIndex = m.actionIndex
        var actionString: String

        when (action)
        {
            MotionEvent.ACTION_DOWN -> actionString = "DOWN"

            MotionEvent.ACTION_UP -> {
                actionString = "UP"


                    val builder = AlertDialog.Builder(this)
                    builder.setTitle("Your Alert")
                    builder.setMessage("Do You Want to Exit Video Session?")
                    //builder.setPositiveButton("OK", DialogInterface.OnClickListener(function = x)
                    builder.setCancelable(false)

                    builder.setPositiveButton("Exit") { dialog, which ->
                        Toast.makeText(this, "Exit", Toast.LENGTH_SHORT).show()

                        val data = Intent()
                        data.putExtra("returnString1", "Patient Exited Video")
                        setResult(RESULT_OK, data)
                        super.finish()

                        //finishAffinity()

                    }

                    builder.setNegativeButton("Cancel") { dialog, which ->
                        //Toast.makeText(this, "Cancel", Toast.LENGTH_SHORT).show()
                    }

                    /*builder.setNeutralButton("Maybe") { dialog, which ->
                        Toast.makeText(this,
                                "Maybe", Toast.LENGTH_SHORT).show()
                    }*/
                    builder.show()

                //}//end corountine




                /*runOnUiThread(object : Runnable() {
                    @Override
                    fun run() {

                        if (!isFinishing()) {
                            AlertDialog.Builder(this@VideoActivity)
                                    .setTitle("Your Alert")
                                    .setMessage("Do You Want to Exit?")
                                    .setCancelable(false)
                                    .setPositiveButton("Exit", object : DialogInterface.OnClickListener() {
                                        @Override
                                        fun onClick(dialog: DialogInterface, id: Int) {
                                            //Action for "Delete".
                                            Toast.makeText(this@VideoActivity, "Exit", Toast.LENGTH_SHORT).show()
                                            val patientExits = Intent(getApplicationContext(), PatientCloseoutActivity::class.java)
                                            mSession!!.disconnect()
                                            startActivity(patientExits)
                                        }
                                    })
                                    .setNegativeButton("Cancel ", object : DialogInterface.OnClickListener() {
                                        @Override
                                        fun onClick(dialog: DialogInterface, which: Int) {
                                            //Action for "Cancel".
                                            Toast.makeText(this@VideoActivity, "Cancel", Toast.LENGTH_SHORT).show()
                                        }
                                    }).show()


                        }
                    }
                })*/
            }//End ACTION UP


            MotionEvent.ACTION_POINTER_DOWN -> actionString = "PNTR DOWN"
            MotionEvent.ACTION_POINTER_UP -> actionString = "PNTR UP"
            MotionEvent.ACTION_MOVE -> actionString = "MOVE"
            else -> actionString = ""

        }//End Action

        Log.d("MOOSE", "*** actionString ***: $actionString")


        /*val touchStatus =
                "Action: $actionString Index: $actionIndex ID: $id X: $x Y: $y"

        if (id == 0)
            textView1.text = touchStatus

        else
            textView2.text = touchStatus*/


    }
}

}//end of VideoActivity