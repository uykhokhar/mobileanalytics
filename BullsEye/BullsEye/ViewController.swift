//
//  ViewController.swift
//  BullsEye
//
//  Created by MouseHouseApp on 1/22/17.
//  Copyright © 2017 Umar Khokhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIGestureRecognizerDelegate{
    
    private enum Events : String {
        case showAlert = "Alert-button", sliderMoved = "Slider", startOver = "StartOver-button", info = "Info-button"
    }
    
    
    /// value of slider
    var currentValue = 0
    
    /// randomly generated value; target value
    var targetValue = 0
    
    /// total score
    var score = 0
    
    /// round number
    var round = 0
    
    
    // MARK: IBOUTLETS
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        updateLabels()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(recordTapEvent(_:)))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBACTIONS
    
    /**
     Display alert showing points gained and description of how close user was
    */
    @IBAction func showAlert(){
        
        Analytics.shared.addEvent(event: Events.showAlert.rawValue)
        
        let difference = abs(targetValue - currentValue)
        var points = 100 - difference
        
        
        let title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50 }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close...You lose 10 points"
            points -= 10
        }
        
        score += points
        
        let message = "You scored \(points) points"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "New Round", style: .default,
                                   handler: {action in self.startNewRound()
                                                        self.updateLabels()})
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    /**
     Get the slider value after slider moved. (IBaction connected to sliderMoved)
     
     - parameter: UISlider from main view
    */
    @IBAction func sliderMoved(_ slider: UISlider) {
        Analytics.shared.addEvent(event: Events.sliderMoved.rawValue)
        currentValue = lroundf(slider.value)
    }

    
    /**
     Start over button starts new game and updates labels.
     */
    @IBAction func startOver(){
        Analytics.shared.addEvent(event: Events.startOver.rawValue)
        
        startNewGame()
        updateLabels()
    }
    
    
    /**
     Info button, nothing happens.
    */
    @IBAction func info(_ sender: Any) {
        Analytics.shared.addEvent(event: Events.info.rawValue)
        
        //print out values of stored array
        print(Analytics.shared.start)
        print(Analytics.shared.touches)
        print(Analytics.shared.events)
        
    }
    
    
    /**
     Start new round by generating new target value, resetting slider to middle, incrementing round number.
    */
    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)
        round = round + 1
    }
    
    // MARK: METHODS
    
    /**
    Start new game by setting score to 0, round to 0 and starting a new round.
    */
    func startNewGame() {
        score = 0
        round = 0
        startNewRound()
    }
    
    /**
    Update the labels when the scores and value change. 
     - Label's new referencing outlet connected to IBOutlet var labels.
    */
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
        
    }
    
    
    // -MARK: Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first
        let point = touch!.location(in: self.view)
        
        // add touch event to analytics engine
        Analytics.shared.addTouch(x: Double(point.x), y: Double(point.y))
        
    }
    
    func recordTapEvent(_ touch: UITapGestureRecognizer){
        let touchPoint = touch.location(in: self.view)
        
        Analytics.shared.addTouch(x: Double(touchPoint.x), y: Double(touchPoint.y))
        
    }
    
    func showMoreActions(touch: UITapGestureRecognizer) {
        
        let touchPoint = touch.location(in: self.view)
        print(touchPoint)
        
    }


}

