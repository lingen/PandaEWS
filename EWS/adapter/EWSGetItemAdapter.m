//
//  EWSGetItemAdapter.m
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import "EWSGetItemAdapter.h"
#import "EWSInboxListModel.h"
#import "EWSXmlParser.h"
#import "EWSMailAccountModel.h"
#import "EWSItemContentModel.h"
#import "EWSMailAttachmentModel.h"
@interface EWSGetItemAdapter()

@property (nonatomic,strong) EWSInboxListModel* model;

@property (nonatomic,strong) EWSXmlParser *parser;

@property (nonatomic,strong) NSString *currentElement;

@property (nonatomic,strong) void(^resultBlock)(id result);

@property (nonatomic,strong) EWSMailAccountModel *mailAccountModel;

@property (nonatomic,strong) EWSItemContentModel *itemContentModel;

@property (nonatomic,strong) EWSMailAttachmentModel *mailAttachmentModel;

@property (nonatomic,strong) NSMutableString* contentString;;

@property (nonatomic,strong) NSMutableString* itemSubject;;


@end

@implementation EWSGetItemAdapter

-(instancetype)initWith:(EWSInboxListModel*)model{
    if (self = [super init]) {
        self.model = model;
        self.parser = [[EWSXmlParser alloc] init];
        self.contentString = [[NSMutableString alloc] init];
        self.itemSubject = [[NSMutableString alloc] init];
        self.itemContentModel = [[EWSItemContentModel alloc] init];
    }
    return self;
}

-(NSString*_Nonnull)requestXmlString{
    
    NSString *soapXmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope\n"
                               "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
                               "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
                               "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
                               "xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">\n"
                               "<soap:Body>\n"
                               "<GetItem\n"
                               "xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\"\n"
                               "xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">\n"
                               "<ItemShape>\n"
                               "<t:BaseShape>AllProperties</t:BaseShape>\n"
                               "<t:IncludeMimeContent>false</t:IncludeMimeContent>\n"
                               "</ItemShape>\n"
                               "<ItemIds>\n"
                               "<t:ItemId Id=\"%@\" ChangeKey=\"%@\" />\n"
                               "</ItemIds>\n"
                               "</GetItem>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>\n",self.model.itemId,self.model.changeKey];
    
    return soapXmlString;
}

-(void)pareseDataToModel:(NSData* _Nonnull)xmlData resultBlock:(void(^_Nullable)(id _Nullable result))resutBlock{
    self.resultBlock = resutBlock;
    
    [_parser parserWithData:xmlData didStartDocument:^{
        
    } didStartElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName, NSDictionary *attributeDict) {
        _currentElement = elementName;
        [self itemContentDidStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    } foundCharacters:^(NSString *string) {
        [self itemContentFoundCharacters:string];
    } didEndElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName) {
        _currentElement = nil;
    } didEndDocument:^{
        [self itemContentDidEndDocument];
    }];
}

-(void)itemContentDidStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    if ([elementName isEqualToString:@"t:Mailbox"]) {
        _mailAccountModel = [[EWSMailAccountModel alloc] init];
    }
    else if ([elementName isEqualToString:@"t:ToRecipients"]) {
        _itemContentModel.toRecipientsList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:@"t:CcRecipients"]) {
        _itemContentModel.ccRecipientsList = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"t:From"]) {
        _itemContentModel.fromList = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"t:Attachments"]) {
        _itemContentModel.attachmentList = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"t:FileAttachment"]) {
        _mailAttachmentModel = [[EWSMailAttachmentModel alloc] init];
    }
    else if ([elementName isEqualToString:@"t:AttachmentId"]) {
        _mailAttachmentModel.attachmentId = attributeDict[@"Id"];
    }
    else if ([elementName isEqualToString:@"t:Subject"]) {
        _itemSubject = [[NSMutableString alloc] init];
    }
    
}

-(void)itemContentFoundCharacters:(NSString *)string{
    
    if ([_currentElement isEqualToString:@"t:Subject"]) {
        [_itemSubject appendString:string];
    }
    else if ([_currentElement isEqualToString:@"t:Body"]){
        [_contentString appendString:string];
    }
    else if ([_currentElement isEqualToString:@"t:Size"]) {
        _itemContentModel.size = string;
    }
    else if ([_currentElement isEqualToString:@"t:DateTimeSent"]) {
        _itemContentModel.dateTimeSentStr = string;
    }
    else if ([_currentElement isEqualToString:@"t:DateTimeCreated"]) {
        _itemContentModel.dateTimeCreatedStr = string;
    }
    else if ([_currentElement isEqualToString:@"t:HasAttachments"]) {
        if ([string isEqualToString:@"true"]) {
            _itemContentModel.hasAttachments = YES;
        }
        else{
            _itemContentModel.hasAttachments = NO;
        }
    }
    else if ([_currentElement isEqualToString:@"t:Name"]) {
        if (_mailAccountModel) {
            _mailAccountModel.name = string;
        }
        else if (_mailAttachmentModel) {
            _mailAttachmentModel.name = string;
            
            if (![_mailAttachmentModel.attachmentId isEqualToString:((EWSMailAttachmentModel *)[_itemContentModel.attachmentList lastObject]).attachmentId]) {
                [_itemContentModel.attachmentList addObject:_mailAttachmentModel];
            }
        }
    }
    else if ([_currentElement isEqualToString:@"t:EmailAddress"]) {
        _mailAccountModel.emailAddress = string;
    }
    else if ([_currentElement isEqualToString:@"t:RoutingType"]) {
        _mailAccountModel.routingType = string;
        if (_itemContentModel.fromList) {
            [_itemContentModel.fromList addObject:_mailAccountModel];
        }
        else if (_itemContentModel.ccRecipientsList){
            [_itemContentModel.ccRecipientsList addObject:_mailAccountModel];
        }
        else if (_itemContentModel.toRecipientsList){
            [_itemContentModel.toRecipientsList addObject:_mailAccountModel];
        }
    }
    else if ([_currentElement isEqualToString:@"t:IsReadReceiptRequested"]) {
        if ([string isEqualToString:@"true"]) {
            _itemContentModel.isReadReceiptRequested = YES;
        }
        else{
            _itemContentModel.isReadReceiptRequested = NO;
        }
    }
    else if ([_currentElement isEqualToString:@"t:IsDeliveryReceiptRequested"]) {
        if ([string isEqualToString:@"true"]) {
            _itemContentModel.isDeliveryReceiptRequested = YES;
        }
        else{
            _itemContentModel.isDeliveryReceiptRequested = NO;
        }
    }
    else if ([_currentElement isEqualToString:@"t:IsRead"]){
        if ([string isEqualToString:@"true"]) {
            _itemContentModel.isRead = YES;
        }
        else{
            _itemContentModel.isRead = NO;
        }
    }
    else if ([_currentElement isEqualToString:@"t:ContentType"]){
        _mailAttachmentModel.contentType = string;
    }
    else if ([_currentElement isEqualToString:@"t:ContentId"]) {
        _mailAttachmentModel.contentId = string;
    }
}

-(void)itemContentDidEndDocument{
    _itemContentModel.itemContentHtmlString = [_contentString copy];
    _itemContentModel.itemSubject = [_itemSubject copy];
    _contentString = nil;
    _itemSubject = nil;
    
    if (self.resultBlock) {
        self.resultBlock(_itemContentModel);
    }
}

@end
