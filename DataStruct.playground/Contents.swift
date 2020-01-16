 //: A UIKit based Playground for presenting user interface


  
import UIKit
import PlaygroundSupport


class GlobalVar: UIViewController{
    struct globalItems {
        static var storyArray = [story]() //By adding this information in a struct, we can reach this information from anywhere
        static var storyIndex = 0
    }
    internal class story{ //This is the class defining what is needed in a story
        let StoryName: String
        var SettingsArray = [settings]() //This array holds the list of settings for that story
        var SettingIndex = 0
        init(storyName: String, settingsArr: [settings], settingInd: Int) {
            StoryName = storyName
            SettingsArray = settingsArr
            SettingIndex = settingInd
        }
        internal class settings{ //This class defines a single setting within a single story
            let SettingName: String
            var ButtonInfo = [Button](repeating: Button(buttonName: "", buttonSound: ""), count: 6)//this holds the name and sound name for every button. This defined for a size of 6 because there are 6 buttons
            let ColorVal: Int //This holds the color previously selected. May have to change to a different type of int value
            init(settingName: String, point: CGPoint, buttonSounds: [Button], colorVal: Int) {
                SettingName = settingName
                ButtonInfo = buttonSounds
                ColorVal = colorVal
            }
            internal class Button{ //Holds the information for a single button on one setting
                let ButtonName: String //The name given to the button by the user
                let ButtonSound: String //this may be a different audio type
                init (buttonName: String, buttonSound: String)
                {
                    ButtonName = buttonName
                    ButtonSound = buttonSound
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

/*class MyViewController : UIViewController {
    let StringName = "Setting + \(GlobalVar.globalItems.storyArray[GlobalVar.globalItems.storyIndex].SettingIndex)"
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = StringName
        label.textColor = .black
        
        let button = UIButton()

        view.addSubview(label)
        self.view = view
    }
}*/
