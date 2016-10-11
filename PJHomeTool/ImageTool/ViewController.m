//
//  ViewController.m
//  ImageTool
//
//  Created by SanguineSB on 14/11/18.
//  Copyright (c) 2014年 HSB. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
{
    //调节尺寸选项栏
    //(1)自动调节尺寸框
    __weak IBOutlet NSButton *fitSizeBox;
    //(2)指定宽的输入框
    __weak IBOutlet NSTextField *widthSizeEdit;
    //(3)指定高的输入框
    __weak IBOutlet NSTextField *heightSizeEdit;
    
    
    //图片类型选项栏
    //(1)JPG选项框
    __weak IBOutlet NSButton *jpgBox;
    //(2)PNG选相框
    __weak IBOutlet NSButton *pngBox;
    
    
    //输出选项栏
    //(1)1x选项栏
    __weak IBOutlet NSButton *formatOneBox;
    //(2)2x选项栏
    __weak IBOutlet NSButton *formatTwoBox;
    //(3)3x选项栏
    __weak IBOutlet NSButton *formatThreeBox;
    
    
    //图片质量选项栏
    //(1)自动调节质量框（只适用于JPG图片，
    __weak IBOutlet NSButton *fitQualityBox;
    //(2)1x质量选项框
    __weak IBOutlet NSTextField *oneQualityEdit;
    //(3)2x质量选项框
    __weak IBOutlet NSTextField *twoQualityEdit;
    //(4)3x质量选项框
    __weak IBOutlet NSTextField *threeQualityEdit;
    
    
    //图片名字输入栏
    //(1)图片名字输入框
    __weak IBOutlet NSTextField *nameEdit;
    //(2)图片名字索引输入框
    __weak IBOutlet NSTextField *nameIndex;
    
    
    //图片名字（取最后一张转换后的图片名称）
    __weak IBOutlet NSTextField *messageImageName;
    //进度
    __weak IBOutlet NSTextField *rateStatus;
    
    //使用背景合成选项栏
    //(1)使用背景合成选项栏
    __weak IBOutlet NSButton *backgroundBox;
    //(2)打开背景按钮
    __weak IBOutlet NSButton *openBackgroundButton;
    //(3)使用的背景图片
    NSImage *backgroundImage;
    
    //当前打开的目录
    NSString *contentsPath;
    
    //打开图片URL数组
    NSArray *imagesURLArray;
    
    //保存最后的数据
    NSMutableArray *dataArray;
    
    //是否停止输出
    BOOL isStopInput;
    
    //停止输出按钮
    __weak IBOutlet NSButton *stopInputButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isStopInput = NO;
}

- (IBAction)choseSize:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [widthSizeEdit setEnabled:NO];
        [heightSizeEdit setEnabled:NO];
    }else {
        [widthSizeEdit setEnabled:YES];
        [heightSizeEdit setEnabled:YES];
    }
}

- (IBAction)choseType:(NSButton *)sender {
    if (sender.tag == 1) {
        [pngBox setState:!pngBox.state];
    }else {
        [jpgBox setState:!jpgBox.state];
    }
}

- (IBAction)choseQuality:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [oneQualityEdit setEnabled:NO];
        [twoQualityEdit setEnabled:NO];
        [threeQualityEdit setEnabled:NO];
    }else {
        [oneQualityEdit setEnabled:YES];
        [twoQualityEdit setEnabled:YES];
        [threeQualityEdit setEnabled:YES];
    }
}

- (IBAction)choseUseBackground:(NSButton *)sender {
    if (sender.state == NSOnState) {
        [openBackgroundButton setEnabled:YES];
    }else {
        [openBackgroundButton setEnabled:NO];
    }
}

- (IBAction)openImages:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:@[@"jpg",@"png",@"tga"]];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        imagesURLArray = [panel URLs];
        contentsPath = [[[[panel URLs] objectAtIndex:0] path] stringByDeletingLastPathComponent];//获取当前目录
    }
}

