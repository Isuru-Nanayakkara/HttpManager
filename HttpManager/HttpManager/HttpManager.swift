import Foundation

open class HttpManager: NSObject {
    
    /**
    HTTP methods.
    
    - POST
    - GET
    */
    fileprivate enum HTTPMethod: String {
        case POST = "POST"
        case GET = "GET"
    }
    
    fileprivate var url: String
    fileprivate var httpMethod: HTTPMethod
    fileprivate var request: NSMutableURLRequest!
    fileprivate var session: Foundation.URLSession!
    
    // MARK: - Initializers
    
    fileprivate init(method: HTTPMethod, url: String) {
        self.url = url
        self.httpMethod = method
        
        super.init()
        
        session = Foundation.URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        request = NSMutableURLRequest()
    }
    
    // MARK: - Public
    
    /**
    Send a POST request.
    
    :param: url
    
    :returns:
    */
    open class func post(_ url: String) -> HttpManager {
        return HttpManager(method: .POST, url: url)
    }
    
    /**
    Send a GET request.
    
    :param: url
    
    :returns:
    */
    open class func get(_ url: String) -> HttpManager {
        return HttpManager(method: .GET, url: url)
    }
    
    /**
    Append parameters to the URL.
    
    :param: parameters
    
    :returns:
    */
    open func parameters(_ parameters: [String: Any]) -> HttpManager {
        url = url + "?" + parameters.stringForHttpParameters()
        return self
    }
    
    /**
    Add custom header values to the request.
    
    :param: headers
    
    :returns:
    */
    open func headers(_ headers: [String: String]) -> HttpManager {
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
    open func data(_ data: [String: Any]) -> HttpManager {
        request.httpBody = data.stringForHttpParameters().data(using: String.Encoding.utf8, allowLossyConversion: false)
        return self
    }
    
    /**
    Execute the HTTP request.
    
    :param: completionHandler
    */
    open func execute(_ completionHandler: @escaping (_ result: Data?, _ error: NSError?) -> ()) {
        session.dataTask(with: makeRequest(), completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completionHandler(nil, error as NSError)
            } else {
                completionHandler(data, nil)
            }
        }).resume()
    }
    
    // MARK: - Private
    
    /**
    Setup the request object.
    Called just before execute().
    
    :returns: request
    */
    fileprivate func makeRequest() -> URLRequest {
        request.url = URL(string: url)
        request.httpMethod = httpMethod.rawValue
        
        return request.copy() as! URLRequest
    }
}

extension HttpManager: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
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
        return parameters.joined(separator: "&")
    }
}

extension String {
    /**
    Percent escape value to be added to a URL query value as specified in RFC 3986. All characters besides alphanumeric character set and "-", ".", "_", and "~" will be percent escaped.
    :see: http://www.ietf.org/rfc/rfc3986.txt
    
    :returns: Percent escaped string
    */
    func percentEscapedString() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._~")
        return addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
}
