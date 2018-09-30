//
//  PDFViewController.m
//  ImageToPDFDemo
//
//  Created by zhangqq on 2018/9/30.
//  Copyright © 2018年 张强. All rights reserved.
//

#import "PDFViewController.h"
#import "ZQPDFManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface PDFViewController ()

@property(nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation PDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //第一步，取到拍照或者本地图片
    UIImage *image = [UIImage imageNamed:@"images.jpeg"];
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64, 300, 450)];
    imv.image = image;
    imv.contentMode = UIViewContentModeScaleAspectFill;
    imv.layer.masksToBounds = YES;
    [self.view addSubview:imv];
    
    //得到保存的照片。
    UIImage *saveImage = [self snapshotWithView:self.view];
    //将新生成的要保存的照片保存到本地相册
    [self saveImage:saveImage];
}


- (void)saveImage:(UIImage *)image{
    //ALAssetsLibrary如果是临时对象。执行完毕就会释放 保存的aseturl就会失效，找不到目标图片了，所以要声明成属性
    self.library = [[ALAssetsLibrary alloc] init];
    [self.library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            [self turnSelfViewToPDFWithAssetUrl:assetURL];
    }];
}

-(void)turnSelfViewToPDFWithAssetUrl:(NSURL *)url{
    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
    ZQPDFManager *manager = [ZQPDFManager new];
    [assetslibrary assetForURL:url
                   resultBlock:^(ALAsset *asset){
                       ALAssetRepresentation *rep = [asset defaultRepresentation];
                       CGImageRef iref = [rep fullScreenImage];
                       if (iref) {
                           UIImage *image = [UIImage imageWithCGImage:iref];
                           if (self.showType == ShowPDFTypeOrigin) {
                               [manager setupPDFDocumentNamed:@"111" width:screenWidth height:screenHeight];
                               [manager addImage:image
                                         atPoint:CGPointMake((screenWidth/2)-(image.size.width/2), 20)];
                           }else{
                              CGRect textRect = [manager addText:@"这是一个标题，专门给PDF加的大兄弟" withFrame:CGRectMake(60, 20, 200, 50) fontSize:17];
                               CGRect lineRect = [manager addLineWithFrame:CGRectMake(0, textRect.origin.y+15, screenWidth, 1) withColor:[UIColor redColor]];
                               [manager setupPDFDocumentNamed:@"111" width:screenWidth height:screenHeight];
                               [manager addImage:image
                                         atPoint:CGPointMake((screenWidth/2)-(image.size.width/2), lineRect.origin.y+40)];
                           }
                           
                           NSFileManager *manager = [NSFileManager defaultManager];
                           NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                           NSString *path = [paths lastObject];
                           NSString * path1 = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",@"111"]];
                           if ([manager fileExistsAtPath:path1]) {
                               NSLog(@"生成PDF文件成功l，路径：%@",path1);
                           }else{
                               NSLog(@"生成PDF文件失败");
                           }
                       }
                   }
                  failureBlock:^(NSError *error) {
                      NSLog(@"从图库获取图片失败: %@",error);
                  }];
}


//长度超过一个屏幕的view 通常是scrollview  转成image长图片
-(UIImage *) snapshotWithScrollView:(UIScrollView *)scrollView{
        UIImage* image = nil;
        UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
                CGRect savedFrame = scrollView.frame;
           scrollView.contentOffset = CGPointZero;
            scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width,
                                          scrollView.contentSize.height);
            [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
             image = UIGraphicsGetImageFromCurrentImageContext();
           scrollView.contentOffset = savedContentOffset;
              scrollView.frame = savedFrame;
    }
      UIGraphicsEndImageContext();
    if (image != nil) {
                return image;
           }
      return nil;
}

//长度不超过一个屏幕的view生成图片
-(UIImage *)snapshotWithView:(UIView *)view
{
        CGSize size = view.bounds.size;
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
}

@end
