//
//  GameScene.m
//  PVZ
//
//  Created by jackson on 1/9/14.
//  Copyright (c) 2014 jackson. All rights reserved.
//

#import "GameScene.h"
#import "JCJoystick.h"
#import "JCButton.h"

@interface GameScene ()
@property BOOL contentCreated;
@property (strong, nonatomic) JCJoystick *joystick;
@property (strong, nonatomic) JCButton *normalButton;
@property (strong, nonatomic) JCButton *helpButton;
@property (strong, nonatomic) JCButton *playButton;
@property (strong, nonatomic) SKLabelNode *myLabel;
@property (strong, nonatomic) SKSpriteNode *princess;
@property (strong, nonatomic) SKSpriteNode *brush;
@property (strong, nonatomic) SKShapeNode *textBox;
@property (strong, nonatomic) SKSpriteNode *background;
@property (strong, nonatomic) SKLabelNode *helpContent;
@property (strong, nonatomic) SKSpriteNode *zombie;
@property (nonatomic) BOOL usesPreciseCollisionDetection;
@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;

- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.background = [SKSpriteNode node];
    [self addChild:self.background];
    
    SKNode *background1 = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
    background1.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+50);
    background1.zPosition = -2;
    SKAction *scale = [SKAction scaleTo:0.6 duration:0];
    [background1 runAction:scale];
    
    [self.background addChild:background1];
    
    self.joystick = [[JCJoystick alloc] initWithControlRadius:20 baseRadius:29 baseColor:[SKColor blueColor] joystickRadius:20 joystickColor:[SKColor redColor]];
    self.joystick.zPosition = +1;
    [self.joystick setPosition:CGPointMake(35,35)];
    [self addChild:self.joystick];
    
    self.normalButton = [[JCButton alloc] initWithButtonRadius:25 color:[SKColor orangeColor] pressedColor:[SKColor blackColor] isTurbo:NO];
    [self.normalButton setPosition:CGPointMake(self.frame.size.width -40, 50)];
    self.normalButton.zPosition = +2;
    [self addChild:self.normalButton];
    
        SKLabelNode     *normalButtonTitle = [SKLabelNode node];
        normalButtonTitle.text = @"Fire";
        [normalButtonTitle setPosition:CGPointMake(0, -6.25)];
        normalButtonTitle.fontSize = 18;
        [self.normalButton addChild:normalButtonTitle];
    
    self.playButton = [[JCButton alloc] initWithButtonRadius:25 color:[SKColor greenColor] pressedColor:[SKColor blackColor] isTurbo:NO];
    [self.playButton setPosition:CGPointMake(CGRectGetMidX(self.frame)-142, 275)];
    self.playButton.zPosition = +2;
    [self addChild:self.playButton];
    
        SKLabelNode     *playButtonTitle = [SKLabelNode node];
        playButtonTitle.text = @"Play";
        [playButtonTitle setPosition:CGPointMake(0, -6.25)];
        playButtonTitle.fontSize = 18;
        [self.playButton addChild:playButtonTitle];
    
    self.helpButton = [[JCButton alloc] initWithButtonRadius:25 color:[SKColor redColor] pressedColor:[SKColor blackColor] isTurbo:NO];
    [self.helpButton setPosition:CGPointMake(CGRectGetMidX(self.frame), 275)];
    self.helpButton.zPosition = +1;
    [self addChild:self.helpButton];
    
        SKLabelNode     *helpButtonTitle = [SKLabelNode node];
        helpButtonTitle.text = @"Help";
        [helpButtonTitle setPosition:CGPointMake(0, -6.25)];
        helpButtonTitle.fontSize = 18;
        [self.helpButton addChild:helpButtonTitle];
    
    self.princess = [SKSpriteNode spriteNodeWithImageNamed:@"princess.png"];
    self.princess.position = CGPointMake(80, 125);
    self.princess.zPosition = -1;
    SKAction *zoom = [SKAction scaleTo:0.5 duration:0];
    [self.princess runAction:zoom];
    [self addChild:self.princess];
    
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    
    self.textBox = [SKShapeNode node];
    CGMutablePathRef  rectPath = CGPathCreateMutable();
    CGPathAddRect(rectPath, nil, CGRectMake(0, 0, 568, 100));
    self.textBox.path = rectPath;
    CGPathRelease(rectPath);
    self.textBox.fillColor =  [SKColor grayColor];
    self.textBox.lineWidth = 0;
    [self.textBox setPosition:CGPointMake(CGRectGetMidX(self.frame)-284, 225)];
    [self addChild:self.textBox];
}

- (void)isZombieTouching
{
    
}

- (void)checkButtons
{
    if (self.normalButton.isOn)
    {
        [self addBrushIn:CGPointMake(0,self.size.height-40)];
    }
    
    if (self.helpButton.isOn)
    {
        [self showHelp];
    }
    if (self.playButton.isOn)
    {
        [self playGame];
    }
}

