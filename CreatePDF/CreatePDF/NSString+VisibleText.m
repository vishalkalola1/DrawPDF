//
//  NSString+VisibleText.m
//  ConstructionApp
//
//  Created by bviadmin on 18/03/16.
//
//

#import "NSString+VisibleText.h"

@implementation NSString (visibleText)

- (NSString*)stringVisibleInRect:(CGRect)rect withFont:(UIFont*)font
{
    //NSLog(@"rect height = %f", rect.size.height);
    
    NSString *visibleString = @"";
    for (int i = 1; i <= self.length; i++)
    {
        NSString *testString = [self substringToIndex:i];
        
        CGSize stringSize = [testString sizeWithFont:font constrainedToSize:CGSizeMake(rect.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        //NSLog(@"String height = %f", stringSize.height);
        
        if (stringSize.height > rect.size.height || stringSize.width > rect.size.width)
            break;
        
        visibleString = testString;
    }
    return visibleString;
}

@end
