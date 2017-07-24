//
//  CarView.swift
//  bios.cars
//
//  Created by iOS Developer on 20/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import UIKit
import HGCircularSlider

public class CarView: UIView {
    
    private var card: UIView?
    private var firstStackView: UIStackView?
    private var circularContainer: UIView?
    private var circularSlider: CircularSlider?
    private var secondStackView: UIStackView?
    private var playButton: UIButton?
    private var thirdStackView: UIStackView?
    private var nameLabel: UILabel?
    private var brandLabel: UILabel?
    private var cvLabel: UILabel?
    private var speedLabel: UILabel?
    
    public var buttonTouchBlock: ((Bool) -> ())?
    
    public var name: String? {
        didSet {
            
            if let name = name {
                
                nameLabel?.text = name
            }
        }
    }
    
    public var brand: String? {
        didSet {
            
            if let brand = brand {
                
                brandLabel?.text = brand
            }
        }
    }
    
    public var cv: Int? {
        didSet {
            
            if let cv = cv {
                
                let template = NSLocalizedString("cv", comment: "")
                cvLabel?.text = String(format: template, cv)
            }
        }
    }
    
    public var speedMax: Int? {
        didSet {
            
            if let speedMax = speedMax {
                
                circularSlider?.minimumValue = 0
                circularSlider?.maximumValue = CGFloat(speedMax)
                circularSlider?.endPointValue = 0
            }
        }
    }
    
    public var currentSpeed: Int? {
        didSet {
            
            if let currentSpeed = currentSpeed {
                
                circularSlider?.endPointValue = CGFloat(currentSpeed)
                
                if let speedMax = speedMax {
                    
                    let template = NSLocalizedString("current_speed", comment: "")
                    let text = String(format: template, currentSpeed, speedMax)
                    
                    speedLabel?.text = text
                }
            }
        }
    }
    
    @objc dynamic func playButtonTouched(sender: UIButton) {
        
        let start = NSLocalizedString("start", comment: "")
        let stop = NSLocalizedString("stop", comment: "")
        
        let currentTitle = sender.title(for: .normal)
        let willStart = currentTitle == start
        
        playButton?.setTitle(willStart ? stop : start, for: .normal)
        buttonTouchBlock?(willStart)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        card = UIView()
        firstStackView = UIStackView()
        circularContainer = UIView()
        circularSlider = CircularSlider()
        playButton = UIButton(type: .custom)
        nameLabel = UILabel()
        brandLabel = UILabel()
        cvLabel = UILabel()
        speedLabel = UILabel()
        
        addSubview(card!)
        card?.addSubview(firstStackView!)
        
        firstStackView?.addArrangedSubview(circularContainer!)
        firstStackView?.addArrangedSubview(playButton!)
        
        circularContainer?.addSubview(circularSlider!)
        
        card?.translatesAutoresizingMaskIntoConstraints = false
        firstStackView?.translatesAutoresizingMaskIntoConstraints = false
        circularContainer?.translatesAutoresizingMaskIntoConstraints = false
        circularSlider?.translatesAutoresizingMaskIntoConstraints = false
        
        let cardHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-spacing-[card]-spacing-|",
            options: [],
            metrics: ["spacing": 20.0],
            views: ["card": card!])
        
        let cardVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-spacing-[card]-spacing-|",
            options: [],
            metrics: ["spacing": 20.0],
            views: ["card": card!])
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += cardHorizontalConstraints
        constraints += cardVerticalConstraints
        
        addConstraints(constraints)
        
        constraints.removeAll()
        
        let firstStackViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-spacing-[firstStackView]-spacing-|",
            options: [],
            metrics: ["spacing": 20.0],
            views: ["firstStackView": firstStackView!])
        
        let firstStackViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-spacing-[firstStackView]-spacing-|",
            options: [],
            metrics: ["spacing": 20.0],
            views: ["firstStackView": firstStackView!])
        
        constraints += firstStackViewHorizontalConstraints
        constraints += firstStackViewVerticalConstraints
        
        card?.addConstraints(constraints)
        
        constraints.removeAll()
        
        let circularContainerHeightConstraint = NSLayoutConstraint(item: circularContainer!,
                                                               attribute: .height,
                                                               relatedBy: .equal,
                                                               toItem: circularContainer,
                                                               attribute: .width,
                                                               multiplier: 1.0,
                                                               constant: 0)
        
        let circularSliderHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[circularSlider(width)]",
            options: [],
            metrics: ["width": 250.0],
            views: ["circularSlider": circularSlider!])
        
        let circularSliderVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[circularSlider(height)]",
            options: [],
            metrics: ["height": 250.0],
            views: ["circularSlider": circularSlider!])
        
        let circularSliderCenterXConstraint = NSLayoutConstraint(item: circularSlider!,
                                                                   attribute: .centerX,
                                                                   relatedBy: .equal,
                                                                   toItem: circularContainer,
                                                                   attribute: .centerX,
                                                                   multiplier: 1.0,
                                                                   constant: 0)
        
        let circularSliderCenterYConstraint = NSLayoutConstraint(item: circularSlider!,
                                                                 attribute: .centerY,
                                                                 relatedBy: .equal,
                                                                 toItem: circularContainer,
                                                                 attribute: .centerY,
                                                                 multiplier: 1.0,
                                                                 constant: 0)
        
        constraints.append(circularContainerHeightConstraint)
        constraints += circularSliderHorizontalConstraints
        constraints += circularSliderVerticalConstraints
        constraints.append(circularSliderCenterXConstraint)
        constraints.append(circularSliderCenterYConstraint)
        
        circularContainer?.addConstraints(constraints)
        
        backgroundColor = .white
        
        let offset = CGSize(width: -1.0 as CGFloat, height: 1.0 as CGFloat)
        let shadowPath = UIBezierPath(roundedRect: card!.bounds, cornerRadius: 2.0 as CGFloat)
        
        card?.backgroundColor = .white
        card?.layer.shadowColor = UIColor.black.cgColor
        card?.layer.shadowOffset = offset
        card?.layer.shadowOpacity = 0.2 as Float
        card?.layer.shadowRadius = 2.0 as CGFloat
        card?.layer.masksToBounds = false
        card?.layer.shadowPath = shadowPath.cgPath
        
        firstStackView?.axis = .vertical
        firstStackView?.alignment = .fill
        firstStackView?.distribution = .fill
        firstStackView?.spacing = 0
        
        circularSlider?.lineWidth = 2.0
        circularSlider?.trackFillColor = .red
        circularSlider?.diskColor = .clear
        circularSlider?.diskFillColor = UIColor.lightGray.withAlphaComponent(0.4)
        circularSlider?.trackColor = .black
        circularSlider?.thumbRadius = 2.0 as CGFloat
        circularSlider?.endThumbStrokeHighlightedColor = UIColor.blue.withAlphaComponent(0.4)
        circularSlider?.endThumbStrokeColor = .green
        circularSlider?.isUserInteractionEnabled = false
        circularSlider?.backgroundColor = .clear
        
        playButton?.setTitleColor(.black, for: .normal)
        playButton?.setTitle(NSLocalizedString("start", comment: ""), for: .normal)
        playButton?.addTarget(self,
                              action: #selector(CarView.playButtonTouched(sender:)),
                              for: .touchUpInside)

    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        firstStackView?.axis = UIDevice.current.orientation == .portrait ? .vertical : .horizontal
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}
