/*
 *  Copyright 2016 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */
#if defined(__arm64__)
#ifdef ARTVC_ENABLE_LOCAL_DEMO_TEST
#import "ARTVCDemoSettingsVC.h"
#import "ARTVCDemoSettingsModel.h"
#import <APMUtils/APMLog.h>
#import <ARTVC/RTCMacros.h>
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, ARDSettingsSections) {
    ARDSettingsSectionUidConfig = 0,
    ARDSettingsSectionBiznameConfig,
    ARDSettingsSectionSubbizConfig,
#ifdef ARTVC_BUILD_FOR_MPAAS
    ARDSettingsSectionWorkspaceIdConfig,
#endif
    ARDSettingsSectionSignatureConfig,
    ARDSettingsSectionMediaConstraints,
    ARDSettingsSectionBitRate,
    ARDSettingsSectionFrameRate,
#ifndef ARTVC_BUILD_FOR_MPAAS
    ARDSettingsSectionServerConfig,
#endif
    ARDSettingsSectionCustomServerUrlConfig,
    ARDSettingsSectionDTLSConfig,
    ARDSettingsSectionRelayConfig,
    ARDSettingsSectionEnablePublishConfig,
    ARDSettingsSectionEnableSubscribeConfig,
    ARDSettingsSectionEnableFlexFECConfig,
    ARDSettingsSectionEnableBWEExperimentConfig,
    ARDSettingsSectionEnableInviteConfig,
    ARDSettingsSectionInviteeUidConfig,
    ARDSettingsSectionLiveUrlConfig,
    ARDSettingsSectionUseBloxWay,
    ARDSettingsSectionBeautyLevel,
    ARDSettingsSectionEnableVirtualBackground,
    ARDSettingsSectionPacingExperimentConfig,
    ARDSettingsSectionNackExperimentConfig,
    ARDSettingsSectionPlayoutDelayExperimentConfig,
    ARDSettingsSectionJitterExperimentConfig,
    ARDSettingsSectionMockedCloudConfigs,
    ARDSettingsSectionVideoSmoothRenderingExperimentConfig,
    ARDSettingsSectionLoopbackConfig,
    ARDSettingsSectionEnd
};

@interface ARTVCDemoSettingsVC ()
@property(nonatomic,strong) UITextField *framerateTF;
@property(nonatomic,strong) UITextField *bitrateTF;
@property(nonatomic,strong) UITextField *bweTF;
@property(nonatomic,strong) UITextField *inviteeUidTF;
@property(nonatomic,strong) UITextField *liveUrlTF;
@property(nonatomic,strong) UITextField *uidTF;
@property(nonatomic,strong) UITextField *biznameTF;
@property(nonatomic,strong) UITextField *subbizTF;
#ifdef ARTVC_BUILD_FOR_MPAAS
@property(nonatomic,strong) UITextField *workspaceIdTF;
#endif
@property(nonatomic,strong) UITextField *signatureTF;
@property(nonatomic,strong) UITextField *customServerUrlTF;
@property(nonatomic,strong) UITextField *beautyLevelTF;
@property(nonatomic,strong) UITextField *pacingExpeTF;
@property(nonatomic,strong) UITextField *nackExpeTF;
@property(nonatomic,strong) UITextField *playoutDelayExpeTF;
@property(nonatomic,strong) UITextField *jitterExpeTF;
@property(nonatomic,strong) UITextField *mockedConfigsTF;
@end

@implementation ARTVCDemoSettingsVC{
    ARTVCDemoSettingsModel *_settingsModel;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
                settingsModel:(ARTVCDemoSettingsModel *)settingsModel {
  self = [super initWithStyle:style];
  if (self) {
    _settingsModel = settingsModel;
  }
  return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Settings";
  [self addDoneBarButton];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self selectCurrentlyStoredOrDefaultMediaConstraints];
}

-(void)dealloc{
    APM_INFO(@"ARTVCDemoSettingsVC dealloc");
}

#pragma mark - Data source

- (NSArray<NSString *> *)mediaConstraintsArray {
  return _settingsModel.availableVideoResoultionsMediaConstraints;
}

#pragma mark -

- (void)addDoneBarButton {
  UIBarButtonItem *barItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                    target:self
                                                    action:@selector(dismissModally:)];
  self.navigationItem.leftBarButtonItem = barItem;
}

- (void)selectCurrentlyStoredOrDefaultMediaConstraints {
    NSString *currentSelection = [_settingsModel currentVideoResoultionConstraintFromStore];
    
    NSUInteger indexOfSelection = [[self mediaConstraintsArray] indexOfObject:currentSelection];
    //新增或者删除分辨率后，新版本升级时会因为数组越界crash
    if(indexOfSelection == NSNotFound){
        //默认选择第一个分辨率
        indexOfSelection = 0;
    }
    NSIndexPath *pathToBeSelected = [NSIndexPath indexPathForRow:indexOfSelection inSection:ARDSettingsSectionMediaConstraints];
    [self.tableView selectRowAtIndexPath:pathToBeSelected
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
    // Manully invoke the delegate method because the previous invocation will not.
    [self tableView:self.tableView didSelectRowAtIndexPath:pathToBeSelected];
}

#pragma mark - Dismissal of view controller

- (void)dismissModally:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return ARDSettingsSectionEnd;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([self sectionIsMediaConstraints:section]) {
    return self.mediaConstraintsArray.count;
  }

  return 1;
}

