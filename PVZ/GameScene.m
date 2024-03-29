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
#import "JCActionButton.h"

@interface GameScene ()
@property BOOL contentCreated;
@property (strong, nonatomic) JCJoystick *joystick;
@property (strong, nonatomic) JCButton *normalButton;
@property (strong, nonatomic) JCActionButton *helpButton;
@property (strong, nonatomic) JCActionButton *hideHelpButton;
@property (strong, nonatomic) JCActionButton *hideStoreButton;
@property (strong, nonatomic) JCButton *playButton;
@property (strong, nonatomic) JCButton *resetButton;
@property (strong, nonatomic) JCButton *storeButton;
@property (strong, nonatomic) SKNode *storeContent;
@property (strong, nonatomic) SKSpriteNode *princess;
@property (strong, nonatomic) SKSpriteNode *brush;
@property (strong, nonatomic) SKSpriteNode *background;
@property (strong, nonatomic) SKSpriteNode *coinLabelPicture;
@property (strong, nonatomic) SKShapeNode *textBox;
@property (strong, nonatomic) SKShapeNode *helpBox;
@property (strong, nonatomic) SKLabelNode *helpContent;
@property (strong, nonatomic) SKLabelNode *gameOverLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *waveText;
@property (strong, nonatomic) SKLabelNode *zombiesKilledText;
@property (strong, nonatomic) SKLabelNode *coinLabel;
@property (strong, nonatomic) SKShapeNode *wall;
@property (nonatomic) NSInteger numZombiesKilled;
@property (nonatomic) NSInteger numZombiesAlive;
@property (nonatomic) NSInteger numPrincessLivesForTesting;
@property (nonatomic) NSInteger timesPressedStart;
@property (nonatomic) NSInteger canPressStart;
@property (nonatomic) NSInteger canNotPressReset;
@property (nonatomic) NSInteger numZombiesToSpawn;
@property (nonatomic) NSInteger numPrincessLives;
@property (nonatomic) NSInteger coins;
@property (nonatomic) NSInteger levelIsRunning;
@property (nonatomic) NSMutableArray *zombies;
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
static const uint32_t princessCategory       =  0x1 << 2;

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
    
    self.joystick = [[JCJoystick alloc] initWithControlRadius:25 baseRadius:34 baseColor:[SKColor blueColor] joystickRadius:25 joystickColor:[SKColor redColor]];
    self.joystick.zPosition = +5;
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
        playButtonTitle.text = @"Start";
        [playButtonTitle setPosition:CGPointMake(0, -6.25)];
        playButtonTitle.fontSize = 18;
        [self.playButton addChild:playButtonTitle];
    
    self.helpButton = [[JCActionButton alloc] initWithButtonRadius:30 color:[SKColor redColor] pressedColor:[SKColor blackColor] isTurbo:NO];
    self.helpButton.target = self;
    self.helpButton.selector = @selector(showHelp);
    [self.helpButton setPosition:CGPointMake(CGRectGetMidX(self.frame), 275)];
    self.helpButton.zPosition = +1;
    [self addChild:self.helpButton];
    
        SKLabelNode     *helpButtonTitle = [SKLabelNode node];
        helpButtonTitle.text = @"Help";
        [helpButtonTitle setPosition:CGPointMake(0, -6.25)];
        helpButtonTitle.fontSize = 18;
        [self.helpButton addChild:helpButtonTitle];
    
    self.resetButton = [[JCButton alloc] initWithButtonRadius:25 color:[SKColor redColor] pressedColor:[SKColor blackColor] isTurbo:NO];
    [self.resetButton setPosition:CGPointMake(CGRectGetMidX(self.frame)+142, 275)];
    self.resetButton.zPosition = +1;
    [self addChild:self.resetButton];
    
        SKLabelNode     *killButtonTitle = [SKLabelNode node];
        killButtonTitle.text = @"Reset";
        [killButtonTitle setPosition:CGPointMake(0, -6.25)];
        killButtonTitle.fontSize = 18;
        [self.resetButton addChild:killButtonTitle];
    
    self.storeButton = [[JCButton alloc] initWithButtonRadius:25 color:[SKColor blueColor] pressedColor:[SKColor blackColor] isTurbo:NO];
    [self.storeButton setPosition:CGPointMake(self.frame.size.width -40, 175)];
     self.storeButton.zPosition = +2;
    [self addChild:self.storeButton];
    
        SKLabelNode *storeButtonTitle = [SKLabelNode node];
        storeButtonTitle.text = @"Store";
        [storeButtonTitle setPosition:CGPointMake(0, -6.25)];
        storeButtonTitle.fontSize = 18;
        [self.storeButton addChild:storeButtonTitle];
    
    self.princess = [SKSpriteNode spriteNodeWithImageNamed:@"princess.png"];
    self.princess.position = CGPointMake(80, 125);
    self.princess.zPosition = -1;
    self.princess.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.princess.size.width/2];
    self.princess.physicsBody.dynamic = YES;
    self.princess.physicsBody.categoryBitMask = princessCategory;
    self.princess.physicsBody.contactTestBitMask = monsterCategory;
    self.princess.physicsBody.collisionBitMask = 0;
    self.princess.physicsBody.usesPreciseCollisionDetection = YES;
    SKAction *zoom = [SKAction scaleTo:0.5 duration:0];
    [self.princess runAction:zoom];
    [self addChild:self.princess];
    
    self.wall = [SKShapeNode node];
    CGMutablePathRef  rectPath1 = CGPathCreateMutable();
    CGPathAddRect(rectPath1, nil, CGRectMake(0, 0, 20, 320));
    self.wall.path = rectPath1;
    CGPathRelease(rectPath1);
    self.wall.fillColor = [SKColor grayColor];
    self.wall.lineWidth = 0;
    self.wall.zPosition = -1;
    [self.wall setPosition:CGPointMake(5, 0)];
    self.wall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.princess.size.width/2];
    self.wall.physicsBody.dynamic = YES;
    self.wall.physicsBody.categoryBitMask = princessCategory;
    self.wall.physicsBody.contactTestBitMask = monsterCategory;
    self.wall.physicsBody.collisionBitMask = 0;
    self.wall.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:self.wall];
    
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
    
    self.waveText = [SKLabelNode node];
    self.waveText.text = [NSString stringWithFormat:@"Wave #: %li", (long)self.numZombiesKilled];
    self.waveText.fontSize = 20;
    self.waveText.position = CGPointMake(CGRectGetMidX(self.frame), 25);
    self.waveText.fontColor = [SKColor blackColor];
    [self addChild:self.waveText];
    
    self.zombiesKilledText = [SKLabelNode node];
    self.zombiesKilledText.text = [NSString stringWithFormat:@"Zombies Killed: %li",(long)self.numZombiesKilled];
    self.zombiesKilledText.position = CGPointMake(CGRectGetMidX(self.frame), 7);
    self.zombiesKilledText.fontSize = 20;
    self.zombiesKilledText.fontColor = [SKColor blackColor];
    [self addChild:self.zombiesKilledText];
    
    self.helpBox = [SKShapeNode node];
    CGMutablePathRef  rectPath2 = CGPathCreateMutable();
    CGPathAddRect(rectPath2, nil, CGRectMake(0, 0, 568, 225));
    self.helpBox.path = rectPath2;
    CGPathRelease(rectPath2);
    self.helpBox.fillColor =  [SKColor grayColor];
    self.helpBox.lineWidth = 0;
    self.helpBox.zPosition = +1;
    [self.helpBox setPosition:CGPointMake(0, 0)];
    [self addChild:self.helpBox];
    
    self.gameOverLabel = [SKLabelNode node];
    self.gameOverLabel.text = @"Game Over";
    self.gameOverLabel.fontSize = 48;
    self.gameOverLabel.fontColor = [SKColor redColor];
    self.gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.gameOverLabel.name = @"GameOver";
    [self addChild:self.gameOverLabel];
    
    self.gameOverLabel.hidden = YES;
    
    self.scoreLabel = [SKLabelNode node];
    self.scoreLabel.fontSize = 48;
    self.scoreLabel.fontColor = [SKColor redColor];
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-52);
    self.scoreLabel.name = @"ScoreText";
    [self addChild:self.scoreLabel];
    
    self.coinLabel = [SKLabelNode node];
    self.coinLabel.fontSize = 24;
    self.coinLabel.fontColor = [SKColor redColor];
    self.coinLabel.position = CGPointMake(self.frame.size.width -40, 250);
    self.coinLabel.zPosition = +3;
    [self addChild:self.coinLabel];
    
        self.coinLabelPicture = [SKSpriteNode spriteNodeWithImageNamed:@"coin"];
        self.coinLabelPicture.position = CGPointMake(-30, 10);
        self.coinLabelPicture.zPosition = +2;
        [self.coinLabel addChild:self.coinLabelPicture];
    
    self.scoreLabel.hidden = YES;
    
    self.slider.hidden = YES;
    
    self.helpBox.hidden = YES;
    
    self.numPrincessLivesForTesting = 1;
    
    self.zombies = [[NSMutableArray alloc] init];
    
    self.canPressStart = 1;
    
    self.canNotPressReset = 0;
    
    self.numPrincessLives = 1;
    
    self.levelIsRunning = 0;
}

