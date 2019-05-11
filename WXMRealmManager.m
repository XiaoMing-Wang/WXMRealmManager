//
//  RLMRealmManager.m
//  ChaomengPlanet
//
//  Created by 超盟 on 2018/10/23.
//  Copyright © 2018年 wq. All rights reserved.
//Library路径
#define KLibraryboxPath \
NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define CacheRealms [KLibraryboxPath stringByAppendingPathComponent:@"CacheRealms"] /** 文件夹  */

#import "WXMRealmManager.h"

@interface WXMRealmManager ()
@property (nonatomic, assign) NSInteger version;
@end

@implementation WXMRealmManager

#pragma mark _____________________________________________ 存

/** 添加单个存储对象 */
- (BOOL)saveRLMObjectWithObj:(RLMObject *)obj {
    if (!obj) return NO;
    NSString *primaryKey = nil;
    @try {
        primaryKey = [obj.class valueForKey:@"primaryKey"];
        RLMRealm *realm = [self realmWithClass:obj.class];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:obj];
        [realm commitWriteTransaction];
        return YES;
    } @catch (NSException *exception) {} @finally {}
    if (primaryKey == nil) {  NSLog(@"添加失败----请确认是否设置primaryKey"); }
    return NO;
}
- (NSInteger)saveRLMObjectsWithArray:(NSArray<RLMObject *> *)array {
    __block NSInteger successCount = 0;
    [array enumerateObjectsUsingBlock:^(RLMObject *obj, NSUInteger idx, BOOL *stop) {
        BOOL success = [self saveRLMObjectWithObj:obj];
        if (success) successCount ++;
    }];
    return successCount;
}
- (NSInteger)saveRLMObjectsSingletonWithArray:(NSArray<RLMObject *> *)array {
    RLMObject * firstObj = array.firstObject;
    NSString *viceKey = nil;
    NSString *viceKeyValue = nil;
    @try {
        viceKey = [firstObj.class valueForKey:@"viceKey"];
        viceKeyValue = [firstObj valueForKey:viceKey];
    } @catch (NSException *exception) { } @finally {}
    if (viceKey == nil || viceKeyValue == nil) {NSLog(@"请设置viceKey");};
    if (viceKey == nil || viceKeyValue == nil) return 0;
    [self removeRLMObjectWithViceKeyValue:viceKeyValue class:firstObj.class];
    return [self saveRLMObjectsWithArray:array];
}
#pragma mark _____________________________________________ 取

/** 通过主键获取单个缓存对象(主键唯一) */
- (id)objWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass {
    if (!primaryKeyValue || !aClass) return nil;
    @try {
        NSString *primaryKey = [aClass valueForKey:@"primaryKey"];
        RLMRealm *realm = [self realmWithClass:aClass];
        RLMResults *results = [aClass allObjectsInRealm:realm];
        NSString *conditions = [NSString stringWithFormat:@"%@ = '%@'",primaryKey,primaryKeyValue];
        if ([primaryKeyValue isKindOfClass:[NSNumber class]]) {
            conditions = [NSString stringWithFormat:@"%@ = %@",primaryKey,primaryKeyValue];
        }
        NSInteger index = [results indexOfObjectWhere:conditions];
        id obj = [results objectAtIndex:index];
        if (obj) return obj;
        return nil;
    } @catch (NSException *exception) {
        NSLog(@"查询失败----请确认是否设置primaryKey 或者 参数类型是否匹配");
    } @finally {}
    return nil;
}

/** 通过副键获取多个缓存对象(副键不唯一) */
- (NSArray <RLMObject *>*)objWithViceKeyValue:(id)viceKeyValue class:(Class)aClass {
    if (!viceKeyValue || !aClass) return nil;
    id viceKey = nil;
    @try {
        viceKey = [aClass valueForKey:@"viceKey"];
    } @catch (NSException *exception) {} @finally {}
    
    if (viceKey == nil) {  NSLog(@"请在model里面设置viceKey或使用 objWithViceKey:viceKeyValue:class:"); }
    if (viceKey == nil) return nil;
    return [self objWithViceKey:viceKey viceKeyValue:viceKeyValue class:aClass];
}
- (NSArray <RLMObject *>*)objWithViceKey:(id)viceKey
                            viceKeyValue:(id)viceKeyValue
                                   class:(Class)aClass {
    if (!viceKeyValue || !aClass || !viceKey) return nil;
    @try {
        NSString *viceKeyValueString = [NSString stringWithFormat:@"%@",viceKeyValue];
        RLMRealm *realm = [self realmWithClass:aClass];
        RLMResults *results = [aClass allObjectsInRealm:realm];
        NSMutableArray *objsArray = @[].mutableCopy;
        for(RLMObject *obj in results) {
            id value = [obj valueForKey:viceKey];
            NSString * valueString = [NSString stringWithFormat:@"%@",value];
            if ([viceKeyValueString isEqualToString:valueString])[objsArray addObject:obj];
        }
        return objsArray;
    } @catch (NSException *exception) {
        NSLog(@"查询数组失败----请确认viceKey正确");
    } @finally {}
    return nil;
}

