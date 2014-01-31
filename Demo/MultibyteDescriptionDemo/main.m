//
//  main.m
//  MultibyteDescriptionDemo
//
//  Created by Inami Yasuhiro on 13/03/21.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultibyteDescription.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        [MultibyteDescription install];
        
        NSArray* arr = @[ @"あいうえお", @"カキクケコ", @"abcde", @[ @"らりるれろ", @"らりるれろ" ] , @{ @"English" : @"hello", @"日本語" : @"こんにちは",  @"한국어" : @"안녕하세요",  @"中文" : @"你好" }, @{ @"キー1" : @{ @"キー2" : @{ @"キー3" : @{ @"キー4" : @"バリュー" } } } }, @[@"らりるれろ"] ];
        NSLog(@"array = \n%@",arr);
        
        NSDictionary* dict = @{ @"キー" : arr };
        NSLog(@"dict = \n%@",dict);
        
        NSSet* set = [NSSet setWithArray:arr];
        NSLog(@"set = \n%@",set);
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arr];
        NSLog(@"orderedSet = \n%@", orderedSet);
        
        NSDate* date = [NSDate date];
        NSLog(@"date = \n%@", date);
        
    }
    return 0;
}

