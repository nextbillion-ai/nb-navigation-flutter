package ai.nextbillion.navigation.nb_navigation_flutter

import io.flutter.plugin.common.MethodChannel

/**
 * @author qiuyu
 * @Date 2023/3/7
 **/
class MethodChannelManager private constructor() {

    var navigationChannel: MethodChannel? = null

    companion object {
        private var instance: MethodChannelManager? = null
            get() {
                if (field == null) {
                    field = MethodChannelManager()
                }
                return field
            }

        @JvmName("getInstance1")
        @JvmStatic
        fun getInstance() = instance!!
    }
}
