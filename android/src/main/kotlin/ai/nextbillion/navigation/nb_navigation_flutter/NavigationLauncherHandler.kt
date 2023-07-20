package ai.nextbillion.navigation.nb_navigation_flutter

import ai.nextbillion.navigation.ui.NavigationLauncher
import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * @author qiuyu
 * @Date 2023/3/7
 **/
class NavigationLauncherHandler : MethodChannelHandler() {

    init {
        methodChannel = MethodChannelManager.getInstance().navigationChannel
    }

    override fun handleMethodCallResult(activity: Activity?, call: MethodCall?, result: MethodChannel.Result?) {
        super.handleMethodCallResult(activity, call, result)
        if (methodChannel == null || call == null || result == null) {
            return
        }
        when (call.method) {
            MethodID.NAVIGATION_LAUNCH_NAVIGATION -> {
                startNavigation(call)
                result.success(true)
            }

        }
    }

    private fun startNavigation(call: MethodCall) {
        val arguments = call.arguments as? Map<*, *>
        val config = arguments?.get("launcherConfig") as? Map<*, *>
        config?.let {
            val configBuilder = Convert.convertLauncherConfig(it)
            val enableCustomStyle = it["useCustomNavigationStyle"] as? Boolean ?: true
            if (enableCustomStyle) {
                configBuilder?.lightThemeResId(R.style.CustomNavigationViewLight)
                configBuilder?.darkThemeResId(R.style.CustomNavigationViewDark)
            }
            val navLauncherConfig = configBuilder?.build()
            if (navLauncherConfig != null && activity != null) {
                NavigationLauncher.startNavigation(activity, navLauncherConfig)
            }
        }
    }


}