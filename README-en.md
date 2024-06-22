English Vision | [中文版](README.md)

## DYFRuntimeProvider

`DYFRuntimeProvider` wraps the runtime, and provides some common usages([Swift Version](https://github.com/itenfay/DYFSwiftRuntimeProvider)).

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods Version](http://img.shields.io/cocoapods/v/DYFRuntimeProvider.svg?style=flat)](http://cocoapods.org/pods/DYFRuntimeProvider)&nbsp;
![CocoaPods Platform](http://img.shields.io/cocoapods/p/DYFRuntimeProvider.svg?style=flat)&nbsp;


## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/itenfay/DYFRuntimeProvider/raw/master/images/g614799921.jpg" width="30%" />
</div>


## Installation

Using [CocoaPods](https://cocoapods.org):


``` 
pod 'DYFRuntimeProvider'
```

Or

```
pod 'DYFRuntimeProvider', '~> 2.1.1'
```


## Usage

Add `#import "DYFRuntimeProvider.h"` to your source code.

### Gets all the method names of a class

**1. Gets all method names of an instance of a class**

```
NSArray *instMethods = [DYFRuntimeProvider getMethodListWithClass:UITableView.class];
NSLog(@"========instMethods: %@", instMethods);
```

**2. Gets all class method names of a class**

```
NSArray *clsMethods = [DYFRuntimeProvider getClassMethodListWithClass:UIView.class];
NSLog(@"========clsMethods: %@", clsMethods);
```

### Gets all variable names of a class

```
NSArray *ivars = [DYFRuntimeProvider getIvarListWithClass:UIButton.class];
NSLog(@"========ivars: %@", ivars);
```

### Gets all the property names of a class

```
NSArray *properties = [DYFRuntimeProvider getPropertyListWithClass:UIButton.class];
NSLog(@"========properties: %@", properties);
```

Take this class as an example. e.g.:

```
@interface Teacher : NSObject
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

- (void)eatWithFoods:(NSDictionary *)foods;
- (void)runWithStep:(NSInteger)step;
- (void)run2WithStep:(NSInteger)step;

+ (void)decInfo:(NSString *)name age:(NSInteger)age;
+ (void)decInfo2:(NSString *)name age:(NSInteger)age;

@end

@implementation Teacher

- (void)eatWithFoods:(NSDictionary *)foods
{
    NSLog(@"========%@ eat foods: %@", _name, foods);
}

- (void)runWithStep:(NSInteger)step
{
    NSLog(@"========%s 1 %@ runs %ld steps", __func__, _name, step);
}

- (void)run2WithStep:(NSInteger)step
{
    NSLog(@"========%s 2 %@ runs %ld steps", __func__, _name, step);
}

+ (void)decInfo:(NSString *)name age:(NSInteger)age
{
    NSLog(@"========decInfo name: %@, age: %ld", name, age);
}

+ (void)decInfo2:(NSString *)name age:(NSInteger)age
{
    NSLog(@"========decInfo2 name: %@, age: %ld", name, age);
}
```

### Adds a method

```
void rt_eatWithFoods2(id self, SEL _cmd, NSDictionary *foods)
{
    NSLog(@"========%@, %@ eat foods: %@", self, NSStringFromSelector(_cmd), foods);
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    SEL eatSel = NSSelectorFromString(@"rt_eatWithFoods:");
    [DYFRuntimeProvider addMethodWithClass:Teacher.class selector:eatSel impSelector:@selector(eatWithFoods:)];
    
    SEL eatSel2 = NSSelectorFromString(@"eatWithFoods2:");
    [DYFRuntimeProvider addMethodWithClass:Teacher.class selector:eatSel2 imp:(IMP)rt_eatWithFoods2 types:"v@:@"];
    
    Teacher *teacher = [[Teacher alloc] init];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([teacher respondsToSelector:eatSel]) {
        [teacher performSelector:eatSel withObject:@{@"name": @"meat", @"number": @1}];
    }
    
    if ([teacher respondsToSelector:eatSel2]) {
        [teacher performSelector:eatSel2 withObject:@{@"name": @"meat", @"number": @1}];
    }
    #pragma clang diagnostic pop
}
```

### Exchanges two methods

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [DYFRuntimeProvider exchangeMethodWithClass:Teacher.class selector:@selector(runWithStep:) anotherSelector:@selector(run2WithStep:)];
    Teacher *teacher = [[Teacher alloc] init];
    [teacher runWithStep:50];
    [teacher run2WithStep:100];
    
    [DYFRuntimeProvider exchangeClassMethodWithClass:Teacher.class selector:@selector(decInfo:age:) anotherSelector:@selector(decInfo2:age:)];
    [Teacher decInfo:@"David" age:40];
    [Teacher decInfo2:@"Liming" age:28];
}
```

### Replaces a method

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [DYFRuntimeProvider replaceMethodWithClass:Teacher.class selector:@selector(runWithStep:) targetSelector:@selector(run2WithStep:)];
    Teacher *teacher = [[Teacher alloc] init];
    [teacher runWithStep:50];
    [teacher run2WithStep:100];
}
```

### Swizzle two methods

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [DYFRuntimeProvider swizzleMethodWithClass:Teacher.class selector:@selector(runWithStep:) swizzledSelector:@selector(run2WithStep:)];
    Teacher *teacher = [[Teacher alloc] init];
    [teacher runWithStep:50];
    [teacher run2WithStep:100];
    
    [DYFRuntimeProvider swizzleClassMethodWithClass:Teacher.class selector:@selector(decInfo:age:) swizzledSelector:@selector(decInfo2:age:)];
    [Teacher decInfo:@"David" age:40];
    [Teacher decInfo2:@"Liming" age:28];
}
```

### The transformation of dictionary and model

**1. Converts the dictionary to model**

```
Teacher *teacher = (Teacher *)[DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forClass:Teacher.class];
if (teacher) {
    NSLog(@"========teacher: %@, %@, %ld, %@", teacher, teacher.name, (long)teacher.age, teacher.address);
}

Teacher *teacher2 = [[Teacher alloc] init];
[DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forObject:teacher2];
NSLog(@"========teacher2: %@, %@, %ld, %@", teacher2, teacher2.name, (long)teacher2.age, teacher2.address);
```

**2. Converts the model to dictionary**

```
NSDictionary *dict = [DYFRuntimeProvider asDictionaryWithObject:teacher];
NSLog(@"========dict: %@", dict);
```

### Archives and unarchives

Take this class as an example. e.g.:

```
@interface Transaction : NSObject <NSCoding>
@property (nonatomic, assign) NSUInteger state;
@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, copy) NSString *userIdentifier;
@property (nonatomic, copy) NSString *originalTransactionTimestamp;
@end

@implementation Transaction

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [DYFRuntimeProvider decode:aDecoder forObject:self];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
 {
    [DYFRuntimeProvider encode:aCoder forObject:self];
}

@end
```

**1. Archives**

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Transaction.data"];
    [self archive:filePath];
}

- (void)archive:(NSString *)path 
{
    Transaction *transaction = [[Transaction alloc] init];
    [DYFRuntimeProvider archiveWithObject:transaction forClass:Transaction.class toFile:path];
}
```

Or

```
@implementation Transaction

- (void)encodeWithCoder:(NSCoder *)aCoder 
{
    [DYFRuntimeProvider encode:aCoder forObject:self];
}

@end
```

**2. Unarchives**

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"Transaction.data"];
    [self unarchive:filePath];
}

