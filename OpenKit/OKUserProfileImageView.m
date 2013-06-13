//
//  OKUserProfileImageView.m
//  OKClient
//
//  Created by Suneet Shah on 1/8/13.
//  Copyright (c) 2013 OpenKit. All rights reserved.
//

#import "OKUserProfileImageView.h"
#import "OKTwitterUtilities.h"
#import "AFImageView.h"
#import "OKGameCenterUtilities.h"


@interface OKUserProfileImageView ()

@property (nonatomic, strong) FBProfilePictureView *fbProfileImageView;
@property (nonatomic, strong) AFImageView *imageView;


@end


@implementation OKUserProfileImageView

+(UIImage*)placeHolderImage{
    return [UIImage imageNamed:@"user_icon.png"];
}

#pragma mark - Init
- (id)init
{
    if ((self = [super init])) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if(self.imageView)
        return;
    
    self.imageView = [[AFImageView alloc] initWithFrame:self.bounds];
    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;
    self.fbProfileImageView = [[FBProfilePictureView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.imageView];
    [self addSubview:self.fbProfileImageView];
}

#pragma mark - Overridden Setters
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.fbProfileImageView setFrame:frame];
    [self.imageView setFrame:frame];
}

#pragma mark - Custom Setters
- (void)setUser:(OKUser *)aUser
{
    // Use the built in FB placeholder for nil user.
    //Clear out the FbProfileImageView
    [self.fbProfileImageView setProfileID:nil];
    
    if(!aUser) {
        [self.fbProfileImageView setHidden:YES];
        [self.imageView setHidden:NO];
        [self.imageView setImage:[OKUserProfileImageView placeHolderImage]];
    }
    else if([aUser fbUserID] != nil) {
        [self.fbProfileImageView setHidden:NO];
        [self.imageView setHidden:YES];
        [self.fbProfileImageView setProfileID:[aUser.fbUserID stringValue]];
    }
    else if ([aUser gameCenterID]) {
        [self.fbProfileImageView setHidden:YES];
        [self.imageView setHidden:NO];
        [self.imageView setImage:[OKUserProfileImageView placeHolderImage]];
        
        [OKGameCenterUtilities loadPlayerPhotoForGameCenterID:[aUser gameCenterID] withPhotoSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
            
            if(photo != nil) {
                [self.imageView setImage:photo];
            }
         }];
    }
    else if([aUser twitterUserID]) {
        //TODO Displaying twitter images is not yet implemented
        [self.fbProfileImageView setProfileID:nil];
        //[self.fbProfileImageView setHidden:YES];
        //[self.imageView setHidden:NO];
        //TODO Twitter profile image
        //[OKTwitterUtilities GetProfileImageURLFromTwitterUserID:[aUser.twitterUserID stringValue]];
    }
    _user = aUser;
}




- (void)setImage:(UIImage *)aImage
{
    [self.fbProfileImageView setHidden:YES];
    [self.imageView setImage:aImage];
    [self.imageView setHidden:NO];
    _image = aImage;
}

#pragma mark - Actions
- (void)setImageURL:(NSString *)url
{
    [self.fbProfileImageView setHidden:YES];
    [self.imageView setHidden:NO];
    [self.imageView setImageWithURL:[NSURL URLWithString:url]];
}

- (void)setImageURL:(NSString *)url withPlaceholderImage:(UIImage *)placeholder
{
    [self setImage:placeholder];
    [self.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}


@end
