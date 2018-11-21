//
//  EmptySearchView.swift
//  MoviesApp
//
//  Created by Nicholas Babo on 21/11/18.
//  Copyright © 2018 Nicholas Babo. All rights reserved.
//

import UIKit

enum ErrorType{
    case noResults
    case generic
}

class GenericErrorView: UIView {
    
    lazy var imageView:UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var label:UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = Palette.white
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(for error:ErrorType, with query:String? = nil){
        switch error{
        case .generic:
            imageView.image = UIImage(named: "poster_notAvailable")
            label.text = "Something went wrong! Please try again later."
        case .noResults:
            imageView.image = UIImage(named: "Group")
            label.text = "No Results were found for '\(query!)'."
        }
    }
    
}

extension GenericErrorView: ViewCode{
    func setupViewHierarchy() {
        self.addSubview(imageView)
        self.addSubview(label)
    }
    
    func setupConstraints() {
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.0).isActive = true
        label.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.7).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        label.numberOfLines = 4
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 25.0)
        setupView(for: .generic)
    }
    
    
}
