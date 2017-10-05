//
//  EWSGetAttachmentAdapter.m
//  EWS
//
//  Created by 刘林 on 2017/10/5.
//  Copyright © 2017年 刘林. All rights reserved.
//

#import "EWSGetAttachmentAdapter.h"
#import "EWSXmlParser.h"

@interface EWSGetAttachmentAdapter()

@property (nonatomic,strong) EWSXmlParser *parser;

@property (nonatomic,strong) NSString *currentElement;

@property (nonatomic,strong) void(^resultBlock)(id result);

@property (nonatomic,strong) NSString* attachmentId;

@property (nonatomic,strong) NSData* data;

@end

@implementation EWSGetAttachmentAdapter

-(instancetype)initWith:(NSString *)attachmentId{
    if (self = [super init]) {
        self.attachmentId = attachmentId;
        self.parser = [[EWSXmlParser alloc] init];
    }
    return self;
}

-(NSString*_Nonnull)requestXmlString{
    
    NSString *soapXmlString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
                               "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
                               "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
                               "xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">\n"
                               "<soap:Body>\n"
                               "<GetAttachment xmlns=\"http://schemas.microsoft.com/exchange/services/2006/messages\"\n"
                               "xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\">\n"
                               "<AttachmentShape>\n"
                               "<t:IncludeMimeContent>true</t:IncludeMimeContent>\n"
                               "</AttachmentShape>\n"
                               "<AttachmentIds>\n"
                               "<t:AttachmentId Id=\"%@\"/>\n"
                               "</AttachmentIds>\n"
                               "</GetAttachment>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>\n",_attachmentId];
    
    return soapXmlString;
}

-(void)pareseDataToModel:(NSData* _Nonnull)xmlData resultBlock:(void(^_Nullable)(id _Nullable result))resutBlock{
    self.resultBlock = resutBlock;
    
    [_parser parserWithData:xmlData didStartDocument:^{
        
    } didStartElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName, NSDictionary *attributeDict) {
        _currentElement = elementName;
    } foundCharacters:^(NSString *string) {
        [self attachmentFoundCharacters:string];
    } didEndElementBlock:^(NSString *elementName, NSString *namespaceURI, NSString *qName) {
        _currentElement = nil;
    } didEndDocument:^{
        [self mailAttachmentDidEndDocument];
    }];
}

-(void)attachmentFoundCharacters:(NSString *)string{
    if ([_currentElement isEqualToString:@"t:Content"]) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
        //把内容存储到某个地方
        self.data = data;
    }
    
}

-(void)mailAttachmentDidEndDocument{
    if (self.resultBlock) {
        self.resultBlock(self.data);
    }
}

@end
