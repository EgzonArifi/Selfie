//
//  YCameraViewController.m
//  Selfie
//
//  Created by Egzon Arifi on 5/18/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "YCameraViewController.h"
#import <ImageIO/ImageIO.h>
#import <Social/Social.h>
#import "EAAlertView.h"
#import "UIView+draggable.h"
#import "LGSemiModalNavViewController.h"
#import "StickersCollectionController.h"
#import "CameraCollectionStickers.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)


@interface YCameraViewController ()<SelectedStickerDelegate,CameraStickerDelegate> {
    UIInterfaceOrientation orientationLast, orientationAfterProcess;
    CMMotionManager *motionManager;
    CameraCollectionStickers *cameraCollectionStickers;
    BOOL isSetSticker;
}
@property (weak, nonatomic) IBOutlet UIButton *stickerButton;

@end

@implementation YCameraViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    
    self = [storyboard instantiateViewControllerWithIdentifier:@"YCameraViewController"];
    
    if(self) {
        //default initialization
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isSetSticker = NO;
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //    }
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    // Do any additional setup after loading the view.
    pickerDidShow = NO;
    
    FrontCamera = NO;
    self.captureImage.hidden = YES;
    
    // Setup UIImagePicker Controller
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    
    croppedImageWithoutOrientation = [[UIImage alloc] init];
    
    initializeCamera = YES;
    photoFromCam = YES;
    
    // Set auto-flash initially
    self.flashToggleButton.tag = AVCaptureFlashModeAuto;
    
    // Initialize Motion Manager
    [self initializeMotionManager];
    
    [self.stickerImageView setUserInteractionEnabled:YES];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer:)];
    [self.videoContainerView addGestureRecognizer:pinchGestureRecognizer];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationWithGestureRecognizer:)];
    [self.videoContainerView addGestureRecognizer:rotationGestureRecognizer];
    
}
- (void)didSelectSticker:(NSString *)sticker {
    if (isSetSticker) {
        float currentScale = [[self.stickerImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        float minScale = 0.4;
        float maxScale = 3.0;
        float zoomSpeed = 1.5;
        float deltaScale = 2.1;
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(self.stickerImageView.transform, deltaScale, deltaScale);
        self.stickerImageView.transform = zoomTransform;
    }
    isSetSticker = NO;
    [self.stickerImageView setImage:[UIImage imageNamed:sticker]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (initializeCamera) {
        initializeCamera = NO;
        
        // Initialize camera
        [self initializeCamera];
    }
    [self.stickerHolderView enableDragging];
    self.stickerHolderView.cagingArea =  CGRectMake(0, 0, self.zoneToDrag.frame.size.width,self.zoneToDrag.frame.size.height);
    [CandidateModel searchCandidate:@"Avdullah Hoti" results:^(NSArray *candidatesArray) {
        self.stickersView = [[CameraStickersView alloc] initWithFrame:self.stickerContainerView.frame];
        self.stickersView.delegate = self;
        self.candidateModel = candidatesArray.firstObject;
        [self.stickersView configureList:self.candidateModel];
        [self.stickerContainerView addSubview:self.stickersView];
        [self.frameImage setImage:[UIImage imageNamed:[self.candidateModel getFrame]]];
    }];
    
    cameraCollectionStickers = [[CameraCollectionStickers alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
    cameraCollectionStickers.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[session stopRunning];
    //    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)dealloc {
    [_imagePreview release];
    [_captureImage release];
    [imgPicker release];
    imgPicker = nil;
    
    if (session)
        [session release], session=nil;
    
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer=nil;
    
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;
}

#pragma mark - CoreMotion Task
- (void)initializeMotionManager {
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = .2;
    motionManager.gyroUpdateInterval = .2;
    
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                            if (!error) {
                                                [self outputAccelertionData:accelerometerData.acceleration];
                                            }
                                            else{
                                                NSLog(@"%@", error);
                                            }
                                        }];
}

#pragma mark - UIAccelerometer callback

- (void)outputAccelertionData:(CMAcceleration)acceleration {
    UIInterfaceOrientation orientationNew;
    
    if (acceleration.x >= 0.75) {
        orientationNew = UIInterfaceOrientationLandscapeLeft;
    }
    else if (acceleration.x <= -0.75) {
        orientationNew = UIInterfaceOrientationLandscapeRight;
    }
    else if (acceleration.y <= -0.75) {
        orientationNew = UIInterfaceOrientationPortrait;
    }
    else if (acceleration.y >= 0.75) {
        orientationNew = UIInterfaceOrientationPortraitUpsideDown;
    }
    else {
        // Consider same as last time
        return;
    }
    
    if (orientationNew == orientationLast)
        return;
    
    //    NSLog(@"Going from %@ to %@!", [[self class] orientationToText:orientationLast], [[self class] orientationToText:orientationNew]);
    
    orientationLast = orientationNew;
}

#ifdef DEBUG
+ (NSString*)orientationToText:(const UIInterfaceOrientation)ORIENTATION {
    switch (ORIENTATION) {
        case UIInterfaceOrientationPortrait:
            return @"UIInterfaceOrientationPortrait";
        case UIInterfaceOrientationPortraitUpsideDown:
            return @"UIInterfaceOrientationPortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft:
            return @"UIInterfaceOrientationLandscapeLeft";
        case UIInterfaceOrientationLandscapeRight:
            return @"UIInterfaceOrientationLandscapeRight";
        case UIInterfaceOrientationUnknown:
            return @"UIInterfaceOrientationUnknown";
    }
    return @"Unknown orientation!";
}
#endif

#pragma mark - Camera Initialization

//AVCaptureSession to show live video feed in view
- (void)initializeCamera {
    if (session)
        [session release], session=nil;
    
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    if (captureVideoPreviewLayer)
        [captureVideoPreviewLayer release], captureVideoPreviewLayer=nil;
    
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    captureVideoPreviewLayer.frame = self.imagePreview.bounds;
    [self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self imagePreview];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera=nil;
    AVCaptureDevice *backCamera=nil;
    
    // check if device available
    if (devices.count == 0) {
        NSLog(@"No Camera Available");
        [self disableCameraDeviceControls];
        return;
    }
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        
        if ([backCamera hasFlash]){
            [backCamera lockForConfiguration:nil];
            if (self.flashToggleButton.tag==AVCaptureFlashModeAuto){
                [backCamera setFlashMode:AVCaptureFlashModeAuto];
            }
            else if(self.flashToggleButton.tag==AVCaptureFlashModeOn){
                [backCamera setFlashMode:AVCaptureFlashModeOn];
            }
            else{
                [backCamera setFlashMode:AVCaptureFlashModeOff];
            }
            [backCamera unlockForConfiguration];
            
            [self.flashToggleButton setEnabled:YES];
        } else {
            if ([backCamera isFlashModeSupported:AVCaptureFlashModeOff]) {
                [backCamera lockForConfiguration:nil];
                [backCamera setFlashMode:AVCaptureFlashModeOff];
                [backCamera unlockForConfiguration];
            }
            [self.flashToggleButton setEnabled:NO];
        }
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (error) {
            NSLog(@"ERROR: trying to open camera: %@", error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                        message:error.localizedFailureReason
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            [self cancel:self.cancelButton];
            return;
        }
        [session addInput:input];
    }
    
    if (FrontCamera) {
        [self.flashToggleButton setEnabled:NO];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (stillImageOutput)
        [stillImageOutput release], stillImageOutput=nil;
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}

- (IBAction)snapImage:(id)sender {
    [self.photoCaptureButton setEnabled:NO];
    
    if (!haveImage) {
        self.captureImage.image = nil; //remove old image from view
        self.captureImage.hidden = NO; //show the captured image view
        self.imagePreview.hidden = YES; //hide the live video feed
        [self capImage];
    } else {
        self.captureImage.hidden = YES;
        self.imagePreview.hidden = NO;
        haveImage = NO;
    }
}

- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    haveImage = YES;
    photoFromCam = YES;
    
    // Resize image to 640x640
    // Resize image
    //    NSLog(@"Image size %@",NSStringFromCGSize(image.size));
    
    UIImage *smallImage = [self imageWithImage:image scaledToWidth:640.0f]; //UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect cropRect = CGRectMake(0, 105, 640, 640);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    croppedImageWithoutOrientation = [[UIImage imageWithCGImage:imageRef] copy];
    
    UIImage *croppedImage = nil;
    //    assetOrientation = ALAssetOrientationUp;
    
    // adjust image orientation
    NSLog(@"orientation: %ld",(long)orientationLast);
    orientationAfterProcess = orientationLast;
    croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    [self.captureImage setImage:croppedImage];
    
    if (FrontCamera) {
        CGAffineTransform transform = self.captureImage.transform;
        transform = CGAffineTransformMakeScale(-1, 1);
        self.captureImage.transform = transform;
    } else {
        CGAffineTransform transform = self.captureImage.transform;
        transform = CGAffineTransformMakeScale(1, 1);
        self.captureImage.transform = transform;
    }
    
    [self setCapturedImage];
}

- (void)setCapturedImage {
    // Stop capturing image
    [session stopRunning];
    
    // Hide Top/Bottom controller after taking photo for editing
    [self hideControllers];
}

#pragma mark - Device Availability Controls
- (void)disableCameraDeviceControls {
    self.cameraToggleButton.enabled = NO;
    self.flashToggleButton.enabled = NO;
    self.photoCaptureButton.enabled = NO;
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (info) {
        photoFromCam = NO;
        
        UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (outputImage == nil) {
            outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        if (outputImage) {
            self.captureImage.hidden = NO;
            self.captureImage.image=outputImage;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            // Hide Top/Bottom controller after taking photo for editing
            [self hideControllers];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    initializeCamera = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button clicks
- (IBAction)switchToLibrary:(id)sender {
    
    if (session) {
        [session stopRunning];
    }
    
    //    self.captureImage = nil;
    
    //    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    imagePickerController.delegate = self;
    //    imagePickerController.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:NULL];
}

- (IBAction)skipped:(id)sender {
    
    if ([delegate respondsToSelector:@selector(yCameraControllerdidSkipped)]) {
        [delegate yCameraControllerdidSkipped];
    }
    
    // Dismiss self view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    if ([delegate respondsToSelector:@selector(yCameraControllerDidCancel)]) {
        [delegate yCameraControllerDidCancel];
    }
    
    // Dismiss self view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePhotoCapture:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didFinishPickingImage:)]) {
        [delegate didFinishPickingImage:self.captureImage.image];
    }
    
    // Dismiss self view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)retakePhoto:(id)sender {
    [self.photoCaptureButton setEnabled:YES];
    self.captureImage.image = nil;
    self.imagePreview.hidden = NO;
    // Show Camera device controls
    [self showControllers];
    
    haveImage=NO;
    //    [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    [session startRunning];
}

- (IBAction)switchCamera:(UIButton *)sender { //switch cameras front and rear cameras
    // Stop current recording process
    [session stopRunning];
    
    if (sender.selected) {  // Switch to Back camera
        sender.selected = NO;
        FrontCamera = NO;
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
    else {                  // Switch to Front camera
        sender.selected = YES;
        FrontCamera = YES;
        [self performSelector:@selector(initializeCamera) withObject:nil afterDelay:0.001];
    }
}

- (IBAction)toogleFlash:(UIButton *)sender{
    if (!FrontCamera) {
        
        NSArray *devices = [AVCaptureDevice devices];
        for (AVCaptureDevice *device in devices) {
            
            NSLog(@"Device name: %@", [device localizedName]);
            
            if ([device hasMediaType:AVMediaTypeVideo]) {
                
                if ([device position] == AVCaptureDevicePositionBack) {
                    NSLog(@"Device position : back");
                    if ([device hasFlash]){
                        
                        [device lockForConfiguration:nil];
                        
                        if (sender.tag==AVCaptureFlashModeAuto) { // Current flash mode is Auto, set it to On
                            [device setFlashMode:AVCaptureFlashModeOn];
                            sender.tag = AVCaptureFlashModeOn;
                            [sender setImage:[UIImage imageNamed:@"Flash On"] forState:UIControlStateNormal];
                        }
                        else if (sender.tag==AVCaptureFlashModeOn){ // Current flash mode is On, set it to Off
                            [device setFlashMode:AVCaptureFlashModeOff];
                            sender.tag = AVCaptureFlashModeOff;
                            [sender setImage:[UIImage imageNamed:@"Flash Off"] forState:UIControlStateNormal];
                        }
                        else{ // Current flash mode is Off, set it to Auto
                            [device setFlashMode:AVCaptureFlashModeAuto];
                            sender.tag = AVCaptureFlashModeAuto;
                            [sender setImage:[UIImage imageNamed:@"Flash Auto"] forState:UIControlStateNormal];
                        }
                        
                        [device unlockForConfiguration];
                        
                        break;
                    }
                }
            }
        }
    }
}

#pragma mark - UI Control Helpers
- (void)hideControllers {
    [self.stickerButton setHidden:YES];
    [UIView animateWithDuration:0.0 animations:^{
        //1)animate them out of screen
        self.photoBar.center = CGPointMake(self.photoBar.center.x, self.photoBar.center.y+116.0);
        self.topBar.center = CGPointMake(self.topBar.center.x, self.topBar.center.y-44.0);
        
        //2)actually hide them
        self.photoBar.alpha = 0.0;
        self.topBar.alpha = 0.0;
        
    } completion:nil];
}

- (void)showControllers {
    [self.stickerButton setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^{
        //1)animate them into screen
        self.photoBar.center = CGPointMake(self.photoBar.center.x, self.photoBar.center.y-116.0);
        self.topBar.center = CGPointMake(self.topBar.center.x, self.topBar.center.y+44.0);
        
        //2)actually show them
        self.photoBar.alpha = 1.0;
        self.topBar.alpha = 1.0;
        
    } completion:nil];
}

#pragma mark - Gestures
-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)pgr {
    CGPoint point = [pgr locationInView:self.videoContainerView];
    
    CGRect boundsRect = CGRectMake(-50, -50,self.videoContainerView.bounds.size.width+50,
                                   self.videoContainerView.bounds.size.height+50);
    if (pgr.state == UIGestureRecognizerStateChanged) {
        
        if (CGRectContainsPoint(boundsRect, point)) {
            CGPoint center = pgr.view.center;
            CGPoint translation = [pgr translationInView:pgr.view];
            center = CGPointMake(center.x + translation.x, center.y + translation.y);
            self.stickerHolderView.center = point;
        }
    }
    [pgr setTranslation:CGPointZero inView:pgr.view];
}
- (void)handlePinchWithGestureRecognizer:(UIPinchGestureRecognizer *)pinchGesture {
    //    self.stickerImageView.transform = CGAffineTransformScale(self.stickerImageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    //
    //    pinchGestureRecognizer.scale = 1.0;
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[self.stickerImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 0.3;
        float maxScale = 3.0;
        float zoomSpeed = .5;
        
        float deltaScale = pinchGesture.scale;
        
        // You need to translate the zoom to 0 (origin) so that you
        // can multiply a speed factor and then translate back to "zoomSpace" around 1
        deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
        
        // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
        //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
        //  A deltaScale of 1.0 will maintain the zoom size
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(self.stickerImageView.transform, deltaScale, deltaScale);
        self.stickerImageView.transform = zoomTransform;
        
        // Reset to 1 for scale delta's
        //  Note: not 0, or we won't see a size: 0 * width = 0
        pinchGesture.scale = 1;
    }
}
- (void)handleRotationWithGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    self.stickerImageView.transform = CGAffineTransformRotate(self.stickerImageView.transform, rotationGestureRecognizer.rotation);
    
    rotationGestureRecognizer.rotation = 0.0;
}

#pragma mark - Share
- (IBAction)postToFacebook:(id)sender {
    [self imageWithView:self.videoContainerView completion:^(UIImage *image) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:@"#BreziRepublikes"];
            [controller addImage:image];
            [self presentViewController:controller animated:YES completion:Nil];
        } else {
            [EAAlertView showMessage:@"Nuk e keni konfiguruar kete aplikacion" withTitle:@"Error"];
        }
    }];
}
- (IBAction)postToInstagram:(id)sender {
    [self imageWithView:self.videoContainerView completion:^(UIImage *image) {
        NSString *textToShare = @"#BreziRepublikes";
        
        NSArray *objectsToShare = @[textToShare, image];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }];
}
- (IBAction)postToTwitter:(id)sender {
    [self imageWithView:self.videoContainerView completion:^(UIImage *image) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"#BreziRepublikes"];
            [tweetSheet addImage:image];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        } else {
            [EAAlertView showMessage:@"Nuk e keni konfiguruar kete aplikacion" withTitle:@"Error"];
        }
    }];
}
- (IBAction)saveToCameraRoll:(id)sender {
    [self imageWithView:self.videoContainerView completion:^(UIImage *image) {
        if (image) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [EAAlertView showMessage:@"Imazhi u ruajt me sukses" withTitle:@"Sukses"];
        } else {
            [EAAlertView showMessage:@"Problem gjate ruajtjes" withTitle:@"Error"];
        }
    }];
}
- (void)imageWithView:(UIView *)view completion:(void (^)(UIImage *image))block {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    block(snapshotImage);
}
- (IBAction)stickerAction:(id)sender {
    /*StickersCollectionController *lgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StickersCollectionController"];
    LGSemiModalNavViewController *semiModal = [[LGSemiModalNavViewController alloc]initWithRootViewController:lgVC];
    semiModal.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*1.2);
    
    semiModal.backgroundShadeColor = [UIColor whiteColor];
    semiModal.animationSpeed = 0.35f;
    semiModal.tapDismissEnabled = YES;
    semiModal.backgroundShadeAlpha = 0.4;
    semiModal.scaleTransform = CGAffineTransformMakeScale(.94, .94);
    
    [self presentViewController:semiModal animated:YES completion:nil];*/
    [self.view addSubview:cameraCollectionStickers];
}
- (void)didSelectCameraCollectionSticker:(NSString *)sticker {
    isSetSticker = YES;
    float currentScale = [[self.stickerImageView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    float minScale = 0.4;
    float maxScale = 3.0;
    float zoomSpeed = 1.5;
    float deltaScale = 0.4;
    deltaScale = ((deltaScale - 1) * zoomSpeed) + 1;
    deltaScale = MIN(deltaScale, maxScale / currentScale);
    deltaScale = MAX(deltaScale, minScale / currentScale);
    CGAffineTransform zoomTransform = CGAffineTransformScale(self.stickerImageView.transform, deltaScale, deltaScale);
    self.stickerImageView.transform = zoomTransform;
    [self.stickerImageView setImage:[UIImage imageNamed:sticker]];
    [cameraCollectionStickers removeFromSuperview];
}
@end
