import AVFoundation
import Vision
import AppKit



func loadPNGAsCGImage(from path: String) -> CGImage? {
    // 1. Load the PNG into an NSImage
    guard let image = NSImage(contentsOfFile: path) else {
        print("Failed to load the image from the given path.")
        return nil
    }
    
    // 2. Convert the NSImage to CGImage
    var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    guard let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
        print("Failed to convert the NSImage to CGImage.")
        return nil
    }
    
    return cgImage
}




func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            print("guard: results")
            return
        }


        for visionResult in results {
            guard let candidate = visionResult.topCandidates(1).first else { continue }
            print(candidate.string)
        }
}


let usage="USAGE:\n        ./ocr <PNG_FILE>"

let args = CommandLine.arguments
if args.count < 2 {
    print(usage)
}

enum LoadError: Error {
     case couldNotLoadPNG
}
guard let img = loadPNGAsCGImage(from: args[1]) else { 
    let e = "Could not load as PNG: "+args[1]
    print(e)
    print(usage)
    throw LoadError.couldNotLoadPNG
}

let requestHandler = VNImageRequestHandler(cgImage: img)
let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

do { try requestHandler.perform([request]) } catch {}



