//
//  MGJSON.h
//  MGJSONTest
//
//  Created by Marc Giroux on 2015-05-14.
//  Copyright (c) 2015 Marc Giroux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGJSON : NSObject

- (instancetype)initWithJSONData:(NSData *)data;
- (instancetype)initWithJSONString:(NSString *)string;

@end
