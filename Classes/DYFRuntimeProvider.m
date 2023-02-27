//
//  DYFRuntimeProvider.m
//
//  Created by chenxing on 2014/11/4. ( https://github.com/chenxing640/DYFRuntimeProvider )
//  Copyright © 2014 chenxing. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFRuntimeProvider.h"

/** An object you want to archive or unarchive. */
static id _rtObject = nil;

/** The class you want to inspect. */
static Class _rtClass = nil;

/**
 Returns a string containing the bytes in a given C array, interpreted according to a given encoding.
 
 @param cString A C array of bytes. The array must end with a NULL byte.
 @return A string containing the characters described in cString.
 */
static NSString *rt_cStringToObjcString(const char *cString) {
    if (cString) {
        return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@implementation DYFRuntimeProvider

+ (NSArray *)supplyMethodListWithClass:(Class)cls
{
    NSMutableArray *selNames = [NSMutableArray arrayWithCapacity:0];
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i < count; i++) {
        SEL sel = method_getName(methodList[i]);
        NSString *selName = rt_cStringToObjcString(sel_getName(sel));
        [selNames addObject:selName];
    }
    free(methodList);
    return selNames.copy;
}

+ (NSArray *)supplyClassMethodListWithClass:(Class)cls
{
    return [self supplyMethodListWithClass:object_getClass(cls)];
}

+ (NSArray *)supplyIvarListWithClass:(Class)cls
{
    NSMutableArray *ivarNames = [NSMutableArray arrayWithCapacity:0];
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(cls, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = rt_cStringToObjcString(ivar_getName(ivar));
        if (ivarName) {
            [ivarNames addObject:ivarName];
        }
    }
    free(ivarList);
    return ivarNames.copy;
}

+ (NSArray *)supplyPropertyListWithClass:(Class)cls
{
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:0];
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = rt_cStringToObjcString(property_getName(property));
        [propertyNames addObject:propertyName];
    }
    free(propertyList);
    return propertyNames.copy;
}

+ (const char *)supplyMethodTypes:(Method)method
{
    return method_getTypeEncoding(method);
}

+ (id)getInstanceVarWithName:(NSString *)name forObject:(id)obj
{
    Class cls = object_getClass(obj);
    Ivar ivar = class_getInstanceVariable(cls, name.UTF8String);
    return object_getIvar(obj, ivar);
}

+ (void)setInstanceVarWithName:(NSString *)name value:(id)value forObject:(id)obj
{
    Class cls = object_getClass(obj);
    Ivar ivar = class_getInstanceVariable(cls, name.UTF8String);
    object_setIvar(obj, ivar, value);
}

+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel impSelector:(SEL)impSel
{
    return [self addMethodWithClass:cls selector:sel impClass:cls impSelector:impSel];
}

+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel impClass:(Class)impCls impSelector:(SEL)impSel
{
    Method m = class_getInstanceMethod(impCls, impSel);
    const char *types = [self supplyMethodTypes:m];
    return [self addMethodWithClass:cls selector:sel impClass:impCls impSelector:impSel types:types];
}

+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel impClass:(Class)impCls impSelector:(SEL)impSel types:(const char *)types
{
    IMP imp = class_getMethodImplementation(impCls, impSel);
    return class_addMethod(cls, sel, imp, types);
}

+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel imp:(IMP)imp types:(const char *)types
{
    return class_addMethod(cls, sel, imp, types);
}

+ (void)exchangeMethodWithClass:(Class)cls selector:(SEL)sel anotherSelector:(SEL)aSel
{
    [self exchangeMethodWithClass:cls selector:sel anotherClass:cls anotherSelector:aSel];
}

+ (void)exchangeMethodWithClass:(Class)cls selector:(SEL)sel anotherClass:(Class)aCls anotherSelector:(SEL)aSel
{
    Method m1 = class_getInstanceMethod(cls, sel);
    Method m2 = class_getInstanceMethod(aCls, aSel);
    method_exchangeImplementations(m1, m2);
}

+ (void)exchangeClassMethodWithClass:(Class)cls selector:(SEL)sel anotherSelector:(SEL)aSel
{
    [self exchangeClassMethodWithClass:cls selector:sel anotherClass:cls anotherSelector:aSel];
}

+ (void)exchangeClassMethodWithClass:(Class)cls selector:(SEL)sel anotherClass:(Class)aCls anotherSelector:(SEL)aSel
{
    Method m1 = class_getClassMethod(cls, sel);
    Method m2 = class_getClassMethod(aCls, aSel);
    method_exchangeImplementations(m1, m2);
}

+ (void)replaceMethodWithClass:(Class)cls selector:(SEL)sel targetSelector:(SEL)targetSel
{
    [self replaceMethodWithClass:cls selector:sel targetClass:cls targetSelector:targetSel];
}

+ (void)replaceMethodWithClass:(Class)cls selector:(SEL)sel targetClass:(Class)targetCls targetSelector:(SEL)targetSel
{
    Method m = class_getInstanceMethod(targetCls, targetSel);
    IMP imp = method_getImplementation(m);
    const char *types = [self supplyMethodTypes:m];
    class_replaceMethod(cls, sel, imp, types);
}

+ (void)replaceMethodWithClass:(Class)cls selector:(SEL)sel imp:(IMP)imp types:(const char *)types
{
    class_replaceMethod(cls, sel, imp, types);
}

