//
//  FavoriteControl.swift
//  Collections
//
//  Created by Megan Weijiang on 2/23/17.
//  Copyright © 2017 Megan Weijiang. All rights reserved.
//

import UIKit

class FavoriteControl: UIStackView {

    //MARK: Properties
    
    @IBInspectable var starCount: Int = 1 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setup()
        }
    }
    
    private var favoriteButtons = [UIButton]()
    
    var favorite = false {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func tapped(button: UIButton) {
        if favorite == false {
            favorite = true
        }
        else {
            favorite = false
        }
    }
    
    private func setup() {
        
        for button in favoriteButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        favoriteButtons.removeAll()
        
        // Create Button
        let button = UIButton()
        
        // Set the button default button image
        button.setImage(UIImage(named: "buttonNotPressed"), for: UIControlState.normal)
        button.setImage(UIImage(named: "buttonPressed"), for: UIControlState.selected)
        
        // Setup the button action
        button.addTarget(self, action: #selector(FavoriteControl.tapped(button:)), for: .touchUpInside)
        
        // Add the button to the stack
        addArrangedSubview(button)

        // Add the new button to the rating button array
        favoriteButtons.append(button)
        
        updateButtonSelectionStates()
        
    }
    
    private func updateButtonSelectionStates() {
        for (_, button) in favoriteButtons.enumerated() {

            button.isSelected = favorite == true
            
        }
    }


}
