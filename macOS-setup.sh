#!/usr/bin/env bash
# Based on ~/.macos — https://mths.be/macos

# Init {{{

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# }}}

# General UI/UX {{{

# Only show scrollbars when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Don't Reduce transparency
defaults write com.apple.universalaccess reduceTransparency -bool false

# Automatically hide menubar
defaults write NSGlobalDomain "_HIHideMenuBar" 1

# Show Crash Reports
defaults write com.apple.CrashReporter DialogType crashreport

# Speed up some dialogs
defaults write NSGlobalDomain NSWindowResizeTime 0.1

# Enable natural swipe direction
defaults write NSGlobalDomain com.apple.swipescrolldirection 1

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# }}}

# User Account Settings {{{

# Set ZSH as default shell
sudo dscl . -create "/Users/${USER}" UserShell "/bin/zsh"

# }}}

# SSD-specific tweaks {{{

# Check if SSD is present
system_profiler SPSerialATADataType | grep -q "Medium Type: SSD"
if [[ $? -eq 0 ]]; then
    # Disable hibernation (speeds up entering sleep mode)
    sudo pmset -a hibernatemode 0

    # Remove the sleep image file to save disk space
    sudo rm /private/var/vm/sleepimage

    # Create a zero-byte file instead…
    sudo touch /private/var/vm/sleepimage

    # ...and make sure it can’t be rewritten
    sudo chflags uchg /private/var/vm/sleepimage
fi

# }}}

# Spotlight {{{

sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i off / > /dev/null 2>&1
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null 2>&1

# }}}

# Time Machine {{{

# Don't offer new disks for backup
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine snapshots
sudo tmutil disablelocal

# }}}

# Keyboard {{{

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Only a very short delay before key repeat starts
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Use all F1, F2, etc. keys as standard function keys
#defaults write -g com.apple.keyboard.fnState -bool true

# }}}

# Language Input {{{

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en" "de"
defaults write NSGlobalDomain AppleLocale -string "de_DE"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricSystem -bool true
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# }}}

# Screen {{{

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# }}}

# Security {{{

# Disable display of recent applications.
defaults write com.apple.recentitems RecentApplications -dict MaxAmount 0
defaults write com.apple.recentitems RecentDocuments -dict MaxAmount 10

# Turn Bluetooth off.
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# }}}

# Finder {{{

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# New window points to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing to prevent truncation of item info
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 86" ~/Library/Preferences/com.apple.finder.plist

# Set font size
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 13" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    Comments -bool false \
    General -bool true \
    OpenWith -bool true \
    MetaData -bool false \
    Name -bool false \
    Privileges -bool true

# }}}

# Dock, Dashboard, and hot corners {{{

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 36

# Position (left, bottom, right)
defaults write com.apple.dock orientation -string "left"

# Automatically hide dock
defaults write com.apple.dock autohide -bool true

# Lower the delay to show the dock
# defaults write com.apple.dock autohide-delay -float 0.1

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Minimize using scale effect
defaults write com.apple.dock mineffect -string "scale"

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.15

# Speed up launchpad animation
defaults write com.apple.dock springboard-show-duration -float 0.15
defaults write com.apple.dock springboard-hide-duration -float 0.15

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Hot corners
# Possible values:
# 0: no-op
# 2: Mission Control
# 3: Show application windows
# 4: Desktop
# 5: Start screen saver
# 6: Disable screen saver
# 7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Launchpad
defaults write com.apple.dock wvous-tl-corner -int 11
defaults write com.apple.dock wvous-tl-modifier -int 0
# Bottom left screen corner → Mission Control
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0
# Bottom right screen corner → Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

# }}}

# Safari & WebKit {{{

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# New windows open with: Empty Page
defaults write com.apple.Safari NewWindowBehavior -int 1

# New tabs open with: Empty Page
defaults write com.apple.Safari NewTabBehavior -int 1

# Open pages in tabs instead of windows: automatically
defaults write com.apple.Safari TabCreationPolicy -int 1

# Don't make new tabs active
defaults write com.apple.Safari OpenNewTabsInFront -bool false

# Command-clicking a link creates tabs
defaults write com.apple.Safari CommandClickMakesTabs -bool true

# Always show tab bar
defaults write com.apple.Safari AlwaysShowTabBar -bool true

# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true

# Don't remember data
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false

# Warn About Fraudulent Websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

# Do not track
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Disable top hit preloading
defaults write com.apple.Safari PreloadTopHit -bool false

# Only keep history for 2 weeks
defaults write com.apple.Safari HistoryAgeInDaysLimit -int 7

# Clear download list on quit
defaults write com.apple.Safari DownloadsClearingPolicy -int 1

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# }}}

# Mail {{{

# Disable loading of images
defaults write com.apple.mail DisableURLLoading -bool true

# Display emails in threaded mode, sorted by date (oldest at the top)
defaults write com.apple.mail DefaultViewerState -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DefaultViewerState -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DefaultViewerState -dict-add "SortOrder" -string "received-date"

# Compose messages in plain text
defaults write com.apple.mail SendFormat -string "Plain"

# }}}