+ (void)swizzleMethodWithClass:(Class)cls selector:(SEL)sel swizzledSelector:(SEL)swizzledSel
{
    [self swizzleMethodWithClass:cls selector:sel swizzledClass:cls swizzledSelector:swizzledSel];
}

+ (void)swizzleMethodWithClass:(Class)cls selector:(SEL)sel swizzledClass:(Class)swizzledCls swizzledSelector:(SEL)swizzledSel
{
    Method originalMethod = class_getInstanceMethod(cls, sel);
    Method swizzledMethod = class_getInstanceMethod(swizzledCls, swizzledSel);
    BOOL isAdded = class_addMethod(swizzledCls, swizzledSel,
                                   method_getImplementation(swizzledMethod),
                                   method_getTypeEncoding(swizzledMethod));
    if (isAdded) {
        class_replaceMethod(swizzledCls, swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleClassMethodWithClass:(Class)cls selector:(SEL)sel swizzledSelector:(SEL)swizzledSel
{
    [self swizzleClassMethodWithClass:cls selector:sel swizzledClass:cls swizzledSelector:swizzledSel];
}

+ (void)swizzleClassMethodWithClass:(Class)cls selector:(SEL)sel swizzledClass:(Class)swizzledCls swizzledSelector:(SEL)swizzledSel
{
    Method originalMethod = class_getClassMethod(cls, sel);
    Method swizzledMethod = class_getClassMethod(swizzledCls, swizzledSel);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (id)asObjectWithDictionary:(NSDictionary *)dictionary forClass:(Class)cls
{
    id object = [[cls alloc] init];
    NSArray *properties = [self supplyPropertyListWithClass:cls];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([properties containsObject:key]) {
            [object setValue:obj forKey:key];
        }
    }];
    return object;
}

+ (id)asObjectWithDictionary:(NSDictionary *)dictionary forObject:(id)object
{
    Class cls = object_getClass(object);
    NSArray *properties = [self supplyPropertyListWithClass:cls];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([properties containsObject:key]) {
            [object setValue:obj forKey:key];
        }
    }];
    return object;
}

+ (NSDictionary *)asDictionaryWithObject:(id)object
{
    NSArray *properties = [self supplyPropertyListWithClass:object_getClass(object)];
    if (properties.count > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSString *key in properties) {
            id value = [object valueForKey:key];
            dict[key] = value ?: [NSNull null];
        }
        return dict.copy;
    }
    return nil;
}

+ (void)encode:(NSCoder *)encoder forObject:(NSObject *)obj
{
    NSArray *ivarNames = [self supplyIvarListWithClass:obj.classForCoder];
    for (NSString *key in ivarNames) {
        id value = [obj valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
}

+ (void)decode:(NSCoder *)decoder forObject:(NSObject *)obj
{
    NSArray *ivarNames = [self supplyIvarListWithClass:obj.classForCoder];
    for (NSString *key in ivarNames) {
        id value = [decoder decodeObjectForKey:key];
        [obj setValue:value forKey:key];
    }
}

+ (void)setAssociatedObject:(id)object key:(const void *)key value:(id)value policy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(object, key, value, policy);
}

+ (id)getAssociatedObject:(id)object key:(const void *)key
{
    return objc_getAssociatedObject(object, key);
}

+ (BOOL)archiveWithObject:(id)object forClass:(Class)cls toFile:(NSString *)path
{
    [[self alloc] archiveOrUnarchiveWithObject:object forClass:cls];
    if (!object) { return NO; }
    if (@available(iOS 11.0, *)) {
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
        [archiver encodeObject:object];
        NSData *data = archiver.encodedData; //[archiver finishEncoding] and return the data.
        return [data writeToFile:path atomically:YES];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    return [data writeToFile:path atomically:YES];
}

+ (id)unarchiveWithFile:(NSString *)path forClass:(Class)cls
{
    [[self alloc] archiveOrUnarchiveWithObject:nil forClass:cls];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) { return nil; }
    if (@available(iOS 11.0, *)) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
        id object = [unarchiver decodeObject];
        [unarchiver finishDecoding];
        return object;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)releaseObject
{
    _rtClass = nil;
    _rtObject = nil;
}

- (void)archiveOrUnarchiveWithObject:(id)obj forClass:(Class)cls
{
    _rtClass  = cls;
    _rtObject = obj;
    [DYFRuntimeProvider replaceMethodWithClass:_rtClass
                                      selector:@selector(initWithCoder:)
                                   targetClass:self.class
                                targetSelector:@selector(initWithCoder:)];
    [DYFRuntimeProvider replaceMethodWithClass:_rtClass
                                      selector:@selector(encodeWithCoder:)
                                   targetClass:self.class
                                targetSelector:@selector(encodeWithCoder:)];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    _rtObject = [super init];
    if (_rtObject) {
        NSArray *ivarNames = [DYFRuntimeProvider supplyIvarListWithClass:_rtClass];
        for (NSString *key in ivarNames) {
            id value = [decoder decodeObjectForKey:key];
            [_rtObject setValue:value forKey:key];
        }
    }
    return _rtObject;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSArray *ivarNames = [DYFRuntimeProvider supplyIvarListWithClass:_rtClass];
    for (NSString *key in ivarNames) {
        id value = [_rtObject valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
}

@end
