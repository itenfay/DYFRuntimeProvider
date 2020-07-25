## [Chinese Document](https://github.com/dgynfi/DYFRuntimeProvider)


If this project can help you, please give it [a star](https://github.com/dgynfi/DYFRuntimeProvider/blob/master/README-en.md). Thanks!


## DYFRuntimeProvider

`DYFRuntimeProvider` wraps the runtime, and can quickly use for the transformation of the dictionary and model, archiving and unarchiving, adding a method, exchanging two methods, replacing a method, and getting all the variable names, property names and method names of a class.

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods Version](http://img.shields.io/cocoapods/v/DYFRuntimeProvider.svg?style=flat)](http://cocoapods.org/pods/DYFRuntimeProvider)&nbsp;
![CocoaPods Platform](http://img.shields.io/cocoapods/p/DYFRuntimeProvider.svg?style=flat)&nbsp;


## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFRuntimeProvider/raw/master/images/g614799921.jpg" width="30%" />
</div>


## Installation

Using [CocoaPods](https://cocoapods.org):

```
target 'Your target name'

pod 'DYFRuntimeProvider', '~> 1.0.0'
```


## Usage

Add `#import "DYFRuntimeProvider.h"` to your source code.

### Gets all the method names of a class

**1. Gets all method names of an instance**

```
NSArray *methodNames = [DYFRuntimeProvider methodListWithClass:UITableView.class];
for (NSString *name in methodNames) {
    NSLog("The method name: %@", name);
}
```

**2. Gets all method names of a class**

```
NSArray *clsMethodNames = [DYFRuntimeProvider classMethodList:self];
for (NSString *name in clsMethodNames) {
    NSLog("The class method name: %@", name);
}
```

### Gets all variable names of a class

```
NSArray *ivarNames = [DYFRuntimeProvider ivarListWithClass:UILabel.class];
for (NSString *name in ivarNames) {
    NSLog("The var name: %@", name);
}
```

### Gets all the property names of a class

```
NSArray *propertyNames = [DYFRuntimeProvider propertyListWithClass:UILabel.class];
for (NSString *name in propertyNames) {
    NSLog("The property name: %@", name);
}
```

### Adds a method

```
+ (void)load {
    [DYFRuntimeProvider addMethodWithClass:self.class selector:NSSelectorFromString(@"verifyCode") impClass:self.class impSelector:@selector(verifyQRCode)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"verifyCode")];
#pragma clang diagnostic pop
}

- (void)verifyQRCode {
    NSLog(@"Verifies QRCode");
}
```

### Exchanges two methods

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DYFRuntimeProvider exchangeMethodWithClass:self.class selector:@selector(verifyCode1) targetClass:self.class targetSelector:@selector(verifyQRCode)];
    
    [self verifyCode1];
    [self verifyQRCode];
}

- (void)verifyCode1 {
    NSLog(@"Verifies Code1");
}

- (void)verifyQRCode {
    NSLog(@"Verifies QRCode");
}
```

### Replaces a method

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DYFRuntimeProvider replaceMethodWithClass:self.class selector:@selector(verifyCode2) targetClass:self.class targetSelector:@selector(verifyQRCode)];
    
    [self verifyCode2];
    [self verifyQRCode];
}

- (void)verifyCode2 {
    NSLog(@"Verifies Code2");
}

- (void)verifyQRCode {
    NSLog(@"Verifies QRCode");
}
```

### The transformation of dictionary and model

**1. Converts the dictionary to model**

```
// e.g.: DYFStoreTransaction: NSObject
DYFStoreTransaction *transaction = [DYFRuntimeProvider modelWithDictionary:dict forClass:DYFStoreTransaction.class];
```

**2. Converts the model to dictionary**

```
DYFStoreTransaction *transaction = [[DYFStoreTransaction alloc] init];
NSDictionary *dict = [DYFRuntimeProvider dictionaryWithModel:transaction];
```

### Archives and unarchives

**1. Archives**

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"DYFStoreTransaction.data"];
    
    [self archive:filePath];
}

- (void)archive:(NSString *)path {
    // e.g.: DYFStoreTransaction: NSObject <NSCoding>
    DYFStoreTransaction *transaction = [[DYFStoreTransaction alloc] init];
    [DYFRuntimeProvider archiveWithObject:transaction forClass:DYFStoreTransaction.class toFile:path];
}
```

Or

```
// e.g.: DYFStoreTransaction: NSObject <NSCoding>

@implementation DYFStoreTransaction

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [DYFRuntimeProvider encode:aCoder forObject:self];
}

@end
```

**2. Unarchives**

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"YFModel.plist"];
    
    [self unarchive:filePath];
}

- (void)unarchive:(NSString *)path {
    // e.g.: DYFStoreTransaction: NSObject <NSCoding>
    DYFStoreTransaction *transaction = [DYFRuntimeProvider unarchiveWithFile:path forClass:DYFStoreTransaction.class];
}
```

Or

```
// e.g.: DYFStoreTransaction: NSObject <NSCoding>

@implementation DYFStoreTransaction

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [DYFRuntimeProvider decode:aDecoder forObject:self];
    }
    return self;
}

@end
```


## Demo

`DYFRuntimeProvider` is learned how to use under this [Demo](https://github.com/dgynfi/DYFStoreKit).


## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. I will be happy to help you.
