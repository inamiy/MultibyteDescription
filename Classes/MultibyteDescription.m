//
//  MultibyteDescription.m
//  MultibyteDescription
//
//  Created by Inami Yasuhiro on 13/03/21.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "MultibyteDescription.h"
#import <objc/runtime.h>

#define  MDINDENT  3

@implementation MultibyteDescription

+ (void)install
{
    [self hackNSArray];
    [self hackNSDictionary];
    [self hackNSSet];
    [self hackNSOrderedSet];
    [self hackNSDate];
}

+ (void)hackNSArray
{
    Method sourceMethod1 = class_getInstanceMethod([NSArray class], @selector(descriptionWithLocale:));
    Method targetMethod1 = class_getInstanceMethod([self class], @selector(mdNSArrayDescriptionWithLocale:));
    method_exchangeImplementations(sourceMethod1, targetMethod1);
    
    Method sourceMethod2 = class_getInstanceMethod([NSArray class], @selector(descriptionWithLocale:indent:));
    Method targetMethod2 = class_getInstanceMethod([self class], @selector(mdNSArrayDescriptionWithLocale:indent:));
    method_exchangeImplementations(sourceMethod2, targetMethod2);
}

+ (void)hackNSDictionary
{
    Method sourceMethod1 = class_getInstanceMethod([NSDictionary class], @selector(descriptionWithLocale:));
    Method targetMethod1 = class_getInstanceMethod([self class], @selector(mdNSDictionaryDescriptionWithLocale:));
    method_exchangeImplementations(sourceMethod1, targetMethod1);
    
    Method sourceMethod2 = class_getInstanceMethod([NSDictionary class], @selector(descriptionWithLocale:indent:));
    Method targetMethod2 = class_getInstanceMethod([self class], @selector(mdNSDictionaryDescriptionWithLocale:indent:));
    method_exchangeImplementations(sourceMethod2, targetMethod2);
}

+ (void)hackNSSet
{
    Method sourceMethod1 = class_getInstanceMethod([NSSet class], @selector(descriptionWithLocale:));
    Method targetMethod1 = class_getInstanceMethod([self class], @selector(mdNSSetDescriptionWithLocale:));
    method_exchangeImplementations(sourceMethod1, targetMethod1);
}

+ (void)hackNSOrderedSet
{
    Method sourceMethod1 = class_getInstanceMethod([NSOrderedSet class], @selector(descriptionWithLocale:));
    Method targetMethod1 = class_getInstanceMethod([self class], @selector(mdNSOrderedSetDescriptionWithLocale:));
    method_exchangeImplementations(sourceMethod1, targetMethod1);
}

+ (void)hackNSDate
{
    Method sourceMethod1 = class_getInstanceMethod([NSDate class], @selector(descriptionWithLocale:));
    Method targetMethod1 = class_getInstanceMethod([self class], @selector(mdNSDateDescriptionWithLocale:));
    method_exchangeImplementations(sourceMethod1, targetMethod1);
}


#pragma mark -

NSString *spaceWithLength(NSUInteger length)
{
    // 添加空格
    NSMutableString *indentStr = [[NSMutableString alloc] initWithCapacity:length];
    for(NSInteger i = 0; i < length; i++)
    {
        [indentStr appendString:@" "];
    }
    return indentStr;
}

- (NSString *)mdNSArrayDescriptionWithLocale:(NSLocale *)locale
{
    NSArray *arr = (NSArray *)self;
    NSMutableString *str = [NSMutableString stringWithFormat:@"[\n"];
    
    NSInteger count = [arr count];
    for(NSInteger i = 0; i < count; i++)
    {
        id obj = arr[i];
        
        if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)])
        {
            [str appendFormat:@"%@%@\n", spaceWithLength(MDINDENT),
             [obj descriptionWithLocale:[NSLocale systemLocale] indent:MDINDENT]];
        }
        else
        {
            if (i!=(count-1)) {
                [str appendFormat:@"%@\"%@\",\n", spaceWithLength(MDINDENT),[obj description]];
            } else {
                [str appendFormat:@"%@\"%@\"\n", spaceWithLength(MDINDENT), [obj description]];
            }
        }
    }
    [str appendFormat:@"]"];
    return str;
}

