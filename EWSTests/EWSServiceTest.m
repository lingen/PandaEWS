//
//  EWSServiceTest.m
//  EWSTests
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWSService.h"
#import "EWSEmailBoxModel.h"
@interface EWSServiceTest : XCTestCase

@end

@implementation EWSServiceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testQueryEwsUrlByAutoDiscovery{
    __block BOOL done = NO;

    EWSEmailBoxModel* emailModel = [[EWSEmailBoxModel alloc] initWith:@"zhangsan@rainy.com.cn" andPassword:@"foreverht123ABC"];
    
    [EWSService sharedInstance].ewsEmailBoxModel = emailModel;
    
    [[EWSService sharedInstance] queryEwsUrlByAutoDiscovery:^(NSString *ewsUrl, NSError *error) {
        if (ewsUrl) {
            NSLog(@"拿到了EWS:%@",ewsUrl);
            done = YES;
        }
    }];
    
    XCTAssertTrue([self waitFor:&done timeout:10],
                  @"Timed out waiting for response asynch method completion");
}

-(void)testFetchInboxItems{
    __block BOOL done = NO;

    
    EWSEmailBoxModel* emailModel = [[EWSEmailBoxModel alloc] initWith:@"zhangsan@rainy.com.cn" andPassword:@"foreverht123ABC"];
    emailModel.ewsUrl = @"https://win-1p4clebkmf9.rainy.com.cn/EWS/Exchange.asmx";
    
    [EWSService sharedInstance].ewsEmailBoxModel = emailModel;

    [[EWSService sharedInstance] fetchInboxItems:^(NSArray *items, NSError *error) {
        NSLog(@"Items:%@",items);
        done = YES;
    }];

    XCTAssertTrue([self waitFor:&done timeout:15],
                  @"Timed out waiting for response asynch method completion");
}

-(void)testFetchItemContent{
    __block BOOL done = NO;
    
    EWSEmailBoxModel* emailModel = [[EWSEmailBoxModel alloc] initWith:@"zhangsan@rainy.com.cn" andPassword:@"foreverht123ABC"];
    emailModel.ewsUrl = @"https://win-1p4clebkmf9.rainy.com.cn/EWS/Exchange.asmx";
    
    [EWSService sharedInstance].ewsEmailBoxModel = emailModel;
    
    [[EWSService sharedInstance] fetchInboxItems:^(NSArray *items, NSError *error) {
        if (items.count > 0) {
            EWSInboxListModel* listModel = items.firstObject;
            [[EWSService sharedInstance] fetchItemContent:listModel resultBlock:^(EWSItemContentModel *contentModel, NSError *error) {
                NSLog(@"邮件内容:%@",contentModel);
                done = YES;
            }];
        }
    }];
    
    XCTAssertTrue([self waitFor:&done timeout:15],
                  @"Timed out waiting for response asynch method completion");
}

- (BOOL)waitFor:(BOOL *)flag timeout:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    }
    while (!*flag);
    return *flag;
}

@end
