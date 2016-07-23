//
//  HomeNewsModel.swift
//  Alayam
//
//  Created by Jeyaraj on 25/07/15.
//
// ajr

import UIKit

protocol HomeNewsModelDelegate
{
    func refreshSliderImageSet()
    
    func refreshTableViewWithRegularNews(isPageEnd : Bool)
    
    func refreshRegularNewsWithFreshData()
}

class HomeNewsModel: NSObject {

    var delegate : HomeNewsModelDelegate?
    
    var isCategoryNews = false
    
    var tableSliderDataSource = NSMutableArray()
    
    var tableViewRegularNewsDataSource = NSMutableArray()
    
    func getHomeNewsList(category :String)
    {
        let request = HomeSliderNewsRequestDTO()
        request.category = category.trim()//.stringByReplacingOccurrencesOfString("-", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        HomeFeedDataHandler().getHomeFeedSliderNews(true, queryParameter: request, parameter: nil, Completion: { (response) -> Void! in
            
            if response != nil
            {
                self.tableSliderDataSource = response.Data.SliderNews
                
//                LocalCacheDataHandler().saveNewData(response.Data.SliderNews)
                
                self.delegate?.refreshSliderImageSet()
            }
            
            
            
            return Void()
        })
            { (error) -> Void in
            
        }
    }
    
    func getHomeLatestNews(pageNumber : Int, numberOfNews : Int, category :String)
    {
        let request = HomeSliderNewsRequestDTO()
        request.category = category.trim()//.stringByReplacingOccurrencesOfString("-", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        HomeFeedDataHandler().getHomeFeednewsWithPagination(false, pageNumber: pageNumber, numberOfNews: numberOfNews, queryParameter: request, parameter: nil, Completion: { (response) -> Void! in
            if response != nil
            {
                var ispageEnd = true
                if response.Data.OnlineCategoryNews.count > 0
                {
                    self.tableViewRegularNewsDataSource.addObjectsFromArray(response.Data.OnlineCategoryNews as [AnyObject])
                    ispageEnd = false
                }
                
                else if self.isCategoryNews && response.Data.AlayamCategoryNews.count > 0
                {
                    self.tableViewRegularNewsDataSource.addObjectsFromArray(response.Data.AlayamCategoryNews as [AnyObject])
                    ispageEnd = false
                }
                else if response.Data.HomeRegularNews.count > 0
                {
                    self.tableViewRegularNewsDataSource.addObjectsFromArray(response.Data.HomeRegularNews as [AnyObject])
                    
                    ispageEnd = false
                }
                self.delegate?.refreshTableViewWithRegularNews(ispageEnd)
            }
            
            return Void()
        }) { (error) -> Void in
            
            
        }
    }
    
    func getHomeLatestNewsFreshData(isLoaderNeed: Bool, pageNumber : Int, numberOfNews : Int, category :String,newsType :String)
    {
        let request = HomeSliderNewsRequestDTO()
        request.category = category.trim()//.stringByReplacingOccurrencesOfString("-", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        request.type = newsType
        HomeFeedDataHandler().getHomeFeednewsWithPagination(isLoaderNeed, pageNumber : pageNumber, numberOfNews: numberOfNews, queryParameter: request, parameter: nil, Completion: { (response) -> Void! in
            if response != nil
            {
                if response.Data.OnlineCategoryNews.count > 0
                {
                    self.tableViewRegularNewsDataSource.addObjectsFromArray(response.Data.OnlineCategoryNews as [AnyObject])
                }
                    
                else if self.isCategoryNews
                {
                    self.tableViewRegularNewsDataSource = response.Data.AlayamCategoryNews
                    LocalCacheDataHandler().saveNewData(category,arrayOfData: response.Data.AlayamCategoryNews)
                }
                else
                {
                    self.tableViewRegularNewsDataSource = response.Data.HomeRegularNews
                    LocalCacheDataHandler().saveNewData(category,arrayOfData: response.Data.HomeRegularNews)
                }
                
                self.delegate?.refreshRegularNewsWithFreshData()
            }
            
            return Void()
            }) { (error) -> Void in
                
                
        }
    }
   
}
