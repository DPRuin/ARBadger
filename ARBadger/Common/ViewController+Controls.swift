/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Handles keyboard (macOS), touch (iOS) and controller (iOS, tvOS) input for controlling the game.
*/

import GameKit

extension ViewController {
    
    // MARK: Game Controller Events

    func setupGameControllers() {
        // Gesture recognizers
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
            gesture.direction = direction
            sceneView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleControllerDidConnectNotification(_ notification: NSNotification) {
        let gameController = notification.object as! GCController
        registerCharacterMovementEvents(gameController)
    }

    private func registerCharacterMovementEvents(_ gameController: GCController) {
        // An analog movement handler for D-pads and thumbsticks.
        let movementHandler: GCControllerDirectionPadValueChangedHandler = { [unowned self] dpad, _, _ in
            self.controllerDPad = dpad
        }
        
        // Gamepad D-pad
        if let gamepad = gameController.gamepad {
            gamepad.dpad.valueChangedHandler = movementHandler
        }
        
        // Extended gamepad left thumbstick
        if let extendedGamepad = gameController.extendedGamepad {
            extendedGamepad.leftThumbstick.valueChangedHandler = movementHandler
        }
    }
    
    // MARK: Touch Events
    func didSwipe(sender: UISwipeGestureRecognizer) {
        if startGameIfNeeded() {
            return
        }
    
        switch sender.direction {
            case UISwipeGestureRecognizerDirection.up: jump()
            case UISwipeGestureRecognizerDirection.down: squat()
            case UISwipeGestureRecognizerDirection.left: leanLeft()
            case UISwipeGestureRecognizerDirection.right: leanRight()
            default: break
        }
    }
}
