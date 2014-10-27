//
//  CSEDrawingView.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEDrawingView.h"
@interface CSEDrawingView()
{
    Boolean firstTouch;
    Boolean needsErase;
    Boolean inited;
    GLuint vertexBufferID;
    GLuint initID;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect,*effect;
@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@end



@implementation CSEDrawingView
@synthesize baseEffect;
@synthesize effect;
@synthesize  location;
@synthesize  previousLocation;
@synthesize savedImage;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        NSLog(@"enter iitWithCoder");
        self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        // Make the new context current
        [EAGLContext setCurrentContext:self.context];
        
        self.baseEffect = [[GLKBaseEffect alloc] init];
        self.effect = [[GLKBaseEffect alloc] init];
        
        // self.baseEffect.useConstantColor = GL_TRUE;
        // self.baseEffect.constantColor = GLKVector4Make();
        
        self.effect.useConstantColor=GL_FALSE;
        //translate UIView coordinate system to openGL coordinate system
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0,
                                                          self.bounds.size.width,
                                                          0,
                                                          self.bounds.size.height,
                                                          0.0f, 1.0f);
        self.baseEffect.transform.projectionMatrix = projectionMatrix;
        self.effect.transform.projectionMatrix=projectionMatrix;
        //set background color
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        
        glClear(GL_COLOR_BUFFER_BIT);
        
        /*
         needsErase = true;
         if(self.savedImage)
         {
         NSLog(@"init image");
         [self initView:self.savedImage];
         //inited=true;
         needsErase=false;
         }
         else
         {
         NSLog(@"no init image");
         
         }
         */
        // Generate, bind, and initialize contents of a buffer to be
        // stored in GPU memory
        needsErase=true;
        glGenBuffers(1,                // STEP 1
                     &vertexBufferID);
        glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                     vertexBufferID);
    }
    NSLog(@"before return from view initial");
    return self;
}


typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

- (void)initView:(UIImage *)image
{
    NSLog(@"initView()");
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    
    glGenBuffers(1, &initID);   //step 1
    glBindBuffer(GL_ARRAY_BUFFER, initID);//step 2
    
    //allocate memory
    static SceneVertex*	vertexBuffer = NULL;
	if(vertexBuffer == NULL)
		vertexBuffer = malloc(4 * sizeof(SceneVertex));
    //set four corner
    CGFloat minX,minY,maxX,maxY;
    minX = CGRectGetMinX(self.frame);
    minY = CGRectGetMinY(self.frame);
    maxX = CGRectGetMaxX(self.frame);
    maxY = CGRectGetMaxY(self.frame);
    
    
    vertexBuffer[0].positionCoords = GLKVector3Make(minX, maxY, 0);
    vertexBuffer[0].textureCoords = GLKVector2Make(0.0f, 0.0f);
    
    vertexBuffer[1].positionCoords = GLKVector3Make(minX, minY, 0);
    vertexBuffer[1].textureCoords = GLKVector2Make(0.0f, 1.0f);
    
    vertexBuffer[2].positionCoords = GLKVector3Make(maxX, minY, 0);
    vertexBuffer[2].textureCoords = GLKVector2Make(1.0f, 1.0f);
    
    vertexBuffer[3].positionCoords = GLKVector3Make(maxX, maxY, 0);
    vertexBuffer[3].textureCoords = GLKVector2Make(1.0f, 0.0f);
    
    
    glBufferData(GL_ARRAY_BUFFER, 4*sizeof(SceneVertex), vertexBuffer, GL_DYNAMIC_DRAW);//step 3
    
    //texture
    CGImageRef imageRef = [image CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader
                                   textureWithCGImage:imageRef
                                   options:nil
                                   error:NULL];
    self.effect.texture2d0.name = textureInfo.name;
    self.effect.texture2d0.target = textureInfo.target;
    
    //Drawing
    [self.effect prepareToDraw];
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//step 4
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, positionCoords)); //step 5
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//step 4 again
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, textureCoords));//step 5 again
    
	glLineWidth(5.0);
	// Draw
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
}

- (void) loadView:(UIImage *)userImage
{
    glClear(GL_COLOR_BUFFER_BIT);
    [self initView:userImage];
}

- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
    
    glBindBuffer(GL_ARRAY_BUFFER,
                 vertexBufferID);
    [self.baseEffect prepareToDraw];
    
    if(needsErase)
    {
        glClear(GL_COLOR_BUFFER_BIT);
        if(self.savedImage)
            [self initView:self.savedImage];
        needsErase = false;
    }
    
    //glClear(GL_COLOR_BUFFER_BIT);
	static GLfloat*	vertexBuffer = NULL;
	
	if(vertexBuffer == NULL)
		vertexBuffer = malloc(2 * 2 * sizeof(GLfloat));
	
    
	vertexBuffer[0]=start.x;
    vertexBuffer[1]=start.y;
    vertexBuffer[2]=end.x;
    vertexBuffer[3]=end.y;
    
	// Load data to the Vertex Buffer Object
	glBufferData(GL_ARRAY_BUFFER, 2*2*sizeof(GLfloat), vertexBuffer, GL_DYNAMIC_DRAW);
	
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
	glLineWidth(5.0);
	// Draw
	glDrawArrays(GL_LINES, 0, 2);
	
    
}



//TOUCH
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	location = [touch locationInView:self];
	location.y = bounds.size.height - location.y;
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect				bounds = [self bounds];
	UITouch*			touch = [[event touchesForView:self] anyObject];
    
	// Convert touch point from UIView referential to OpenGL one (upside-down flip)
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
	} else {
		location = [touch locationInView:self];
	    location.y = bounds.size.height - location.y;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
	}
    
	// Render the stroke
	[self renderLineFromPoint:previousLocation toPoint:location];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		previousLocation.y = bounds.size.height - previousLocation.y;
		[self renderLineFromPoint:previousLocation toPoint:location];
	}
}


-(void)changeColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    self.baseEffect.constantColor = GLKVector4Make(red,green,blue,1.0f);
}
@end
