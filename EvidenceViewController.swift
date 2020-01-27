//
//  EvidenceViewController.swift
//  ARDetective
//
//  Created by Hannah Spencer on 26/01/2020.
//  Copyright © 2020 Hannah Spencer. All rights reserved.
//

import UIKit

class EvidenceViewController: UIViewController {
        
    @IBOutlet weak var hairImage: UIImageView!
    @IBOutlet weak var hairLabel: UILabel!
    @IBOutlet weak var footprintImage: UIImageView!
    @IBOutlet weak var footprintLabel: UILabel!
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hairImage.isHidden = true
        hairLabel.isHidden = true
        
        footprintImage.isHidden = true
        footprintLabel.isHidden = true
        
        buttonImage.isHidden = true
        buttonLabel.isHidden = true
        
        updateEvidence()
    }
    
    func updateEvidence() {
        if Evidence.hair {
            hairImage.isHidden = false
            hairLabel.isHidden = false
        }
        if Evidence.footprint {
            footprintImage.isHidden = false
            footprintLabel.isHidden = false
        }
        if Evidence.button {
            buttonImage.isHidden = false
            buttonLabel.isHidden = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
