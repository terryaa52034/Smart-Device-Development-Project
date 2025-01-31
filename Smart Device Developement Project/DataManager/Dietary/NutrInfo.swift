//
//  NutrInfo.swift
//  Smart Device Developement Project
//
//  Created by Aloysius on 8/7/18.
//  Copyright © 2018 ITP312. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NutrInfo: NSObject {
    
    let user = AuthenticateUser.getUID()
    
    func calcBMI(onComplete: @escaping (Double) -> Void){
        
        var ref: DatabaseReference
        //let user = "dQsolOJTwjNSaGiEfMEnBObUkXH3"
        ref = Database.database().reference().child("Profile").child(user)
        
        ref.observeSingleEvent(of: .value,
                               with: { (snapshot) in
                                let height = (snapshot.childSnapshot(forPath: "height").value as? String)!
                                let weight = (snapshot.childSnapshot(forPath: "weight").value as? String)!
                                let h = Double(height) ?? 0.0
                                let w = Double(weight) ?? 0.0
                                let h1 = h/100
                                let BMI = w / (h1 * h1)
                                let x = Double(BMI * 100).rounded() / 100
                                onComplete(x)
        })
    }
    
    func calReccCalories(onComplete: @escaping (Int) -> Void){

        var ref: DatabaseReference
        //let user = "dQsolOJTwjNSaGiEfMEnBObUkXH3"
        ref = Database.database().reference().child("Profile").child(user)
        
        ref.observeSingleEvent(of: .value,
                               with: { (snapshot) in
                                let height = (snapshot.childSnapshot(forPath: "height").value as? String)!
                                let weight = (snapshot.childSnapshot(forPath: "weight").value as? String)!
                                let h = Double(height) ?? 0.0
                                let w = Double(weight) ?? 0.0
                                let b1 = 13.75 * h
                                let b2 = 5.0 * w
                                let b3 = 6.75 * 20
                                let recc = 66.47 + b1 + b2 - b3
                                let calories = Int(recc.rounded())
                                onComplete(calories)
        })
    }
    
    func getWeight(onComplete: @escaping (Double) -> Void){

        var ref: DatabaseReference
        //let user = "dQsolOJTwjNSaGiEfMEnBObUkXH3"
        ref = Database.database().reference().child("Profile").child(user)
        
        ref.observeSingleEvent(of: .value,
                               with: { (snapshot) in
                                let weight = (snapshot.childSnapshot(forPath: "weight").value as? String)!
                                let w = Double(weight) ?? 0.0
                                onComplete(w)
        })
    }
    
    func getGoal(onComplete: @escaping (Int) -> Void){
        
        var ref: DatabaseReference
        //let user = "dQsolOJTwjNSaGiEfMEnBObUkXH3"
        ref = Database.database().reference().child("Profile").child(user)
        
        ref.observeSingleEvent(of: .value,
                               with: { (snapshot) in
                                let goal = (snapshot.childSnapshot(forPath: "goal").value as? Int)!
                                onComplete(goal)
        })
    }
    
    static func updateGoals(goal: Int){
        Database.database().reference().child("Profile").child(AuthenticateUser.getUID()).updateChildValues(["goal": goal])
    }
    
}
