//
//  RatingViewController.swift
//  Feedback
//
//  Created by Rohan Moradiya on 16/06/21.
//

import UIKit

enum RatingStyle {
    case OneToTen
    case OneToFive
    case Stars
    case Emoji
    case MCQ
    case FollowUp
    case ReviewPrompt
    case ThankYou
}

struct RatingConfiguration {
    let ratingStyle: RatingStyle
    let primaryTitle1: String?
    let primaryTitle2: String?
    let secondaryTitle: String?
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?
    let doneButtonTitle: String?
}

class RatingViewController: UIViewController {
    
    @IBOutlet weak var ratingView: RoundedConrnerView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var viewPrimaryTitle1: UIView!
    @IBOutlet weak var viewPrimaryTitle2: UIView!
    @IBOutlet weak var viewSecondaryTitle: UIView!
    @IBOutlet weak var viewPrimaryButton: UIView!
    @IBOutlet weak var viewSecondaryButton: UIView!
    @IBOutlet weak var viewDoneButton: UIView!
    
    @IBOutlet weak var lblPrimaryTitle1: UILabel!
    @IBOutlet weak var lblPrimaryTitle2: UILabel!
    @IBOutlet weak var lblSecondaryTitle: UILabel!
    @IBOutlet weak var btnPrimary: ActionButton!
    @IBOutlet weak var btnSecondary: ActionButton!
    @IBOutlet weak var btnDone: ActionButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private var isKeyboardVisible = false
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var confuguration: RatingConfiguration?
    
    var selectedIndex: Int? {
        didSet {
            if selectedIndex != nil {
                self.btnPrimary.isActive = true
            } else {
                self.btnPrimary.isActive = false
            }
        }
    }
    
    var enteredText: String? {
        didSet {
            if enteredText?.count ?? 0 > 0 {
                self.btnPrimary.isActive = true
            } else {
                self.btnPrimary.isActive = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUIAccordingToConfiguration()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        ratingView.addGestureRecognizer(panGestureRecognizer!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.isKeyboardVisible = true
        self.bottomConstraint.constant = keyboardFrame.size.height //+ 20
        self.ratingView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.isKeyboardVisible = false
        
        self.bottomConstraint.constant = 0
        self.ratingView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func setupUIAccordingToConfiguration() {
        guard let config = self.confuguration else { return }
        
        if let value = config.primaryTitle1 {
            self.viewPrimaryTitle1.isHidden = false
            self.lblPrimaryTitle1.text = value
        } else {
            self.viewPrimaryTitle1.isHidden = true
        }
        
        if let value = config.primaryTitle2 {
            self.viewPrimaryTitle2.isHidden = false
            self.lblPrimaryTitle2.text = value
        } else {
            self.viewPrimaryTitle2.isHidden = true
        }
        
        if let value = config.secondaryTitle {
            self.viewSecondaryTitle.isHidden = false
            self.lblSecondaryTitle.text = value
        } else {
            self.viewSecondaryTitle.isHidden = true
        }
        
        if let value = config.primaryButtonTitle {
            self.viewPrimaryButton.isHidden = false
            self.btnPrimary.setTitle(value, for: .normal)
            self.btnPrimary.style = .primary
            self.btnPrimary.isActive = false
        } else {
            self.viewPrimaryButton.isHidden = true
        }
        
        if let value = config.secondaryButtonTitle {
            self.viewSecondaryButton.isHidden = false
            self.btnSecondary.setTitle(value, for: .normal)
            self.btnSecondary.style = .secondary
            self.btnSecondary.isActive = true
        } else {
            self.viewSecondaryButton.isHidden = true
        }
        
        if let value = config.doneButtonTitle {
            self.viewDoneButton.isHidden = false
            self.btnDone.setTitle(value, for: .normal)
            self.btnDone.style = .done
            self.btnDone.isActive = true
        } else {
            self.viewDoneButton.isHidden = true
        }
        
        switch config.ratingStyle {
        case .OneToTen:
            let view = OneToTenView.loadFromNib()
            view.delegate = self
            self.stackView.insertArrangedSubview(view, at: 3)
            break
        case .OneToFive:
            let view = OneToFiveView.loadFromNib()
            view.delegate = self
            self.stackView.insertArrangedSubview(view, at: 3)
            break
        case .Stars:
            let view = StarsView.loadFromNib()
            view.delegate = self
            self.stackView.insertArrangedSubview(view, at: 3)
            break
        case .Emoji:
            let view = EmojiView.loadFromNib()
            view.delegate = self
            self.stackView.insertArrangedSubview(view, at: 3)
            break
        case .MCQ:
            let view = MCQView.loadFromNib()
            view.delegate = self
            view.setupViewWithOptions(["Very disappointed", "Somewhat disappointed", "Not disappointed (it isn’t really that useful)", "Test fourth option"])
            self.stackView.insertArrangedSubview(view, at: 3)
            break
        case .FollowUp:
            let view = FollowupView.loadFromNib()
            view.delegate = self
            self.stackView.insertArrangedSubview(view, at: 3)
            break
        case .ThankYou:
            break
        case .ReviewPrompt:
            self.btnPrimary.isActive = true
            break
        }
        
    }
    
    func animateRatingView() {
        let originalPosition = self.ratingView.frame.origin.y
        ratingView.frame.origin.y = self.view.frame.size.height
        ratingView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.ratingView.frame.origin.y = originalPosition
        }
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: ratingView)
        if panGesture.state == .began {
            originalPosition = ratingView.center
            currentPositionTouched = panGesture.location(in: ratingView)
            
        } else if panGesture.state == .changed {
            ratingView.frame.origin = CGPoint(
                x: ratingView.frame.origin.x,
                y: (originalPosition?.y ?? 0) - (ratingView.frame.size.height / 2) + translation.y
            )
            
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: ratingView)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                               , animations: {
                                self.ratingView.frame.origin = CGPoint(
                                    x: self.ratingView.frame.origin.x,
                                    y: self.view.frame.size.height
                                )
                               }, completion: { (isCompleted) in
                                if isCompleted {
                                    self.closeFeedbackView()
                                }
                               })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.ratingView.center = self.originalPosition!
                })
            }
        }
    }

    @IBAction func onBlankSpaceTapped(_ sender: Any) {
        if self.isKeyboardVisible == true {
            self.view.endEditing(true)
            return
        }
        self.view.backgroundColor = UIColor.clear
        self.closeFeedbackView()
    }
    
    @IBAction func onPrimaryButton(_ sender: UIButton) {
        self.closeFeedbackView()
    }
    
    @IBAction func onSecondaryButton(_ sender: UIButton) {
        self.closeFeedbackView()
    }
    
    @IBAction func onDoneButton(_ sender: UIButton) {
        self.closeFeedbackView()
    }
    
    func closeFeedbackView() {
        self.dismiss(animated: false, completion: nil)
    }
}

extension RatingViewController: RatingViewProtocol {
    
    func oneToTenViewChangeSelection(_ selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
    }
    
    func oneToFiveViewChangeSelection(_ selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
    }
    
    func starsViewChangeSelection(_ selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
    }
    
    func emojiViewChangeSelection(_ selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
    }
    
    func mcqViewChangeSelection(_ selectedIndex: Int?) {
        self.selectedIndex = selectedIndex
    }
    
    func followupViewEnterTextWith(_ text: String?) {
        self.enteredText = text
    }
}
