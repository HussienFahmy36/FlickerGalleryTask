//
//  SceneDelegate.swift
//  FlickerGallery
//
//  Created by Hussien Gamal Mohammed on 13/10/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dataSourceCoordinator = FeederDatasourceCoordinator(
        local: FeederRealmDatasource(),
        remote: FeederFlickerApiDatasource(networkHandler: URLSessionHandler())
    )
    
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

