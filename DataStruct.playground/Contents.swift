 //: A UIKit based Playground for presenting user interface


  
import UIKit
import PlaygroundSupport


class GlobalVar{
    struct GlobalItems {
        static var storyArray = [Story]() //By adding this information in a struct, we can reach this information from anywhere
        static var storyIndex = 0
    }
    internal class Story{ //This is the class defining what is needed in a story
        let storyName: String
        var sceneArray = [Scenes]() //This array holds the list of settings for that story
        var sceneIndex = 0
        init(storyN: String, settingsArr: [Scenes], settingInd: Int) {
            storyName = storyN
            sceneArray = settingsArr
            sceneIndex = settingInd
        }
        internal class Scenes{ //This class defines a single setting within a single story
            let sceneName: String
            var buttonInfo = [SoundAffects](repeating: SoundAffects(soundN: "", SoundV: ""), count: 6)//this holds the name and sound name for every button. This defined for a size of 6 because there are 6 buttons
            let colorVal: Int //This holds the color previously selected. May have to change to a different type of int value
            init(settingName: String, buttonSounds: [SoundAffects], colorV: Int) {
                sceneName = settingName
                buttonInfo = buttonSounds
                colorVal = colorV
            }
            internal class SoundAffects{ //Holds the information for a single button on one setting
                let soundName: String //The name given to the button by the user
                let soundVal: String //this may be a different audio type
                init (soundN: String, SoundV: String)
                {
                    soundName = soundN
                    soundVal = SoundV
                }
            }
        }
    }
    // Do any additional setup after loading the view, typically from a nib
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
