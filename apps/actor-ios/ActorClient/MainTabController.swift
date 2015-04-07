//
//  MainTabController.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 10.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation
import UIKit

class MainTabController : UITabBarController, UITabBarDelegate, ABActionShitDelegate {

    var centerButton:UIButton? = nil;
    var isInited = false;
    
    // MARK: -
    // MARK: Constructors
    
    init() {
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    // MARK: -
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!isInited) {
            if (MSG.isLoggedIn()) {
                isInited = true
                
                let contactsNavigation = AANavigationController(rootViewController: ContactsViewController())
                let dialogsNavigation = AANavigationController(rootViewController: DialogsViewController())
                let settingsNavigation = AANavigationController(rootViewController: AASettingsController())
                viewControllers = [contactsNavigation, dialogsNavigation, settingsNavigation];
                
                selectedIndex = 1;
            }
        }
    }
    
    // MARK: -
    // MARK: Methods
    
    func centerButtonTap() {
        var actionShit = ABActionShit()
        actionShit.buttonTitles = ["Add Contact", "Create group", "Write to..."];
        actionShit.delegate = self
        actionShit.showWithCompletion(nil)
    }
    
    // MARK: -
    // MARK: ABActionShit Delegate
    
    func actionShit(actionShit: ABActionShit!, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            navigationController?.pushViewController(GroupMembersController(), animated: true)
        }
    }
}