//
//  MGJSON.m
//  MGJSONTest
//
//  Created by Marc Giroux on 2015-05-14.
//  Copyright (c) 2015 Marc Giroux. All rights reserved.
//

#import "MGJSON.h"
#import <objc/runtime.h>

@implementation MGJSON

- (instancetype)initWithJSONData:(NSData *)data
{
    self = [super init];
    NSError *error;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error == nil) {
        for (NSString *key in dict) {
            SEL selector = NSSelectorFromString(key);
            if ([self respondsToSelector:selector]) {
                objc_property_t property = class_getProperty([self class], [key cStringUsingEncoding:NSUTF8StringEncoding]);
                char *proptype           = property_copyAttributeValue(property, "T");
                NSString *tmpString      = [NSString stringWithUTF8String:proptype];
                NSString *cleaned        = [[[[tmpString componentsSeparatedByString:@"@"] componentsJoinedByString:@""] componentsSeparatedByString:@"\""] componentsJoinedByString:@""];
                
                NSArray *basics = @[@"B", @"f", @"d", @"i", @"q", @"NSString", @"NSArray", @"NSDictionary", @"NSNumber"];
                
                if (![basics containsObject:cleaned]) {
                    NSData *n_data = [NSJSONSerialization dataWithJSONObject:[dict objectForKey:key] options:0 error:nil];
                    id instance = [[NSClassFromString(cleaned) alloc] initWithJSONData:n_data];
                    
                    [self setValue:instance forKey:key];
                } else {
                    /* Basic type */
                    [self setValue:[dict objectForKey:key] forKey:key];
                }
            }
        }
    } else {
        NSLog(@"%@", error);
    }
    
    return self;
}

- (instancetype)initWithJSONString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithJSONData:data];
}

- (NSString *)description
{
    NSMutableString *out = @"".mutableCopy;
    
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            
            [out appendString:[NSString stringWithFormat:@"\n%@ : %@", name, [self valueForKey:name]]];            
        }
        free(propertyArray);
    }
    
    return out;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
