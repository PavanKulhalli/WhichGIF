//
//  MatchGIFWithTagViewController.swift
//  WhichGIF
//
//  Created by Pavan Kulhalli on 10/04/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit
import MobileCoreServices


class MatchTagWithGIFViewController: UIViewController {
    
    var countdownTimer: Timer!
    var totalTime = 30
    var score = 0
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var gif1ImageView: UIImageView!
    @IBOutlet weak var gif2ImageView: UIImageView!
    @IBOutlet weak var gif3ImageView: UIImageView!
    @IBOutlet weak var gif4ImageView: UIImageView!
    @IBOutlet weak var gif5ImageView: UIImageView!
    @IBOutlet weak var gif6ImageView: UIImageView!
    
    @IBOutlet weak var tag1Label: UILabel!
    @IBOutlet weak var tag2Label: UILabel!
    @IBOutlet weak var tag3Label: UILabel!
    @IBOutlet weak var tag4Label: UILabel!
    @IBOutlet weak var tag5Label: UILabel!
    @IBOutlet weak var tag6Label: UILabel!
    
    @IBOutlet weak var gifTag1Label: UILabel!
    @IBOutlet weak var gifTag2Label: UILabel!
    @IBOutlet weak var gifTag3Label: UILabel!
    @IBOutlet weak var gifTag4Label: UILabel!
    @IBOutlet weak var gifTag5Label: UILabel!
    @IBOutlet weak var gifTag6Label: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        timeLeftLabel.text = "Time Left: \(timeFormatted(totalTime))"
        startTimer()
        
        tag1Label.addInteraction(UIDragInteraction(delegate: self))
        tag2Label.addInteraction(UIDragInteraction(delegate: self))
        tag3Label.addInteraction(UIDragInteraction(delegate: self))
        tag4Label.addInteraction(UIDragInteraction(delegate: self))
        tag5Label.addInteraction(UIDragInteraction(delegate: self))
        tag6Label.addInteraction(UIDragInteraction(delegate: self))
        
        gifTag1Label.addInteraction(UIDropInteraction(delegate: self))
        gifTag2Label.addInteraction(UIDropInteraction(delegate: self))
        gifTag3Label.addInteraction(UIDropInteraction(delegate: self))
        gifTag4Label.addInteraction(UIDropInteraction(delegate: self))
        gifTag5Label.addInteraction(UIDropInteraction(delegate: self))
        gifTag6Label.addInteraction(UIDropInteraction(delegate: self))
        
        Helper.showActivityIndicator(self)
        
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        countdownTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.generateRandomGIF(self.gif1ImageView)
        Helper.generateRandomGIF(self.gif2ImageView)
        Helper.generateRandomGIF(self.gif3ImageView)
        Helper.generateRandomGIF(self.gif4ImageView)
        Helper.generateRandomGIF(self.gif5ImageView)
        Helper.generateRandomGIF(self.gif6ImageView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timeLeftLabel.text = "Time Left: \(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        let currentScore = checkScore()
        let alert = UIAlertController(title: "Time is Up!!!", message: "You scored:\(currentScore) in this round", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.popToHomeViewController()
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d", seconds)
    }
    
    
    func checkScore() -> String {
        if ((gifTag1Label.text) != "") {
            score += 10
        }
        if ((gifTag2Label.text) != "") {
            score += 10
        }
        if ((gifTag3Label.text) != "") {
            score += 10
        }
        if ((gifTag4Label.text) != "") {
            score += 10
        }
        if ((gifTag5Label.text) != "") {
            score += 10
        }
        if ((gifTag6Label.text) != "") {
            score += 10
        }
        
        return "\(score)"
    }
    
    func popToHomeViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let currentScore = checkScore()
        let alert = UIAlertController(title: "Well Done!!!", message: "You scored:\(currentScore) in this round", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.popToHomeViewController()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//MARK:- UIDragInteractionDelegate Methods

extension MatchTagWithGIFViewController: UIDragInteractionDelegate {
    // This method is used to drag the item
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let textValue = interaction.view as? UILabel {
            interaction.view?.backgroundColor = UIColor(red: 0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.00)
            textValue.textColor = UIColor.white
            let provider = NSItemProvider(object: textValue.text! as NSString)
            let item = UIDragItem(itemProvider: provider)
            return [item]
        }
        return []
    }
}

//MARK:- UIDropInteractionDelegate Methods

extension MatchTagWithGIFViewController: UIDropInteractionDelegate {
    //To Highlight whether the dragging item can drop in the specific area
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        let dropOperation: UIDropOperation?
        if session.canLoadObjects(ofClass: String.self) {
            dropOperation = .copy
        } else if session.canLoadObjects(ofClass: UIImage.self) {
            dropOperation = .cancel
        } else {
            
            dropOperation = .cancel
        }
        
        return UIDropProposal(operation: dropOperation!)
    }
    
    //Drop the drag item and handle accordingly
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let location = session.location(in: self.view)
        if session.canLoadObjects(ofClass: String.self) {
            session.loadObjects(ofClass: String.self) { (items) in
                if let values = items as? [String] {
                    
                    if self.gifTag1Label.frame.contains(location) {
                        self.gifTag1Label.text = values.last
                    } else if self.gifTag2Label.frame.contains(location) {
                        self.gifTag2Label.text = values.last
                    } else if self.gifTag3Label.frame.contains(location) {
                        self.gifTag3Label.text = values.last
                    } else if self.gifTag4Label.frame.contains(location) {
                        self.gifTag4Label.text = values.last
                    } else if self.gifTag5Label.frame.contains(location) {
                        self.gifTag5Label.text = values.last
                    } else if self.gifTag6Label.frame.contains(location) {
                        self.gifTag6Label.text = values.last
                    } else {
                        if let textValue = interaction.view as? UILabel {
                            interaction.view?.backgroundColor = UIColor.clear
                            textValue.textColor = UIColor.black
                        }
                    }
                    
                } else {
                    
                }
            }
        } else if session.canLoadObjects(ofClass: UIImage.self) {
            
        }
    }
}
