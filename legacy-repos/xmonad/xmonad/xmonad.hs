import Data.Monoid
import System.Exit
import Data.List (unwords, intercalate)

import XMonad
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Config.Desktop (desktopLayoutModifiers)

import qualified XMonad.StackSet as W
import qualified Data.Map as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse = False :: Bool

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = True :: Bool

-- Width of the window border in pixels.
myBorderWidth = 7

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = zip ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] [xK_0..xK_9] :: [(String, KeySym)]

-- Border colors for unfocused and focused windows, respectively.
myFocusedBorderColor = "#EE4E34" :: String
myNormalBorderColor  = "#FCEDDA" :: String

myIntrpr = "bash" :: String
myScripts = "~/.xmonad/scripts" :: String
myMainMonitor = "eDP-1" :: String
myVolumeStep = 5 :: Int
myQuickVolumeIncrease = 100 :: Int
myQuickVolumeDecrease = 50 :: Int
myBrightnessStep = 5 :: Int
myQuickBrightnessIncrease = 100 :: Int
myQuickBrightnessDecrease = 50 :: Int

join_with_factory ::  String -> String -> (String -> String)
join_with_factory sep root = (\name -> intercalate sep [root, name])
join_with_myscripts :: String -> String
join_with_myscripts = join_with_factory "/" myScripts
join_with_intrpr :: String -> String
join_with_intrpr = join_with_factory " " myIntrpr

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm, xK_BackSpace), spawn "xset s activate")
    -- launch dmenu
    , ((modm, xK_d), spawn "dmenu_run")
    , ((modm .|. shiftMask, xK_d), spawn $ join_with_intrpr (join_with_myscripts "dmenu_tools.sh"))

    -- close focused window
    , ((modm .|. shiftMask, xK_q), kill)

    -- Move focus to the next/previous/master window
    , ((modm, xK_j), windows W.focusDown)
    , ((modm, xK_k), windows W.focusUp)
    , ((modm, xK_h), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next/previous window
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)

    -- fullscreen focused window
    , ((modm .|. shiftMask, xK_f), sendMessage (Toggle "Full"))

    -- Shrink/Expand the master area
    -- , ((modm .|. shiftMask, xK_l), sendMessage Shrink)
    -- , ((modm, xK_l), sendMessage Expand)

    -- Push window back into tiling
    , ((modm, xK_t), withFocused $ windows . W.sink)

    -- Increment/Deincrement the number of windows in the master area
    , ((modm, xK_comma), sendMessage (IncMasterN 1))
    , ((modm, xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit/Recompile/Restart xmonad
    , ((modm .|. shiftMask, xK_e), io (exitWith ExitSuccess))
    , ((modm .|. shiftMask, xK_c), spawn "notify-send 'Compiling xmonad'; xmonad --recompile; notify-send \"xmonad compilation finished with $?\"")
    , ((modm .|. shiftMask, xK_r), spawn "xmonad --restart && notify-send 'xmonad restarted'")
    ]
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) (map snd myWorkspaces)
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    -- ++
    --
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myLayouts = toggleLayouts (Full) (tiled)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio = 1/2
     -- Percent of screen to increment by when resizing panes
     delta = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = (map fst myWorkspaces),
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = smartBorders $ desktopLayoutModifiers $ myLayouts,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