#pragma mark _____________________________________________ 删

/** 通过主键删除 */
- (BOOL)removeRLMObjectWithObj:(RLMObject *)obj {
    if (!obj) return NO;
    NSString *primaryKey = nil;
    @try {
        primaryKey = [obj.class valueForKey:@"primaryKey"];
        RLMRealm *realm = [self realmWithClass:obj.class];
        [realm beginWriteTransaction];
        [realm deleteObject:obj];
        [realm commitWriteTransaction];
    } @catch (NSException *exception) {} @finally {}
    if (primaryKey == nil) { NSLog(@"删除请确认是否设置primaryKey"); }
    if (primaryKey == nil) return NO;
    return YES;
}
- (BOOL)removeRLMObjectWithPrimaryKeyValue:(id)primaryKeyValue class:(Class)aClass {
    if (!aClass || !primaryKeyValue) return NO;
    RLMObject *obj =  [self objWithPrimaryKeyValue:primaryKeyValue class:aClass];
    return [self removeRLMObjectWithObj:obj];
}

/** 通过副键删除 */
- (NSInteger)removeRLMObjectWithViceKeyValue:(id)viceKeyValue class:(Class)aClass {
    if (!viceKeyValue || !aClass) return 0;
    NSString *viceKey = nil;
    @try {
        viceKey = [aClass valueForKey:@"viceKey"];
    } @catch (NSException *exception) {} @finally {}
    
    if (viceKey == nil) { NSLog(@"没有设置viceKey"); }
    if (viceKey == nil) return 0;
    return [self removeRLMObjectWithViceKey:viceKey viceKeyValue:viceKeyValue class:aClass];
}
- (NSInteger)removeRLMObjectWithViceKey:(id)viceKey
                      viceKeyValue:(id)viceKeyValue
                             class:(Class)aClass {
    if (!viceKey || !viceKeyValue || !aClass) return 0;
    NSArray <RLMObject *>* array = [self objWithViceKey:viceKey viceKeyValue:viceKeyValue class:aClass];
    __block NSInteger removeCount = 0;
    [array enumerateObjectsUsingBlock:^(RLMObject * _Nonnull obj, NSUInteger idx, BOOL * stop) {
        BOOL successDele = [self removeRLMObjectWithObj:obj];
        if (successDele) removeCount++;
    }];
    if (array.count == 0) { NSLog(@"一个都没删除"); }
    return removeCount;
}

#pragma mark _____________________________________________
#pragma mark _____________________________________________
#pragma mark _____________________________________________

+ (WXMRealmManager *)sharedInstance {
    static WXMRealmManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WXMRealmManager new];
        manager.version = RLMRealmVersion;
    });
    return manager;
}
///** 判断数据库是否可用 */
//- (void)judgeRealmCache {
////    @try {
////        RLMRealm *realm = [RLMRealm realmWithURL:USERPATH];
////        [RLMObject allObjectsInRealm:realm];
////        NSLog(@"数据库可用");
////    } @catch (NSException *exception) {  [self cleanRealm]; } @finally {}
//}
/** 数据库迁移 版本号int值 */
- (void)realmMigration {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    /** config.fileURL = USERPATH; */
    [RLMRealmConfiguration setDefaultConfiguration:config];
    config.schemaVersion = 1234;
    @try {
        config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {};
        [RLMRealmConfiguration setDefaultConfiguration:config];
        [RLMRealm defaultRealm];
    } @catch (NSException *exception) {} @finally {}
}
/** 删除数据库 */
- (void)cleanRealm {
    @try {
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:CacheRealms];
        NSString *fileName;
        while (fileName = [dirEnum nextObject]) {
            NSString * path = [CacheRealms stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            NSLog(@"正在删除%@...",fileName);
        }
    } @catch (NSException *exception) { } @finally {}
}
/** 创建数据库存储文件 */
+ (void)load {
    NSFileManager* man = [NSFileManager defaultManager];
    NSString *cache = CacheRealms;
    BOOL isDir = NO;
    BOOL isExists = [man fileExistsAtPath:cache isDirectory:&isDir];
    if (!isExists || !isDir) {
        [man createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"%@",CacheRealms);
}
/** 获取realm数据库 */
- (RLMRealm *)realmWithClass:(Class)aClass {
    NSString * className = [aClass valueForKey:@"className"];
    NSString * path = [CacheRealms stringByAppendingPathComponent:className];
    NSURL * url = [[NSURL URLWithString:path] URLByAppendingPathExtension:@"realm"];
    return [RLMRealm realmWithURL:url];
}
@end


