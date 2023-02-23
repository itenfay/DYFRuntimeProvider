## DYFRuntimeProvider

`DYFRuntimeProvider`包装了Objective-C的运行时，并提供了一些常见的用法。

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods Version](http://img.shields.io/cocoapods/v/DYFRuntimeProvider.svg?style=flat)](http://cocoapods.org/pods/DYFRuntimeProvider)&nbsp;
![CocoaPods Platform](http://img.shields.io/cocoapods/p/DYFRuntimeProvider.svg?style=flat)&nbsp;


## QQ群 (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/chenxing640/DYFRuntimeProvider/raw/master/images/g614799921.jpg" width="30%" />
</div>


## 安装

使用 [CocoaPods](https://cocoapods.org):

``` 
target 'Your target name'

pod 'DYFRuntimeProvider'
or
pod 'DYFRuntimeProvider', '~> 2.0.1'
```


## 使用

将 `#import "DYFRuntimeProvider.h"` 添加到源代码中。

### 获取一个类的所有方法名

**1. 获取一个类的实例的所有方法名**

```
NSArray *instMethods = [DYFRuntimeProvider supplyMethodListWithClass:UITableView.class];
NSLog(@"========instMethods: %@", instMethods);
```

**2. 获取一个类的所有类方法名**

```
NSArray *clsMethods = [DYFRuntimeProvider supplyClassMethodListWithClass:UIView.class];
NSLog(@"========clsMethods: %@", clsMethods);
``` 

### 获取一个类的所有变量名

```
NSArray *ivars = [DYFRuntimeProvider supplyIvarListWithClass:UIButton.class];
NSLog(@"========ivars: %@", ivars);
```

### 获取一个类的所有属性名

```
NSArray *properties = [DYFRuntimeProvider supplyPropertyListWithClass:UIButton.class];
NSLog(@"========properties: %@", properties);
```

以这个类为例，如下：

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

### 添加一个方法

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

### 交换两个方法

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

### 替换一个方法

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

### 交换两个方法（黑魔法）

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

### 字典和模型的转换

**1. 字典转模型**

```
Teacher *teacher = (Teacher *)[DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forClass:Teacher.class];
if (teacher) {
    NSLog(@"========teacher: %@, %@, %ld, %@", teacher, teacher.name, (long)teacher.age, teacher.address);
}

Teacher *teacher2 = [[Teacher alloc] init];
[DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forObject:teacher2];
NSLog(@"========teacher2: %@, %@, %ld, %@", teacher2, teacher2.name, (long)teacher2.age, teacher2.address);
```

**2. 模型转字典**

```
NSDictionary *dict = [DYFRuntimeProvider asDictionarywithObject:teacher];
NSLog(@"========dict: %@", dict);
```

### 归档解档

以这个类为例，如下：

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

**1. 归档**

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
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

**2. 解档**

```
- (void)viewDidLoad 
{
    [super viewDidLoad];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
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

### 添加一个分类属性

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

### 获取和修改实例变量属性

```
Teacher *teacher = (Teacher *)[DYFRuntimeProvider asObjectWithDictionary:@{@"name": @"高粟", @"age": @26, @"address": @"xx市xx"} forClass:Teacher.class];
NSString *teacherName = [DYFRuntimeProvider getInstanceVarWithName:@"_name" forObject:teacher];
NSLog(@"========teacher name: %@", teacherName);
[DYFRuntimeProvider setInstanceVarWithName:@"_name" value:@"李想" forObject:teacher];
NSLog(@"========teacher newName: %@", teacher.name);
```


<!-- ## 演示

`DYFRuntimeProvider` 在此 [演示](https://github.com/chenxing640/DYFStoreKit) 下学习如何使用。
-->


## 欢迎反馈

如果你注意到任何问题被卡住，请创建一个问题。我乐意帮助你。
