//
//  ViewController.swift
//  ThreeLetters
//
//  Created by Alex Larin on 30.11.2020.
//

import UIKit
import Combine
import CombineExt

class ViewController: UIViewController {
    
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var buttonTap: UIButton!
    
    enum condition {
        case start
        case stop
    }
    let letters:[Character] = ["A", "B", "C", "D", "E"]
    let timeInterval = 0.3
    let object = RandomsObject()
    var state  = condition.stop
    private var subscriptions = Set<AnyCancellable>()
    
    
    @IBAction func startButtonAction(_ sender: Any){
        switch self.state {
        case .stop:
            self.winLabel.isHidden = true
            self.state = condition.start
            startSpin()
        case .start:
            self.state = condition.stop
            if aLabel.text == bLabel.text && bLabel.text == cLabel.text{
                self.winLabel.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func startSpin() {
        let timer = Timer
            .publish(every: timeInterval, on: .main, in: .common)
            .autoconnect()
        
        timer
            .sink { _ in
                guard self.state != .stop else { timer.upstream.connect().cancel()
                    return
                }
                self.object.firstRandom = self.letters.randomElement() ?? "A"
                self.object.secondRandom = self.letters.randomElement() ?? "B"
                self.object.thirdRandom = self.letters.randomElement() ?? "C"
            }
            .store(in: &subscriptions)
        
        object.objectWillChange
            .sink {
                UIView.transition(with: self.aLabel, duration: self.timeInterval, options: .transitionFlipFromTop) {
                    self.aLabel.text = String(self.object.firstRandom)
                }
                UIView.transition(with: self.bLabel, duration: self.timeInterval, options: .transitionFlipFromTop) {
                    self.bLabel.text = String(self.object.secondRandom)
                }
                UIView.transition(with: self.cLabel, duration: self.timeInterval, options: .transitionFlipFromTop) {
                    self.cLabel.text = String(self.object.thirdRandom)
                }
            }
            .store(in: &subscriptions)
    }
    
}

