//
//  AlayamTextView.swift
//  Alayam
//
//  Created by admin on 06/07/16.
//  Copyright © 2016 Vaijayanthi Mala. All rights reserved.
//

import UIKit

@IBDesignable
public class AlayamTextView: UITextView {
        
        //    private struct Constants {
        //        static
        //
        //    }
        
        static let defaultPlaceholderColor = UIColor.lightGrayColor()
        var maxCharCount = 300
        
        private let placeholderLabel: UILabel = UILabel()
        
        private var placeholderLabelConstraints = [NSLayoutConstraint]()
        
        @IBInspectable var placeholder: String = "" {
            didSet {
                placeholderLabel.text = placeholder
            }
        }
        
        @IBInspectable var placeholderColor: UIColor = defaultPlaceholderColor {
            didSet {
                placeholderLabel.textColor = placeholderColor
            }
        }
        
        override public var font: UIFont! {
            didSet {
                placeholderLabel.font = font
            }
        }
        
        override public var textAlignment: NSTextAlignment {
            didSet {
                placeholderLabel.textAlignment = textAlignment
            }
        }
        
        override public var text: String! {
            didSet {
                textDidChange()
            }
        }
        
        override public var attributedText: NSAttributedString! {
            didSet {
                textDidChange()
            }
        }
        
        override public var textContainerInset: UIEdgeInsets {
            didSet {
                updateConstraintsForPlaceholderLabel()
            }
        }
        
        override init(frame: CGRect, textContainer: NSTextContainer?) {
            super.init(frame: frame, textContainer: textContainer)
            commonInit()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            
            self.autocapitalizationType = .Words
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(textDidChange),
                                                             name: UITextViewTextDidChangeNotification,
                                                             object: nil)
            
            placeholderLabel.font = font
            placeholderLabel.textColor = placeholderColor
            placeholderLabel.textAlignment = textAlignment
            placeholderLabel.text = placeholder
            placeholderLabel.numberOfLines = 0
            placeholderLabel.backgroundColor = UIColor.clearColor()
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(placeholderLabel)
            updateConstraintsForPlaceholderLabel()
        }
        
        private func updateConstraintsForPlaceholderLabel() {
            var newConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
                                                                                options: [],
                                                                                metrics: nil,
                                                                                views: ["placeholder": placeholderLabel])
            newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(textContainerInset.top))-[placeholder]",
                                                                             options: [],
                                                                             metrics: nil,
                                                                             views: ["placeholder": placeholderLabel])
            newConstraints.append(NSLayoutConstraint(
                item: placeholderLabel,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: self,
                attribute: .Width,
                multiplier: 1.0,
                constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
                ))
            removeConstraints(placeholderLabelConstraints)
            addConstraints(newConstraints)
            placeholderLabelConstraints = newConstraints
        }
        
        @objc private func textDidChange() {
            placeholderLabel.hidden = !text.isEmpty
        }
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
        }
        
        deinit {
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                name: UITextViewTextDidChangeNotification,
                                                                object: nil)
        }
        
        
        func textViewShouldBeginEditing(textView: UITextView) -> Bool {
            
            dispatch_async(dispatch_get_main_queue()) {
                textView.selectAll(nil)
            }
            //        textView.selectAll(textView)
            //        textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.endOfDocument)
            
            return true
        }
        
        
        func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
            
            let language = textView.textInputMode?.primaryLanguage
            
            if language == nil
            {
                return false
                
            }
            
            
            let newString = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
            
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            
            if newString.characters.count > maxCharCount {
                return false
            }
            
            return textView.textInputMode != nil
        }

}