- (IBAction)openBackgroundImage:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"jpg",@"png",@"tga"]];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        backgroundImage = [[NSImage alloc] initWithContentsOfFile:[[panel URL] path]];
    }
}

- (IBAction)stopInput:(id)sender {
    isStopInput = YES;
}

- (void)saveData
{
    NSNumber *tempWidth = @0.0f;
    NSNumber *tempHeight = @0.0f;
    NSNumber *tempOneQuality = @0.8f;
    NSNumber *tempTwoQuality = @0.5f;
    NSNumber *tempThreeQuality = @0.5f;
    NSString *tempNameString = @"";
    NSString *tempNameIndexString = @"";
    
    NSMutableArray *tempFormatImageIndexArray = [NSMutableArray array];
    
    dataArray = [NSMutableArray array];
    
    //调节尺寸
    if (fitSizeBox.state == NSOffState) {
        tempWidth = [NSNumber numberWithFloat:[[widthSizeEdit stringValue] floatValue]];
        tempHeight = [NSNumber numberWithFloat:[[heightSizeEdit stringValue] floatValue]];
    }
    
    //图片质量
    if (fitQualityBox.state == NSOffState) {
        tempOneQuality = [NSNumber numberWithFloat:[[oneQualityEdit stringValue] floatValue]];
        tempTwoQuality = [NSNumber numberWithFloat:[[twoQualityEdit stringValue] floatValue]];
        tempThreeQuality = [NSNumber numberWithFloat:[[threeQualityEdit stringValue] floatValue]];
    }
    
    //名字
    if (!([nameEdit.stringValue length] > 0)) {
        tempNameString = nameEdit.stringValue;
    }
    else {
        tempNameString = nameEdit.stringValue;
    }
    
    if (!([nameIndex.stringValue length] > 0)) {
        tempNameIndexString = @"0";
    }
    else {
        tempNameIndexString = nameIndex.stringValue;
    }
    
    //输出
    if (formatOneBox.state == NSOnState) {
        [tempFormatImageIndexArray addObject:@"0"];
    }
    
    if (formatTwoBox.state == NSOnState) {
        [tempFormatImageIndexArray addObject:@"1"];
    }
    
    if (formatThreeBox.state == NSOnState) {
        [tempFormatImageIndexArray addObject:@"2"];
    }
    
    [dataArray addObject:tempWidth];//0
    [dataArray addObject:tempHeight];//1
    [dataArray addObject:tempOneQuality];//2
    [dataArray addObject:tempTwoQuality];//3
    [dataArray addObject:tempThreeQuality];//4
    [dataArray addObject:tempNameString];//5
    [dataArray addObject:tempFormatImageIndexArray];//6
}

- (IBAction)saveImages:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        
        //处理数据
        [self saveData];
        
        contentsPath = [[[[panel URLs] objectAtIndex:0] path] stringByDeletingPathExtension];//获取当前目录
        
        [messageImageName setStringValue:@"正在生成..."];
        [messageImageName setTextColor:[NSColor colorWithRed:255.0f/255.0f green:134.0f/255.0f blue:81.0f/255.0f alpha:1.0f]];
        
        [rateStatus setStringValue:[NSString stringWithFormat:@"进度:0%%            总共:%@",@(imagesURLArray.count)]];
        [rateStatus setTextColor:[NSColor colorWithRed:255.0f/255.0f green:134.0f/255.0f blue:81.0f/255.0f alpha:1.0f]];
        
        //停止输出按钮
        [stopInputButton setEnabled:YES];
        isStopInput = NO;
        
        //生成图片
        [self performSelector:@selector(produceImage) withObject:nil afterDelay:1.0f];
    }
}

