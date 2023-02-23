//
//  DYFRuntimeProvider.h
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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

/**
 The class for runtime wrapper that provides some common usages.
 */
@interface DYFRuntimeProvider : NSObject

/**
 Describes the instance methods implemented by a class.
 
 @param cls The class you want to inspect.
 @return String array of the instance methods.
 */
+ (NSArray *)supplyMethodListWithClass:(Class)cls;

/**
 To get the class methods of a class.
 
 @param cls The object you want to inspect.
 @return String array of the class methods.
 */
+ (NSArray *)supplyClassMethodListWithClass:(Class)cls;

/**
 Describes the instance variables declared by a class.
 
 @param cls The class you want to inspect.
 @return String array of the instance variables.
 */
+ (NSArray *)supplyIvarListWithClass:(Class)cls;

/**
 Describes the properties declared by a class.
 
 @param cls The class you want to inspect.
 @return String array of the properties.
 */
+ (NSArray *)supplyPropertyListWithClass:(Class)cls;

/**
 Returns a string describing a method's parameter and return types.
 
 @param method The method to inspect.
 @return  A C string. The string may be NULL.
 */
+ (const char *)supplyMethodTypes:(Method)method;

/**
 Reads the value of an instance variable in an object.
 
 @param name The name of an instance variable.
 @param obj The object containing the instance variable whose value you want to read.
 @return The value of the instance variable specified by ivar, or nil if object is nil.
 */
+ (id)getInstanceVarWithName:(NSString *)name forObject:(id)obj;

/**
 Sets the value of an instance variable in an object.
 
 @param name The name of an instance variable.
 @param value The new value for the instance variable.
 @param obj The object containing the instance variable whose value you want to set.
 */
+ (void)setInstanceVarWithName:(NSString *)name value:(id)value forObject:(id)obj;

/**
 Adds a new method to a class with a given selector and implementation.
 
 @param cls The class to which to add a method.
 @param sel A selector that specifies the name of the method being added.
 @param impSel A function which is the implementation of the new method.
 @return YES if the method was added successfully, otherwise NO.
 */
+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel impSelector:(SEL)impSel;

/**
 Adds a new method to a class with a given selector and implementation.
 
 @param cls The class to which to add a method.
 @param sel A selector that specifies the name of the method being added.
 @param impCls A class which is the implementation of the new method.
 @param impSel A function which is the implementation of the new method.
 @return YES if the method was added successfully, otherwise NO.
 */
+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel impClass:(Class)impCls impSelector:(SEL)impSel;

/**
 Adds a new method to a class with a given selector and implementation.
 
 @param cls The class to which to add a method.
 @param sel A selector that specifies the name of the method being added.
 @param impCls A class which is the implementation of the new method.
 @param impSel A function which is the implementation of the new method.
 @param types A string describing a method's parameter and return types. see [Type Encodings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)
 @return YES if the method was added successfully, otherwise NO.
 */
+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel impClass:(Class)impCls impSelector:(SEL)impSel types:(const char *)types;

/**
 Adds a new method to a class with a given selector and implementation.
 
 @param cls The class to which to add a method.
 @param sel A selector that specifies the name of the method being added.
 @param imp A function which is the implementation of the new method. e.g.: void xt(id self, SEL _cmd, BOOL x, NSString *str) {}; IMP _imp = (IMP)xt; const char *_types = "v@:B@";
 @param types A string describing a method's parameter and return types. see [Type Encodings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)
 @return YES if the method was added successfully, otherwise NO.
 */
+ (BOOL)addMethodWithClass:(Class)cls selector:(SEL)sel imp:(IMP)imp types:(const char *)types;

/**
 Exchanges the implementations of two methods.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the method whose implementation you want to exchange.
 @param aSel The selector of the method you want to specify.
 */
+ (void)exchangeMethodWithClass:(Class)cls selector:(SEL)sel anotherSelector:(SEL)aSel;

/**
 Exchanges the implementations of two methods.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the method whose implementation you want to exchange.
 @param aCls The class you want to specify.
 @param aSel The selector of the method you want to specify.
 */
+ (void)exchangeMethodWithClass:(Class)cls selector:(SEL)sel anotherClass:(Class)aCls anotherSelector:(SEL)aSel;

/**
 Exchanges the implementations of two class methods for a given class.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the class method whose implementation you want to exchange.
 @param aSel The selector of the class method you want to specify.
 */
+ (void)exchangeClassMethodWithClass:(Class)cls selector:(SEL)sel anotherSelector:(SEL)aSel;

/**
 Exchanges the implementations of two class methods for two given classes.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the class method whose implementation you want to exchange.
 @param aCls The class you want to specify.
 @param aSel TThe selector of the class method you want to specify.
 */
+ (void)exchangeClassMethodWithClass:(Class)cls selector:(SEL)sel anotherClass:(Class)aCls anotherSelector:(SEL)aSel;

/**
 Replaces the implementation of a method for a given class.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the method whose implementation you want to replace.
 @param targetSel The selector of the method you want to specify..
 */
+ (void)replaceMethodWithClass:(Class)cls selector:(SEL)sel targetSelector:(SEL)targetSel;

/**
 Replaces the implementation of a method for two given class.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the method whose implementation you want to replace.
 @param targetCls The class you want to specify.
 @param targetSel The selector of the method you want to specify.
 */
