//
//  WDSScaleTransform.h
//  Spati
//
//  Copyright (c) 2013 Wit Dot Media Berlin GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDSTransformPipe.h"

#if TARGET_OS_IPHONE

@interface WDSScaleTransform : NSObject<WDSTransform>

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL percentScale;

- (instancetype)initWithSize:(CGSize)size;

- (WDSTransformPipe *)newPipe;

@end

#endif // TARGET_OS_IPHONE
