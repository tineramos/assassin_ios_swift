//
//  PlaceOfInterest.swift
//  AssassinSwift
//
//  Created by Tine Ramos on 22/08/2016.
//  Copyright © 2016 Queen Mary University of London. All rights reserved.
//

import UIKit

class PlaceOfInterest: NSObject {
    
    var view: UIView?
    var location: CLLocation?
    
    override init() {
        super.init()
        
        view = nil
        location = nil
    }
    
    func placeOfInterestWithView(view: UIView, atLocation location: CLLocation) -> PlaceOfInterest {
        let poi = PlaceOfInterest.init()
        poi.view = view
        poi.location = location
        return poi
    }

}
