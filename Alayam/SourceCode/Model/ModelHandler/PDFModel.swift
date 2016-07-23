//
//  PDFModel.swift
//  Alayam
//
//  Created by Mala on 10/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol PDFModelDelegate
{
    func refreshPDF()
}

class PDFModel: NSObject {
    var delegate : PDFModelDelegate?
    
    var PDFList = NSMutableArray()
    
    func getPDFList()
    {
        PDFDataHandler().getPDFList(true, queryParameter: GetPDFRequestDTO(), parameter: nil, Completion: {
            (response) -> Void! in
            
            if response != nil
            {
                self.PDFList = response.Data.PDF
                self.delegate?.refreshPDF()
            }
            return Void()
            }) { (error) -> Void in
                
                
        }

    }
}
