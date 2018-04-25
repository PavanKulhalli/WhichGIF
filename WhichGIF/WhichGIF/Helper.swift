//
//  Helper.swift
//  WhichGIF
//
//  Created by Pavan Kulhalli on 24/04/2018.
//  Copyright © 2018 COMP47390-41550. All rights reserved.
//


import GiphyCoreSDK
import CoreData

class Helper{
    static func generateRandomGIF(_ imageView:UIImageView) {
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        imageView.addSubview(activityIndicator);
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
        _ = GiphyCore.shared.random("") { (response, error) in
            
            if (error as NSError?) != nil {
                // Do what you want with the error
            }
            
            if let response = response, let data = response.data  {
                print(response.meta)
                print(data)
                DispatchQueue.main.async {
                    imageView.image = UIImage.gifImageWithURL(data.jsonRepresentation!["image_original_url"] as! String)
                    imageView.accessibilityIdentifier = data.id
                    activityIndicator.stopAnimating();
                    UIApplication.shared.endIgnoringInteractionEvents();
                }
            } else {
                print("No Result Found")
            }
        }
    }
    
    static func showActivityIndicator(_ currentViewController:UIViewController) {
        let alert = UIAlertController(title: "", message: "GIF is loading. Please wait...", preferredStyle: .alert)
        currentViewController.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 2 seconds)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // Save Data with Core Data
    static func saveTagsForGIFToCoreData(_ gifId: String, _ tags: [String] ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let gifEntity = NSEntityDescription.entity(forEntityName: "GIF", in: managedContext)!
        let gif = NSManagedObject(entity: gifEntity, insertInto: managedContext)
        
        gif.setValue(gifId, forKeyPath: "gifId")
        
        let tagEntity = NSEntityDescription.entity(forEntityName: "Tag", in: managedContext)!
        let tags = gif.mutableSetValue(forKey: "tags")
        
        for tagItem in tags {
            let tag = NSManagedObject(entity: tagEntity, insertInto: managedContext)
            tag.setValue(tagItem, forKey: "tag")
            tags.add(tag)
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        print("\n \n \n \n Fetching results saved")
        let tagFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        tagFetch.returnsObjectsAsFaults = false
        let tagsResults = try! managedContext.fetch(tagFetch)
        print((tagsResults.last as! Tag).gif!)
        
        do {
            let count = try managedContext.count(for: tagFetch)
            print(count)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
    }
}
