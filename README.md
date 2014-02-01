MultibyteDescription 0.2
========================

A better way to NSLog multibyte string for OSX/iOS. 

How to use
----------

```
#import "MultibyteDescription.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        [MultibyteDescription install];
        
        NSArray* arr = @[ @"あいうえお", @"カキクケコ", @"abcde", @[ @"らりるれろ", @"らりるれろ" ] , @{ @"English" : @"hello", @"日本語" : @"こんにちは",  @"한국어" : @"안녕하세요",  @"中文" : @"你好" } ];
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
```

Acknowledgement
---------------

Main idea is from @yusuga's post: <http://qiita.com/items/85437eba2623f6ffbdbd> (in Japanese)

License
-------
`MultibyteDescription` is available under the [Beerware](http://en.wikipedia.org/wiki/Beerware) license.

If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.