- (void)produceImage
{
    //是否自动适应
    BOOL isFitSize = fitSizeBox.state;
    
    //是否为JPG格式
    BOOL isJPG = jpgBox.state;
    
    //获取宽
    CGFloat width = [dataArray[0] floatValue];
    
    //获取高
    CGFloat height = [dataArray[1] floatValue];
    
    //设置图片尺寸
    NSSize imageSize = {width,height};
    
    //屏幕分辨率，区分retina屏和非retina屏
    CGFloat screenScale = [[NSScreen mainScreen] backingScaleFactor];
    
    //1x图片质量
    CGFloat oneQuality = [dataArray[2] floatValue];
    
    //2x图片质量
    CGFloat twoQuality = [dataArray[3] floatValue];
    
    //3x图片质量
    CGFloat threeQuality = [dataArray[4] floatValue];
    
    //设置输出名字的颜色
    [messageImageName setTextColor:[NSColor colorWithRed:255.0f/255.0f green:134.0f/255.0f blue:81.0f/255.0f alpha:1.0f]];
    
    //以%d前面名字
    NSString *frontName;
    
    //以%d后面名字
    NSString *backName;
    
    if ([dataArray[5] length] != 0) {
        
        if (![dataArray[5] containsString:@"%d"])
        {
            frontName = dataArray[5];
            backName = @"";
        }
        else
        {
            NSInteger frontNumber = [dataArray[5] rangeOfString:@"%d"].location;
            frontName = [dataArray[5] substringToIndex:frontNumber];
            if ([dataArray[5] length] < (frontNumber + 2)) {
                backName = @"";
            }else {
                backName = [dataArray[5] substringFromIndex:frontNumber + 2];
            }
        }
    }
    
    if ([dataArray[6] count] <= 0) {
        [messageImageName setStringValue:@"请选择输出倍率！"];
        return;
    }
    
    NSInteger formatImageIndex = [[dataArray[6] objectAtIndex:0] integerValue];
    NSInteger formatImageNumber = [dataArray[6] count];
    
    __block NSSize orignImageSize;
    __block NSSize produceImageSize;
    
    
    //创建同步队列
    dispatch_queue_t serial_queue = dispatch_queue_create("ProduceImageSerialQueue", DISPATCH_QUEUE_SERIAL);
    
    //图片索引
    __block NSInteger imageIndex = [nameIndex.stringValue integerValue];
    
    //图片总数
    __block NSInteger imageSum = imagesURLArray.count;
    
    for (int i = 0; i < imagesURLArray.count; i++) {
        
        dispatch_async(serial_queue, ^{
            
            if (isStopInput) {
                [stopInputButton setEnabled:NO];
                return;
            }
            
            //图片类型
            NSString *imageType;
            
            //图片质量
            CGFloat quality = 0.0;
            
            
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:[imagesURLArray[i] path]];
            orignImageSize = image.size;
            
            
            for (NSInteger j = formatImageIndex; j < formatImageNumber; j++) {
                
                if (!isFitSize) {
                    [image setSize:imageSize];
                }
                
                if (j == 0) {
                    NSSize imageHalfSize = {image.size.width / screenScale / 2.0f,image.size.height /screenScale / 2.0f};
                    produceImageSize = imageHalfSize;
                    quality = oneQuality;
                }else if (j == 1) {
                    NSSize imageEqualSize = {orignImageSize.width / screenScale,orignImageSize.height / screenScale};
                    produceImageSize = imageEqualSize;
                    quality = twoQuality;
                }
                else if (j == 2) {
                    NSSize imageHalfMoreSize = {orignImageSize.width / screenScale * 1.5f,orignImageSize.height / screenScale * 1.5f};
                    produceImageSize = imageHalfMoreSize;
                    
                    quality = threeQuality;
                }
                
                [image setSize:produceImageSize];
                
                NSImage *bg = [backgroundImage copy];
                
                if (backgroundBox.state == NSOnState) {
                    if (backgroundImage) {
                        [bg lockFocus];
                        [bg setSize:NSMakeSize(produceImageSize.width * screenScale, produceImageSize.height * screenScale)];
                        [image drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
                    }
                }
                else {
                    [image lockFocus];
                }
                
                NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc]
                                              initWithFocusedViewRect:CGRectMake(0, 0,image.size.width, image.size.height)];
                NSData *imageData;
                if (isJPG) {
                    NSDictionary *imagePros = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:quality]
                                                                          forKey:NSImageCompressionFactor];
                    imageData = [imageRep representationUsingType:NSJPEGFileType properties:imagePros];
                    imageType = @".jpg";
                }else {
                    NSDictionary *imagePros = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:quality]
                                                                          forKey:NSImageCompressionFactor];
                    imageData = [imageRep representationUsingType:NSPNGFileType properties:imagePros];
                    imageType = @".png";
                }
                NSString *imageName;
                if (j == 0) {
                    if ([dataArray[5] length] == 0) {
                        imageName = [NSString stringWithFormat:@"%@/%ld%@",contentsPath,imageIndex,imageType];
                    }else {
                        
                        if (![dataArray[5] containsString:@"%d"])
                        {
                            imageName = [NSString stringWithFormat:@"%@/%@%@%@",contentsPath,frontName,backName,imageType];
                        }
                        else
                        {
                            imageName = [NSString stringWithFormat:@"%@/%@%ld%@%@",contentsPath,frontName,imageIndex,backName,imageType];
                        }
                    }
                }
                else if (j == 1) {
                    if ([dataArray[5] length] == 0) {
                        imageName = [NSString stringWithFormat:@"%@/%ld@2x%@",contentsPath,imageIndex,imageType];
                    }else {
                        
                        if (![dataArray[5] containsString:@"%d"])
                        {
                            imageName = [NSString stringWithFormat:@"%@/%@%@@2x%@",contentsPath,frontName,backName,imageType];
                        }
                        else
                        {
                            imageName = [NSString stringWithFormat:@"%@/%@%ld%@@2x%@",contentsPath,frontName,imageIndex,backName,imageType];
                        }
                    }
                }
                else if (j == 2) {
                    if ([dataArray[5] length] == 0) {
                        imageName = [NSString stringWithFormat:@"%@/%ld@3x%@",contentsPath,imageIndex,imageType];
                    }else {
                        
                        if (![dataArray[5] containsString:@"%d"])
                        {
                            imageName = [NSString stringWithFormat:@"%@/%@%@@3x%@",contentsPath,frontName,backName,imageType];
                        }
                        else
                        {
                            imageName = [NSString stringWithFormat:@"%@/%@%ld%@@3x%@",contentsPath,frontName,imageIndex,backName,imageType];
                        }
                    }
                }
                
                if (backgroundBox.state == NSOnState) {
                    if (bg) {
                        [bg unlockFocus];
                    }
                }
                else {
                    [image unlockFocus];
                }
                
                [imageData writeToFile:[imageName stringByExpandingTildeInPath] atomically:YES];
                
                if (j == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (i == (imagesURLArray.count - 1)) {
                            isStopInput = NO;
                            [rateStatus setStringValue:[NSString stringWithFormat:@"进度:100%%            总共:%@",@(imageSum)]];
                            [rateStatus setTextColor:[NSColor colorWithRed:34/255.0f green:198/255.0f blue:204.0f/255.0f alpha:1.0f]];
                            [messageImageName setStringValue:[imageName substringFromIndex:(contentsPath.length + 1)]];
                            [messageImageName setTextColor:[NSColor colorWithRed:34/255.0f green:198/255.0f blue:204.0f/255.0f alpha:1.0f]];
                        }
                        else {
                            [rateStatus setStringValue:[NSString stringWithFormat:@"进度:%.2f%%            总共:%@",imageIndex*100.0f/imageSum,@(imageSum)]];
                            [messageImageName setStringValue:[imageName substringFromIndex:(contentsPath.length + 1)]];
                        }
                    });
                }
            }
            
            imageIndex++;
        });
        
    }
}

@end