#pragma mark - Index path helpers
- (BOOL)sectionIsUidConfig:(NSInteger)section {
  return section == ARDSettingsSectionUidConfig;
}
- (BOOL)sectionIsBiznameConfig:(NSInteger)section {
  return section == ARDSettingsSectionBiznameConfig;
}
- (BOOL)sectionIsSubbizConfig:(NSInteger)section {
  return section == ARDSettingsSectionSubbizConfig;
}
#ifdef ARTVC_BUILD_FOR_MPAAS
- (BOOL)sectionIsWorkspaceIdConfig:(NSInteger)section {
  return section == ARDSettingsSectionWorkspaceIdConfig;
}
#endif
- (BOOL)sectionIsSignatureConfig:(NSInteger)section {
  return section == ARDSettingsSectionSignatureConfig;
}

- (BOOL)sectionIsMediaConstraints:(NSInteger)section {
  return section == ARDSettingsSectionMediaConstraints;
}

- (BOOL)sectionIsBitrate:(NSInteger)section {
  return section == ARDSettingsSectionBitRate;
}

- (BOOL)sectionIsFrameRate:(NSInteger)section {
    return section == ARDSettingsSectionFrameRate;
}
#ifndef ARTVC_BUILD_FOR_MPAAS
- (BOOL)sectionIsServerConfig:(NSInteger)section {
    return section == ARDSettingsSectionServerConfig;
}
#endif
- (BOOL)sectionIsCustomServerUrlConfig:(NSInteger)section {
    return section == ARDSettingsSectionCustomServerUrlConfig;
}

- (BOOL)sectionIsDtlsConfig:(NSInteger)section {
    return section == ARDSettingsSectionDTLSConfig;
}

- (BOOL)sectionIsRelayConfig:(NSInteger)section {
    return section == ARDSettingsSectionRelayConfig;
}
- (BOOL)sectionIsEnablePublishConfig:(NSInteger)section {
    return section == ARDSettingsSectionEnablePublishConfig;
}
- (BOOL)sectionIsEnableSubscribeConfig:(NSInteger)section {
    return section == ARDSettingsSectionEnableSubscribeConfig;
}
- (BOOL)sectionIsEnableFlexFECConfig:(NSInteger)section {
    return section == ARDSettingsSectionEnableFlexFECConfig;
}
- (BOOL)sectionIsBWEExperimentConfig:(NSInteger)section {
    return section == ARDSettingsSectionEnableBWEExperimentConfig;
}
- (BOOL)sectionIsEnableInviteConfig:(NSInteger)section {
    return section == ARDSettingsSectionEnableInviteConfig;
}
- (BOOL)sectionIsInviteeUidConfig:(NSInteger)section {
    return section == ARDSettingsSectionInviteeUidConfig;
}
- (BOOL)sectionIsLiveUrlConfig:(NSInteger)section {
    return section == ARDSettingsSectionLiveUrlConfig;
}
- (BOOL)sectionIsUseBloxWay:(NSInteger)section {
    return section == ARDSettingsSectionUseBloxWay;
}
- (BOOL)sectionIsBeautyLevel:(NSInteger)section {
    return section == ARDSettingsSectionBeautyLevel;
}
- (BOOL)sectionIsVirtualBackground:(NSInteger)section {
    return section == ARDSettingsSectionEnableVirtualBackground;
}
- (BOOL)sectionIsPacingExperimentConfig:(NSInteger)section {
    return section == ARDSettingsSectionPacingExperimentConfig;
}
- (BOOL)sectionIsNackExperimentConfig:(NSInteger)section {
    return section == ARDSettingsSectionNackExperimentConfig;
}
- (BOOL)sectionIsPlayoutDelayExperimentConfig:(NSInteger)section {
    return section == ARDSettingsSectionPlayoutDelayExperimentConfig;
}
- (BOOL)sectionIsJitterExperimentConfig:(NSInteger)section {
    return section == ARDSettingsSectionJitterExperimentConfig;
}
- (BOOL)sectionIsMockedCloudConfigs:(NSInteger)section {
    return section == ARDSettingsSectionMockedCloudConfigs;
}
- (BOOL)sectionIsVideoSmoothRenderingExperimentConfig:(NSInteger)section {
    return section == ARDSettingsSectionVideoSmoothRenderingExperimentConfig;
}
- (BOOL)sectionIsLoopbackConfig:(NSInteger)section {
    return section == ARDSettingsSectionLoopbackConfig;
}
- (BOOL)indexPathIsUidConfig:(NSIndexPath *)indexPath {
  return [self sectionIsUidConfig:indexPath.section];
}
- (BOOL)indexPathIsBiznameConfig:(NSIndexPath *)indexPath {
  return [self sectionIsBiznameConfig:indexPath.section];
}
- (BOOL)indexPathIsSubbizConfig:(NSIndexPath *)indexPath {
  return [self sectionIsSubbizConfig:indexPath.section];
}
#ifdef ARTVC_BUILD_FOR_MPAAS
- (BOOL)indexPathIsWorkspaceIdConfig:(NSIndexPath *)indexPath {
    return [self sectionIsWorkspaceIdConfig:indexPath.section];
}
#endif
- (BOOL)indexPathIsSignatureConfig:(NSIndexPath *)indexPath {
  return [self sectionIsSignatureConfig:indexPath.section];
}

