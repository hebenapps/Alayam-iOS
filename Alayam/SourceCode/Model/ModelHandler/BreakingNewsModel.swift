//
//  BreakingNewsModel.swift
//  Alayam
//
//  Created by Mala on 9/6/15.
//  Copyright (c) 2015 Vaijayanthi Mala. All rights reserved.
//

import UIKit

protocol BreakingNewsModelDelegate
{
    func refreshTableViewWithRegularNews()
    func refreshRegularNewsWithFreshData()
}

class BreakingNewsModel: NSObject {
    
    var delegate : BreakingNewsModelDelegate?
   
   // var isCategoryNews = false
    
    var tableViewHotNewsDataSource = NSMutableArray()
    var sliderNewsDetails: SliderNewsDTO!
    
    func getBreakingNews(pageNumber : Int, numberOfNews : Int, category : String)
    {
        let request = BreakingNewsRequestDTO()
        request.category = category
        BreakingNewsDataHandler().getBreakingnewsWithPagination(false, pageNumber: pageNumber, numberOfNews: numberOfNews, queryParameter: request, parameter: nil, Completion: { (response) -> Void! in
            if response != nil
            {
//                if self.isCategoryNews
//                {
//                    self.tableViewHotNewsDataSource.addObjectsFromArray(response.Data.CategoryNews as [AnyObject])
//                }
//                else
//                {
                    self.tableViewHotNewsDataSource.addObjectsFromArray(response.Data.HotNews as [AnyObject])
               //}
                self.delegate?.refreshTableViewWithRegularNews()
            }
            
            return Void()
            }) { (error) -> Void in
                
                
        }
    }
    
    
    func getBreakingNewsFreshData(isLoaderNeed: Bool, pageNumber : Int, numberOfNews : Int, category :String)
    {
        let request = BreakingNewsRequestDTO()
        request.category = category
        BreakingNewsDataHandler().getBreakingnewsWithPagination(isLoaderNeed, pageNumber : pageNumber, numberOfNews: numberOfNews, queryParameter: request, parameter: nil, Completion: { (response) -> Void! in
            if response != nil
            {
//                if self.isCategoryNews
//                {
//                    self.tableViewHotNewsDataSource = response.Data.CategoryNews
//                }
//                else
//                {
                    self.tableViewHotNewsDataSource = response.Data.HotNews
               // }
                
                self.delegate?.refreshRegularNewsWithFreshData()
            }
            
            return Void()
            }) { (error) -> Void in
                
                
        }
    }
    
    

    
    
}
