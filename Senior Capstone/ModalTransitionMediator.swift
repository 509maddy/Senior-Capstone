//
//  ModalTransitionMediator.swift
//  Senior Capstone
//
//  Created by Tommy Moawad on 10/25/20.
//  Copyright © 2020 Madison Lucas. All rights reserved.
//

import Foundation

// The parent view controller that can be used to navigate to a modal
protocol ModalTransitionListener {
    func popoverDismissed()
}

/** Used between the modal and the parent view controller to communivate when the modal has appeared and is dismissed
 */
class ModalTransitionMediator {
    class var instance: ModalTransitionMediator {
        struct Static {
            static let instance: ModalTransitionMediator = ModalTransitionMediator()
        }
        return Static.instance
    }

    private var listener: ModalTransitionListener?

    func setListener(listener: ModalTransitionListener) {
        self.listener = listener
    }

    func sendPopoverDismissed(modelChanged: Bool) {
        listener?.popoverDismissed()
    }
}
