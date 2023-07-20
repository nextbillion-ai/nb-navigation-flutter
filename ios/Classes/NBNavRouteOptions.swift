//
//  NBNavRouteOptions.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/3/2.
//

import Foundation
import Nbmap
import NbmapDirections
import NbmapCoreNavigation

class NBNavRouteOptions: NavigationRouteOptions {

    override var accessToken: String {
        return NGLAccountManager.accessToken ?? ""
    }
    
    
}
