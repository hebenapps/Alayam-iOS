import Foundation
import Alamofire

public class Router:URLRequestConvertible {
    //public static let baseUrlString:String = "https://cdn2.liad.tk:443/file/add?type=png&name=test1&sourceType=org_logo"
    
    //case Upload(fieldName: String, fileName: String, mimeType: String, fileContents: NSData, boundaryConstant:String);
    
    //	var method: Alamofire.Method {
    //		switch self {
    //			case Upload:
    //				return .POST
    //			default:
    //				return .GET
    //		}
    //	}
    //
    //	var path: String {
    //		switch self {
    //			case Upload:
    //				return "/testupload.php"
    //			default:
    //				return "/"
    //		}
    //	}
    
    var fileName : String
    var fieldName : String
    var mimeType : String
    var fileContents : NSData
    var boundaryConstant : String
    var urlString : String
    
    init(filename: String, fieldname: String, mimeType: String, fileContent : NSData , boundaryConstant : String, url : String) {
        self.fileName = filename
        self.fieldName = fieldname
        self.mimeType = mimeType
        self.fileContents = fileContent
        self.boundaryConstant = boundaryConstant
        self.urlString = url
    }
    
    
    public var URLRequest: NSURLRequest {
        var URL: NSURL = NSURL(string:self.urlString)!
        var mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "POST"
        //mutableURLRequest.HTTPMethod = method.rawValue
        //
        //			switch self {
        //				case .Upload(let fieldName, let fileName, let mimeType, let fileContents, let boundaryConstant):
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        var error: NSError?
        let boundaryStart = "--\(boundaryConstant)\r\n"
        let boundaryEnd = "--\(boundaryConstant)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        let contentTypeString = "Content-Type: \(mimeType)\r\n\r\n"
        
        // Prepare the HTTPBody for the request.
        let requestBodyData : NSMutableData = NSMutableData()
        requestBodyData.appendData(boundaryStart.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(fileContents)
        requestBodyData.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        requestBodyData.appendData(boundaryEnd.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        mutableURLRequest.HTTPBody = requestBodyData
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        
        //				default:
        //					return mutableURLRequest
        //			}
    }
}