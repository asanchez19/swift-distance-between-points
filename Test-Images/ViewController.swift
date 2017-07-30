//
//  ViewController.swift
//  Test-Images
//
//  Created by Alejandro Sanchez on 29/7/17.
//  Copyright © 2017 Alejandro Sanchez. All rights reserved.
//  DVP code

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var p1Info: UILabel!
    @IBOutlet weak var p2Info: UILabel!
    @IBOutlet weak var distanciaInfo: UILabel!
    var esperando = true
    var p1 : CGPoint? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.distanciaInfo.text = " "
        self.p1Info.text = " "
        self.p2Info.text = " "
        self.esperando = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        //  let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("tapAction")))
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        
        let aux = sender.location(in: self.imageView) // Change to whatever view you want the point for
        
        print(aux)
        if esperando {
            p2Info.text = "\(aux.x)  ,   \(aux.y)"
            self.esperando = false
            self.distanciaInfo.text = self.calcularDistancia(p2: aux)
        } else {
            self.p1Info.text = "\(aux.x)  ,   \(aux.y)"
            self.p2Info.text = " "
            self.distanciaInfo.text = " "
            self.p1 = aux
            self.esperando = true
        }
        
    }
    
    
    func calcularDistancia(p2: CGPoint) -> String {
        let xDist = (self.p1?.x)! - p2.x
        let yDist = (self.p1?.y)! - p2.y
        let distance = CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
        
        return "\(distance)"
    }
    
    
    @IBAction func cameraAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: false, completion: nil)
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: false, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        imageView.image  = image
        }else {
        print("Error..")
        }
        self.dismiss(animated: false, completion: nil)
    }
}

