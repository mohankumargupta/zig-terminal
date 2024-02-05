pub const FgColor = enum(u8) {
    Black = 30,
    Red = 31,
    Green = 32,
    Yellow = 33,
    Blue = 34,
    Magenta = 35,
    Cyan = 36,
    White = 37,
};

pub const BgColor = enum(u8) {
    Black = 40,
    Red = 41,
    Green = 42,
    Yellow = 43,
    Blue = 44,
    Magenta = 45,
    Cyan = 46,
    White = 47,
};

pub const FgPaletteColor = struct { color: u8 };
pub const FgRGBColor = struct { r: u8, g: u8, b: u8 };
pub const BgPaletteColor = struct { color: u8 };
pub const BgRGBColor = struct { r: u8, g: u8, b: u8 };

pub const Bold = 1;
pub const Faint = 2;
pub const Italic = 3;
pub const Underline = 4;
pub const BlinkSlow = 5;
pub const BlinkFast = 6;

pub const Framed = 51;
pub const Encircled = 52;
pub const Overlined = 53;
pub const ResetFrameEnci = 54;
pub const ResetOverlined = 55;

pub const Font1 = 11;
pub const Font2 = 12;
pub const Font3 = 13;
pub const Font4 = 14;
pub const Font5 = 15;
pub const Font6 = 16;
pub const Font7 = 17;
pub const Font8 = 18;
pub const Font9 = 19;

pub const UnderlineDouble = 21;
pub const ResetIntensity = 22;
pub const ResetItalic = 23;
pub const ResetUnderline = 24;
pub const ResetBlink = 25;
