//
//  PassableUIButton.swift
//  Jotify
//
//  Created by Harrison Leath on 4/27/21.
//

import UIKit

//used to create buttons which can pass parameters since
//UIButtons do not allow passing values through actions assigned
//by "addTarget()"
class PassableUIButton: UIButton{
    
    var params: Dictionary<String, Any>
    
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