- (void)checkButtons
{
    if (self.numPrincessLivesForTesting == 1)
    {
        if (self.normalButton.isOn)
        {
            [self addBrushIn:CGPointMake(0,self.size.height-40)];
        }
        
        if (self.playButton.isOn)
        {
            if (self.canPressStart == 1)
            {
                self.timesPressedStart++;
                
                if (self.zombieSpeed == 0)
                {
                    self.zombieSpeed = -1;
                }
                
                self.zombieSpeed = self.zombieSpeed * self.timesPressedStart;
                NSLog(@"Increased zombie speed by 1 to:%f", self.zombieSpeed);
                
                self.canPressStart = 0;
                
                [self playGame:self.numZombiesToSpawn];
            }
        }
        
        if (self.storeButton.isOn)
        {
            [self store];
        }
    }
    
    if (self.canNotPressReset == 0)
    {
        if (self.resetButton.isOn)
        {
            self.canNotPressReset++;
            [self reset];
            NSLog(@"Reseting...");
        }
    }
}

- (void)store
{
    if (self.storeContent == nil)
    {
        self.helpBox.hidden = NO;
        
        self.storeButton.hidden = YES;
        
        self.normalButton.hidden = YES;
        
        self.joystick.hidden = YES;
        
        self.hideStoreButton = [[JCActionButton alloc] initWithButtonRadius:25 color:[SKColor greenColor] pressedColor:[SKColor blackColor] isTurbo:NO];
        self.hideStoreButton.position = CGPointMake(self.frame.size.width -40, 175);
        self.hideStoreButton.target = self;
        self.hideStoreButton.selector = @selector(hideStore);
        self.hideStoreButton.zPosition = +2;
        [self addChild:self.hideStoreButton];
        
        SKLabelNode *hideStoreButtonTitle = [SKLabelNode node];
        hideStoreButtonTitle.text = @"Back";
        hideStoreButtonTitle.position = CGPointMake(0, -6.25);
        hideStoreButtonTitle.fontSize = 18;
        [self.hideStoreButton addChild:hideStoreButtonTitle];
        
        self.storeContent = [SKNode node];
        self.storeContent.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.storeContent];
        
        SKSpriteNode *healthPack = [SKSpriteNode spriteNodeWithImageNamed:@"healthPack"];
        //healthPack.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        healthPack.zPosition = +2;
        [self.storeContent addChild:healthPack];
        
        JCActionButton *healthPackBuyButton = [[JCActionButton alloc] initWithButtonRadius:25 color:[SKColor blueColor] pressedColor:[SKColor blackColor] isTurbo:NO];
        healthPackBuyButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        healthPackBuyButton.zPosition = +5;
        healthPackBuyButton.target = self;
        healthPackBuyButton.selector = @selector(buyHealthPack);
        healthPackBuyButton.name = @"button1";
        [self addChild:healthPackBuyButton];
        
            SKLabelNode *healthPackBuyButtonTitle = [SKLabelNode node];
            healthPackBuyButtonTitle.text = @"Buy";
            healthPackBuyButtonTitle.position = CGPointMake(0, -6.25);
            healthPackBuyButtonTitle.fontSize = 18;
            [healthPackBuyButton addChild:healthPackBuyButtonTitle];
    }
}

