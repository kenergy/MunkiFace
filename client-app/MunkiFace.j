@import "MFNetworkDataSource.j"
@import "MFApplicationViewController.j"
@import "MFOutlineDataSource.j"
@import "MFOutlineSelectedObject.j"
@import "MFCatalog.j"
@import "MFManifest.j"
@import "MFManifestsOutlineDataSource.j"
@import "MFPkgsInfo.j"
@import "MFPkgsInfoOutlineDataSource.j"
@import "MFTreeModel.j"
@import "MFManifestBackgroundView.j"
@import "MFPkgsInfoCollectionViewItemView.j"
@import "MFByteTransformer.j"

MF_SERVER_URI = [[[CPBundle mainBundle] infoDictionary]
	objectForKey:@"MunkiFace Server URI"];
