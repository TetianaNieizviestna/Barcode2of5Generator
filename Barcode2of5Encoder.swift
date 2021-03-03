//
//  Barcode2of5Encoder.swift
//
//  Created by Tetiana Nieizviestna 
//

import Foundation

enum BarWidth: Int {
    case Narrow = 0
    case Wide = 1
}

struct Barcode2of5Encoder {
    
    private enum Constants {
        
        static let encodings: [Character: [BarWidth]] = [
            "0": [.Narrow, .Narrow, .Wide, .Wide, .Narrow], //"00110"
            "1": [.Wide, .Narrow, .Narrow, .Narrow, .Wide], //"10001"
            "2": [.Narrow, .Wide, .Narrow, .Narrow, .Wide], //"01001"
            "3": [.Wide, .Wide, .Narrow, .Narrow, .Narrow], //"11000"
            "4": [.Narrow, .Narrow, .Wide, .Narrow, .Wide], //"00101"
            "5": [.Wide, .Narrow, .Wide, .Narrow, .Narrow], //"10100"
            "6": [.Narrow, .Wide, .Wide, .Narrow, .Narrow], //"01100"
            "7": [.Narrow, .Narrow, .Narrow, .Wide, .Wide], //"00011"
            "8": [.Wide, .Narrow, .Narrow, .Wide, .Narrow], //"10010"
            "9": [.Narrow, .Wide, .Narrow, .Wide, .Narrow], //"01010"
        ]

        static let LENGTH = 22
        static let START_ENCODE: [BarWidth] = [.Narrow, .Narrow, .Narrow, .Narrow]
        static let STOP_ENCODE: [BarWidth] = [.Wide, .Narrow, .Narrow]

    }
    
    enum Error: Swift.Error {
        case length
        case intermediateCharacter
    }
    
    private let code: String
    
    public init(code: String) throws {
        let code = code.uppercased()
        
        guard code.count == Constants.LENGTH else {
            throw Error.length
        }
        
        guard code.filter({ !Constants.encodings.keys.contains($0) }).isEmpty else {
            throw Error.intermediateCharacter
        }
        
        self.code = code
    }
    
    /// Return sequence of bits representing Barcode Interlaved 2 of 5 (ITF-22)
    ///
    /// - Returns: Returns string representing bits
    public func sequence() -> [BarWidth] {
        
        let codedArray = code.map { Constants.encodings[$0] }
        var resultCode = Constants.START_ENCODE
        
        for index in stride(from: 0, to: codedArray.count, by: 2){
            let element1 = codedArray[index] ?? [.Narrow]
            let element2 = codedArray[index + 1] ?? [.Narrow]
            for indexInCode in 0..<element1.count {
                resultCode += [element1[indexInCode]]
                resultCode += [element2[indexInCode]]
            }
        }
        
        resultCode += Constants.STOP_ENCODE
        return resultCode
    }
    
}
