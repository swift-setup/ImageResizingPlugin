import Foundation

enum ImageProcessingError: LocalizedError {
    case invalidImageSize(CGSize)
    case invalidPngData
    
    var errorDescription: String? {
        switch self {
            case .invalidImageSize(let size):
                return NSLocalizedString("Invalid image size: \(size)", comment: "Invalid image size error message")
            case .invalidPngData:
                return NSLocalizedString("Invalid png data", comment: "Invalid png data")
        }
    }
}