- (BOOL)indexPathIsMediaConstraints:(NSIndexPath *)indexPath {
  return [self sectionIsMediaConstraints:indexPath.section];
}

- (BOOL)indexPathIsBitrate:(NSIndexPath *)indexPath {
  return [self sectionIsBitrate:indexPath.section];
}

- (BOOL)indexPathIsFrameRate:(NSIndexPath *)indexPath {
    return [self sectionIsFrameRate:indexPath.section];
}
#ifndef ARTVC_BUILD_FOR_MPAAS
- (BOOL)indexPathIsServerConfig:(NSIndexPath *)indexPath {
    return [self sectionIsServerConfig:indexPath.section];
}
#endif
- (BOOL)indexPathIsCustomServerUrlConfig:(NSIndexPath *)indexPath {
    return [self sectionIsCustomServerUrlConfig:indexPath.section];
}
- (BOOL)indexPathIsDTLSConfig:(NSIndexPath *)indexPath {
    return [self sectionIsDtlsConfig:indexPath.section];
}
- (BOOL)indexPathIsRelayConfig:(NSIndexPath *)indexPath {
    return [self sectionIsRelayConfig:indexPath.section];
}
- (BOOL)indexPathIsEnablePublishConfig:(NSIndexPath *)indexPath {
    return [self sectionIsEnablePublishConfig:indexPath.section];
}
- (BOOL)indexPathIsEnableSubscribeConfig:(NSIndexPath *)indexPath {
    return [self sectionIsEnableSubscribeConfig:indexPath.section];
}
- (BOOL)indexPathIsEnableFlexFECConfig:(NSIndexPath *)indexPath {
    return [self sectionIsEnableFlexFECConfig:indexPath.section];
}
- (BOOL)indexPathIsBWEExperimentConfig:(NSIndexPath *)indexPath {
    return [self sectionIsBWEExperimentConfig:indexPath.section];
}
- (BOOL)indexPathIsEnableInviteConfig:(NSIndexPath *)indexPath {
    return [self sectionIsEnableInviteConfig:indexPath.section];
}
- (BOOL)indexPathIsInviteeUidConfig:(NSIndexPath *)indexPath {
    return [self sectionIsInviteeUidConfig:indexPath.section];
}
- (BOOL)indexPathIsLiveUrlConfig:(NSIndexPath *)indexPath {
    return [self sectionIsLiveUrlConfig:indexPath.section];
}
- (BOOL)indexPathIsUseBloxWay:(NSIndexPath *)indexPath {
    return [self sectionIsUseBloxWay:indexPath.section];
}
- (BOOL)indexPathIsBeautyLevel:(NSIndexPath *)indexPath {
    return [self sectionIsBeautyLevel:indexPath.section];
}
- (BOOL)indexPathIsVirtualBackground:(NSIndexPath *)indexPath {
    return [self sectionIsVirtualBackground:indexPath.section];
}
- (BOOL)indexPathIsPacingExperimentConfig:(NSIndexPath *)indexPath {
    return [self sectionIsPacingExperimentConfig:indexPath.section];
}
- (BOOL)indexPathIsNackExperimentConfig:(NSIndexPath *)indexPath {
    return [self sectionIsNackExperimentConfig:indexPath.section];
}
- (BOOL)indexPathIsPlayoutDelayExperimentConfig:(NSIndexPath *)indexPath {
    return [self sectionIsPlayoutDelayExperimentConfig:indexPath.section];
}
- (BOOL)indexPathIsJitterExperimentConfig:(NSIndexPath *)indexPath {
    return [self sectionIsJitterExperimentConfig:indexPath.section];
}
- (BOOL)indexPathIsMockedCloudConfigs:(NSIndexPath *)indexPath {
    return [self sectionIsMockedCloudConfigs:indexPath.section];
}
- (BOOL)indexPathIsVideoSmoothRenderingExperimentConfig:(NSIndexPath *)indexPath {
    return [self sectionIsVideoSmoothRenderingExperimentConfig:indexPath.section];
}
- (BOOL)indexPathIsLoopbackConfig:(NSIndexPath *)indexPath {
    return [self sectionIsLoopbackConfig:indexPath.section];
}
#pragma mark - Table view delegate

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
    if ([self sectionIsUidConfig:section]) {
        return @"用户ID，需全局唯一，建议加业务前缀，避免uid冲突,该字段必须设置";
    }
    if ([self sectionIsBiznameConfig:section]) {
        return @"业务名称,该字段必须设置";
    }
