//
//  TiltView.swift
//  Core Motion Mini-App
//
//  Created by Christian-SDGKU on 07/10/26.
//


import SwiftUI

struct TiltView: View {

    @State private var viewModel = TiltViewModel()

    var body: some View {

        VStack(spacing: 25) {

            Text("Is Tilted?")
                .font(.largeTitle)
                .bold()

            Text("Hold your device flat")
                .font(.headline)

            Text(viewModel.status)
                .font(.system(size: 45))
                .bold()

            VStack(spacing: 10) {

                Text(
                    "Roll: \(viewModel.roll, specifier: "%.1f")°"
                )

                Text(
                    "Pitch: \(viewModel.pitch, specifier: "%.1f")°"
                )
            }
            .font(.title2)

            if !viewModel.errorMessage.isEmpty {

                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button(
                viewModel.isRunning ? "Stop" : "Start"
            ) {

                if viewModel.isRunning {
                    viewModel.stop()
                } else {
                    viewModel.start()
                }
            }
            .buttonStyle(.borderedProminent)

            Button("Reset") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
            
            Button(
                viewModel.isDemoMode
                    ? "Stop Demo"
                    : "Demo Mode"
            ) {
                viewModel.toggleDemo()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    TiltView()
}
