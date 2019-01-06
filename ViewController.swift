//
//  ViewController.swift
//  Life Manager
//
//  Created by Catie Rencricca on 12/20/18.
//  Copyright © 2018 Catie Rencricca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Data {
        static var lists: [String] = []
    }
    

    var welcomeLabel: UILabel!
    var focusLabel: UILabel!
    var nextScreen: UIButton!
    
    var titleFont = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 40)
    var textFont = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = checkTime()
        welcomeLabel.textColor = .black
        welcomeLabel.font = titleFont
        view.addSubview(welcomeLabel)
        
        focusLabel = UILabel()
        focusLabel.translatesAutoresizingMaskIntoConstraints = false
        focusLabel.text = "Right now, I am focusing on..."
        focusLabel.textColor = .black
        focusLabel.font = textFont
        view.addSubview(focusLabel)
        
        nextScreen = UIButton()
        nextScreen.translatesAutoresizingMaskIntoConstraints = false
        nextScreen.setTitle("Continue", for: .normal)
        nextScreen.backgroundColor = .gray
        nextScreen.setTitleColor(.white, for: .normal)
        nextScreen.layer.cornerRadius = 5
        nextScreen.clipsToBounds = true
        nextScreen.titleLabel?.font = textFont
        nextScreen.addTarget(self, action: #selector(start), for: .touchUpInside)
        view.addSubview(nextScreen)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            focusLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
//            focusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:-200),
            nextScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextScreen.widthAnchor.constraint(equalToConstant: 100),
            nextScreen.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
    
    @objc func start() {
        let mainScreen = MainScreenViewController()
        self.navigationController?.pushViewController(mainScreen, animated: true)
    }
    
    func checkTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if (hour < 12) {
            return "Good Morning"
        } else if (hour < 17) {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }


}