#if defined(ARTVC_BUILD_FOR_MPAAS)
    if ([self sectionIsSubbizConfig:section]) {
        return @"AppId名称,,该字段为空则从配置文件读取，非空则使用该字段";
    }
#else
    if ([self sectionIsSubbizConfig:section]) {
        return @"业务子名称,该字段必须设置";
    }
#endif
#ifdef ARTVC_BUILD_FOR_MPAAS
    if ([self sectionIsWorkspaceIdConfig:section]) {
        return @"Workspace名称,该字段为空则从配置文件读取，非空则使用该字段";
    }
#endif
    if ([self sectionIsSignatureConfig:section]) {
        return @"签名信息,该字段必须设置";
    }
    if ([self sectionIsMediaConstraints:section]) {
        return @"编码后输出分辨率";
    }
    
    if ([self sectionIsBitrate:section]) {
        return @"最大码率Kbps,设置为0则由SDK自动控制码率";
    }
    
    if ([self sectionIsFrameRate:section]) {
        return @"帧率,设置大于15FPS时当前使用30FPS";
    }
#if defined(ARTVC_BUILD_FOR_MPAAS)
    if ([self sectionIsCustomServerUrlConfig:section]) {
        return @"自定义信令服务器环境URL,该字段为空则从配置文件读取，非空则使用该字段";
    }
#else
    if ([self sectionIsServerConfig:section]) {
        return @"信令服务器环境（开发过程中建议使用测试环境）";
    }
    if ([self sectionIsCustomServerUrlConfig:section]) {
        return @"自定义信令服务器环境URL,如果设置了则上述开关会失效";
    }
