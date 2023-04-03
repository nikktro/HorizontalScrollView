//
//  FilterView.swift
//  HorizontalScrollView
//
//  Created by Nikolay Trofimov on 03.04.2023.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func didRemoveItemAtIndex(index: Int, item: String)
}

extension FilterViewDelegate {
    func didRemoveItemAtIndex(index: Int, item: String) {}
}

class FilterView: UIView {

    weak var delegate: FilterViewDelegate?
    
    var dataSource: [String] = [] {
        didSet {
            renderUI()
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
        
        var scrollViewAnchors = [NSLayoutConstraint]()
        scrollViewAnchors.append(scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0))
        scrollViewAnchors.append(scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0))
        scrollViewAnchors.append(scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0))
        scrollViewAnchors.append(scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0))
        NSLayoutConstraint.activate(scrollViewAnchors)
        
        var stackViewAnchors = [NSLayoutConstraint]()
        stackViewAnchors.append(stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0))
        stackViewAnchors.append(stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor))
        stackViewAnchors.append(stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor))
        stackViewAnchors.append(stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor))
        NSLayoutConstraint.activate(stackViewAnchors)
    }
    
    private func renderUI() {
        for (index, item) in dataSource.enumerated() {
            stackView.addArrangedSubview(createTokenView(index: index, item: item))
        }
    }
    
    private func createTokenView(index: Int, item: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.text = item
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        let removeButton = UIButton(type: .custom)
        removeButton.tag = index
        removeButton.setImage(UIImage(systemName: "xmark")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        removeButton.addTarget(self, action: #selector(removeButtonAction), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(removeButton)
        
        var viewAnchors = [NSLayoutConstraint]()
        viewAnchors.append(textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0))
        viewAnchors.append(textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8))
        viewAnchors.append(textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0))
        NSLayoutConstraint.activate(viewAnchors)
        
        var removeButtonAnchors = [NSLayoutConstraint]()
        removeButtonAnchors.append(removeButton.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: 0))
        removeButtonAnchors.append(removeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
        removeButtonAnchors.append(removeButton.heightAnchor.constraint(equalTo: view.heightAnchor))
        removeButtonAnchors.append(removeButton.widthAnchor.constraint(equalTo: removeButton.heightAnchor))
        removeButtonAnchors.append(removeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0))
        NSLayoutConstraint.activate(removeButtonAnchors)
        
        return view
    }
    
    @objc private func removeButtonAction(sender: UIButton) {
        self.delegate?.didRemoveItemAtIndex(index: sender.tag, item: dataSource[sender.tag])
        stackView.removeAllSubviews()
        dataSource.remove(at: sender.tag)
    }
    
}

extension UIStackView {
    func removeAllSubviews() {
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}
