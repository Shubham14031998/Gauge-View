//
//  ViewController.swift
//  ABGaugeView
//
//  Created by Shubham Kaliyar on 06/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arcView: TAGaugeView!
    @IBOutlet weak var circleView: TAProgressVieww!

    
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arcView.needleValue = 0
        self.setupprogressView(magProgress: self.circleView,count: CGFloat(self.arcView.needleValue/100))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.arcView.needleValue = self.arcView.needleValue + 1
            self.setupprogressView(magProgress: self.circleView,count: CGFloat(self.arcView.needleValue/100))
            if self.arcView.needleValue == 100 {
                self.arcView.needleValue = 1
            }
        }
    }
    func setupprogressView(magProgress:TAProgressVieww,count:CGFloat = 10) {
        magProgress.setProgress(progress: count, animated: true)
        magProgress.progressShapeColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        magProgress.backgroundShapeColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        magProgress.percentColor = UIColor.black
        magProgress.lineWidth = 15
        magProgress.orientation = .top
        magProgress.lineCap = .round
        magProgress.layoutIfNeeded()
    }
}

