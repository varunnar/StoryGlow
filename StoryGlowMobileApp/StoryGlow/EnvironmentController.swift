//
//  EnvironmentController.swift
//  StoryGlow
//
//  Created by Varun Narayanswamy on 1/30/20.
//  Copyright © 2020 Varun Narayanswamy. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import RxLifxApi
import RxLifx
import LifxDomain

class EnvironmentController: UIViewController {
    
    var SoundButton1 = UIButton()
    var SoundButton2 = UIButton()
    var SoundButton3 = UIButton()
    var SoundButton4 = UIButton()
    var SoundButton5 = UIButton()
    var SoundButton6 = UIButton()
    var StackView1 = UIStackView()
    var StackView2 = UIStackView()
    var ColorWheelView = UIImageView()
    var ColorWheel = UIImage()
    
    
    let lightService = LightService(
        lightsChangeDispatcher: lightNotification(),
        transportGenerator: UdpTransport.self,
        extensionFactories: [LightsGroupLocationService.self]
    )
    var lightArray = [Light]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        lightService.start()
        NotificationCenter.default.addObserver(self, selector: #selector(AddedLight), name: NSNotification.Name(rawValue: "LightAdded"), object: nil)
        
        
        SetupStackView1()
        SetupStackView2()
        SetupColorWheel()
        let imageClickedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        let imageHeldGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageHeld))
        ColorWheelView.addGestureRecognizer(imageClickedGesture)
        ColorWheelView.addGestureRecognizer(imageHeldGesture)
        ColorWheelView.isUserInteractionEnabled = true
        

        // Do any additional setup after loading the view.
    }
    
    func SetupStackView1()
    {
        SoundButton1.backgroundColor = .gray
        SoundButton2.backgroundColor = .gray
        SoundButton3.backgroundColor = .gray
        view.addSubview(StackView1)
        StackView1.addArrangedSubview(SoundButton1)
        StackView1.addArrangedSubview(SoundButton2)
        StackView1.addArrangedSubview(SoundButton3)
        StackView1.axis = .horizontal
        StackView1.alignment = .fill
        StackView1.spacing = 40
        StackView1.distribution = .fillEqually
        StackViewConfig1()
    }
    
    func StackViewConfig1()
    {
        StackView1.translatesAutoresizingMaskIntoConstraints = false
        StackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        StackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        StackView1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        StackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
    }
    
    func SetupStackView2()
    {
        SoundButton4.backgroundColor = .gray
        SoundButton5.backgroundColor = .gray
        SoundButton6.backgroundColor = .gray
        view.addSubview(StackView2)
        StackView2.addArrangedSubview(SoundButton4)
        StackView2.addArrangedSubview(SoundButton5)
        StackView2.addArrangedSubview(SoundButton6)
        StackView2.axis = .horizontal
        StackView2.alignment = .fill
        StackView2.spacing = 40
        StackView2.distribution = .fillEqually
        StackViewConfig2()
    }
    
    func StackViewConfig2()
    {
        StackView2.translatesAutoresizingMaskIntoConstraints = false
        StackView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        StackView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        StackView2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        StackView2.topAnchor.constraint(equalTo: StackView1.bottomAnchor, constant: 50).isActive = true
        
    }
    
    func SetupColorWheel()
    {
        ColorWheel = UIImage(named: "colorwheel2")!
        ColorWheelView = UIImageView(image: ColorWheel)
        view.addSubview(ColorWheelView)
        colorwheelConfig()
    }
    
    func colorwheelConfig()
    {
        ColorWheelView.translatesAutoresizingMaskIntoConstraints = false
        ColorWheelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ColorWheelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        ColorWheelView.widthAnchor.constraint(equalToConstant: ColorWheel.size.width).isActive = true
        ColorWheelView.heightAnchor.constraint(equalToConstant: ColorWheel.size.height).isActive = true
        /*ColorWheelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        ColorWheelView.topAnchor.constraint(equalTo: StackView2.bottomAnchor, constant: 220).isActive = true
        ColorWheelView.contentMode = .scaleToFill*/
        

        
    }
    
    @objc func imageTap(recognizer: UITapGestureRecognizer)
    {
        let point = recognizer.location(in: ColorWheelView)
        let x = Int(point.x)
        let y = Int(point.y)
        SoundButton1.backgroundColor = ColorWheel[x,y]
    }
    
    @objc func imageHeld(recognizer: UILongPressGestureRecognizer)
    {
        let point = recognizer.location(in: ColorWheelView)
        let x = Int(point.x)
        let y = Int(point.y)
        for i in lightArray{
            let RGBcolor = ColorWheel[x,y]
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            RGBcolor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
            let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
            setColor.fireAndForget()
            SoundButton1.backgroundColor = ColorWheel[x,y]
        }
    }
    
    @objc func AddedLight(notification: Notification){
        if let light = notification.object as? Light{
            lightArray.append(light)
            let color = HSBK(hue: UInt16(.random(in: 0...1) * Float(UInt16.max)), saturation: UInt16(.random(in: 0...1) * Float(UInt16.max)), brightness: UInt16(1 * Float(UInt16.max)), kelvin: 0)
            print(color.brightness)
            print(color.hue)
            print(color.saturation)
            let setColor = LightSetColorCommand.create(light: light, color: color, duration: 0)
            setColor.fireAndForget()
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

extension UIImage {
    subscript(x: Int, y: Int)-> UIColor?{
        guard x>=0 && x<Int(size.width) && y>=0 && y<Int(size.height),
            let cg = cgImage,
            let provider = cg.dataProvider,
            let providedData = provider.data,
            let pureData = CFDataGetBytePtr(providedData) else{
                return nil
        }
        let componentNum = 4
        let pixelData = ((Int(size.width)*y)+x) * componentNum
        let r = CGFloat(pureData[pixelData]) / 255.0
        let g = CGFloat(pureData[pixelData + 1]) / 255.0
        let b = CGFloat(pureData[pixelData + 2]) / 255.0
        let a = CGFloat(pureData[pixelData + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
            
    }
}
