//
//  MeetUsConfigurator.swift
//  Figueres2018
//
//  Created by Javier Jara on 12/7/16.
//  Copyright (c) 2016 Data Center Consultores. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension MeetUsViewController: MeetUsPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension MeetUsInteractor: MeetUsViewControllerOutput
{
}

extension MeetUsPresenter: MeetUsInteractorOutput
{
}

class MeetUsConfigurator
{
  // MARK: - Object lifecycle
  
  static let sharedInstance = MeetUsConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: MeetUsViewController)
  {
    let router = MeetUsRouter()
    router.viewController = viewController
    
    let presenter = MeetUsPresenter()
    presenter.output = viewController
    
    let interactor = MeetUsInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
