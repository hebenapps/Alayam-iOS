//
//  PDFData.swift
//  Alayam
//
//  Created by Mala on 10/11/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

class PDFData: NSObject {
   
}

class GetPDFRequestDTO : NSObject
{
    
}

class GetPDFResponseDTO : NSObject
{
    var Data = DataDTO()
    var Status : NSNumber = 0.0
    var ErrorMessage : AnyObject?
    var ErrorCode : AnyObject?
}

class PDFDTO : NSObject
{
    var IssueID : NSNumber = 0.0
    var AllPath = ""
    var SportPath = ""
    var EconamicPath = ""

}