+ (void)replaceMethodWithClass:(Class)cls selector:(SEL)sel targetClass:(Class)targetCls targetSelector:(SEL)targetSel;

/**
 Replaces the implementation of a method for a given class.
 
 @param cls The class you want to modify.
 @param sel A selector that identifies the method whose implementation you want to replace.
 @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd. e.g.: void xt(id self, SEL _cmd, BOOL x, NSString *str) {}; IMP _imp = (IMP)xt; const char *_types = "v@:B@";
 @param types A string describing a method's parameter and return types. see [Type Encodings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)
 */
+ (void)replaceMethodWithClass:(Class)cls selector:(SEL)sel imp:(IMP)imp types:(const char *)types;

/**
 Swizzles the implementation of a method for two given classes.
 
 @param cls The class you want to specify.
 @param sel The selector of the method you want to specify.
 @param swizzledSel A selector that identifies the method whose implementation you want to swizzle.
 */
+ (void)swizzleMethodWithClass:(Class)cls selector:(SEL)sel swizzledSelector:(SEL)swizzledSel;

/**
 Swizzles the implementation of a method for two given classes.
 
 @param cls The class you want to specify.
 @param sel The selector of the method you want to specify.
 @param swizzledCls The class you want to swizzle.
 @param swizzledSel A selector that identifies the method whose implementation you want to swizzle.
 */
+ (void)swizzleMethodWithClass:(Class)cls selector:(SEL)sel swizzledClass:(Class)swizzledCls swizzledSelector:(SEL)swizzledSel;

/**
 Swizzles the implementation of two class methods for a given class.
 
 @param cls The class you want to specify.
 @param sel The selector of the class method you want to specify.
 @param swizzledSel A selector that identifies the class method whose implementation you want to swizzle.
 */
+ (void)swizzleClassMethodWithClass:(Class)cls selector:(SEL)sel swizzledSelector:(SEL)swizzledSel;

/**
 Swizzles the implementation of two class methods for two given classes.
 
 @param cls The class you want to specify.
 @param sel The selector of the class method you want to specify.
 @param swizzledCls The class you want to swizzle.
 @param swizzledSel A selector that identifies the class method whose implementation you want to swizzle.
 */
+ (void)swizzleClassMethodWithClass:(Class)cls selector:(SEL)sel swizzledClass:(Class)swizzledCls swizzledSelector:(SEL)swizzledSel;

/**
 Converts a dictionary whose elements are key-value pairs to a corresponding object.
 
 @param dictionary A collection whose elements are key-value pairs.
 @param cls A class that inherits the NSObject class.
 @return A corresponding object.
 */
+ (id)asObjectWithDictionary:(NSDictionary *)dictionary forClass:(Class)cls;

/**
 Converts a dictionary whose elements are key-value pairs to a corresponding object.
 
 @param dictionary A collection whose elements are key-value pairs.
 @param object An object that inherits the NSObject class.
 @return A corresponding object.
 */
+ (id)asObjectWithDictionary:(NSDictionary *)dictionary forObject:(id)object;

/**
 Converts a object to a corresponding dictionary whose elements are key-value pairs.
 
 @param model A NSObject object.
 @return A corresponding dictionary.
 */
+ (NSDictionary *)asDictionarywithObject:(id)object;

/**
 Encodes an object using a given archiver.
 
 @param encoder An archiver object.
 @param obj An object you want to encode.
 */
+ (void)encode:(NSCoder *)encoder forObject:(NSObject *)obj;

/**
 Decodes an object initialized from data in a given unarchiver.
 
 @param decoder An unarchiver object.
 @param obj An object you want to decode.
 */
+ (void)decode:(NSCoder *)decoder forObject:(NSObject *)obj;

/**
 Sets an associated value for a given object using a given key and association policy.
 
 @param object The source object for the association.
 @param obj The key for the association.
 @param value The key for the association.
 @param policy The policy for the association. For possible values, see [objc_AssociationPolicy]().
 */
+ (void)setAssociatedObject:(id)object key:(const void *)key value:(id)value policy:(objc_AssociationPolicy)policy;

/**
 Returns the value associated with a given object for a given key.
 
 @param object The source object for the association.
 @param key The key for the association.
 @return YES if the operation was successful, otherwise NO.
 */
+ (id)getAssociatedObject:(id)object key:(const void *)key;

/**
 Archives an object by encoding it into a data object, then atomically writes the resulting data object to a file at a given path, and returns a Boolean value that indicates whether the operation was successful.
 
 @param object The object you want to archive.
 @param cls The class you want to inspect.
 @param path The path of the file in which to write the archive.
 @return YES if the operation was successful, otherwise NO.
 */
+ (BOOL)archiveWithObject:(id)object forClass:(Class)cls toFile:(NSString *)path;

/**
 Decodes and returns the object previously encoded by NSKeyedArchiver written to the file at a given path.
 
 @param path A path to a file that contains an object previously encoded by NSKeyedArchiver.
 @param cls The class you want to inspect.
 @return The object previously encoded by NSKeyedArchiver written to the file path. Returns nil if there is no file at path.
 */
+ (id)unarchiveWithFile:(NSString *)path forClass:(Class)cls;

/**
 Releases the inner objects once you’re finished.
 */
+ (void)releaseObject;

@end
