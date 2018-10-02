//
//  UIView+tapGesture.swift
//  Cingulo
//
//  Created by Cíngulo on 05/06/2018.
//  Copyright © 2018 Codigo da Mente Edicao E Comercio De Livros E Testes. All rights reserved.
//

import UIKit

extension UIView {
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var MLtapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }

    fileprivate typealias MLAction = ((_ sender: UITapGestureRecognizer?) -> Void)?

    // Set our computed property type to a closure
    fileprivate var MLtapGestureRecognizerAction: MLAction? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.MLtapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.MLtapGestureRecognizer) as? MLAction
            return tapGestureRecognizerActionInstance
        }
    }

    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addMLTapGestureRecognizer(action: ((_ sender: UITapGestureRecognizer?) -> Void)?) {
        self.isUserInteractionEnabled = true
        self.MLtapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMLTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleMLTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.MLtapGestureRecognizerAction {
            action?(sender)
        } else {
            print("no action")
        }
    }

}
