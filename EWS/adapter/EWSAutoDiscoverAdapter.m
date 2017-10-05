//
//  EWSAutoDiscover.m
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import "EWSAutoDiscoverAdapter.h"
#import "EWSXmlParser.h"

@interface EWSAutoDiscoverAdapter()

@property (nonatomic,strong) NSString* autoDiscoverUrl;

@property (nonatomic,strong) NSString* emailAddress;

@property (nonatomic,strong) EWSXmlParser *parser;

@property (nonatomic,strong) NSString *currentElement;

@property (nonatomic,strong) void(^resultBlock)(id result);

@end

@implementation EWSAutoDiscoverAdapter

-(instancetype)initWith:(NSString*)autoDiscoverUrl emailAddress:(NSString*)emailAddress{
    if (self = [super init]) {
        self.autoDiscoverUrl = autoDiscoverUrl;
        self.emailAddress = emailAddress;
        self.parser = [[EWSXmlParser alloc] init];
    }
    return self;
}

-(NSString*_Nonnull)requestXmlString{
    
    NSString *soapXmlString = [NSString stringWithFormat:
                               @"<Autodiscover xmlns=\"http://schemas.microsoft.com/exchange/autodiscover/outlook/requestschema/2006\">\n"
                               "<Request>\n"
                               "<EMailAddress>%@</EMailAddress>\n"
                               "<AcceptableResponseSchema>http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a</AcceptableResponseSchema>\n"
                               "</Request>\n"
                               "</Autodiscover>\n",_emailAddress];
    
    return soapXmlString;
}

//解析XML到固定的Model
-(void)pareseDataToModel:(NSData* _Nonnull)xmlData resultBlock:(void(^)(id result))resutBlock{
    self.resultBlock = resutBlock;
    
    [_parser parserWithData:xmlData didStartDocument:^{
        
    } didStartElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName, NSDictionary *attributeDict) {
        _currentElement = elementName;
    } foundCharacters:^(NSString *string) {
        [self autodiscoverFoundCharacters:string];
    } didEndElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName) {
        _currentElement = nil;
    } didEndDocument:^{
        
    }];
}

-(void)autodiscoverFoundCharacters:(NSString *)string{
    if ([_currentElement isEqualToString:@"EwsUrl"]) {
       NSString* ewsUrl = [NSString stringWithString:string];
       self.resultBlock(ewsUrl);
       return;
    }
}

-(NSString*_Nullable)requestUrl{
    return self.autoDiscoverUrl;
}
@end