#endif
    if ([self sectionIsDtlsConfig:section]) {
        return @"数据加密，默认启用DTLS";
    }
    if ([self sectionIsRelayConfig:section]) {
        return @"强制走中转模式，默认为NO";
    }
    if ([self sectionIsEnablePublishConfig:section]) {
        return @"允许推流，默认为YES";
    }
    if ([self sectionIsEnableSubscribeConfig:section]) {
        return @"允许拉流，默认为YES";
    }
    if ([self sectionIsEnableFlexFECConfig:section]) {
        return @"开启FlecFEC-03，默认为NO,开启后video-timing功能会被关闭";
    }
    if ([self sectionIsBWEExperimentConfig:section]) {
        return @"BWE实验参数(丢包率，最低评估带宽)\n开启(首字母大写，其他小写):Enabled-0.02,0.1,300\n关闭(首字母大写，其他小写):Disabled";
    }
    if ([self sectionIsEnableInviteConfig:section]) {
        return @"允许CreateRoom后Invite对端";
    }
    if ([self sectionIsInviteeUidConfig:section]) {
        return @"对端UID,用于Invite请求";
    }
    if ([self sectionIsLiveUrlConfig:section]) {
        return @"RTMP推流地址";
    }
    
    if ([self sectionIsUseBloxWay:section]) {
        return @"使用智能音视频处理，默认为NO";
    }
    if ([self sectionIsBeautyLevel:section]) {
        return @"设置美颜级别(0~1),默认关闭\n0:关闭美颜 / 0~1:美颜级别";
    }
    if ([self sectionIsVirtualBackground:section]) {
        return @"开启虚拟背景,默认关闭";
    }
    if ([self sectionIsPacingExperimentConfig:section]) {
        return @"Pacing实验";
    }
    if ([self sectionIsNackExperimentConfig:section]) {
        return @"NACK实验参数\n开启(首字母大写，其他小写):Enabled-0.05,0.9,0.8,0.7,2,10\n关闭(首字母大写，其他小写):Disabled";
    }
    if ([self sectionIsPlayoutDelayExperimentConfig:section]) {
        return @"PlayoutDelay实验参数\n开启(首字母大写，其他小写):Enabled-5,20\n关闭(首字母大写，其他小写):Disabled";
    }
    if ([self sectionIsJitterExperimentConfig:section]) {
        return @"JitterEstimator实验参数\n开启(首字母大写，其他小写):Enabled-1.5,60,30,2.33,15,3,0,100\n关闭(首字母大写，其他小写):Disabled";
    }
    if ([self sectionIsMockedCloudConfigs:section]) {
        return @"mock 云控";
    }
    if ([self sectionIsVideoSmoothRenderingExperimentConfig:section]) {
        return @"视频平滑渲染";
    }
    if ([self sectionIsLoopbackConfig:section]) {
        return @"loopback test,用于环回测试，自己订阅自己发布的流";
    }
  return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexPathIsUidConfig:indexPath]) {
        return [self uidConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if ([self indexPathIsBiznameConfig:indexPath]) {
        return [self biznameConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if ([self indexPathIsSubbizConfig:indexPath]) {
        return [self subbizConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
#ifdef ARTVC_BUILD_FOR_MPAAS
    if ([self indexPathIsWorkspaceIdConfig:indexPath]) {
        return [self workspaceIdConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
#endif
    if ([self indexPathIsSignatureConfig:indexPath]) {
        return [self signatureConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if ([self indexPathIsMediaConstraints:indexPath]) {
        return [self mediaConstraintsTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if ([self indexPathIsBitrate:indexPath]) {
        return [self bitrateTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    
    if([self indexPathIsFrameRate:indexPath]){
        return [self framerateTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
#ifndef ARTVC_BUILD_FOR_MPAAS
    if([self indexPathIsServerConfig:indexPath]){
        return [self serverConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
#endif
    if([self indexPathIsCustomServerUrlConfig:indexPath]){
        return [self customServerUrlConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsDTLSConfig:indexPath]){
        return [self dtlsConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsRelayConfig:indexPath]){
        return [self relayConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsEnablePublishConfig:indexPath]){
        return [self enablePublishConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsEnableSubscribeConfig:indexPath]){
        return [self enableSubscribeConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsEnableFlexFECConfig:indexPath]){
        return [self enableFlexFECConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsBWEExperimentConfig:indexPath]){
        return [self enableBWEExperimentConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsEnableInviteConfig:indexPath]){
        return [self enableInviteConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsInviteeUidConfig:indexPath]){
        return [self inviteeUidConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsLiveUrlConfig:indexPath]){
        return [self liveUrlConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsUseBloxWay:indexPath]){
        return [self enableUseBloxWayTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsBeautyLevel:indexPath]){
        return [self beautyLevelTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsVirtualBackground:indexPath]){
        return [self virtualBGTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsPacingExperimentConfig:indexPath]){
        return [self pacingExperimentConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsNackExperimentConfig:indexPath]){
        return [self nackExperimentConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsPlayoutDelayExperimentConfig:indexPath]){
        return [self playoutDelayExperimentConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsJitterExperimentConfig:indexPath]){
        return [self jitterExperimentConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if ([self indexPathIsMockedCloudConfigs:indexPath]) {
        return [self mockedCloudConfigsTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsVideoSmoothRenderingExperimentConfig:indexPath]){
        return [self videoSmoothRenderingExperimentConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsLoopbackConfig:indexPath]){
        return [self loopbackConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:@"identifier"];
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView
           willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  if ([self indexPathIsMediaConstraints:indexPath]) {
    return [self tableView:tableView willDeselectMediaConstraintsRowAtIndexPath:indexPath];
  }
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self indexPathIsMediaConstraints:indexPath]) {
    [self tableView:tableView didSelectMediaConstraintsCellAtIndexPath:indexPath];
  }
}

#pragma mark - Table view delegate(Media Constraints)

- (UITableViewCell *)mediaConstraintsTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsMediaConstraintsViewCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];
  }
  cell.textLabel.text = self.mediaConstraintsArray[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectMediaConstraintsCellAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;

  NSString *mediaConstraintsString = self.mediaConstraintsArray[indexPath.row];
  [_settingsModel storeVideoResoultionConstraint:mediaConstraintsString];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
    willDeselectMediaConstraintsRowAtIndexPath:(NSIndexPath *)indexPath {
  NSIndexPath *oldSelection = [tableView indexPathForSelectedRow];
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldSelection];
  cell.accessoryType = UITableViewCellAccessoryNone;
  return indexPath;
}

#pragma mark - Table view delegate(Bitrate)

- (UITableViewCell *)bitrateTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsBitrateCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.bitrateTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSUInteger storedBitrate = [_settingsModel currentBitrate];
//      if(storedBitrate == 0){
//          self.bitrateTF.placeholder = @"输入最大码率";
//      }else{
      self.bitrateTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)storedBitrate];
//      }
      self.bitrateTF.keyboardType = UIKeyboardTypeNumberPad;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveBitrate)]
    ];
    [numberToolbar sizeToFit];

    self.bitrateTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.bitrateTF];
  }
  return cell;
}
-(void)saveBitrate{
    NSString *text = self.bitrateTF.text;
    if(text.length > 0){
        [_settingsModel storeBitrate:[text integerValue]];
    }
    [self.view endEditing:YES];
}

#pragma mark - Table view delegate(Framerate)
- (UITableViewCell *)framerateTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsFramerateCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        self.framerateTF = [[UITextField alloc]
                                  initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
        NSUInteger storedFramerate = [_settingsModel currentFramerate];
        if(storedFramerate == 0){
            self.framerateTF.placeholder = @"输入帧率(建议15fps)";
        }else{
            self.framerateTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)storedFramerate];
        }
        self.framerateTF.keyboardType = UIKeyboardTypeNumberPad;
        
        // Numerical keyboards have no return button, we need to add one manually.
        UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        numberToolbar.items = @[
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil],
                                [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(saveFramerate)]
                                ];
        [numberToolbar sizeToFit];
        
        self.framerateTF.inputAccessoryView = numberToolbar;
        [cell.contentView addSubview:self.framerateTF];
    }
    return cell;
}
-(void)saveFramerate{
    NSString *text = self.framerateTF.text;
    if(text.length > 0){
        [_settingsModel storeFramerate:[text integerValue]];
    }
    [self.view endEditing:YES];
}
#ifndef ARTVC_BUILD_FOR_MPAAS
#pragma mark - Table view delegate(ServerConfig)
- (UITableViewCell *)serverConfigTableViewCellForTableView:(UITableView *)tableView
                                            atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsServerConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"使用线上环境";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(serverChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel isOnlineServer]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)serverChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"The switch is on.");
        [_settingsModel storeServerconfig:YES];
    } else {
        APM_INFO(@"The switch is off.");
        [_settingsModel storeServerconfig:NO];
    }
}
#endif
#pragma mark - Table view delegate(dtls)
- (UITableViewCell *)dtlsConfigTableViewCellForTableView:(UITableView *)tableView
                                               atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsDtlsConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"禁止DTLS";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(dtlsChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel isDtlsDisabled]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)dtlsChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"disable DTLS");
        [_settingsModel storeDtlsDisabled:YES];
    } else {
        APM_INFO(@"enable DTLS");
        [_settingsModel storeDtlsDisabled:NO];
    }
}
#pragma mark - Table view delegate(relay mode)
- (UITableViewCell *)relayConfigTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsRelayConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"强制走中转";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(relayChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel isRelaySpecified]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)relayChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"use relay");
        [_settingsModel storeRelayMode:YES];
    } else {
        APM_INFO(@"not use relay");
        [_settingsModel storeRelayMode:NO];
    }
}

