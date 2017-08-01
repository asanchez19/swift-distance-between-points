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
	@IBOutlet weak var imageView: UIImageView!
	var primero = true
	var p1 : CGPoint? = nil
	var circulo1 = CAShapeLayer()
	var circulo2 = CAShapeLayer()
	var linea = CAShapeLayer()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.distanciaInfo.text = " "
        self.p1Info.text = " "
		self.p2Info.text = " "
		self.primero = false
		
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
        
        var aux = sender.location(in: self.imageView) // Change to whatever view you want the point for
		
		aux = correccion(punto: aux)
		
        print(aux)
		if primero {
			p2Info.text = "\(aux.x)  ,   \(aux.y)"
			self.primero = false
			self.distanciaInfo.text = self.calcularDistancia(p2: aux)
		} else {
			self.p1Info.text = "\(aux.x)  ,   \(aux.y)"
			self.p2Info.text = " "
			self.distanciaInfo.text = " "
			self.p1 = aux
			self.primero = true
		}
		dibujaPunto(punto: aux)
		
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
        } else {
			print("Error..")
        }
        self.dismiss(animated: false, completion: nil)
    }
	
	func correccion(punto: CGPoint) -> CGPoint {
		var aux = punto
		aux.x = punto.x
		aux.y = punto.y + 88
		
		return aux
	}
	
	func dibujaPunto(punto: CGPoint) {
		let circlePath = UIBezierPath(arcCenter: CGPoint(x: punto.x, y: punto.y), radius: CGFloat(1), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
		
		if primero {
			configCirculo(forma: circulo1, caracteristicas: circlePath)
			view.layer.addSublayer(circulo1)
		} else {
			configCirculo(forma: circulo2, caracteristicas: circlePath)
			view.layer.addSublayer(circulo2)
			dibujaLinea(p2: punto)
		}
	}
	
	func configCirculo(forma: CAShapeLayer, caracteristicas: UIBezierPath) {
		forma.path = caracteristicas.cgPath
		forma.fillColor = UIColor.clear.cgColor
		forma.strokeColor = UIColor.red.cgColor
		forma.lineWidth = 1.0	// Grosor de la linea
	}
	
	func dibujaLinea(p2:CGPoint) {
		
		// borra la linea si ya existe
		let linePath = UIBezierPath()
		self.linea.path = linePath.cgPath
		
		// asigna la posición a la nueva linea
		self.linea = CAShapeLayer()
		linePath.move(to: p1!)
		linePath.addLine(to: p2)
		self.linea.path = linePath.cgPath
		self.linea.strokeColor = UIColor.red.cgColor
		self.linea.lineWidth = 1
		self.linea.lineJoin = kCALineJoinRound
		self.view.layer.addSublayer(linea)
	}
	
	
}

