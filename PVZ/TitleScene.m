//
//  TitleScene.m
//  PVZ
//
//  Created by jackson on 1/7/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import "TitleScene.h"
#import "GameScene.h"

@interface TitleScene ()
@property BOOL contentCreated;
@end

@implementation TitleScene

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addChild: [self newTitleNode]];
    [self addChild: [self newTitle2Node]];
    [self addChild: [self newTitle3Node]];
    [self addChild: [self newTitle4Node]];
}

- (SKLabelNode *)newTitleNode
{
    SKLabelNode *titleNode = [SKLabelNode labelNodeWithFontNamed:@"Times"];
    titleNode.text = @"JJ Presents";
    titleNode.fontSize = 30;
    titleNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+600);
    titleNode.name = @"titleNode";
    return titleNode;
}

- (SKLabelNode *)newTitle2Node
{
    SKLabelNode *title2Node = [SKLabelNode labelNodeWithFontNamed:@"Times"];
    title2Node.text = @"Princesses";
    title2Node.fontSize = 30;
    title2Node.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    title2Node.name = @"title2Node";
    SKAction *fade = [SKAction fadeOutWithDuration:0];
    [title2Node runAction:fade];
    return title2Node;
}

- (SKLabelNode *)newTitle3Node
{
    SKLabelNode *title3Node = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    title3Node.text = @"vs.";
    title3Node.fontSize = 30;
    title3Node.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-50);
    title3Node.name = @"title3Node";
    SKAction *fade = [SKAction fadeOutWithDuration:0];
    [title3Node runAction:fade];
    return title3Node;
}

- (SKLabelNode *)newTitle4Node
{
    SKLabelNode *title4Node = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-CondensedBlack"];
    title4Node.text = @"Zombies";
    title4Node.fontSize = 30;
    title4Node.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
    title4Node.name = @"title4Node";
    SKAction *fade = [SKAction fadeOutWithDuration:0];
    [title4Node runAction:fade];
    return title4Node;
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    SKNode *titleNode = [self childNodeWithName:@"titleNode"];
    SKNode *title2Node = [self childNodeWithName:@"title2Node"];
    SKNode *title3Node = [self childNodeWithName:@"title3Node"];
    SKNode *title4Node = [self childNodeWithName:@"title4Node"];
    
    if (titleNode != nil)
    {
        titleNode.name = nil;
        SKAction *moveDown = [SKAction moveByX: 0 y: -500.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fade = [SKAction fadeOutWithDuration: 1];
        SKAction *moveSequence = [SKAction sequence:@[moveDown, zoom, pause, fade]];
        [titleNode runAction: moveSequence];
    }
    
    if (title2Node != nil)
    {
        title2Node.name = nil;
        SKAction *pause = [SKAction waitForDuration:3];
        SKAction *show = [SKAction fadeInWithDuration:0.3];
        SKAction *pause5 = [SKAction waitForDuration:1.5];
        SKAction *hide = [SKAction fadeOutWithDuration:0.3];
        SKAction *moveSequence = [SKAction sequence:@[pause, show, pause5, hide]];
        [title2Node runAction: moveSequence];
    }
    
    if (title3Node != nil)
    {
        title3Node.name = nil;
        SKAction *pause = [SKAction waitForDuration: 5];
        SKAction *show = [SKAction fadeInWithDuration:0.3];
        SKAction *pause5 = [SKAction waitForDuration:1.5];
        SKAction *hide = [SKAction fadeOutWithDuration:0.3];
        SKAction *moveSequence = [SKAction sequence:@[pause, show, pause5, hide]];
        [title3Node runAction: moveSequence];
    }
    
    if (title4Node != nil)
    {
        title4Node.name = nil;
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration:10];
        SKAction *show = [SKAction fadeInWithDuration:0.3];
        SKAction *pause5 = [SKAction waitForDuration:1.5];
        SKAction *pauses = [SKAction waitForDuration:0.01];
        SKAction *hide = [SKAction fadeOutWithDuration:0.3];
        SKAction *moveSequence = [SKAction sequence:@[pause, show, pauses, zoom, pause5, hide]];
        [title4Node runAction: moveSequence completion:^
         {
             CGSize aSize = self.size;
             SKScene *gameScene  = [[GameScene alloc] initWithSize:aSize];
             SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
             [self.view presentScene:gameScene transition:doors];
         }];
    }
    
}


@end