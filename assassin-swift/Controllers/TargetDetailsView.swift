//
//  TargetDetailsView.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 26/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class TargetDetailsView: UIView {

    @IBOutlet weak var codeNameLabel: UILabel?
    @IBOutlet weak var courseLabel: UILabel?
    @IBOutlet weak var genderLabel: UILabel?
    @IBOutlet weak var ageLabel: UILabel?
    @IBOutlet weak var heightLabel: UILabel?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TargetDetailsView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }

    func showTargetView(target: Target) {
        codeNameLabel?.text = target.code_name
        courseLabel?.text = target.course
        genderLabel?.text = target.gender
        ageLabel?.text = "\(target.age!) years old"
        heightLabel?.text = "\(target.height!) cm"
    }
    
    @IBAction func hideInView() {
        removeFromSuperview()
    }
    
}