- (void)hideStore
{
    if (self.storeContent != nil)
    {
        self.helpBox.hidden = YES;
        
        self.storeButton.hidden = NO;
        
        self.joystick.hidden = NO;
        
        self.normalButton.hidden = NO;
        
        SKNode *button1 = [self childNodeWithName:@"button1"];
        
        SKAction *destroy = [SKAction removeFromParent];
        
        [self.storeContent runAction:[SKAction sequence:@[destroy]]];
        [self.hideStoreButton runAction:[SKAction sequence:@[destroy]]];
        [button1 runAction:[SKAction sequence:@[destroy]]];
        
        self.storeContent = nil;
    }
}

- (void)buyHealthPack
{
    NSLog(@"Checking coins");
    if (self.coins == 3)
    {
        self.numPrincessLives++;
        self.coins-=3;
        NSLog(@"Added one life");
    }
    else
    {
        NSLog(@"Not enough coins");
    }
}

- (void)reset
{
    self.numPrincessLives = 1;
    self.numZombiesKilled = 0;
    self.zombieSpeed = 0;
    self.numPrincessLivesForTesting = 1;
    self.timesPressedStart = 0;
    self.numZombiesAlive = 0;
    self.canPressStart = 1;
    SKAction *hide = [SKAction fadeOutWithDuration:0];
    SKAction *show = [SKAction fadeInWithDuration:0];
    
    self.gameOverLabel.hidden = YES;
    self.scoreLabel.hidden = YES;
    
    [self.princess runAction:show];
    
    for (SKSpriteNode *aZombie in self.zombies)
    {
        SKNode *ash = [aZombie childNodeWithName:@"ash"];
        SKAction *d = [SKAction removeFromParent];
        [ash runAction:[SKAction sequence:@[hide, d]]];
    }
}

