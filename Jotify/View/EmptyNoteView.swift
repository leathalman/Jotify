//
//  EmptyNoteView.swift
//  Jotify
//
//  Created by Harrison Leath on 2/13/21.
//

import UIKit

class EmptyNoteView: UIView {
    
    lazy var cloudView: UIImageView = {
        let img = UIImage(named: "Cloud")
        let view = UIImageView(image: img)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleView: UITextView = {
        let view = UITextView()
        view.textAlignment = .center
        view.text = "Swipe right to write a new note."
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var detailView: UITextView = {
        let view = UITextView()
        view.textAlignment = .center
        view.text = "You haven't saved any notes! If you have used Jotify before, you may have to relaunch the app for your notes to appear."
        view.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var wrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(wrapper)
        
        wrapper.addSubview(cloudView)
        wrapper.addSubview(titleView)
        wrapper.addSubview(detailView)
        
        wrapper.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        wrapper.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        wrapper.heightAnchor.constraint(equalToConstant: 400).isActive = true
        wrapper.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        cloudView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        cloudView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 30).isActive = true
        cloudView.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.40).isActive = true
        cloudView.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.75).isActive = true
        
        titleView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -10).isActive = true
        titleView.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.75).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        detailView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        detailView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
        detailView.widthAnchor.constraint(equalTo: wrapper.widthAnchor, multiplier: 0.75).isActive = true
        detailView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame = superview?.bounds ?? .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
