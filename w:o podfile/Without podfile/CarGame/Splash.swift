//
//  Splash.swift
//  CarGame
//
//  Created by selin eylül bilen on 3/31/21.
//

import UIKit
import Lottie

class Splash: UIViewController {

    let animation = Animation.named("main")
    let animationView = AnimationView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //UIView.animate(withDuration: 0.6, delay: 0.8, options: .curveEaseIn, animations: {
        //     self.title = CGRect(x: 97, y: 531, width: 221, height: 221)
        // }, completion: nil)
        
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.animation = animation
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        

        view.addSubview(animationView)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
            self.performSegue(withIdentifier: "main", sender: nil)
        }
    }
}

