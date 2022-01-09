//
//  ToyViewModel.swift
//  DragGesture_SwiftUI
//
//  Created by Pedro Rojas on 08/01/22.
//

import SwiftUI

class ToyViewModel: ObservableObject {
    @Published var isDragged = false
    @Published var highlighedId: Int?
    @Published var selectedId: Int?
    @Published var showAlert = false
    @Published var currentPosition = initialPosition
    @Published var currentToy: Toy?
    @Published var draggableObjectScale: CGFloat = 1.0

    private var toys = Array(Toy.all.shuffled().prefix(upTo: 3))
    @Published var containerToys = Toy.all.shuffled()

    private static let initialPosition = CGPoint(
        x: UIScreen.main.bounds.midX,
        y: UIScreen.main.bounds.maxY - 100
    )

    private var frames: [Int: CGRect] = [:]
    private(set) var attempts = 0

    func setupGame() {
        currentToy = toys.popLast()

        if currentToy == nil {
            gameOver()
        }
    }

    func gameOver() {
        showAlert = true
    }

    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
    }

    func update(dragLocation: CGPoint) {
        currentPosition = dragLocation
        for (id, frame) in frames where frame.contains(dragLocation) {
            highlighedId = id
            return
        }

        highlighedId = nil
    }

    func update(isDragged: Bool){
        self.isDragged = isDragged
        guard isDragged == false else { return }
        defer { self.highlighedId = nil }

        guard let highlighedId = self.highlighedId else {
            withAnimation {
                currentPosition = ToyViewModel.initialPosition
            }
            return
        }

        withAnimation {
            if highlighedId == 1 {
                selectedId = highlighedId
                guard let frame = frames[highlighedId] else { return }
                currentPosition = CGPoint(x: frame.midX, y: frame.midY)
                draggableObjectScale = 0
                showAlert = true
            } else {
                currentPosition = ToyViewModel.initialPosition
            }
        }

        attempts += 1
    }

    func isHighlighted(id: Int) -> Bool {
        return highlighedId == id
    }

    func restart() {
        withAnimation {
            containerToys.shuffle()
        }

        withAnimation(.none) {
            currentPosition = ToyViewModel.initialPosition

            withAnimation {
                draggableObjectScale = 1
            }
        }

        selectedId = nil
    }

}
