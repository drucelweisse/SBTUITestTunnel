// MatchRequestTests.swift
//
// Copyright (C) 2016 Subito.it S.r.l (www.subito.it)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SBTUITestTunnel
import Foundation

class MatchRequestTests: XCTestCase {

    private let request = NetworkRequests()
    
    func testSimpleUrlAllMethods() {
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org"), response: SBTStubResponse(response: ["stubbed": 1]))
        
        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssert(request.isStubbed(result))
        
        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
        XCTAssert(request.isStubbed(result))
    }
    
    func testSimpleUrlGetOnly() {
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
        
        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssert(request.isStubbed(result))
        
        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
        XCTAssertFalse(request.isStubbed(result))
    }

    func testUrlWithQueryGetOnly() {
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "&param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssert(request.isStubbed(result))
        app.stubRequestsRemoveAll()

        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param2=val2", "&param1=val1"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
        let result2 = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssert(request.isStubbed(result2))
        app.stubRequestsRemoveAll()
        
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1&param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
        let result3 = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssert(request.isStubbed(result3))
        app.stubRequestsRemoveAll()
        
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param2=val2&param1=val1"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
        let result4 = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssertFalse(request.isStubbed(result4))
        app.stubRequestsRemoveAll()
        
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "&param3=val3"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
        let result5 = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssertFalse(request.isStubbed(result5))
        app.stubRequestsRemoveAll()
        
        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "&param2=val2"], method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
        let result6 = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
        XCTAssertFalse(request.isStubbed(result6))
        app.stubRequestsRemoveAll()
    }
    
//    func testMethodHonored() {
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org/post", method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org/post", method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//    }
//
//    func testUrlWithQueryPostOnly() {
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param5=val5", "&param6=val6"], method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param6=val6", "&param5=val5"], method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param5=val5&param6=val6"], method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param6=val6&param5=val5"], method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param5=val5", "&param1=val1"], method:"POST"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param5=val5", "&param6=val6"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        app.cells["executePostDataTaskRequestWithHTTPBody"].tap()
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//    }
//
//    func testInvertQueryGetOnly() {
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["!param1=val1", "&param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "!param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["!param1=val1", "!param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssertFalse(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["!param9=val9", "&param1=val1"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "!param9=val9"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "&param2=val2", "!param9=val9"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["&param1=val1", "!param9=val9", "&param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//
//        app.stubRequests(matching: SBTRequestMatch(url: "httpbin.org", query: ["!param9=val9", "&param1=val1", "&param2=val2"], method:"GET"), response: SBTStubResponse(response: ["stubbed": 1]))
//        let result = request.dataTaskNetwork(urlString: "http://httpbin.org/get?param1=val1&param2=val2")
//        XCTAssert(request.isStubbed(result))
//        app.stubRequestsRemoveAll()
//    }
}

extension MatchRequestTests {
    override func setUp() {
        app.launchConnectionless { (path, params) -> String in
            return SBTUITestTunnelServer.performCommand(path, params: params)
        }
    }
    
    override func tearDown() {
        app.monitorRequestRemoveAll()
        app.stubRequestsRemoveAll()
        app.blockCookiesRequestsRemoveAll()
        app.throttleRequestRemoveAll()
    }
}
