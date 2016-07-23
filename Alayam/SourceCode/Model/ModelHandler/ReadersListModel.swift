//
//  ReadersListModel.swift
//  Alayam
//
//  Created by Jeyaraj on 11/09/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol ReadersListModelDelegate
{
    func refreshTableView()
}

class ReadersListModel: NSObject {
    
    var delegate : ReadersListModelDelegate?
    
    var readersList : NSMutableArray?
    
    func refreshReadersList()
    {
        readersList = LocalCacheDataHandler().fetchReadersList("")
        delegate?.refreshTableView()
    }
    
    func addToReaderList(newsDetails : SliderNewsDTO)
    {
        LocalCacheDataHandler().addNewReaderList(newsDetails)
    }
   
}