#pragma mark - Table view delegate(enable publish)
- (UITableViewCell *)enablePublishConfigTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsEnablePublishConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"允许推流";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(enablePublishChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel eanblePublish]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)enablePublishChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable pusblish");
        [_settingsModel setEnablePublish:YES];
    } else {
        APM_INFO(@"diable publish");
        [_settingsModel setEnablePublish:NO];
    }
}
#pragma mark - Table view delegate(enable subscribe)
- (UITableViewCell *)enableSubscribeConfigTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsEnableSubscribeConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"允许拉流";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(enableSubscribeChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel eanbleSubscribe]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)enableSubscribeChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable Subscribe");
        [_settingsModel setEnableSubscribe:YES];
    } else {
        APM_INFO(@"diable Subscribe");
        [_settingsModel setEnableSubscribe:NO];
    }
}
#pragma mark - Table view delegate(enable flexfec-03)
- (UITableViewCell *)enableFlexFECConfigTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsEnableFlexFECConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"开启FlexFEC-03";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(enableFlexFECChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel eanbleFlexFEC]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)enableFlexFECChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable FlexFEC-03");
        [_settingsModel setEnableFlexFEC:YES];
    } else {
        APM_INFO(@"diable FlexFEC-03");
        [_settingsModel setEnableFlexFEC:NO];
    }
}
#pragma mark - Table view delegate(BWE Experiment)

- (UITableViewCell *)enableBWEExperimentConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsBWEExperimentCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.bweTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* storedBweFlag = [_settingsModel bweExperimentFlag];
      self.bweTF.placeholder = storedBweFlag;
      self.bweTF.text = storedBweFlag;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveBweExperimentFlag)]
    ];
    [numberToolbar sizeToFit];

    self.bweTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.bweTF];
  }
  return cell;
}
-(void)saveBweExperimentFlag{
    NSString *text = self.bweTF.text;
    [_settingsModel setBweExperimentFlag:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(enable invite)
- (UITableViewCell *)enableInviteConfigTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsEnableInviteConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"允许Invite";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(enableInviteChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel eanbleInviteAfterCreateRoom]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)enableInviteChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable invite");
        [_settingsModel setEanbleInviteAfterCreateRoom:YES];
    } else {
        APM_INFO(@"diable invite");
        [_settingsModel setEanbleInviteAfterCreateRoom:NO];
    }
}
#pragma mark - Table view delegate(InviteeUid)

