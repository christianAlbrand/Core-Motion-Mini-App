//
//  MotionService.swift
//  Core Motion Mini-App
//
//  Created by Christian-SDGKU on 07/10/26.
//


import Foundation
import CoreMotion

class MotionService {

    private let motionManager = CMMotionManager()

    var onMotionUpdate: ((Double, Double) -> Void)?

    var isAvailable: Bool {
        return motionManager.isDeviceMotionAvailable
    }

    func startUpdates() {

        guard motionManager.isDeviceMotionAvailable else {
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.1

        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated

        motionManager.startDeviceMotionUpdates(
            to: queue
        ) { [weak self] motion, error in

            guard let motion = motion else {
                return
            }

            let roll = motion.attitude.roll
            let pitch = motion.attitude.pitch

            let rollDegrees = roll * 180 / .pi
            let pitchDegrees = pitch * 180 / .pi

            self?.onMotionUpdate?(
                rollDegrees,
                pitchDegrees
            )
        }
    }

    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}
