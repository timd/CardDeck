//
//  BaseCollectionViewTests.m
//  BaseCollectionViewTests
//
//  Created by Tim on 16/07/14.
//  Copyright (c) 2014 Charismatic Megafauna Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) NSMutableArray *sectionsArray;
-(void)moveCellAtIndexPath:(NSIndexPath *)indexPath toQuadrant:(NSInteger)quadrant;
@end

@interface CardDeckTests : XCTestCase
@property (nonatomic, strong) MainViewController *mainViewController;
@end

@implementation CardDeckTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    XCTAssertTrue(self.mainViewController, @"can't initialise MainViewController");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.mainViewController = nil;
    XCTAssertFalse(self.mainViewController, @"can't destroy MainViewController");
}

- (void)testMoveOfItem {

    // Create sections array
    self.mainViewController.sectionsArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    // Create 1st inner array
    NSMutableArray *innerArrayOne = [[NSMutableArray alloc] init];
    [innerArrayOne addObject:@"innerArrayOne-ObjectOne"];
    [innerArrayOne addObject:@"innerArrayOne-ObjectTwo"];
    [self.mainViewController.sectionsArray addObject:innerArrayOne];

    // Create 2nd inner array
    NSMutableArray *innerArrayTwo = [[NSMutableArray alloc] init];
    [innerArrayTwo addObject:@"innerArrayTwo-ObjectOne"];
    [innerArrayTwo addObject:@"innerArrayTwo-ObjectTwo"];
    [self.mainViewController.sectionsArray addObject:innerArrayTwo];
    
    XCTAssertTrue(self.mainViewController.sectionsArray.count == 2, @"should be two inner arrays");
    
    NSMutableArray *innerOne = [self.mainViewController.sectionsArray objectAtIndex:0];
    XCTAssertTrue(innerOne.count == 2, @"should be two items in innerArrayOne");

    NSMutableArray *innerTwo = [self.mainViewController.sectionsArray objectAtIndex:1];
    XCTAssertTrue(innerTwo.count == 2, @"should be two items in innerArrayOne");

    // Create index path for section 0 item 0 (innerArrayOne-ObjectOne)
    NSIndexPath *donorIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    // Move it to 2nd inner array, quadrant 1
    [self.mainViewController moveCellAtIndexPath:donorIndexPath toQuadrant:1];

    // Test that moves have taken place
    
    // Should still have the same basic structure
    XCTAssertTrue(self.mainViewController.sectionsArray.count == 2, @"should still be two inner arrays");
    
    // Should have moved one item out of the first inner array
    NSMutableArray *newInnerOne = [self.mainViewController.sectionsArray objectAtIndex:0];
    XCTAssertTrue(newInnerOne.count == 1, @"should now be one item in innerOne");
    
    // Should have moved one item INTO the second inner array
    NSMutableArray *newInnerTwo = [self.mainViewController.sectionsArray objectAtIndex:1];
    XCTAssertTrue(newInnerTwo.count == 3, @"should now be three items in innerOne");
    

}


@end