- (void)killZ:(SKSpriteNode*)aZombie
{
    if (self.numPrincessLivesForTesting == 1)
    {
        self.numZombiesKilled++;
    }
    
    NSLog(@"zombieCount++ to %li",(long)self.numZombiesKilled);
    SKNode   *body = [aZombie childNodeWithName:@"body"];
    [body removeFromParent];
    
    SKSpriteNode *zombieD = [SKSpriteNode spriteNodeWithImageNamed:@"ash.png"];
    zombieD.zPosition = -1;
    zombieD.name = @"ash";
    [aZombie addChild:zombieD];
    
    [aZombie removeAllActions];
    
    self.numZombiesAlive -= 1;
    
    if (self.numZombiesAlive == 0)
    {
        self.canPressStart = 1;
    }
}


- (void)addBrushIn:(CGPoint)position
{
    if (self.brush == nil)
    {
        self.brush = [SKSpriteNode spriteNodeWithImageNamed:@"brush.png"];
        [self.brush setPosition:position];
        self.brush.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.brush.size.width/2];
        self.brush.physicsBody.dynamic = YES;
        self.brush.physicsBody.categoryBitMask = projectileCategory;
        self.brush.physicsBody.contactTestBitMask = monsterCategory;
        self.brush.physicsBody.collisionBitMask = 0;
        self.brush.physicsBody.usesPreciseCollisionDetection = YES;
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

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"physicsContact = %@", contact);
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
    if ((firstBody.categoryBitMask & monsterCategory) != 0 &&
        (secondBody.categoryBitMask & princessCategory) != 0)
    {
        [self zombie:(SKSpriteNode *) firstBody.node didCollideWithPrincess:(SKSpriteNode *) secondBody.node];
    }
    if ((firstBody.categoryBitMask & monsterCategory) != 0 &&
        (secondBody.categoryBitMask & princessCategory) != 0)
    {
        [self zombie:(SKSpriteNode *) firstBody.node didCollideWithWall:(SKShapeNode *) secondBody.node];
    }
}

