//
//  MapTableViewCell.swift
//  MapSearch
//
//  Created by Galit Ronen on 10/29/18.
//  Copyright © 2018 Consult Partners US. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    var textView: UITextView?
    let buffer : CGFloat = 10
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadTextView()
    }
    
    func loadTextView() {
        textView = UITextView(frame: CGRect(x: buffer, y: 0, width: self.frame.width - buffer * 2, height: self.frame.height))
        
        guard let textView = textView else {
            print ("Unable to create text view within table cell view")
            return
        }
        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
