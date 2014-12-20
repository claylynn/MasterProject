//
//  CSEDrawingViewController.m
//  story
//
//  Created by Chen on 10/26/14.
//  Copyright (c) 2014 sbu. All rights reserved.
//

#import "CSEDrawingViewController.h"

@interface CSEDrawingViewController ()
{
    GLuint vertexBufferID;
    GLuint initID;
}
@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property GLfloat lineWidth;
@end



@implementation CSEDrawingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CSEDrawingView *view = (CSEDrawingView *)self.view;
    //set drawing delegate
    view.drawingDelegate=self;
    //set context
    view.context = [[EAGLContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    //set baseEffect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor=GL_TRUE;
    self.baseEffect.constantColor=GLKVector4Make(1.0f,0.0f,0.0f,1.0f);
    //translate UIView coordinate system to openGL coordinate system
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0,
                                                      view.bounds.size.width,
                                                      0,
                                                      view.bounds.size.height,
                                                      0.0f, 1.0f);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
    self.lineWidth=5.0;
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glGenBuffers(1,                // STEP 1
                 &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
                 vertexBufferID);
}

typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

- (void)initView:(UIImage *)image
{
    NSLog(@"initView()");
    
    glGenBuffers(1, &initID);   //step 1
    glBindBuffer(GL_ARRAY_BUFFER, initID);//step 2
    
    //allocate memory
    static SceneVertex*	vertexBuffer = NULL;
	if(vertexBuffer == NULL)
		vertexBuffer = malloc(4 * sizeof(SceneVertex));
    //set four corner
    CGFloat minX,minY,maxX,maxY;
    minX = CGRectGetMinX(self.view.frame);
    minY = CGRectGetMinY(self.view.frame);
    maxX = CGRectGetMaxX(self.view.frame);
    maxY = CGRectGetMaxY(self.view.frame);
    
    
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
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    self.baseEffect.useConstantColor=GL_FALSE;
    //Drawing
    [self.baseEffect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//step 4
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, positionCoords)); //step 5
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//step 4 again
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex),
                          NULL+offsetof(SceneVertex, textureCoords));//step 5 again
    
	glLineWidth(self.lineWidth);
	// Draw
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    self.baseEffect.useConstantColor=GL_TRUE;

    
}

- (void)drawing:(CGPoint)start toPoint:(CGPoint)end
{
    
    glBindBuffer(GL_ARRAY_BUFFER,
                 vertexBufferID);
    [self.baseEffect prepareToDraw];
    
    
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
	glLineWidth(self.lineWidth);
	// Draw
	glDrawArrays(GL_LINES, 0, 2);
	
    
}

-(void)clear
{
    NSLog(@"clear");
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    [self.baseEffect prepareToDraw];
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (IBAction)loadImage:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];
    
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    [self initView:image];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"view will disappear");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear()");
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if(self.savedImage)
        [self initView:self.savedImage];
    
}

- (IBAction)colorButtonPressed:(UIButton *)sender {
    switch (sender.tag) {
            //red
        case 1:
            self.baseEffect.constantColor=GLKVector4Make(1.0f,0.0f,0.0f,1.0f);
            break;
            //green
        case 2:
            NSLog(@"tag");
            self.baseEffect.constantColor=GLKVector4Make(0.0f,1.0f,0.0f,1.0f);
            break;
            //blue
        case 3:
            self.baseEffect.constantColor=GLKVector4Make(0.0f,0.0f,1.0f,1.0f);
            break;
            //yellow
        case 4:
            self.baseEffect.constantColor=GLKVector4Make(1.0f,1.0f,0.0f,1.0f);
            break;
            //grey
        case 5:
            self.baseEffect.constantColor=GLKVector4Make(0.56f,0.56f,0.56f,1.0f);
            break;
            //black
        case 6:
            self.baseEffect.constantColor=GLKVector4Make(0.0f,0.0f,0.0f,1.0f);
            break;
            //white
        case 7:
            self.baseEffect.constantColor=GLKVector4Make(1.0f,1.0f,1.0f,1.0f);
            break;
            
        default:
            break;
    }
}

- (IBAction)widthButtonPressed:(UIButton *)sender {
    if (sender.tag == 1) {
        self.lineWidth-=1.0;
        if(self.lineWidth<1.0)
            self.lineWidth=1.0;
    }
    else{
        self.lineWidth+=1.0;
    }
}
@end