- (void)projectile:(SKSpriteNode *)brush didCollideWithMonster:(SKSpriteNode *)zombieBody
{
    NSLog(@"Hit");
    if (brush == self.brush)
    {
        [self.brush removeFromParent];
        self.brush = nil;
    }
    
    for (SKSpriteNode *aZombie in self.zombies)
    {
        if (zombieBody == [aZombie childNodeWithName:@"body"])
        {
            [self killZ:aZombie];
        }
    }
}

- (void)zombie:(SKSpriteNode *)zombieBody didCollideWithPrincess:(SKSpriteNode *)princess
{
    self.numPrincessLives--;
    
    if (self.numPrincessLives <= 0)
    {
        NSLog(@"PrincessDIE");
        if (princess == self.princess)
        {
            [self princessMustDie];
        }
        
        for (SKSpriteNode *aZombie in self.zombies)
        {
            if (zombieBody == [aZombie childNodeWithName:@"body"])
            {
                [self killZ:aZombie];
            }
        }
    }
    else
    {
        for (SKSpriteNode *aZombie in self.zombies)
        {
            if (zombieBody == [aZombie childNodeWithName:@"body"])
            {
                [self killZ:aZombie];
            }
        }
    }
}

- (void)zombie:(SKSpriteNode *)zombieBody didCollideWithWall:(SKShapeNode *)wall
{
    self.numPrincessLives--;
    
    if (self.numPrincessLives <=0)
    {
        NSLog(@"PrincessDIE");
        if (wall == self.wall)
        {
            [self princessMustDie];
        }
        
        for (SKSpriteNode *aZombie in self.zombies)
        {
            if (zombieBody == [aZombie childNodeWithName:@"body"])
            {
                [self killZ:aZombie];
            }
        }
    }
}

- (void)princessMustDie
{
    self.numPrincessLivesForTesting = 0;
    
    SKAction *hide = [SKAction fadeOutWithDuration:0.1];
    SKAction *show = [SKAction fadeInWithDuration:0.1];
    SKAction *wait = [SKAction waitForDuration:0.5];
    [self.princess runAction:[SKAction sequence:@[hide, wait, show, wait, hide, wait, show, wait, hide]]];
    
    self.gameOverLabel.hidden = NO;
    self.scoreLabel.hidden = NO;
    
    for (SKSpriteNode *aZombie in self.zombies)
    {
        [aZombie removeFromParent];
    }
}

- (void)playGame:(NSUInteger)numberOfZombies
{
    if (self.numZombiesAlive == 0)
    {
        for (SKSpriteNode *aZombie in self.zombies)
        {
            [aZombie removeFromParent];
        }
        [self.zombies removeAllObjects];
        
        self.levelIsRunning = 1;
        
        while (self.numZombiesAlive < numberOfZombies)
        {
            self.numZombiesAlive += 1;
            
            SKSpriteNode    *zombie = [SKSpriteNode node];
            
            int values[15] = {12, 25, 37, 50, 62, 75, 87, 100, 112, 125, 137, 150, 162, 175, 187};
            int value = values[random() % 15];
            zombie.position = CGPointMake(500, value);
            
            SKSpriteNode *zombieNA = [SKSpriteNode spriteNodeWithImageNamed:@"zombieChar.png"];
            zombieNA.size = CGSizeMake(zombieNA.size.width*0.04, zombieNA.size.height*0.04);
            zombieNA.zPosition = -1;
            zombieNA.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:zombieNA.size];
            zombieNA.physicsBody.dynamic = YES;
            zombieNA.physicsBody.categoryBitMask = monsterCategory;
            zombieNA.physicsBody.contactTestBitMask = projectileCategory;
            zombieNA.physicsBody.collisionBitMask = 0;
            zombieNA.name = @"body";
            [zombie addChild:zombieNA];
            
            SKAction *moveZombie = [SKAction moveByX:self.zombieSpeed y:0 duration:0.1];
            [zombie runAction:[SKAction repeatActionForever:[SKAction sequence:@[moveZombie]]]];
            
            [self addChild:zombie];
            [self.zombies addObject:zombie];
        }
    }
}


