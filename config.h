/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 5;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappx     = 6;        /* gap pixel between windows */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
//static const char col_gray1[]       = "#222222";
//static const char col_gray2[]       = "#444444";
//static const char col_gray3[]       = "#bbbbbb";
//static const char col_gray4[]       = "#eeeeee";
//static const char col_cyan[]        = "#005577";

/* one dark inspired colors */
static const char col_background[]      = "#282c34";
static const char col_foreground[]      = "#abb2bf";

static const char col_black[]           = "#282c34";
static const char col_red[]             = "#e06c75";
static const char col_green[]           = "#98c379";
static const char col_yellow[]          = "#d19a66";
static const char col_blue[]            = "#61afef";
static const char col_magenta[]         = "#c678dd";
static const char col_cyan[]            = "#56b6c2";
static const char col_white[]           = "#abb2bf";

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_foreground, col_background, col_white },
	[SchemeSel]  = { col_foreground, col_background,  col_green  },
};

/* tagging */
static const char *tags[] = { "Term", "Firefox", "Dev", "Extra", "Extra", "Extra", "Steam", "Spotify", "Discord" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating  isterminal noswallow monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,          0,          0,          -1 },
	//{ "Firefox",  NULL,       NULL,       1 << 1,       0,        0,          0,              -1 },
    { "Spotify",  NULL,       NULL,       1 << 7,       0,          0,          0,           0 },
    { "discord",  NULL,       NULL,       1 << 8,       0,          0,          0,           -1 },
    { "Steam",  NULL,       NULL,       1 << 6,       0,            0,          0,          0 },
    { "Alacritty",  NULL,       NULL,       0,       0,            1,          0,          -1 },
    { "Qemu-system-x86_64",  NULL,       NULL,       1 << 3,       0,            1,          0,          -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_background, "-nf", col_foreground, "-sb", col_background, "-sf", col_green, NULL };
static const char *termcmd[]  = { "alacritty", NULL };
static const char *browser[]  = { "firefox", NULL };
static const char *volup[]  = { "pactl", "set-sink-volume", "1", "+1%" };
static const char *voldown[]  = { "pactl", "set-sink-volume", "1", "-1%" };
static const char *volmute[]  = { "pactl", "set-sink-mute", "1", "toggle" };
static const char *playnext[] = { "playerctl", "next"};
static const char *playprev[] = { "playerctl", "prev"};
static const char *playtoggle[] = { "playerctl", "play-pause"};

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|ShiftMask,             XK_l,      spawn,          SHCMD("betterlockscreen --lock dim") },
	{ MODKEY,                       XK_s,      spawn,          {.v = browser } },

	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
    {0, XF86XK_AudioLowerVolume, spawn, { .v = voldown} },
    {0, XF86XK_AudioRaiseVolume, spawn, { .v = volup} },
    {0, XF86XK_AudioMute, spawn, { .v = volmute} },
    {0, XF86XK_AudioPrev, spawn, { .v = playprev} },
    {0, XF86XK_AudioNext, spawn, { .v = playnext} },
    {0, XF86XK_AudioPlay, spawn, { .v = playtoggle} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
