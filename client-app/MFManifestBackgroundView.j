/**
	This is the background view for the manifests view. All it really does is
	makes sure that view has a background color. Nothing special.
 */
@implementation MFManifestBackgroundView : CPView


- (void)drawRect:(CGRect)aRect
{
	[super drawRect:aRect];
	var startColor = CGColorCreateGenericGray(1.0, 0.8);
	var endColor = CGColorCreateGenericGray(1.0, 0.8);
	var gradient = CGGradientCreateWithColors(
		CGColorSpaceCreateDeviceRGB(),
		[startColor, endColor],
		[0,1]
	);
	var context = [[CPGraphicsContext currentContext] graphicsPort];
	CGContextAddRect(context, aRect);
	var startPoint = CGPointMake(0, 0);
	var endPoint = CGPointMake(0, aRect.size.height);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}

@end
