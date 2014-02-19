//
//  JCActionButton.h
//  PrVZ
//
//  Created by jackson on 2/17/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import "JCButton.h"

@interface JCActionButton : JCButton

@property   (strong, nonatomic) id          target;
@property   (nonatomic)         SEL         selector;

@end
