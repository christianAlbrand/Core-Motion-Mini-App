//
//  TiltViewModel.swift
//  Core Motion Mini-App
//
//  Created by Christian-SDGKU on 07/10/26.
//


import Foundation
import Observation

@Observable
class TiltViewModel {

    private let motionService = MotionService()

    var isRunning = false
    var roll = 0.0
    var pitch = 0.0
    var status = "STOPPED"
    var errorMessage = ""
    var isDemoMode = false

    private let threshold = 8.0

    init() {

        motionService.onMotionUpdate = { [weak self] roll, pitch in

            DispatchQueue.main.async {

                guard let self = self else {
                    return
                }

                self.roll = roll
                self.pitch = pitch

                if abs(roll) <= self.threshold &&
                    abs(pitch) <= self.threshold {

                    self.status = "LEVEL"

                } else {

                    self.status = "TILTED"
                }
            }
        }
    }

    func start() {

        errorMessage = ""

        guard motionService.isAvailable else {
            errorMessage = "Motion sensors are not available on this device."
            return
        }

        motionService.startUpdates()

        isRunning = true
        status = "LEVEL"
    }

    func stop() {

        motionService.stopUpdates()

        isRunning = false
        status = "STOPPED"
    }

    func reset() {

        stop()

        roll = 0
        pitch = 0
        status = "STOPPED"
    }

    // MARK: - Demo Mode

    func toggleDemo() {

        isDemoMode.toggle()

        if isDemoMode {
            startDemo()
        } else {
            stopDemo()
        }
    }

    private func startDemo() {

        isRunning = true
        status = "LEVEL"

        Task {

            var angle = 0.0
            var increasing = true

            while isDemoMode {

                try? await Task.sleep(
                    for: .milliseconds(500)
                )

                if increasing {
                    angle += 5
                } else {
                    angle -= 5
                }

                if angle >= 20 {
                    increasing = false
                }

                if angle <= -20 {
                    increasing = true
                }

                await MainActor.run {

                    self.roll = angle
                    self.pitch = angle / 2

                    if abs(self.roll) <= self.threshold &&
                        abs(self.pitch) <= self.threshold {

                        self.status = "LEVEL"

                    } else {

                        self.status = "TILTED"
                    }
                }
            }
        }
    }

    private func stopDemo() {

        isRunning = false
        roll = 0
        pitch = 0
        status = "STOPPED"
    }
}