- (void)playGame
{
    self.zombie = [SKSpriteNode node];
    [self addChild:self.zombie];
    
    int values[4] = {25, 50, 75, 100};
    int value = values[random() % 4];
    SKSpriteNode *zombieNA = [SKSpriteNode spriteNodeWithImageNamed:@"zombie.png"];
    zombieNA.position = CGPointMake(500, value);
    zombieNA.size = CGSizeMake(zombieNA.size.width*1.5, zombieNA.size.height*1.5);
    zombieNA.zPosition = -1;
    [self.zombie addChild:zombieNA];
    
    SKAction *moveZombie = [SKAction moveByX:-1.0 y:0 duration:0.1];
    [zombieNA runAction:[SKAction repeatActionForever:moveZombie]];
}

- (void)addBrushIn:(CGPoint)position
{
    if (self.brush == nil)
    {
        self.brush = [SKSpriteNode spriteNodeWithImageNamed:@"brush.png"];
        [self.brush setPosition:position];
        [self addChild:self.brush];
        
        SKAction *posy = [SKAction moveToY:self.princess.position.y duration:0];
        SKAction *move = [SKAction moveTo:CGPointMake(self.size.width+self.brush.size.width/2,self.princess.position.y) duration:1.25];
        SKAction *destroy = [SKAction removeFromParent];
        SKAction *clearBrush = [SKAction runBlock:^
                                {
                                    self.brush = nil;
                                }];
        [self.brush runAction:[SKAction sequence:@[posy, move, clearBrush, destroy]]];
    }
}

- (void)showHelp
{
    if (self.helpContent == nil)
    {
        self.helpContent = [SKLabelNode node];
        self.helpContent.text = @"Help";
        self.helpContent.fontSize = 18;
        self.helpContent.fontColor = [SKColor redColor];
        self.helpContent.zPosition = +2;
        [self.helpContent setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+10)];
        [self addChild:self.helpContent];
        
        SKLabelNode *helpContentLine2 = [SKLabelNode node];
        helpContentLine2.text = @" - Use Joystick to move up and down";
        helpContentLine2.fontSize = 18;
        helpContentLine2.fontColor = [SKColor redColor];
        helpContentLine2.zPosition = +2;
        [helpContentLine2 setPosition:CGPointMake(0, -20)];
        [self.helpContent addChild:helpContentLine2];
        
        SKLabelNode *helpContentLine3 = [SKLabelNode node];
        helpContentLine3.text = @" - Press the orange button to fire";
        helpContentLine3.fontSize = 18;
        helpContentLine3.fontColor = [SKColor redColor];
        helpContentLine3.zPosition = +2;
        [helpContentLine3 setPosition:CGPointMake(0, -40)];
        [self.helpContent addChild:helpContentLine3];
        
        SKLabelNode *helpContentLine4 = [SKLabelNode node];
        helpContentLine4.text = @" - Press the green button to start";
        helpContentLine4.fontSize = 18;
        helpContentLine4.fontColor = [SKColor redColor];
        helpContentLine4.zPosition = +2;
        [helpContentLine4 setPosition:CGPointMake(0, -60)];
        [self.helpContent addChild:helpContentLine4];
        
        SKLabelNode *helpContentLine5 = [SKLabelNode node];
        helpContentLine5.text = @" - Objective: KILL ZOMBIES";
        helpContentLine5.fontSize = 18;
        helpContentLine5.fontColor = [SKColor redColor];
        helpContentLine5.zPosition = +2;
        [helpContentLine5 setPosition:CGPointMake(0, -80)];
        [self.helpContent addChild:helpContentLine5];
        
        SKLabelNode *helpContentLine6 = [SKLabelNode node];
        helpContentLine6.text = @"Touch to Close";
        helpContentLine6.fontSize = 18;
        helpContentLine6.fontColor = [SKColor redColor];
        helpContentLine6.zPosition = +2;
        [helpContentLine6 setPosition:CGPointMake(0, -100)];
        [self.helpContent addChild:helpContentLine6];
        
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.5];
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
        SKAction *s = [SKAction sequence:@[fadeOut, fadeIn]];
        [helpContentLine6 runAction:[SKAction repeatActionForever:s]];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.helpContent != nil)
    {
        SKAction *hide = [SKAction fadeOutWithDuration:0.5];
        SKAction *clear = [SKAction runBlock:^
                           {
                               self.helpContent = nil;
                           }];
        SKAction *destroy = [SKAction removeFromParent];
        [self.helpContent runAction:[SKAction repeatActionForever:[SKAction sequence:@[hide, clear, destroy]]]];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    [self.princess setPosition:CGPointMake(self.princess.position.x, self.princess.position.y+self.joystick.y*2)];
    [self checkButtons];
    [self isZombieTouching];
}

@end