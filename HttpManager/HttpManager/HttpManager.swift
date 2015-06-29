import Foundation

public class HttpManager: NSObject {
    
    /**
    HTTP methods.
    
    - POST
    - GET
    */
    private enum HTTPMethod: String {
        case POST = "POST"
        case GET = "GET"
    }
    
    private var url: String
    private var httpMethod: HTTPMethod
    private var request: NSMutableURLRequest!
    private var session: NSURLSession!
    
    // MARK: - Initializers
    
    private init(method: HTTPMethod, url: String) {
        self.url = url
        self.httpMethod = method
        
        super.init()
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        request = NSMutableURLRequest()
    }
    
    // MARK: - Public
    
    /**
    Send a POST request.
    
    :param: url
    
    :returns:
    */
    public class func post(url: String) -> HttpManager {
        return HttpManager(method: .POST, url: url)
    }
    
    /**
    Send a GET request.
    
    :param: url
    
    :returns:
    */
    public class func get(url: String) -> HttpManager {
        return HttpManager(method: .GET, url: url)
    }
    
    /**
    Append parameters to the URL.
    
    :param: parameters
    
    :returns:
    */
    public func parameters(parameters: [String: AnyObject]) -> HttpManager {
        url = url + "?" + parameters.stringForHttpParameters()
        return self
    }
    
    /**
    Add custom header values to the request.
    
    :param: headers
    
    :returns:
    */
    public func headers(headers: [String: String]) -> HttpManager {
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return self
    }
    
    /**
    Add form data.
    
    :param: data
    
    :returns:
    */
    public func data(data: [String: AnyObject]) -> HttpManager {
        request.HTTPBody = data.stringForHttpParameters().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return self
    }
    
    /**
    Execute the HTTP request.
    
    :param: completionHandler
    */
    public func execute(completionHandler: (result: AnyObject!, error: NSError?) -> ()) {
        session.dataTaskWithRequest(makeRequest(), completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil)
                completionHandler(result: json, error: nil)
            }
        }).resume()
    }
    
    // MARK: - Private
    
    /**
    Setup the request object.
    Called just before execute().
    
    :returns: request
    */
    private func makeRequest() -> NSURLRequest {
        request.URL = NSURL(string: url)
        request.HTTPMethod = httpMethod.rawValue
        
        return request.copy() as! NSURLRequest
    }
}

extension HttpManager: NSURLSessionDelegate {
    public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        
        completionHandler(.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
    }
}

extension Dictionary {
    /**
    Build string representation of HTTP parameter dictionary of keys and objects
    
    :returns: String representation in the form of key1=value1&key2=value2
    */
    func stringForHttpParameters() -> String {
        var parameters = [String]()
        
        for (key, value) in self {
            let escapedKey = (key as! String).percentEscapedString()!
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.percentEscapedString()!
            
            parameters.append("\(escapedKey)=\(escapedValue)")
        }
        return join("&", parameters)
    }
}

extension String {
    /**
    Percent escape value to be added to a URL query value as specified in RFC 3986. All characters besides alphanumeric character set and "-", ".", "_", and "~" will be percent escaped.
    :see: http://www.ietf.org/rfc/rfc3986.txt
    
    :returns: Percent escaped string
    */
    func percentEscapedString() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        return stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}