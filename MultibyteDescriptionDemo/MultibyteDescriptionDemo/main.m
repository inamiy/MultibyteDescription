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
        
        NSArray* arr = @[@"あいうえお", @[@"アイウエオ", @"カキクケコ", @[@"唖伊兎絵尾", @"可来区毛個"], @"サシスセソ"], @"かきくけこ", @"さしすせそ", @"abcde", @{ @"たちつてと" : @"なにぬねの",  @"はひふへほ" : @"まみむめも"}];
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

