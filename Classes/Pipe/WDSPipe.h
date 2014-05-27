//
//  WDSPipe.h
//  Spati
//
//  Copyright (c) 2014 Wit Dot Media Berlin GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WDSStatus) {
    WDSStatusSuccess,
    WDSStatusFailed,
    WDSStatusCancelled,
    WDSStatusNotFound,
};

@protocol WDSCancel <NSObject>
- (void)cancel;
- (BOOL)isCancelled;
@end


@interface WDSPipe : NSObject

@property (nonatomic, strong) WDSPipe *next;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;

- (id<WDSCancel>)get:(id)key block:(void(^)(id object, WDSStatus status))block;

- (void)appendPipe:(WDSPipe *)pipe;
- (void)insertPipe:(WDSPipe *)pipe afterPipe:(WDSPipe *)after;
- (void)insertPipe:(WDSPipe *)pipe beforePipe:(WDSPipe *)before;

@end
