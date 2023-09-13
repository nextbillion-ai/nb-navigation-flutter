package ai.nextbillion.navigation.nb_navigation_flutter

import android.app.Activity
import android.text.TextUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * @author qiuyu
 * @Date 2023/3/7
 **/
class MethodHandleFactory {


    private var routeFetchHandler: RouteFetcherHandler = RouteFetcherHandler()
    private var navigationLauncherHandler: NavigationLauncherHandler = NavigationLauncherHandler()
    private var nbNavigationHandler: NBNavigationHandler = NBNavigationHandler()

    companion object {
        @Volatile
        private var sInstance: MethodHandleFactory? = null

        fun getInstance(): MethodHandleFactory? {
            if (null == sInstance) {
                synchronized(MethodHandleFactory::class.java) {
                    if (null == sInstance) {
                        sInstance = MethodHandleFactory()
                    }
                }
            }
            return sInstance
        }
    }


    fun dispatchMethodHandler(
        activity: Activity?,
        call: MethodCall?,
        result: MethodChannel.Result?
    ) {
        if (null == call || null == result) {
            return
        }
        var methodChannelHandler: MethodChannelHandler? = null
        val method = call.method
        if (TextUtils.isEmpty(method)) {
            return
        }
        when (method) {
            MethodID.NAVIGATION_FETCH_ROUTE, MethodID.NAVIGATION_FIND_SELECTED_ROUTE, MethodID.NAVIGATION__GET_FORMATTED_ROUTE_DURATION -> methodChannelHandler =
                routeFetchHandler

            MethodID.NAVIGATION_LAUNCH_NAVIGATION -> methodChannelHandler =
                navigationLauncherHandler

            MethodID.NAVIGATION_INIT_NAVIGATION, MethodID.NAVIGATION_GET_ACCESS_KEY, MethodID.NAVIGATION_GET_BASE_URL, MethodID.NAVIGATION_SET_BASE_URL -> methodChannelHandler =
                nbNavigationHandler

            else -> {}
        }
        methodChannelHandler?.handleMethodCallResult(activity, call, result)
    }

}