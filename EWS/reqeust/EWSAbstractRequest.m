//
//  EWSAbstractRequest.m
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import "EWSAbstractRequest.h"
#import "EWSHttpRequest.h"
#import "EWSXmlParser.h"
#import "EWSInboxListModel.h"
#import "EWSService.h"

@interface EWSAbstractRequest()

@property (nonatomic,strong) id<EWSApiAdapter> apiAdapter;

@property (nonatomic,strong) EWSEmailBoxModel* emailModel;

@property (nonatomic,strong) EWSHttpRequest *request;

@property (nonatomic,strong) NSMutableData *resultData;

@property (nonatomic,strong) NSError *error;

@property (nonatomic,strong) void(^resultBlock)(id result,NSError* error);

@end

@implementation EWSAbstractRequest

-(instancetype)initWith:(EWSEmailBoxModel*)emailModel apiAdapter:(id<EWSApiAdapter>)apiAdapter{
    if (self = [super init]) {
        self.emailModel = emailModel;
        self.apiAdapter = apiAdapter;
        self.resultData = [[NSMutableData alloc] init];
        self.request = [[EWSHttpRequest alloc] init];
    }
    return self;
}

-(void)request:(void(^)(id result,NSError* error))resultBlock{
    self.resultBlock = resultBlock;
    
    NSString* url = self.emailModel.ewsUrl;
    
    if ([self.apiAdapter respondsToSelector:@selector(requestUrl)]) {
        url = [self.apiAdapter requestUrl];
    }
    
    NSString* requestXmlString = [_apiAdapter requestXmlString];
    
    [_request ewsHttpRequest:requestXmlString andUrl:url emailBoxInfo:self.emailModel receiveResponse:^(NSURLResponse *response) {
        
    } reveiveData:^(NSData *data) {
        [_resultData appendData:data];
    } finishLoading:^{
        [self requestFinishLoading];
    } error:^(NSError *error) {
        _error = error;
    }];
}

-(void)requestFinishLoading{
    NSString* xmlString = [[NSString alloc] initWithData:_resultData encoding:NSUTF8StringEncoding];
    NSLog(@"返回XML结果:%@",xmlString);
    [self.apiAdapter pareseDataToModel:_resultData resultBlock:^(id result) {
        self.resultBlock(result, _error);
    }];
}

@end