- (void)unarchive:(NSString *)path 
{
    Transaction *transaction = [DYFRuntimeProvider unarchiveWithFile:path forClass:Transaction.class];
}
```

Or

```
@implementation Transaction

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [DYFRuntimeProvider decode:aDecoder forObject:self];
    }
    return self;
}

@end
```

### Add a catogory property

```
@interface UIApplication (Pt)
@property (nonatomic, strong) Teacher *teacher;
@end

static NSString *kTeacherKey = @"TeacherKey";

@implementation UIApplication (Pt)

- (Teacher *)teacher
{
    return (Teacher *)[DYFRuntimeProvider getAssociatedObject:self key:&kTeacherKey];
}

- (void)setTeacher:(Teacher *)teacher
{
    [DYFRuntimeProvider setAssociatedObject:self key:&kTeacherKey value:teacher policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end
```

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    Teacher *teacher2 = [[Teacher alloc] init];
    [DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forObject:teacher2];
    UIApplication.sharedApplication.teacher = teacher2;
    NSLog(@"========teacher: %@", UIApplication.sharedApplication.teacher);
}
```


### Get and modify instance variable property.

```
Teacher *teacher = (Teacher *)[DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forClass:Teacher.class];
NSString *teacherName = [DYFRuntimeProvider getInstanceVarWithName:@"_name" forObject:teacher];
NSLog(@"========teacher name: %@", teacherName);
[DYFRuntimeProvider setInstanceVarWithName:@"_name" value:@"李想" forObject:teacher];
NSLog(@"========teacher newName: %@", teacher.name);
```


## Demo

`DYFRuntimeProvider` is learned how to use under this [Demo](https://github.com/itenfay/DYFSwiftRuntimeProvider/raw/master/Example/RuntimeExample).


## Feedback is welcome

If you notice any issue to create an issue. I will be happy to help you.
