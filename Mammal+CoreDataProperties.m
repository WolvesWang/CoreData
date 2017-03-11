//
//  Mammal+CoreDataProperties.m
//  CoreData
//
//  Created by wangwenbing on 2017/3/6.
//  Copyright © 2017年 Centit. All rights reserved.
//

#import "Mammal+CoreDataProperties.h"

@implementation Mammal (CoreDataProperties)

+ (NSFetchRequest<Mammal *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Mammal"];
}

@dynamic suckle;
@dynamic walk;
@dynamic habit;
@dynamic icon;
@dynamic color;
@dynamic numbersArray;
@dynamic lifeDictionary;

@end

@implementation UIImageTransformer

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

+ (Class)transformedValueClass
{
    return [NSData class];
}

- (id)transformedValue:(id)value
{
    return UIImagePNGRepresentation((UIImage *)value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:(NSData *)value];
}

@end

@implementation UIColorTransformer

 /**     允许转换    */
+ (BOOL)allowsReverseTransformation
{
     return YES;
}

 /**     转换成什么类    */
+ (Class)transformedValueClass
{
    return [NSData class];
}

 /**     返回转换后的对象    */
- (id)transformedValue:(id)value
 {
         // 将color转成NSData
         UIColor *color = (UIColor *)value;
    
         CGFloat red, green, blue, alpha;
         [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
         CGFloat components[4] = {red, green, blue, alpha};
   
         NSData *dataFromColor = [[NSData alloc] initWithBytes:components length:sizeof(components)];
  
       return dataFromColor;
    }

 /**     重新生成原对象    */
 - (id)reverseTransformedValue:(id)value
 {
   
        CGFloat components[4] = {0.0f, 0.0f, 0.0f, 0.0f};
        NSData *data = (NSData *)value;
        [data getBytes:components length:sizeof(components)];
    
        UIColor *color = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    
        return color;
 }
@end

@implementation NSArrayTransformer

+ (Class)transformedValueClass
{
    return [NSArray class];
    
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

-(id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)value];
}
@end


@implementation NSDictionaryTransformer

+ (Class)transformedValueClass
{
    return [NSDictionary class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
   return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)value];
}
@end
