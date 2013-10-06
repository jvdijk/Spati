//
//  WDSMultiCache.m
//  Spati
//
//  Copyright (c) 2013 witdot. All rights reserved.
//

#import "WDSMultiCache.h"


@implementation WDSMultiCache


- (id)initWithCaches:(NSArray *)caches
{
    self = [super init];
    if (self) {
        _caches = caches;
    }
    return self;
}

- (id)objectForKey:(NSString *)key
{
    for (WDSCache *cache in _caches) {
        id result = [cache objectForKey:key];
        if (result) return result;
    }
    return nil;
}

- (id)dataForKey:(NSString *)key
{
    for (WDSCache *cache in _caches) {
        id result = [cache dataForKey:key];
        if (result) return result;
    }
    return nil;
}

- (BOOL)setObject:(id)object forKey:(NSString *)key
{
    BOOL result = NO;
    for (WDSCache *cache in _caches) {
        result |= [cache setObject:object forKey:key];
    }
    return result;
}

- (BOOL)setData:(NSData *)data forKey:(NSString *)key
{
    BOOL result = NO;
    for (WDSCache *cache in _caches) {
        result |= [cache setData:data forKey:key];
    }
    return result;
}

- (BOOL)removeObjectForKey:(NSString *)key
{
    BOOL result = YES;
    for (WDSCache *cache in _caches) {
        result &= [cache removeObjectForKey:key];
    }
    return result;
}

- (BOOL)moveObjectForKey:(NSString *)key toKey:(NSString *)toKey
{
    BOOL result = YES;
    for (WDSCache *cache in _caches) {
        result &= [cache moveObjectForKey:key toKey:toKey];
    }
    return result;
}

- (BOOL)removeAllObjects
{
    BOOL result = YES;
    for (WDSCache *cache in _caches) {
        result &= [cache removeAllObjects];
    }
    return result;
}

- (void)objectForKey:(NSString *)key block:(void(^)(id))block
{
    [self objectForKey:key index:0 block:block];
}

- (void)objectForKey:(NSString *)key index:(NSUInteger)index block:(void(^)(id))block
{
    if (index >= _caches.count) { if (block) block(nil); return; }
    [_caches[index] objectForKey:key block:^(id object) {
        if (object) { if (block) block(object); return; }
        [self objectForKey:key index:index + 1 block:block];
    }];
}

- (void)dataForKey:(NSString *)key block:(void (^)(NSData *))block
{
    [self dataForKey:key index:0 block:block];
}

- (void)dataForKey:(NSString *)key index:(NSUInteger)index block:(void(^)(id))block
{
    if (index >= _caches.count) { if (block) block(nil); return; }
    [_caches[index] dataForKey:key block:^(NSData *data) {
        if (data) { if (block) block(data); return; }
        [self dataForKey:key index:index + 1 block:block];
    }];
}

- (void)setObject:(id)object forKey:(NSString *)key block:(void(^)(BOOL))block
{
    [self setObject:object forKey:key index:0 result:NO block:block];
}

- (void)setObject:(id)object forKey:(NSString *)key index:(NSUInteger)index result:(BOOL)result block:(void(^)(BOOL))block
{
    if (index >= _caches.count) { if (block) block(result); return; }
    [_caches[index] setObject:object forKey:key block:^(BOOL done) {
        [self setObject:object forKey:key index:index + 1 result:(result || done) block:block];
    }];
}

- (void)setData:(NSData *)data forKey:(NSString *)key block:(void (^)(BOOL))block
{
    [self setData:data forKey:key index:0 result:NO block:block];
}

- (void)setData:(NSData *)data forKey:(NSString *)key index:(NSUInteger)index result:(BOOL)result block:(void(^)(BOOL))block
{
    if (index >= _caches.count) { if (block) block(result); return; }
    [_caches[index] setData:data forKey:key block:^(BOOL done) {
        [self setData:data forKey:key index:index + 1 result:(result || done) block:block];
    }];
}

- (void)removeObjectForKey:(NSString *)key block:(void(^)(BOOL))block
{
    [self removeObjectForKey:key index:0 result:YES block:block];
}

- (void)removeObjectForKey:(NSString *)key index:(NSUInteger)index result:(BOOL)result block:(void(^)(BOOL))block
{
    if (index >= _caches.count) { if (block) block(result); return; }
    [_caches[index] removeObjectForKey:key block:^(BOOL done) {
        [self removeObjectForKey:key index:index + 1 result:(result && done) block:block];
    }];
}

- (void)moveObjectForKey:(NSString *)key toKey:(NSString *)toKey block:(void(^)(BOOL))block
{
    [self moveObjectForKey:key toKey:toKey index:0 result:YES block:block];
}

- (void)moveObjectForKey:(NSString *)key toKey:(NSString *)toKey index:(NSUInteger)index result:(BOOL)result block:(void(^)(BOOL))block
{
    if (index >= _caches.count) { if (block) block(result); return; }
    [_caches[index] moveObjectForKey:key toKey:toKey block:^(BOOL done) {
        [self moveObjectForKey:key toKey:toKey index:index + 1 result:(result && done) block:block];
    }];
}

- (void)removeAllObjectsWithBlock:(void (^)(BOOL))block
{
    [self removeAllObjectsWithIndex:0 result:YES block:block];
}

- (void)removeAllObjectsWithIndex:(NSUInteger)index result:(BOOL)result block:(void(^)(BOOL))block
{
    if (index >= _caches.count) { if (block) block(result); return; }
    [_caches[index] removeAllObjectsWithBlock:^(BOOL done) {
        [self removeAllObjectsWithIndex:index + 1 result:(result && done) block:block];
    }];
}


@end