- (NSString *)mdNSArrayDescriptionWithLocale:(NSLocale *)locale indent:(NSUInteger)indent
{
    NSArray *arr = (NSArray *)self;
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"[\n"];
    NSInteger count = [arr count];
    for(NSInteger i = 0; i < count; i++)
    {
        id obj = arr[i];
        
        if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)])
        {
            [str appendFormat:@"%@%@\n", spaceWithLength(indent+MDINDENT), [obj descriptionWithLocale:[NSLocale systemLocale] indent:indent+MDINDENT]];
        }
        else
        {
            if (i!=(count-1)) {
                [str appendFormat:@"%@\"%@\",\n", spaceWithLength(indent+MDINDENT), [obj description]];
            } else {
                [str appendFormat:@"%@\"%@\"\n", spaceWithLength(indent+MDINDENT), [obj description]];
            }
        }
    }
    [str appendFormat:@"%@]", spaceWithLength(indent)];
    
    
    return str;
}

- (NSString *)mdNSDictionaryDescriptionWithLocale:(NSLocale *)locale
{
    NSDictionary *dict = (NSDictionary *)self;
    NSMutableString *str = [NSMutableString stringWithFormat:@"{\n"];
    
    NSArray *keys = [dict allKeys];
    NSInteger count = [keys count];
    for(NSInteger i = 0; i < count; i++)
    {
        id key = keys[i];
        id value = [self valueForKey:key];
        
        NSLog(@"%@", [key description]);
        
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)])
        {
            [str appendFormat:@"%@%@ :\n%@%@\n", spaceWithLength(MDINDENT), [key description], spaceWithLength(MDINDENT),
             [value descriptionWithLocale:[NSLocale systemLocale] indent:MDINDENT]];
        }
        else
        {
            if (i!=(count-1)) {
                [str appendFormat:@"%@%@ :\"%@\",\n", spaceWithLength(MDINDENT), [key description], [value description]];
            } else {
                [str appendFormat:@"%@%@ :\"%@\"\n", spaceWithLength(MDINDENT), [key description], [value description]];
            }
        }
    }
    [str appendFormat:@"}"];
    return str;
}

- (NSString *)mdNSDictionaryDescriptionWithLocale:(NSLocale *)local indent:(NSUInteger)indent
{
    NSDictionary *dict = (NSDictionary *)self;
    NSMutableString *str = [NSMutableString stringWithFormat:@"{\n"];
    
    NSArray *keys = [dict allKeys];
    NSInteger count = [keys count];
    for(NSInteger i = 0; i < count; i++)
    {
        id key = keys[i];
        id value = [self valueForKey:key];
        
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)])
        {
            [str appendFormat:@"%@%@\n%@ :%@\n", spaceWithLength(MDINDENT+indent), [key description], spaceWithLength(MDINDENT),
             [value descriptionWithLocale:[NSLocale systemLocale] indent:MDINDENT+indent]];
        }
        else
        {
            if (i!=(count-1)) {
                [str appendFormat:@"%@%@ :\"%@\",\n", spaceWithLength(MDINDENT+indent), [key description], [value description]];
            } else {
                [str appendFormat:@"%@%@ :\"%@\"\n", spaceWithLength(MDINDENT+indent), [key description], [value description]];
            }
        }
    }
    [str appendFormat:@"}"];
    return str;
}

- (NSString *)mdNSSetDescriptionWithLocale:(NSLocale *)locale
{
    NSSet *set = (NSSet *)self;
    return [NSString stringWithFormat:@"{%@}", [[set allObjects] descriptionWithLocale:locale]];
}

- (NSString *)mdNSOrderedSetDescriptionWithLocale:(NSLocale *)locale
{
    NSOrderedSet *set = (NSOrderedSet *)self;
    NSLog(@"%@", [set array]);
    return [NSString stringWithFormat:@"{%@}", [[set array] description]];
}

- (NSString *)mdNSDateDescriptionWithLocale:(NSLocale *)locale
{
    NSDate *date = (NSDate *)self;
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:NSDateFormatterMediumStyle
                                          timeStyle:NSDateFormatterMediumStyle];
}

@end
