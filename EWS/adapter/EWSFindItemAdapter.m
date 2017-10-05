//
//  EWSFindItemAdapter.m
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import "EWSFindItemAdapter.h"
#import "EWSXmlParser.h"
#import "EWSInboxListModel.h"

@interface EWSFindItemAdapter()

@property (nonatomic,strong) NSString* floder;

@property (nonatomic,strong) void(^resultBlock)(id result);

@property (nonatomic,strong) EWSXmlParser *parser;

@property (nonatomic,strong) NSString *currentElement;

@property (nonatomic,strong) NSMutableArray* listArray;

@end

@implementation EWSFindItemAdapter

-(instancetype)initWith:(NSString*)folder{
    if (self = [super init]) {
        self.floder = folder;
        self.parser = [[EWSXmlParser alloc] init];
        self.listArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString*_Nonnull)requestXmlString{
    
    NSString *soapXmlString = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
                               "xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">\n"
                               "<soap:Body>\n"
                               "<FindItem xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\"\n"
                               "xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\"\n"
                               "Traversal=\"Shallow\">\n"
                               "<ItemShape>\n"
                               "<t:BaseShape>IdOnly</t:BaseShape>\n"
                               "</ItemShape>\n"
                               "<ParentFolderIds>\n"
                               "<t:DistinguishedFolderId Id=\"%@\"/>\n"
                               "</ParentFolderIds>\n"
                               "</FindItem>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>\n",self.floder];
    
    return soapXmlString;
}

-(void)pareseDataToModel:(NSData* _Nonnull)xmlData resultBlock:(void(^_Nullable)(id _Nullable result))resutBlock{
    self.resultBlock = resutBlock;
    
    __block NSString *currentItemType;

    [_parser parserWithData:xmlData didStartDocument:^{
        
    } didStartElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName, NSDictionary *attributeDict) {
        _currentElement = elementName;
        [self inboxListDidStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict currentType:currentItemType];
        currentItemType = elementName;
    } foundCharacters:^(NSString *string) {
        
    } didEndElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName) {
        _currentElement = nil;
    } didEndDocument:^{
        
        if (self.resultBlock) {
            self.resultBlock(_listArray);
        }
    
    }];
}

-(void)inboxListDidStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict currentType:(NSString *)currentType{
    if ([elementName isEqualToString:@"t:ItemId"]) {
        EWSInboxListModel *temp = [[EWSInboxListModel alloc] init];
        temp.changeKey = attributeDict[@"ChangeKey"];
        temp.itemId = attributeDict[@"Id"];
        if ([currentType isEqualToString:@"t:Message"]) {
            temp.itemType = @"Message";
        }
        else if ([currentType isEqualToString:@"t:MeetingRequest"]){
            temp.itemType = @"MeetingRequest";
        }
        [_listArray addObject:temp];
    }
}


@end
