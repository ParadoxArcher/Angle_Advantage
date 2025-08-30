###### A prerequisite of [[_boost]] that tapers the release value of #MoveInputY 
- Pass in #MoveInputY from [[_boost]]
- Create a script-wide variable #BoostStorage 
- Determine if we are increasing or decreasing #BoostStorage by checking:
	- `if` a predetermined #StorageReleaseScaler divided from #MoveInputY is `>=` #BoostStorage 
		- `if` `true`: multiply #MoveInputY by a predetermined #StorageGrowth, then add it to #BoostStorage. Make sure to `clampf` the sum to ensure #BoostStorage doesn't exceed #MoveInputY
			- then, `return` `1` to signify that, while an input
		- `else`: 