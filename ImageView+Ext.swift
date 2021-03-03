//
//  ImageView+Ext.swift
//
//  Created by Tetiana Nieizviestna
//

import UIKit

// MARK: Barcode generating
extension UIImageView {
    
    func generateBarcode(code: String) {
        let frame = self.frame
        let barcodeGenerator = BarcodeGenerator(code: code, frame: frame)
        
        if #available(iOS 10.0, *) {
            self.image = barcodeGenerator.drawBarcodeImage()
        } else {
            print("available(iOS 10.0, *)...")
        }
    }
}
