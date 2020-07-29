//
//  AMImageSaver.m
//  AntMedia
//
//  Created by klaus zhang on 2018/7/12.
//  Copyright © 2018年 aspling. All rights reserved.
//
#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
#import "AMImageSaver.h"
#import <Photos/Photos.h>
//#import "APMLog+BusinessImplementedLog.h"
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[AMImageSaver ] "
@implementation AMImageSaver
#pragma mark - public
+(void)save:(UIImage *)image toAlbum:(NSString *)album{
    
    //判断当前用户授权
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus statusResult) {
                
                //statusResult 用户选择的授权
                if (statusResult == PHAuthorizationStatusDenied) {
                    //用户没有允许,什么都不做
                }else if (statusResult == PHAuthorizationStatusAuthorized){
                    [self doSaveImage:image toAlbum:album];
                }
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {
            NSLog(@"由于系统原因,没能保存成功");
        }
            break;
        case PHAuthorizationStatusDenied://说明之前已经被拒绝
        {
            // 提示用户,如想保存修改权限：【设置】-【隐私】-【照片】-【百思不得姐8】
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            [self doSaveImage:image toAlbum:album];
        }
            break;
            
    }
    
}

#pragma mark 相册处理

+ (PHAssetCollection *)assetCollectionWithAlbum:(NSString*)albumName{
    PHAssetCollection *result;
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *ac in assetCollections) {
        if ([ac.localizedTitle isEqualToString:albumName]) {
            result = ac;
            return result;
        }
    }
    //来到这里表明没有当前相册
    //创建相册
    __block NSString *assetCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        assetCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:nil];
    
    // 创建新相册
    return result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionID] options:nil].firstObject;
}

/**
 *  返回添加到相机胶卷中的图片
 */

+ (PHFetchResult *)saveImageToCameraRoll:(UIImage*)image
{
    __block NSString *assetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 添加图片到【Camera Roll(相机胶卷)】
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if(assetId){
        return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil];
    }else{
        return nil;
    }
}

/**
 *  保存图片到自定义相册
 */
+ (void)doSaveImage:(UIImage*)image toAlbum:(NSString *)album{
    NSDate *start = [NSDate date];
    PHAssetCollection *assetCollection = [self assetCollectionWithAlbum:album];
    PHFetchResult *assets;
    //图片
    assets = [self saveImageToCameraRoll:image];

    // 将刚才添加到【Camera Roll(相机胶卷)】中的图片, 顺便添加到【自定义相册】
    NSError *error;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//        [request insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
        [request addAssets:assets];
    } error:&error];
    
    // 错误判断
    if (error) {
        NSLog(@"保存失败！");
    } else {
        NSLog(@"保存成功！");
    }
    NSTimeInterval cost = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"save image to album,cost %.4fs",cost);
}

@end
#endif
#endif