- (void)showHelp
{
    if (self.helpContent == nil)
    {
        self.helpBox.hidden = NO;
        
        self.normalButton.hidden = YES;
        
        self.joystick.hidden = YES;
        
        self.storeButton.hidden = YES;
        
        self.helpContent = [SKLabelNode node];
        self.helpContent.text = @"Help";
        self.helpContent.fontSize = 18;
        self.helpContent.fontColor = [SKColor redColor];
        self.helpContent.zPosition = +2;
        [self.helpContent setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+40)];
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

        SKLabelNode *sliderText = [SKLabelNode node];
        sliderText.text = @"Zombie Spawn";
        sliderText.fontSize = 18;
        sliderText.fontColor = [SKColor greenColor];
        sliderText.zPosition = +2;
        sliderText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
        sliderText.name = @"sliderText";
        [self addChild:sliderText];
        
        self.hideHelpButton = [[JCActionButton alloc] initWithButtonRadius:25 color:[SKColor greenColor] pressedColor:[SKColor blackColor] isTurbo:NO];
        self.hideHelpButton.target = self;
        self.hideHelpButton.selector = @selector(hideHelp);
        [self.hideHelpButton setPosition:CGPointMake(self.frame.size.width -40, 175)];
        self.hideHelpButton.zPosition = +5;
        [self addChild:self.hideHelpButton];
        
            SKLabelNode *hideHelpButtonTitle = [SKLabelNode node];
            hideHelpButtonTitle.text = @"Back";
            [hideHelpButtonTitle setPosition:CGPointMake(0, -6.25)];
            hideHelpButtonTitle.fontSize = 18;
            [self.hideHelpButton addChild:hideHelpButtonTitle];
        
        self.slider.hidden = NO;
    }
}


- (void)hideHelp
{
    if (self.helpContent != nil)
    {
        SKAction *hide = [SKAction fadeOutWithDuration:0.5];
        SKAction *clear = [SKAction runBlock:^
                           {
                               self.helpContent = nil;
                           }];
        SKAction *destroy = [SKAction removeFromParent];
        [self.helpContent runAction:[SKAction sequence:@[hide, clear, destroy]]];
        
        [self.hideHelpButton runAction:[SKAction sequence:@[clear, destroy]]];
        
        SKNode *sliderText = [self childNodeWithName:@"sliderText"];
        
        [sliderText runAction:[SKAction sequence:@[hide, clear, destroy]]];
        
        self.helpBox.hidden = YES;
        
        self.slider.hidden = YES;
        
        self.normalButton.hidden = NO;
        
        self.joystick.hidden = NO;
        
        self.storeButton.hidden = NO;
        
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    [self.princess setPosition:CGPointMake(self.princess.position.x, self.princess.position.y+self.joystick.y*2)];
    [self checkButtons];
    self.waveText.text = [NSString stringWithFormat:@"Wave #: %li", (long)self.timesPressedStart];
    self.zombiesKilledText.text = [NSString stringWithFormat:@"Zombies Killed: %lli",(long long)self.numZombiesKilled];
    self.scoreLabel.text = [NSString stringWithFormat:@"Your Score: %lli",(long long)self.numZombiesKilled];
    self.coinLabel.text = [NSString stringWithFormat:@"%lli",(long long)self.coins];
    
    self.numZombiesToSpawn = self.slider.value;
    
    if (self.levelIsRunning == 1)
    {
        if (self.numZombiesAlive == 0)
        {
            self.coins = self.numZombiesKilled;
            self.levelIsRunning = 0;
        }
    }
    
    if (self.numPrincessLivesForTesting == 0)
    {
        if (self.canNotPressReset != 0)
        {
            self.canNotPressReset = 0;
        }
    }
}

@end