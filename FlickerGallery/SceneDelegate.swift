//
//  SceneDelegate.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    /*
     Note: the next lines here demonstrating the flexibility of the architecture by giving the ability to swap the caching data source with just one line of code, also you can implement a new caching datasource at any time and you will only need to instantiate it and use it here.
     */
    let realmDatasource = FeederRealmDatasource()
    let coreDataSource = FeederCoreDataSource()
    lazy var dataSourceCoordinator = {
        FeederDatasourceCoordinator(
            local: coreDataSource,
            remote: FeederFlickerApiDatasource(networkHandler: URLSessionHandler())
        )
    }()
    
    var flickerImagesViewController: FlickerImagesListViewController {
        FlickerImagesListViewController(
            viewModel:
                FlickerImagesListViewModel(
                    dataCoordinator: dataSourceCoordinator,
                    reachability: FeederReachability()
                )
        )
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: flickerImagesViewController)
        window?.makeKeyAndVisible()
    }
}

