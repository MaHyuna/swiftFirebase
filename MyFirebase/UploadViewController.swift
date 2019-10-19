//
//  UploadViewController.swift
//  MyFirebase
//
//  Created by maro on 22/09/2019.
//  Copyright © 2019 마현아. All rights reserved.
//

import UIKit
import FirebaseStorage

class UploadViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labelUrl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBtnUpload(_ sender: Any) {
        let storage = Storage.storage()
        let stroageRef = storage.reference()
        
        let data = imageview.image!.pngData()
        let riversRef = stroageRef.child( "p_img01.png" )
        
        let uploadTask = riversRef.putData(data!, metadata: nil) {
            (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            
            let size = metadata.size
            
            riversRef.downloadURL {
                (url, error) in
                guard let downloadURL = url else {
                    return
                }
                self.labelUrl.text = downloadURL.absoluteString
                print("download URL: ", downloadURL.absoluteString)
            }
        }
        
    }
    

}
