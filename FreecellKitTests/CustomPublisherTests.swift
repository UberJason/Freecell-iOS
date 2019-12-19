//
//  CustomPublisherTests.swift
//  CustomPublisherTests
//
//  Created by Jason Ji on 12/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
import Combine
@testable import FreecellKit

class CustomPublisherTests: XCTestCase {

    lazy var dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm:ss.ssss"
        return f
    }()
    
    var cancellable: AnyCancellable?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCustomPublisher() {
        let expectation = XCTestExpectation(description: "async")
        var events = [Event]()

        let upstream = PassthroughSubject<Int, Never>()
        cancellable = upstream
            .buffer(size: 1000, prefetch: .byRequest, whenFull: .dropOldest)
            .modulated(.seconds(1), scheduler: DispatchQueue.main)
            .sink { value in
                events.append(Event(value: value, date: Date()))
                print("value received: \(value) at \(self.dateFormatter.string(from: Date()))")
            }

        // WHEN I send 3 events, wait 6 seconds, and send 3 more events
        upstream.send(1)
        upstream.send(2)
        upstream.send(3)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(6800)) {
            upstream.send(4)
            upstream.send(5)
            upstream.send(6)

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(4000)) {

                // THEN I expect the stored events to be no closer together in time than the interval of 1.0s
                for i in 1 ..< events.count {
                    let interval = events[i].date.timeIntervalSince(events[i-1].date)
                    print("Interval: \(interval)")

                    // There's some small error in the interval but it should be about 1 second since I'm using a 1s modulated publisher.
                    XCTAssertTrue(interval > 0.90)
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 15)
    }
}

struct Event {
    let value: Int
    let date: Date
}
