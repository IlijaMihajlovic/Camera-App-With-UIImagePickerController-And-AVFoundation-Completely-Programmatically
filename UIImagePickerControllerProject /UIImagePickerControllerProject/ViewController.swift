//
//  ViewController.swift
//  UIImagePickerControllerProject
//
//  Created by Ilija Mihajlovic on 3/8/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit

enum ImageSource {
    case photoLibary
    case camera
}


class ViewController: UIViewController {
    var imagePicker: UIImagePickerController!
    
    
    private var imageViewTake: UIImageView = {
        //var someImageView = UIImageView()
        var someImageView = ScaledHeightImageView()
        someImageView.layer.borderWidth = 1.5
        someImageView.layer.borderColor = UIColor.orange.cgColor
        someImageView.clipsToBounds = true
        someImageView.backgroundColor = UIColor.clear
        //someImageView = ScaledHeightImageView()
        someImageView.contentMode = .scaleAspectFit
        someImageView.translatesAutoresizingMaskIntoConstraints = false
        
          // When we use the image
         //someImageView.image = UIImage(named: "SomeImage")
        
        return someImageView
    }()
    
    private var buttonTapped: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Chose an Image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    private var saveImageButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Save Image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewToSubView()
        setupConstraints()
        
    }

    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            //We got back an error!
            showAlertWith(title: "Error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved", message: "Your image has been saved to your photos.")
            
        }
    }
    
   @objc fileprivate func takePhoto(_ seder: UIButton!) {
    guard  UIImagePickerController.isSourceTypeAvailable(.camera) else {
        selectImageFrom(.photoLibary)
        return
    }
    selectImageFrom(.camera)
    buttonTapped.setTitle("Take a Image", for: .normal)
    
    }
    
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        switch  source {
        case .camera:
            imagePicker.sourceType = .camera
       
        case .photoLibary:
            imagePicker.sourceType = .photoLibrary
            
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
   @objc fileprivate func save(_ sender: AnyObject) {
        guard let selectedImage = imageViewTake.image else {
            showAlertWith(title: "Error", message: "You Need To First Taka a Photo or Chose One From Libary")
            print("Image not found!")
            return
        }
    
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    
    }
    
  
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    fileprivate func addViewToSubView() {
        view.addSubview(saveImageButton)
        view.addSubview(buttonTapped)
        view.addSubview(imageViewTake)
    }
    
    
    fileprivate func setupConstraints() {
        
        NSLayoutConstraint.activate([
           //imageView.widthAnchor.constraint(equalToConstant: 400),
            //imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 267),
            imageViewTake.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            //imageViewTake.bottomAnchor.constraint(equalTo: buttonTapped.topAnchor, constant: -30),
            imageViewTake.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            imageViewTake.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            imageViewTake.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
            
            ])
        
        NSLayoutConstraint.activate([
            //buttonTapped.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 130),
            //buttonTapped.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonTapped.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonTapped.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonTapped.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            buttonTapped.heightAnchor.constraint(equalToConstant: 60.00),
            //buttonTapped.widthAnchor.constraint(equalToConstant: 70.00)
            
            ])
        
        
        NSLayoutConstraint.activate([
            saveImageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            saveImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveImageButton.heightAnchor.constraint(equalToConstant: 40.00),
            saveImageButton.widthAnchor.constraint(equalToConstant: 90.00)
            
            ])
        
    }


}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Item not found!")
            return
        }
        imageViewTake.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


