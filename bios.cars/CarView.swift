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
    private var dashboardImageView: UIImageView?
    private var mainStackView: UIStackView?
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
    
    @objc dynamic func deviceOrientationDidChange(notification: Notification) {
        
        mainStackView?.axis = UIDevice.current.orientation == .portrait ? .vertical : .horizontal
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
        dashboardImageView = UIImageView(image: UIImage(named: "dashboard"))
        mainStackView = UIStackView()
        circularSlider = CircularSlider()
        secondStackView = UIStackView()
        playButton = UIButton(type: .custom)
        thirdStackView = UIStackView()
        nameLabel = UILabel()
        brandLabel = UILabel()
        cvLabel = UILabel()
        speedLabel = UILabel()
        
        addSubview(card!)
        card?.addSubview(dashboardImageView!)
        card?.addSubview(mainStackView!)
        mainStackView?.addArrangedSubview(circularSlider!)
        mainStackView?.addArrangedSubview(secondStackView!)
        secondStackView?.addArrangedSubview(playButton!)
        secondStackView?.addArrangedSubview(thirdStackView!)
        thirdStackView?.addArrangedSubview(nameLabel!)
        thirdStackView?.addArrangedSubview(brandLabel!)
        thirdStackView?.addArrangedSubview(cvLabel!)
        card?.addSubview(speedLabel!)
        
        card?.translatesAutoresizingMaskIntoConstraints = false
        dashboardImageView?.translatesAutoresizingMaskIntoConstraints = false
        mainStackView?.translatesAutoresizingMaskIntoConstraints = false
        circularSlider?.translatesAutoresizingMaskIntoConstraints = false
        secondStackView?.translatesAutoresizingMaskIntoConstraints = false
        playButton?.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        brandLabel?.translatesAutoresizingMaskIntoConstraints = false
        cvLabel?.translatesAutoresizingMaskIntoConstraints = false
        speedLabel?.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let stackViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[mainStackView]|",
            options: [],
            metrics: nil,
            views: ["mainStackView": mainStackView!])
        
        let stackViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[mainStackView]|",
            options: [],
            metrics: nil,
            views: ["mainStackView": mainStackView!])
        
        let speedLabelCenterXConstraint = NSLayoutConstraint(item: speedLabel!,
                                                                attribute: .centerX,
                                                                relatedBy: .equal,
                                                                toItem: card,
                                                                attribute: .centerX,
                                                                multiplier: 1.0,
                                                                constant: 0)
        
        let speedLabelCenterYConstraint = NSLayoutConstraint(item: speedLabel!,
                                                             attribute: .centerY,
                                                             relatedBy: .equal,
                                                             toItem: circularSlider,
                                                             attribute: .centerY,
                                                             multiplier: 1.0,
                                                             constant: 0)
        
        let dashboardImageViewWidthConstraint = NSLayoutConstraint(item: dashboardImageView!,
                                                                     attribute: .width,
                                                                     relatedBy: .equal,
                                                                     toItem: circularSlider,
                                                                     attribute: .width,
                                                                     multiplier: 1.0,
                                                                     constant: 0)
        
        let dashboardImageViewHeightConstraint = NSLayoutConstraint(item: dashboardImageView!,
                                                                   attribute: .height,
                                                                   relatedBy: .equal,
                                                                   toItem: dashboardImageView,
                                                                   attribute: .width,
                                                                   multiplier: 1.0,
                                                                   constant: 0)
        
        let dashboardImageViewLeftConstraint = NSLayoutConstraint(item: dashboardImageView!,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: card,
                                                             attribute: .leading,
                                                             multiplier: 1.0,
                                                             constant: 0)
        
        let dashboardImageViewTopConstraint = NSLayoutConstraint(item: dashboardImageView!,
                                                             attribute: .top,
                                                             relatedBy: .equal,
                                                             toItem: card,
                                                             attribute: .top,
                                                             multiplier: 1.0,
                                                             constant: 0)
        
        constraints += stackViewHorizontalConstraints
        constraints += stackViewVerticalConstraints
        constraints.append(dashboardImageViewWidthConstraint)
        constraints.append(dashboardImageViewHeightConstraint)
        constraints.append(dashboardImageViewLeftConstraint)
        constraints.append(dashboardImageViewTopConstraint)
        constraints.append(speedLabelCenterXConstraint)
        constraints.append(speedLabelCenterYConstraint)
        
        card?.addConstraints(constraints)
        
        constraints.removeAll()
        
        let circularSliderHeightConstraint = NSLayoutConstraint(item: circularSlider!,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: nil,
                                                             attribute: .notAnAttribute,
                                                             multiplier: 1.0,
                                                             constant: 100)
        
        let circularSliderWidthConstraint = NSLayoutConstraint(item: circularSlider!,
                                                                attribute: .width,
                                                                relatedBy: .equal,
                                                                toItem: circularSlider,
                                                                attribute: .height,
                                                                multiplier: 1.0,
                                                                constant: 0)
        
        circularSlider?.addConstraints([circularSliderHeightConstraint, circularSliderWidthConstraint])
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CarView.deviceOrientationDidChange(notification:)),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        
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
        
        backgroundColor = .white
        
        let offset = CGSize(width: -1, height: -1)
        let shadowPath = UIBezierPath(roundedRect: card!.bounds, cornerRadius: 2.0 as CGFloat)

        card?.backgroundColor = .white
        card?.layer.shadowColor = UIColor.black.cgColor
        card?.layer.shadowOffset = offset
        card?.layer.shadowOpacity = 0.2 as Float
        card?.layer.shadowRadius = 2.0 as CGFloat
        card?.layer.masksToBounds = false
        card?.layer.shadowPath = shadowPath.cgPath
        
        dashboardImageView?.contentMode = .scaleAspectFit
        
        mainStackView?.axis = UIDevice.current.orientation == .portrait ? .vertical : .horizontal
        mainStackView?.alignment = .fill
        mainStackView?.distribution = .fill
        mainStackView?.spacing = 20.0
        
        circularSlider?.lineWidth = 2.0
        circularSlider?.trackFillColor = .green
        circularSlider?.diskColor = .clear
        circularSlider?.diskFillColor = UIColor.green.withAlphaComponent(0.4)
        circularSlider?.trackColor = .clear
        circularSlider?.thumbRadius = 2.0 as CGFloat
        circularSlider?.endThumbStrokeHighlightedColor = UIColor.blue.withAlphaComponent(0.4)
        circularSlider?.endThumbStrokeColor = .green
        circularSlider?.isUserInteractionEnabled = false
        circularSlider?.backgroundColor = .clear
        
        playButton?.setTitleColor(.black, for: .normal)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}
