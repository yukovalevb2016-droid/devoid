import Foundation
import CoreML
import UIKit
import CoreGraphics

final class FoodRecognizer {
    static let modelName = "FoodClassifier"
    private static var _model: MLModel?

    static var isModelAvailable: Bool {
        (try? loadModel()) != nil
    }

    private static func loadModel() throws -> MLModel {
        if let m = _model { return m }
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc")
                ?? Bundle.main.url(forResource: modelName, withExtension: "mlmodel") else {
            throw NSError(domain: "FoodRecognizer", code: -1, userInfo: [NSLocalizedDescriptionKey: "model not found"])
        }
        let m = try MLModel(contentsOf: url)
        _model = m
        return m
    }

    static func recognize(imageData: Data) async -> [(label: String, confidence: Double)]? {
        guard let uiImage = UIImage(data: imageData) else { return nil }
        return await Task.detached(priority: .userInitiated) { () -> [(label: String, confidence: Double)]? in
            do {
                let model = try loadModel()
                guard let inputName = model.modelDescription.inputDescriptionsByName.first?.key else { return nil }
                let size = 224
                guard let resized = uiImage.resized(to: CGSize(width: size, height: size)),
                      let cg = resized.cgImage else { return nil }

                let shape: [NSNumber] = [1, 3, NSNumber(value: size), NSNumber(value: size)]
                let array = try MLMultiArray(shape: shape, dataType: .float32)
                let mean: [Float] = [0.485, 0.456, 0.406]
                let std: [Float] = [0.229, 0.224, 0.225]

                let width = cg.width
                let height = cg.height
                let bytesPerPixel = 4
                let bytesPerRow = bytesPerPixel * width
                var raw = [UInt8](repeating: 0, count: bytesPerRow * height)
                raw.withUnsafeMutableBytes { buffer in
                    guard let base = buffer.baseAddress else { return }
                    let context = CGContext(
                        data: base,
                        width: width, height: height,
                        bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                        space: CGColorSpaceCreateDeviceRGB(),
                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                    )
                    context?.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
                }

                for y in 0..<height {
                    for x in 0..<width {
                        let i = y * bytesPerRow + x * bytesPerPixel
                        let r = (Float(raw[i]) / 255 - mean[0]) / std[0]
                        let g = (Float(raw[i + 1]) / 255 - mean[1]) / std[1]
                        let b = (Float(raw[i + 2]) / 255 - mean[2]) / std[2]
                        array[[0, 0, y, x] as [NSNumber]] = NSNumber(value: r)
                        array[[0, 1, y, x] as [NSNumber]] = NSNumber(value: g)
                        array[[0, 2, y, x] as [NSNumber]] = NSNumber(value: b)
                    }
                }

                let provider = try MLDictionaryFeatureProvider(dictionary: [inputName: array])
                let out = try model.prediction(from: provider)
                guard let dict = out.featureValue(for: "classLabelProbs")?.dictionaryValue else { return nil }
                let probs = dict.compactMapValues { $0 as? Double }
                let top = probs.sorted { $0.value > $1.value }.prefix(3)
                return top.map { (label: String(describing: $0.key), confidence: $0.value) }
            } catch {
                print("Ошибка распознавания: \(error)")
                return nil
            }
        }.value
    }
}

private extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