- (UITableViewCell *)inviteeUidConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsInviteeUidCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.inviteeUidTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel inviteeUid];
      self.inviteeUidTF.placeholder = stored;
      self.inviteeUidTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveInviteeUid)]
    ];
    [numberToolbar sizeToFit];

    self.inviteeUidTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.inviteeUidTF];
  }
  return cell;
}
-(void)saveInviteeUid{
    NSString *text = self.inviteeUidTF.text;
    [_settingsModel setInviteeUid:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(live url)

- (UITableViewCell *)liveUrlConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsLiveUrlCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.liveUrlTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel liveUrl];
      self.liveUrlTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveLiveUrl)]
    ];
    [numberToolbar sizeToFit];

    self.liveUrlTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.liveUrlTF];
  }
  return cell;
}
-(void)saveLiveUrl{
    NSString *text = self.liveUrlTF.text;
    [_settingsModel setLiveUrl:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(uid)

- (UITableViewCell *)uidConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsUidCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.uidTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel uid];
      self.uidTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveUid)]
    ];
    [numberToolbar sizeToFit];

    self.uidTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.uidTF];
  }
  return cell;
}
-(void)saveUid{
    NSString *text = self.uidTF.text;
    [_settingsModel setUid:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(bizname)

- (UITableViewCell *)biznameConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsBiznameCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.biznameTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel bizname];
      self.biznameTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveBizname)]
    ];
    [numberToolbar sizeToFit];

    self.biznameTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.biznameTF];
  }
  return cell;
}
-(void)saveBizname{
    NSString *text = self.biznameTF.text;
    [_settingsModel setBizname:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(subbiz)

- (UITableViewCell *)subbizConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingssubbizCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.subbizTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel subbiz];
      self.subbizTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveSubbiz)]
    ];
    [numberToolbar sizeToFit];

    self.subbizTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.subbizTF];
  }
  return cell;
}
-(void)saveSubbiz{
    NSString *text = self.subbizTF.text;
    [_settingsModel setSubbiz:text];
    [self.view endEditing:YES];
}
#ifdef ARTVC_BUILD_FOR_MPAAS
- (UITableViewCell *)workspaceIdConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsWorkspaceIdCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.workspaceIdTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel workspaceId];
      self.workspaceIdTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveWorkspaceId)]
    ];
    [numberToolbar sizeToFit];

    self.workspaceIdTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.workspaceIdTF];
  }
  return cell;
}
-(void)saveWorkspaceId{
    NSString *text = self.workspaceIdTF.text;
    [_settingsModel setWorkspaceId:text];
    [self.view endEditing:YES];
}
#endif
#pragma mark - Table view delegate(signature)

- (UITableViewCell *)signatureConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingssignatureCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.signatureTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel signature];
      self.signatureTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveSignature)]
    ];
    [numberToolbar sizeToFit];

    self.signatureTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.signatureTF];
  }
  return cell;
}
-(void)saveSignature{
    NSString *text = self.signatureTF.text;
    [_settingsModel setSignature:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(custom server url)

- (UITableViewCell *)customServerUrlConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsCustomServerUrlCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.customServerUrlTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel customServerUrl];
      self.customServerUrlTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveCustomServerUrl)]
    ];
    [numberToolbar sizeToFit];

    self.customServerUrlTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.customServerUrlTF];
  }
  return cell;
}
-(void)saveCustomServerUrl{
    NSString *text = self.customServerUrlTF.text;
    [_settingsModel setCustomServerUrl:text];
    [self.view endEditing:YES];
}

#pragma mark - Table view delegate(useBlox)
- (UITableViewCell *)enableUseBloxWayTableViewCellForTableView:(UITableView *)tableView
                                                   atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsEnableUseBloxWayCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"使用智能音视频处理";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(enableUseBloxWayChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel enableUseBloxWay]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)enableUseBloxWayChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable blox way");
        [_settingsModel setUseBloxWayChanged:YES];
    } else {
        APM_INFO(@"diable blox way");
        [_settingsModel setUseBloxWayChanged:NO];
    }
}

#pragma mark - Table view delegate(beauty)
- (UITableViewCell *)beautyLevelTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsBeautyLevelCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        self.beautyLevelTF = [[UITextField alloc]
                                  initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
        self.beautyLevelTF.text = [_settingsModel beautyLevel];
        
        // Numerical keyboards have no return button, we need to add one manually.
        UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        numberToolbar.items = @[
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil],
                                [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(saveBeautyLevel)]
                                ];
        [numberToolbar sizeToFit];
        
        self.beautyLevelTF.inputAccessoryView = numberToolbar;
        [cell.contentView addSubview:self.beautyLevelTF];
    }
    return cell;
}
-(void)saveBeautyLevel{
    NSString *text = self.beautyLevelTF.text;
    [_settingsModel setBeautyLevel:[text floatValue]];
    [self.view endEditing:YES];
}

#pragma mark - Table view delegate(virtual background)
- (UITableViewCell *)virtualBGTableViewCellForTableView:(UITableView *)tableView
                                            atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsEnableVirtualBGCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"开启虚拟背景";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(useVirtualBGChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel enableVirtualBG]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)useVirtualBGChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable virtual background.");
        [_settingsModel setVirtualBG:YES];
    } else {
        APM_INFO(@"disable virtual background.");
        [_settingsModel setVirtualBG:NO];
    }
}
#pragma mark - Table view delegate(pacing experiment)

