//
//  NSString+VisibleText.h
//  ConstructionApp
//
//  Created by bviadmin on 18/03/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (visibleText)

- (NSString*)stringVisibleInRect:(CGRect)rect withFont:(UIFont*)font;

@end
