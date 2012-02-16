@import "MFPackage.j"
@implementation MFPackage (Adobe)


- (CPString)adobeSetupType
{
	return [self objectForKey:@"AdobeSetupType"];
}




- (CPArray)adobePayloads
{
	return [self objectForKey:@"payloads"];
}




- (CPString)adobeSerialnumber
{
	return [[self adobeInstallInfo] objectForKey:@"serialnumber"];
}




- (CPString)adobeInstallXML
{
	return [[self adobeInstallInfo] objectForKey:@"installxml"];
}




- (CPString)adobeUninstallXML
{
	return [[self adobeInstallInfo] objectForKey:@"uninstallxml"];
}




- (CPString)adobeMediaSignature
{
	return [[self adobeInstallInfo] objectForKey:@"media_signature"];
}




- (CPString)adobeMediaDigest
{
	return [[self adobeInstallInfo] objectForKey:@"media_digest"];
}




- (int)adobePayloadCount
{
	return [[self adobeInstallInfo] objectForKey:@"payload_count"];
}




- (BOOL)adobeSupressRegistration
{
	return [[self adobeInstallInfo] objectForKey:@"supress_registration"];
}




- (BOOL)adobeSupressUpdates
{
	return [[self adobeInstallInfo] objectForKey:@"supress_updates"];
}




- (CPDictionary)adobeInstallInfo
{
	return [self objectForKey:@"adobe_install_info"];
}
@end
