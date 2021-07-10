//
//  OneToTenView.swift
//  Feedback
//
//  Created by Rohan Moradiya on 19/06/21.
//

import UIKit

class FollowupView: UIView {

    @IBOutlet weak var textView: UITextView!
    weak var delegate: RatingViewProtocol?
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    let placeHolderText = "I had trouble with..."
    var placeholderLabel : UILabel!
    var enteredText: String? {
        didSet {
            self.delegate?.followupViewEnterTextWith(enteredText)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = placeHolderText
        placeholderLabel.font = UIFont.systemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension FollowupView: UITextViewDelegate {

    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        self.enteredText = textView.text
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = newSize.height > 65 ? newSize.height : 65
        
        if let frame = textView.superview?.superview?.superview?.frame {
            if frame.origin.y > 80 {
                self.textViewHeightConstraint.constant = newHeight
            }
        }
    }
    
}
