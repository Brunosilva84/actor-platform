//
//  Copyright (c) 2014-2015 Actor LLC. <https://actor.im>
//

import Foundation

public class AAWallpapperPreviewController: AAViewController {
    
    private let imageView = UIImageView()
    private let cancelButton = UIButton()
    private let setButton = UIButton()
    
    private let imageName: String
    
    public init(imageName: String) {
        self.imageName = imageName
        super.init()
        imageView.image = UIImage.bundled(imageName)!
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        cancelButton.backgroundColor = appStyle.vcPanelBgColor
        cancelButton.addTarget(self, action: "cancelDidTap", forControlEvents: .TouchUpInside)
        cancelButton.setTitle(AALocalized("AlertCancel"), forState: .Normal)
        cancelButton.setTitleColor(appStyle.tabUnselectedTextColor, forState: .Normal)
        setButton.backgroundColor = appStyle.vcPanelBgColor
        setButton.addTarget(self, action: "setDidTap", forControlEvents: .TouchUpInside)
        setButton.setTitle(AALocalized("AlertSet"), forState: .Normal)
        setButton.setTitleColor(appStyle.tabUnselectedTextColor, forState: .Normal)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.Top
        
        view.addSubview(imageView)
        view.addSubview(cancelButton)
        view.addSubview(setButton)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = view.bounds
        
        cancelButton.frame = CGRect(x: 0, y: view.height - 55, width: view.width / 2, height: 55)
        setButton.frame = CGRect(x: view.width / 2, y: view.height - 55, width: view.width / 2, height: 55)
    }
    
    func cancelDidTap() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setDidTap() {
        Actor.changeSelectedWallpaper("local:\(imageName)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}