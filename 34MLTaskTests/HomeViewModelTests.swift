//
//  HomeViewModelTests.swift
//  MLTaskTests
//
//  Created by Moustafa Mohamed Gadallah on 12/12/1446 AH.
//

import XCTest
@testable import MLTask

final class HomeViewModelTests: XCTestCase {

    var vm: HomeViewModel!

    override func setUpWithError() throws {
        vm = HomeViewModel()
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func testLikeExperienceIncreasesCount() throws {
        XCTAssertEqual(vm.likesCount, 0)
        
        vm.likeExperience()
        XCTAssertEqual(vm.likesCount, 1)
        
        vm.likeExperience()
        XCTAssertEqual(vm.likesCount, 2)
    }
}
