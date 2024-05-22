//
//  ProgressViewController.swift
//  BaseApp
//
//  Created by Mind on 29/02/24.
//  Copyright © 2024 Passio Inc. All rights reserved.
//

import Foundation
import UIKit

class ProgressViewController: UIViewController {

    @IBOutlet weak var macrosButton : UIButton!
    @IBOutlet weak var microButton  : UIButton!
    @IBOutlet weak var segmentUnderlineView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var pageFrameView : UIView! {
        willSet {
            self.addChild(pageMaster)
            newValue.addSubview(pageMaster.view)
            newValue.fitToSelf(childView: pageMaster.view)
            pageMaster.didMove(toParent: self)
        }
    }

    private let pageMaster          = PageMaster([])
    private var viewControllerList  : [UIViewController] = []
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let macroViewController = UIStoryboard(name: "Progress", bundle: PassioInternalConnector.shared.bundleForModule)
            .instantiateViewController(identifier: "MacroProgressViewController") as! MacroProgressViewController
        
        let microViewController = UIStoryboard(name: "Progress", bundle: PassioInternalConnector.shared.bundleForModule)
            .instantiateViewController(identifier: "MicroProgressViewController") as! MicroProgressViewController
        
        self.viewControllerList = [macroViewController,microViewController]
        self.setupUI()
        self.setupPageViewController()
        
    }

    
    func setupUI(){
        [macrosButton,microButton].forEach({
            $0?.setTitleColor(.gray900, for: .normal)
            $0?.setTitleColor(.indigo600, for: .selected)
        })
        macrosButton.isSelected = true
        microButton.isSelected = false
    }
    
}

// MARK: - Actions
extension ProgressViewController {
    

    @IBAction func setTab(_ sender: UIButton) {
        self.setTabBarIndex(sender.tag)
    }
    
}
extension ProgressViewController: PageMasterDelegate {
    
    private func setupPageViewController() {
        pageMaster.pageDelegate = self
        pageMaster.setup(viewControllerList)
    }
    
    func pageMaster(_ master: PageMaster, didChangePage page: Int) {
        setTabBarIndex(page)
    }
    
}
extension ProgressViewController {
    
    private func setTabBarIndex(_ selectedIndex : Int) {
        pageMaster.setPage(selectedIndex,animated: true)
        
//        if selectedIndex == 0{
//            
//        }
//        
//        macrosButton.isSelected = selectedIndex == 0
//        microButton.isSelected = selectedIndex == 1
    
        let buttons = [macrosButton,microButton].compactMap({$0})
        
        for button in buttons {
            button.isSelected = button.tag == selectedIndex
            button.titleLabel?.font = button.tag == selectedIndex ? UIFont.custom(.semiBold, 20) : UIFont.custom(.regular, 20)
        }
        
        
        
        UIView.animate(withDuration: 0.3) {
            self.leadingConstraint.constant = CGFloat(selectedIndex) * ScreenSize.width * 0.5
            self.segmentUnderlineView.layoutIfNeeded()
        }
        
    }
    
}

