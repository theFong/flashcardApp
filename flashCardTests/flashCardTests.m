//
//  flashCardTests.m
//  flashCardTests
//
//  Created by Alec Fong on 10/15/16.
//  Copyright © 2016 Alec Fong. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlashCardModel.h"


@interface flashCardTests : XCTestCase
@property (strong, nonatomic) FlashCardModel* flashCardModel;
@property (strong, nonatomic) FlashCard* currentFlashCard;
@end

@implementation flashCardTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _flashCardModel = [FlashCardModel sharedModel];
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testRemove {
    [self.flashCardModel removeFlashcard];
    XCTAssert([self.flashCardModel numberOfFlashcards] == 5);
}
- (void)testInsert {
    [self.flashCardModel insertWithQuestion:@"Hell0" answer:@"bye" favorite:false];
    XCTAssert([self.flashCardModel numberOfFlashcards] == 6);
}
- (void)testToggleFavorite {
    [self.flashCardModel toggleFavorite];
    XCTAssert([[self.flashCardModel favoriteFlashcards] count] ==1);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];

}

@end
