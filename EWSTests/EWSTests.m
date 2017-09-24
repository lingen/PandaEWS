//
//  EWSTests.m
//  EWSTests
//
//  Created by 刘林 on 2017/9/24.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EWSAutodiscover.h"
#import "EWSEmailBoxModel.h"
#import "EWSService.h"
#import "EWSInboxList.h"
#import "EWSItemContent.h"
@interface EWSTests : XCTestCase

@end

@implementation EWSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
 * 通过AutoDiscovery来发现EWS的API，因为用户只知道自己的用户名密码，通常不会知道服务器的相关API
 */
-(void)testAutoDiscovery{
    __block BOOL done = NO;
    EWSEmailBoxModel* emailModel = [[EWSEmailBoxModel alloc] initWith:@"zhangsan@rainy.com.cn" andPassword:@"foreverht123ABC"];
    [EWSService sharedInstance].ewsEmailBoxModel = emailModel;
    [[EWSAutodiscover sharedInstance] autoDiscover:@"zhangsan@rainy.com.cn" resultBlock:^(NSString *ewsApiUrl, NSError *error) {
        if (ewsApiUrl) {
            NSLog(@"找到了服务器地址:%@",ewsApiUrl);
        }
        done = YES;
    }];
    
    XCTAssertTrue([self waitFor:&done timeout:10],
                  @"Timed out waiting for response asynch method completion");
}

-(void)testGetInbox{
    __block BOOL done = NO;
    EWSEmailBoxModel* emailModel = [[EWSEmailBoxModel alloc] initWith:@"zhangsan@rainy.com.cn" andPassword:@"foreverht123ABC"];
    [EWSService sharedInstance].ewsEmailBoxModel = emailModel;
    
    [[EWSInboxList sharedInstance] getInboxListWithEWSUrl:@"https://win-1p4clebkmf9.rainy.com.cn/EWS/Exchange.asmx" resultBlock:^(NSMutableArray *inboxList, NSError *error) {
        if (inboxList.count > 0) {
            NSLog(@"拉到了INBOX邮箱数据");
        }
        done = YES;

    }];
    
    XCTAssertTrue([self waitFor:&done timeout:10],
                  @"Timed out waiting for response asynch method completion");
}

-(void)testGetEmailDetail{
    __block BOOL done = NO;
    EWSEmailBoxModel* emailModel = [[EWSEmailBoxModel alloc] initWith:@"zhangsan@rainy.com.cn" andPassword:@"foreverht123ABC"];
    [EWSService sharedInstance].ewsEmailBoxModel = emailModel;
    
    EWSInboxListModel* listModel = [[EWSInboxListModel alloc] init];
    listModel.changeKey = @"QYl163Zgm65QAAAAAAjx";
    listModel.itemId = @"AQAVAHpoYW5nc2FuQHJhaW55LmNvbS5jbgBGAAAD6Qjm3cqfTE++TVzsSXmJ/gcAp0QChx68/0GJdet2YJuuUAAAAgENAAAAp0QChx68/0GJdet2YJuuUAAAAgj/AAAA";
    
    [[EWSInboxList sharedInstance] getInboxListWithEWSUrl:@"https://win-1p4clebkmf9.rainy.com.cn/EWS/Exchange.asmx" resultBlock:^(NSMutableArray *inboxList, NSError *error) {
        if (inboxList.count > 0) {
            EWSInboxListModel* listModel = inboxList.firstObject;
            
            [[EWSItemContent sharedInstance] getItemContentWithEWSUrl:@"https://win-1p4clebkmf9.rainy.com.cn/EWS/Exchange.asmx" item:listModel finishBlock:^(EWSItemContentModel *itemContentInfo, NSError *error) {
                if (itemContentInfo) {
                    NSLog(@"aaa");
                }
                done = YES;
                
            }];
        }
        
    }];
    

    
    XCTAssertTrue([self waitFor:&done timeout:10],
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
