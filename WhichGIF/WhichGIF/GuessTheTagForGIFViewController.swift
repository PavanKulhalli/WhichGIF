//
//  GuessTheTagViewController.swift
//  WhichGIF
//
//  Created by Pavan Kulhalli on 10/04/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//

import UIKit
import GiphyCoreSDK


class GuessTheTagForGIFViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate  {
    
    var countdownTimer: Timer!
    var totalTime = 30
    var score = 0
    var tagsArray = [] as [String]
    
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private struct Identifiers {
        static let round1ToBonus1Identifier: String = "round1ToBonus1Identifier"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timeLeftLabel.text = "Time Left: \(timeFormatted(totalTime))"
        startTimer()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage.png")!)
        
        tagsTableView.tableFooterView = UIView()
        Helper.showActivityIndicator(self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        countdownTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Helper.generateRandomGIF(gifImageView)
        
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
        tagTextField.resignFirstResponder()
        let alert = UIAlertController(title: "Time is Up!!!", message: "You scored:\(score) in this round", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.goToNextLevel()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%02d", seconds)
    }
    
    func goToNextLevel() {
        performSegue(withIdentifier: Identifiers.round1ToBonus1Identifier, sender: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Well Done!!!", message: "You scored:\(score) in this round", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            let gifId = self.gifImageView.accessibilityIdentifier
            Helper.saveTagsForGIFToCoreData(gifId!,self.tagsArray)
            self.goToNextLevel()
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagsArray.insert(textField.text!, at: 0)
        score += 10 * totalTime
        textField.text = ""
        tagsTableView.reloadData()
        return false
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tagsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagsIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = tagsArray[indexPath.row]
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tagsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            //case Identifiers.round1ToBonus1Identifier:
            // let destinationVC = segue.destination as! MatchTagWithGIFViewController
            
        default:
            break
        }
    }
}
