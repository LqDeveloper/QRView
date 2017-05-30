//
//  ScanViewController.m
//  相册
//
//  Created by liquan on 2017/3/8.
//  Copyright © 2017年 liquan. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

/*
 AVCaptureSession 会话对象。此类作为硬件设备输入输出信息的桥梁，承担实时获取设备数据的责任
 AVCaptureDeviceInput 设备输入类。这个类用来表示输入数据的硬件设备，配置抽象设备的port
 AVCaptureMetadataOutput 输出类。这个支持二维码、条形码等图像数据的识别
 AVCaptureVideoPreviewLayer 图层类。用来快速呈现摄像头获取的原始数据
 二维码扫描功能的实现步骤是创建好会话对象，用来获取从硬件设备输入的数据，并实时显示在界面上。在扫描到相应图像数据的时候，通过AVCaptureVideoPreviewLayer类型进行返回
 */

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureDeviceInput *input;
@property(nonatomic,strong)AVCaptureMetadataOutput *output;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;

//中间的扫描框
@property(nonatomic,strong)CAShapeLayer *scanRectLayer;
//灰色背景
@property(nonatomic,strong)CAShapeLayer *bgLayer;
//扫描线
@property(nonatomic,strong)CAShapeLayer *lineLayer;


@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2f];
    [self.view.layer addSublayer:self.previewLayer];
    [self.view.layer addSublayer:self.bgLayer];
    [self.view.layer addSublayer:self.lineLayer];
    [self.session startRunning];
}
/**
 视频输入设备
 */
-(AVCaptureDeviceInput *)input{
    if (!_input) {
        //获取输入设备（摄像头）
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //根据输入设备创建输入对象
        _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    }
    return _input;
}

/**
 数据输出对象
 */
-(AVCaptureMetadataOutput *)output{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理监听输出对象输出的数据，在主线程刷新
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置扫描的区域
        //AVCaptureVideoPreviewLayer 的frame (0,0,ScreenWidth,ScreenHeight) (x,y,w,h)
        //扫描区域在self.view 的frame ((ScreenWidth - 220)/2,100,220,220)
        //(x1,y1,w1,h1)
        //扫描区域 （y1/h,x1/w,h1/h,w1/w）
        _output.rectOfInterest = CGRectMake(100.0/ScreenHeight, ((ScreenWidth - 220)/2)/ScreenWidth, 220.0/ScreenHeight, 220.0/ScreenWidth);
        
    }
    return _output;
}

/**
 会话对象
 */
-(AVCaptureSession *)session{
    if (!_session) {
        //创建会话
        _session = [[AVCaptureSession alloc]init];
        //实现高质量的输出和摄像 默认值AVCaptureSessionPresetHigh 可以不写
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [self setupIODevice];
    }
    return _session;
}

//扫描视图
-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.bounds;
    }
    return _previewLayer;
}
/**
 *  配置输入输出设置
 */
-(void)setupIODevice{
    if ([self.session canAddInput:self.input]) {
        [_session addInput:_input];
    }
    if ([self.session canAddOutput:self.output]) {
        [_session addOutput:_output];
    }
    //告诉输出对象, 需要输出什么样的数据 (二维码还是条形码等) 要先创建会话才能设置
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//灰色背景
-(CAShapeLayer *)bgLayer{
    if (!_bgLayer) {
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.path = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        _bgLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        _bgLayer.mask = self.scanRectLayer;
    }
    return _bgLayer;
}
//扫描框
// 设置扫描范围
//
-(CAShapeLayer *)scanRectLayer{
    if (!_scanRectLayer){
     _scanRectLayer = [CAShapeLayer layer];
        
       CGRect rect = CGRectMake((ScreenWidth - 220)/2-1,100-1,220+2,220+2);
        CGRect bounds = [UIScreen mainScreen].bounds;
        if (!CGRectContainsRect(bounds, rect)) {
            return nil;
        }
    
        //获取preViewLayer的起始坐标 高度和宽度
        CGFloat boundsX = CGRectGetMinX(bounds);
        CGFloat boundsY = CGRectGetMinY(bounds);
        CGFloat boundsWidth = CGRectGetWidth(bounds);
        CGFloat boundsHeight = CGRectGetHeight(bounds);
        //获取中间透明矩形的起始坐标和高度宽度
        CGFloat minX = CGRectGetMinX(rect);
        CGFloat maxX = CGRectGetMaxX(rect);
        CGFloat minY = CGRectGetMinY(rect);
        CGFloat maxY = CGRectGetMaxY(rect);
        CGFloat width = CGRectGetWidth(rect);
       
        
        //添加路径
        UIBezierPath *path= [UIBezierPath bezierPathWithRect:CGRectMake(boundsX, boundsY, minX, boundsHeight)];
        [path  appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(minX, boundsY, width, minY)]];
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(maxX, boundsY, boundsWidth - maxX, boundsHeight)]];
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(minX, maxY, width, boundsHeight - maxY)]];
        
        
        _scanRectLayer.path = path.CGPath;
    }
    return _scanRectLayer;
}

-(CAShapeLayer *)lineLayer{
    if (!_lineLayer) {
        //和扫描区域一致 加上1边框宽度
        CGRect rect = CGRectMake((ScreenWidth - 220)/2-1,100-1,220+2,220+2);
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.strokeColor = [UIColor greenColor].CGColor;
        
    }
    return _lineLayer;

}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  二维码扫描数据返回
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        NSLog(@"%@",metadataObject.stringValue);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