- (UITableViewCell *)pacingExperimentConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsPacingExperimentCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.pacingExpeTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel pacingExperiment];
      self.pacingExpeTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(savePacingExperiment)]
    ];
    [numberToolbar sizeToFit];

    self.pacingExpeTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.pacingExpeTF];
  }
  return cell;
}
-(void)savePacingExperiment{
    NSString *text = self.pacingExpeTF.text;
    [_settingsModel setPacingExperiment:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(NACK experiment)

- (UITableViewCell *)nackExperimentConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsNackExperimentCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.nackExpeTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel nackExperiment];
      self.nackExpeTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveNackExperiment)]
    ];
    [numberToolbar sizeToFit];

    self.nackExpeTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.nackExpeTF];
  }
  return cell;
}
-(void)saveNackExperiment{
    NSString *text = self.nackExpeTF.text;
    [_settingsModel setNackExperiment:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(PlayoutDelay experiment)

- (UITableViewCell *)playoutDelayExperimentConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsPlayoutDelayExperimentCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.playoutDelayExpeTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel playoutDelayExperiment];
      self.playoutDelayExpeTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(savePlayoutDelayExperiment)]
    ];
    [numberToolbar sizeToFit];

    self.playoutDelayExpeTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.playoutDelayExpeTF];
  }
  return cell;
}
-(void)savePlayoutDelayExperiment{
    NSString *text = self.playoutDelayExpeTF.text;
    [_settingsModel setPlayoutDelayExperiment:text];
    [self.view endEditing:YES];
}
#pragma mark - Table view delegate(Jitter experiment)

- (UITableViewCell *)jitterExperimentConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
  NSString *dequeueIdentifier = @"ARDSettingsJitterExperimentCellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:dequeueIdentifier];

    self.jitterExpeTF = [[UITextField alloc]
        initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
      NSString* stored = [_settingsModel jitterExperiment];
      self.jitterExpeTF.text = stored;

    // Numerical keyboards have no return button, we need to add one manually.
    UIToolbar *numberToolbar =
        [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.items = @[
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil],
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(saveJitterExperiment)]
    ];
    [numberToolbar sizeToFit];

    self.jitterExpeTF.inputAccessoryView = numberToolbar;
    [cell.contentView addSubview:self.jitterExpeTF];
  }
  return cell;
}
-(void)saveJitterExperiment{
    NSString *text = self.jitterExpeTF.text;
    [_settingsModel setJitterExperiment:text];
    [self.view endEditing:YES];
}

#pragma mark - Table view delegate(mocked cloud configs)
- (UITableViewCell *)mockedCloudConfigsTableViewCellForTableView:(UITableView *)tableView
                                                     atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsSectionMockedCloudConfigsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:dequeueIdentifier];

      self.mockedConfigsTF = [[UITextField alloc]
          initWithFrame:CGRectMake(10, 0, cell.bounds.size.width - 20, cell.bounds.size.height)];
        NSString* stored = [_settingsModel mockedConfigs];
        self.mockedConfigsTF.text = stored;

      // Numerical keyboards have no return button, we need to add one manually.
      UIToolbar *numberToolbar =
          [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
      numberToolbar.items = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                      target:nil
                                                      action:nil],
        [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(saveMockedConfigs)]
      ];
      [numberToolbar sizeToFit];

      self.mockedConfigsTF.inputAccessoryView = numberToolbar;
      [cell.contentView addSubview:self.mockedConfigsTF];
    }
    return cell;
}
- (void)saveMockedConfigs {
    NSString *text = self.mockedConfigsTF.text;
    [_settingsModel setMockedConfigs:text];
    [self.view endEditing:YES];
}

#pragma mark - Table view delegate(Disable Smooth Rendering experiment)

- (UITableViewCell *)videoSmoothRenderingExperimentConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsVideoSmoothRenderingConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"关闭平滑渲染";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(videoSmoothRenderingChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel isVideoSmoothRenderingDisabled]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)videoSmoothRenderingChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"disable video smooth rendering switch is on.");
        [_settingsModel disableVideoSmoothRendering:YES];
    } else {
        APM_INFO(@"disable video smooth rendering switch is off.");
        [_settingsModel disableVideoSmoothRendering:NO];
    }
}
#pragma mark - Table view delegate(loopback test)

- (UITableViewCell *)loopbackConfigTableViewCellForTableView:(UITableView *)tableView
                                          atIndexPath:(NSIndexPath *)indexPath {
    NSString *dequeueIdentifier = @"ARDSettingsLoopbackConfigCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:dequeueIdentifier];
        
        cell.textLabel.text = @"环回测试";

        CGRect frame = CGRectMake(self.view.frame.size.width-51-10,cell.frame.origin.y+(cell.frame.size.height-31)/2,  0,  0);
        UISwitch *sw = [[UISwitch alloc] initWithFrame:frame];
        [sw addTarget:self action:@selector(loopbackTestChanged:) forControlEvents:UIControlEventValueChanged];
        [sw setOn:[_settingsModel isLoopbackTestEnabled]];
        [cell.contentView addSubview:sw];
    }
    return cell;
}
-(void)loopbackTestChanged:(UISwitch*)sw{
    if ([sw isOn]){
        APM_INFO(@"enable loopback test switch is on.");
        [_settingsModel enableLoopbackTest:YES];
    } else {
        APM_INFO(@"enable loopback test switch is off.");
        [_settingsModel enableLoopbackTest:NO];
    }
}
@end
NS_ASSUME_NONNULL_END
#endif
#endif
