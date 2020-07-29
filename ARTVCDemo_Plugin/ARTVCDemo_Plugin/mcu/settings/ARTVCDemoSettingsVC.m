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
#undef APM_LOG_TAG
#define APM_LOG_TAG @"[ACDemo] "

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, ARDSettingsSections) {
    ARDSettingsSectionUidConfig = 0,
    ARDSettingsSectionBiznameConfig,
    
    ARDSettingsSectionSignatureConfig,
    ARDSettingsSectionMediaConstraints,
    ARDSettingsSectionBitRate,
    ARDSettingsSectionFrameRate,
    ARDSettingsSectionServerConfig,
    ARDSettingsSectionDTLSConfig,
    ARDSettingsSectionRelayConfig,
    ARDSettingsSectionEnablePublishConfig,
    ARDSettingsSectionEnableSubscribeConfig,
    ARDSettingsSectionEnableInviteConfig,
    ARDSettingsSectionInviteeUidConfig,
    ARDSettingsSectionLiveUrlConfig,
    ARDSettingsSectionEnd
};

@interface ARTVCDemoSettingsVC () {
  ARTVCDemoSettingsModel *_settingsModel;
}
@property(nonatomic,strong) UITextField *framerateTF;
@property(nonatomic,strong) UITextField *bitrateTF;
@property(nonatomic,strong) UITextField *inviteeUidTF;
@property(nonatomic,strong) UITextField *liveUrlTF;
@property(nonatomic,strong) UITextField *uidTF;
@property(nonatomic,strong) UITextField *biznameTF;
@property(nonatomic,strong) UITextField *signatureTF;
@end

@implementation ARTVCDemoSettingsVC

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

- (BOOL)sectionIsServerConfig:(NSInteger)section {
    return section == ARDSettingsSectionServerConfig;
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
- (BOOL)sectionIsEnableInviteConfig:(NSInteger)section {
    return section == ARDSettingsSectionEnableInviteConfig;
}
- (BOOL)sectionIsInviteeUidConfig:(NSInteger)section {
    return section == ARDSettingsSectionInviteeUidConfig;
}
- (BOOL)sectionIsLiveUrlConfig:(NSInteger)section {
    return section == ARDSettingsSectionLiveUrlConfig;
}

- (BOOL)indexPathIsUidConfig:(NSIndexPath *)indexPath {
  return [self sectionIsUidConfig:indexPath.section];
}
- (BOOL)indexPathIsBiznameConfig:(NSIndexPath *)indexPath {
  return [self sectionIsBiznameConfig:indexPath.section];
}

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

- (BOOL)indexPathIsServerConfig:(NSIndexPath *)indexPath {
    return [self sectionIsServerConfig:indexPath.section];
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
- (BOOL)indexPathIsEnableInviteConfig:(NSIndexPath *)indexPath {
    return [self sectionIsEnableInviteConfig:indexPath.section];
}
- (BOOL)indexPathIsInviteeUidConfig:(NSIndexPath *)indexPath {
    return [self sectionIsInviteeUidConfig:indexPath.section];
}
- (BOOL)indexPathIsLiveUrlConfig:(NSIndexPath *)indexPath {
    return [self sectionIsLiveUrlConfig:indexPath.section];
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
    
    if ([self sectionIsServerConfig:section]) {
        return @"信令服务器环境（开发过程中建议使用测试环境）";
    }
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
    if ([self sectionIsEnableInviteConfig:section]) {
        return @"允许CreateRoom后Invite对端";
    }
    if ([self sectionIsInviteeUidConfig:section]) {
        return @"对端UID,用于Invite请求";
    }
    if ([self sectionIsLiveUrlConfig:section]) {
        return @"RTMP推流地址";
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
    
    if([self indexPathIsServerConfig:indexPath]){
        return [self serverConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
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
    if([self indexPathIsEnableInviteConfig:indexPath]){
        return [self enableInviteConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsInviteeUidConfig:indexPath]){
        return [self inviteeUidConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
    }
    if([self indexPathIsLiveUrlConfig:indexPath]){
        return [self liveUrlConfigTableViewCellForTableView:tableView atIndexPath:indexPath];
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
    [cell addSubview:self.bitrateTF];
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
        [cell addSubview:self.framerateTF];
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
    [cell addSubview:self.inviteeUidTF];
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
    [cell addSubview:self.liveUrlTF];
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
    [cell addSubview:self.uidTF];
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
    [cell addSubview:self.biznameTF];
  }
  return cell;
}
-(void)saveBizname{
    NSString *text = self.biznameTF.text;
    [_settingsModel setBizname:text];
    [self.view endEditing:YES];
}
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
    [cell addSubview:self.signatureTF];
  }
  return cell;
}
-(void)saveSignature{
    NSString *text = self.signatureTF.text;
    [_settingsModel setSignature:text];
    [self.view endEditing:YES];
}
@end
NS_ASSUME_NONNULL_END
#endif
#endif
