//
//  UploadImagesViewController.swift
//  FarmersMarked
//
//  Created by Thomas Haulik Barchager on 11/10/2019.
//  Copyright © 2019 Haulik. All rights reserved.
//

import UIKit
import Firebase

class UploadImagesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var originalImage: UIImage?
    let imageController = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageController.delegate = self
        progressView.isHidden = true
        labelText.isHidden = true
        textField.isHidden = true

    }
    
    
    @IBAction func uploadButtonWasTapped(_ sender: Any) {
        progressView.isHidden = false
        labelText.isHidden = false
        textField.isHidden = false
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "Picture/\(randomID).jpg")
        guard let imageData =  imageView.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("Oh no, something went wrong! \(error.localizedDescription)")
                return
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            
            uploadRef.downloadURL { (url, error) in
                if let error = error{
                    print("Something went wrong! \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print("Here is your download URL: \(url.absoluteString)")
                    self.textField.text = url.absoluteString
                }
            }
        }
        
        taskReference.observe(.progress) { (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return }
            print("You are \(pctThere) complete")
            self.progressView.progress = Float(pctThere)
        }
    }
    
    @IBAction func fetchImageWasTapped(_ sender: Any) {
        progressView.isHidden = false
        labelText.isHidden = false
        textField.isHidden = false
        let storageRef = Storage.storage().reference(withPath: "Picture/72B8C4DE-79AF-4515-ABE6-C382A894DBED.jpg")
        let taskReference = storageRef.getData(maxSize: 6 * 1024 * 1024) { [weak self] (data, error) in
            if let error = error {
                print("Something went wrong: \(error.localizedDescription)")
                return
            }
            if let data = data {
                self?.imageView.image = UIImage(data: data)
            }
        }
        
        storageRef.downloadURL { (url, error) in
            if let error = error{
                print("Something went wrong! \(error.localizedDescription)")
                return
            }
            if let url = url {
                print("Here is your download URL: \(url.absoluteString)")
                self.textField.text = url.absoluteString
            }
        }
        
        taskReference.observe(.progress) { (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return }
            print("You are \(pctThere) complete")
            self.progressView.progress = Float(pctThere)
        }
    }
    
    
    @IBAction func pickImage(_ sender: Any) {
        imageController.sourceType = .photoLibrary
                   
                   imageController.allowsEditing = true
                   
                   self.present(imageController, animated: true){
                       //after it is complete
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            imageView.image = image
            
        }else{
            print("Well somthing went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
