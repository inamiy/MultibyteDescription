//
//  MultibyteDescription.m
//  MultibyteDescription
//
//  Created by Inami Yasuhiro on 13/03/21.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "MultibyteDescription.h"
#import <objc/runtime.h>

@implementation MultibyteDescription

//
// Great ideas from @yusuga: http://qiita.com/items/85437eba2623f6ffbdbd (in Japanese)
//
+ (void)install
{
    Class c;
    IMP imp;
    SEL sel;
    
    //------------------------------
    // NSArray
    //------------------------------
    c = [NSArray class];
    
    // descriptionWithLocale:
    imp = imp_implementationWithBlock(^NSString*(NSArray *arr, id locale) {
        NSMutableString *mStr = [NSMutableString stringWithString:@"(\n"];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                [mStr appendFormat:@"%@", [obj descriptionWithLocale:locale indent:2]];
            } else {
                [mStr appendFormat:@"    %@", [obj description]];
            }
            if (idx == [arr count] - 1) {
                [mStr appendString:@"\n"];
            } else {
                [mStr appendString:@",\n"];
            }
        }];
        [mStr appendString:@")"];
        return mStr;
    });
    sel = @selector(descriptionWithLocale:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
    
    // descriptionWithLocale:indent:
    imp = imp_implementationWithBlock(^NSString*(NSArray *arr, id locale, NSUInteger indent) {
        NSMutableString *mStr = [NSMutableString string];
        for (int i = 0; i < indent; i++) {
            [mStr appendString:@"    "];
        }
        [mStr appendString:@"(\n"];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                [mStr appendFormat:@"    %@", [obj descriptionWithLocale:locale indent:indent + 1]];
            } else {
                for (int i = 0; i < indent; i++) {
                    [mStr appendString:@"    "];
                }
                [mStr appendFormat:@"%@", [obj description]];
            }
            if (idx == [arr count] - 1) {
                [mStr appendString:@"\n"];
            } else {
                [mStr appendString:@",\n"];
            }
        }];
        for (int i = 0; i < indent - 1; i++) {
            [mStr appendString:@"    "];
        }
        [mStr appendString:@")"];
        return mStr;
    });
    sel = @selector(descriptionWithLocale:indent:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
    
    //------------------------------
    // NSDictionary
    // (FIXME: improve indentation)
    //------------------------------
    c = [NSDictionary class];
    
    // descriptionWithLocale:
    imp = imp_implementationWithBlock(^NSString*(NSDictionary *dict, id locale) {
        NSMutableString *mStr = [NSMutableString stringWithString:@"{\n"];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                [mStr appendFormat:@"    %@ = %@;\n", key, [obj descriptionWithLocale:locale indent:2]];
            } else {
                [mStr appendFormat:@"    %@ = %@;\n", key, [obj description]];
            }
        }];
        [mStr appendString:@"}"];
        return mStr;
    });
    sel = @selector(descriptionWithLocale:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
    
    // descriptionWithLocale:indent:
    imp = imp_implementationWithBlock(^NSString*(NSDictionary *dict, id locale, NSUInteger indent) {
        NSMutableString *mStr = [NSMutableString string];
        for (int i = 0; i < indent; i++) {
            [mStr appendString:@"    "];
        }
        [mStr appendString:@"{\n"];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            for (int i = 0; i < indent; i++) {
                [mStr appendString:@"    "];
            }
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                [mStr appendFormat:@"%@ = %@;\n", key, [obj descriptionWithLocale:locale indent:indent + 1]];
            } else {
                [mStr appendFormat:@"%@ = %@;\n", key, [obj description]];
            }
        }];
        for (int i = 0; indent > 0 && i < indent - 1; i++) {
            [mStr appendString:@"    "];
        }
        [mStr appendString:@"}"];
        return mStr;
    });
    sel = @selector(descriptionWithLocale:indent:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
    
    //------------------------------
    // NSSet
    //------------------------------
    c = [NSSet class];
    
    // descriptionWithLocale:
    imp = imp_implementationWithBlock(^NSString*(NSSet* set, id locale) {
        return [NSString stringWithFormat:@"{%@}",[[set allObjects] descriptionWithLocale:locale]];
    });
    sel = @selector(descriptionWithLocale:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
    
    //------------------------------
    // NSOrderedSet
    //------------------------------
    c = [NSOrderedSet class];
    
    // descriptionWithLocale:
    imp = imp_implementationWithBlock(^NSString*(NSOrderedSet* orderedSet, id locale) {
        return [NSString stringWithFormat:@"{%@}",[[orderedSet array] descriptionWithLocale:locale]];
    });
    sel = @selector(descriptionWithLocale:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
    
    //------------------------------
    // NSDate
    //------------------------------
    c = [NSDate class];
    
    // descriptionWithLocale:
    imp = imp_implementationWithBlock(^NSString*(NSDate* date, id locale) {
        return [NSDateFormatter localizedStringFromDate:date
                                              dateStyle:NSDateFormatterMediumStyle
                                              timeStyle:NSDateFormatterMediumStyle];
    });
    sel = @selector(descriptionWithLocale:);
    class_replaceMethod(c, sel, imp, method_getTypeEncoding(class_getInstanceMethod(c, sel)));
}

@end
