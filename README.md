# MGJSON

MGJSON is a simple way to handle JSON in Objective-C. It uses a model based architecture. Simply see it has a definitions for json data.

##Usage
```objective-c
#import "MGJSON.h"

@interface YourModel : MGJSON

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *simpleNumber;

@end
```

From your code you can now do this
```objective-c
NSString *json   = @"..your json..";
YourModel *model = [[YourModel alloc] initWithJSONString:json];
NSLog(@"%@", model.title);
```

##Nesting
MGJSON Supports model nesting that does not require you to add any code. When defining your model, 
simply create a property that uses another model, like so:

```objective-c
@property (nonatomic, copy) AnotherModel *simpleNumber;
```

MGJSON will auto-detect and assign everything for that specific object.

There are two ways you can initialize your model

```objective-c
- (instancetype)initWithJSONData:(NSData *)data;
- (instancetype)initWithJSONString:(NSString *)string;
```

In case your json provides more properties than your model declares, MGJSON will drop these extra values instead of crashing.
Pretty neat right?

Enjoy
