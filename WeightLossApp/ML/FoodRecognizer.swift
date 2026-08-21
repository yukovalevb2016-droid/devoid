import Foundation
import Vision
import CoreML
import UIKit

final class FoodRecognizer {
    static let modelName = "FoodClassifier"

    static var isModelAvailable: Bool {
        Bundle.main.url(forResource: modelName, withExtension: "mlmodelc") != nil
            || Bundle.main.url(forResource: modelName, withExtension: "mlmodel") != nil
    }

    static func recognize(imageData: Data) async -> [(label: String, confidence: Double)]? {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc")
                ?? Bundle.main.url(forResource: modelName, withExtension: "mlmodel") else {
            return nil
        }
        return await Task.detached(priority: .userInitiated) {
            do {
                let mlModel = try MLModel(contentsOf: modelURL)
                let visionModel = try VNCoreMLModel(for: mlModel)
                let request = VNCoreMLRequest(model: visionModel)
                request.imageCropAndScaleOption = .centerCrop

                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try handler.perform([request])

                guard let results = request.results as? [VNClassificationObservation] else { return nil }
                return results.prefix(3).map { (label: $0.identifier, confidence: Double($0.confidence)) }
            } catch {
                print("Ошибка распознавания: \(error)")
                return nil
            }
        }.value
    }
}
