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
    
    var storyIndex = 0
    var SceneIndex = 0
    var colorView = UIView()
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
    
    //initializing light services
    let lightService = LightService(
        lightsChangeDispatcher: lightNotification(),
        transportGenerator: UdpTransport.self,
        extensionFactories: [LightsGroupLocationService.self]
    )
    //Array of type light that holds all the lightbulbs found by the application
    var lightArray = [Light]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //start the light services
        lightService.start()
        //give a notification for when the light is added
        NotificationCenter.default.addObserver(self, selector: #selector(AddedLight), name: NSNotification.Name(rawValue: "LightAdded"), object: nil)
        
        //setting up the stackviews and images
        SetupStackView1()
        SetupStackView2()
        SetupColorWheel()
        
        //Adding gestures to the image to allow color selection
        let imageClickedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        let imageHeldGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageHeld))
        ColorWheelView.addGestureRecognizer(imageClickedGesture)
        ColorWheelView.addGestureRecognizer(imageHeldGesture)
        ColorWheelView.isUserInteractionEnabled = true
        

        // Do any additional setup after loading the view.
    }
    
    
     //setting up buttons and adding them to stackview1
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
    
    //configuring stackview1's constraints
    func StackViewConfig1()
    {
        StackView1.translatesAutoresizingMaskIntoConstraints = false
        StackView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        StackView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        StackView1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        StackView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
    }
    
    //setting up buttons and adding them to stackview2
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
        StackView2.topAnchor.constraint(equalTo: StackView1.bottomAnchor, constant: 30).isActive = true
        
    }
    //configuring stackview2's constraints
    func SetupColorWheel()
    {
        ColorWheel = UIImage(named: "colorwheel2")!
        ColorWheelView = UIImageView(image: ColorWheel)
        view.addSubview(ColorWheelView)
        view.addSubview(colorView)
        colorwheelConfig()
    }
    
    //Setting up the Colorwheel image and adding Constraints
    func colorwheelConfig()
    {
        ColorWheelView.translatesAutoresizingMaskIntoConstraints = false
        ColorWheelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ColorWheelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        //making sure UIImageView is the same size as the image so the CGimage pixels line up with the UIImage pixels
        ColorWheelView.widthAnchor.constraint(equalToConstant: ColorWheel.size.width).isActive = true
        ColorWheelView.heightAnchor.constraint(equalToConstant: ColorWheel.size.height).isActive = true
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = .gray
        colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        colorView.bottomAnchor.constraint(equalTo: ColorWheelView.topAnchor, constant:-30).isActive = true
        

        
    }
    
    //Checks if image is clicked, check the color of the image at the point, change the color of the button and the color of every light. May not be needed with longtap gesture recognizer as well
    @objc func imageTap(recognizer: UITapGestureRecognizer)
    {
        print("tapped")
        let point = recognizer.location(in: ColorWheelView)
        let x = Int(point.x)
        let y = Int(point.y)
        
        //Iterating through all lights and changing the color
        for i in lightArray{
            let RGBcolor = ColorWheel[x,y]
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            
            //converting color from RGB to HSB
            RGBcolor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            //Setting light color
            let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
            let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
            setColor.fireAndForget()
            colorView.backgroundColor = ColorWheel[x,y]
        }
    }
    
    //like the click function, checks the color of image as it's held, change the button color and the color of every light
    @objc func imageHeld(recognizer: UILongPressGestureRecognizer)
    {
        let point = recognizer.location(in: ColorWheelView)
        let x = Int(point.x)
        let y = Int(point.y)
        
        //Iterating through all lights and changing the color
        for i in lightArray{
            let RGBcolor = ColorWheel[x,y]
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            
            //converting color from RGB to HSB
            RGBcolor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            //Setting light color
            let color = HSBK(hue: UInt16(65535*hue), saturation: UInt16(65535*saturation), brightness: UInt16(65535*brightness), kelvin: 0)
            let setColor = LightSetColorCommand.create(light: i, color: color, duration: 0)
            setColor.fireAndForget()
            colorView.backgroundColor = ColorWheel[x,y]
        }
    }
    
    //Notification for adding light. If a light is found change the light to a random color to mark that it is connected
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

//This extension gets us the pixel information of the CGimage and converts it into an RGB UIColor
extension UIImage {
    subscript(x: Int, y: Int)-> UIColor?{
        //makes sure that our point is within the range of the image
        guard x>=0 && x<Int(size.width) && y>=0 && y<Int(size.height),
            //converts cgimage data into data for each byte
            let cg = cgImage,
            let provider = cg.dataProvider,
            let providedData = provider.data,
            let pureData = CFDataGetBytePtr(providedData) else{
                return nil
        }
        //converts data into RGBA
        let componentNum = 4
        let pixelData = ((Int(size.width)*y)+x) * componentNum
        let r = CGFloat(pureData[pixelData]) / 255.0
        let g = CGFloat(pureData[pixelData + 1]) / 255.0
        let b = CGFloat(pureData[pixelData + 2]) / 255.0
        let a = CGFloat(pureData[pixelData + 3]) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: a)
            
    }
}