# Terminal {{{

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Use Secure Keyboard Entry
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Install themes
cd Terminal
for theme in *.terminal; do
    theme="${theme%.*}" # Strip extension
    theme="${theme// /\\ }" # Add backslash before spaces
    /usr/libexec/PlistBuddy -c "Delete :Window\ Settings:$theme" ~/Library/Preferences/com.apple.Terminal.plist 2> /dev/null
    /usr/libexec/PlistBuddy -c "Add :Window\ Settings:$theme dict" ~/Library/Preferences/com.apple.Terminal.plist
    /usr/libexec/PlistBuddy -c "Merge $theme.terminal :Window\ Settings:$theme" ~/Library/Preferences/com.apple.Terminal.plist
done
cd ..

# Use the One Dark theme by default in Terminal.app
defaults write com.apple.Terminal "Default Window Settings" -string "One Dark"
defaults write com.apple.Terminal "Startup Window Settings" -string "One Dark"

# Don't show tabbar
defaults write com.apple.Terminal ShowTabBar -bool false

# Disable the annoying line marks
defaults write com.apple.Terminal ShowLineMarks -int 0

# }}}

# Activity Monitor {{{

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# }}}

# TextEdit {{{

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# }}}

# Disk Utility {{{

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# }}}

# Mac App Store {{{

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

# }}}

# Xcode {{{

# Enable Mac developer mode (keep password entry to a minimum for Xcode an Instruments)
/usr/sbin/DevToolsSecurity -enable > /dev/null 2> /dev/null

# Create color scheme directory
mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes

# Copy color schemes
yes | cp Xcode/*.xccolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes

# Color scheme
defaults write com.apple.dt.Xcode DVTFontAndColorCurrentTheme -string "One Light.xccolortheme"

# Show page guide at 100 columns
defaults write com.apple.dt.Xcode DVTTextPageGuideLocation -int 100
defaults write com.apple.dt.Xcode DVTTextShowPageGuide -bool true

# Show line numbers
defaults write com.apple.dt.Xcode DVTTextShowLineNumbers -bool true

# Disable Xcode indentation
defaults write com.apple.dt.Xcode DVTTextEditorWrapsLines -bool false
defaults write com.apple.dt.Xcode DVTTextUsesSyntaxAwareIndenting -bool false

# Always use tabs for indentation
defaults write com.apple.dt.Xcode DVTTextIndentUsingTabs -bool true
defaults write com.apple.dt.Xcode DVTTextTabKeyIndentBehavior -string "Never"

# Disable code folding sidebar
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -bool false

# Also trim whitespace-only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool true

# Use legacy mode for build data
defaults write com.apple.dt.Xcode IDEBuildLocationStyle -string "DeterminedByTargets"

# Store derived data relative to the project
defaults write com.apple.dt.Xcode IDECustomDerivedDataLocation -string "DerivedData"

# Open files in new tab on double-click
defaults write com.apple.dt.Xcode IDEEditorCoordinatorTarget_DoubleClick -string "SeparateTab"

# Display build times
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true

# }}}

# Textmate {{{

# Ignore case in find window
defaults write com.macromates.TextMate.preview findIgnoreCase -bool true

# Wrap around if find hits end-of-file
defaults write com.macromates.TextMate.preview findWrapAround -bool true

# Display file browser on the left side
defaults write com.macromates.TextMate.preview fileBrowserPlacement -string "left"

# Always display tab bar
defaults write com.macromates.TextMate.preview disableTabBarCollapsing -bool true

# Disable rmate
defaults write com.macromates.TextMate.preview rmateServerDisabled -bool true

# Use beta update channel
defaults write com.macromates.TextMate.preview SoftwareUpdateChannel -string "beta"

# }}}

# SourceTree {{{

# Agree to eula
defaults write com.torusknot.SourceTreeNotMAS agreedToEULA -bool true

# No analytics
defaults write com.torusknot.SourceTreeNotMAS analyticsHasAgreed -bool false

# Prefer rebase instead of merge
defaults write com.torusknot.SourceTreeNotMAS gitRebaseTrackingBranches -bool true

# Supress warning on amend
defaults write com.torusknot.SourceTreeNotMAS gitSuppressWarnOnAmend -bool true

# Set diff font and size
defaults write com.torusknot.SourceTreeNotMAS diffFontName -string "PragmataPro"
defaults write com.torusknot.SourceTreeNotMAS diffFontSize -int 13

# Don't show tips
defaults write com.torusknot.SourceTreeNotMAS showFileStatusViewOptionsTip -bool false
defaults write com.torusknot.SourceTreeNotMAS showStagingTip -bool false

# Check for updates automatically and don't send profile
defaults write com.torusknot.SourceTreeNotMAS SUEnableAutomaticChecks -bool true
defaults write com.torusknot.SourceTreeNotMAS SUSendProfileInfo -bool false

# Don't modify git config
defaults write com.torusknot.SourceTreeNotMAS agreedToUpdateConfig -bool false

# }}}

# iTerm {{{

# Install terminfo files
find "terminfo" -name "*.terminfo" -exec tic {} +

# Load prefs from dotfiles
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "${HOME}/.config/iTerm"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# }}}

# MacVim {{{

defaults write org.vim.MacVim MMFullScreenFadeTime -float 0.05
defaults write org.vim.MacVim MMUseCGLayerAlways -bool true

# }}}

# Hammerspoon {{{

defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

# }}}

# Kill affected applications {{{

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" > /dev/null 2>&1
done

echo "Restart your computer to let all changes take effect"

# }}}
