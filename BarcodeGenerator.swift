//
//  BarcodeGenerator.swift
//
//  Created by Tetiana Nieizviestna
//

import Foundation

class BarcodeGenerator {
    
    private let barColor: CGColor = UIColor.black.cgColor
    private var frame: CGRect
    
    private var encoder: Barcode2of5Encoder?
    private var sequence: [BarWidth] = []
    
    init(code: String, frame: CGRect) {
        self.encoder = try? Barcode2of5Encoder(code: code)
        self.sequence = encoder?.sequence() ?? []
        self.frame = frame
    }

    @available(iOS 10.0, *)
    func drawBarcodeImage() -> UIImage {
        
        var x = CGFloat(0)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.frame.width, height: self.frame.height))
        
        let barCodeImage = renderer.image { ctx in
            ctx.cgContext.setFillColor(barColor)
            
            sequence.enumerated().forEach{
                let currentBarWidth = getCurrentWidth(element: $0.element)
                drawCurrentRect(ctx: ctx, index: $0.offset, x: x, width: currentBarWidth)
                x += currentBarWidth
            }
            
            ctx.cgContext.drawPath(using: .fill)
        }
        
        return barCodeImage
    }
    
    private func drawCurrentRect(ctx: UIGraphicsImageRendererContext, index: Int, x: CGFloat, width: CGFloat) {
        if index % 2 == 0 { // if index is even the color is black, add rectangle
            let rect = CGRect(x: x, y: 0, width: width, height: self.frame.height)
            ctx.cgContext.addRect(rect)
        }
    }
    
    private func getNarrowWidth() -> CGFloat {
        var narrow = 0
        var wide = 0
        
        self.sequence.forEach{
            if $0 == .Narrow {
                narrow += 1
            } else {
                wide += 1
            }
        }
        
        let multiplier = CGFloat(2)
        return CGFloat(self.frame.width / (CGFloat(narrow) + multiplier * CGFloat(wide)))
    }
    
    private func getWideWidth(narrowWidth: CGFloat) -> CGFloat {
        let multiplier = CGFloat(2)
        return narrowWidth * multiplier
    }
    
    private func getCurrentWidth(element: BarWidth) -> CGFloat {
        if element == .Narrow {
            return getNarrowWidth()
        }
        return getWideWidth(narrowWidth: getNarrowWidth())
    }
}
