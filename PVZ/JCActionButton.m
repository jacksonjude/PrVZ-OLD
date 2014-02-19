//
//  JCActionButton.m
//  PrVZ
//
//  Created by jackson on 2/17/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import "JCActionButton.h"

@implementation JCActionButton

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[touches allObjects] containsObject:self.onlyTouch])
    {
        if (self.target)
        {
            [self.target performSelector:self.selector withObject:nil];
        }
    }
    [super touchesEnded:touches withEvent:event];
}


@end
