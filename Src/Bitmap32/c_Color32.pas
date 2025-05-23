{******************************************************************************}
{* This file is part of SAS.Planet project.                                   *}
{*                                                                            *}
{* Copyright (C) 2007-Present, SAS.Planet development team.                   *}
{*                                                                            *}
{* SAS.Planet is free software: you can redistribute it and/or modify         *}
{* it under the terms of the GNU General Public License as published by       *}
{* the Free Software Foundation, either version 3 of the License, or          *}
{* (at your option) any later version.                                        *}
{*                                                                            *}
{* SAS.Planet is distributed in the hope that it will be useful,              *}
{* but WITHOUT ANY WARRANTY; without even the implied warranty of             *}
{* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the               *}
{* GNU General Public License for more details.                               *}
{*                                                                            *}
{* You should have received a copy of the GNU General Public License          *}
{* along with SAS.Planet. If not, see <http://www.gnu.org/licenses/>.         *}
{*                                                                            *}
{* https://github.com/sasgis/sas.planet.src                                   *}
{******************************************************************************}

unit c_Color32;

interface

uses
  t_Bitmap32;

const
  // Some predefined color constants
  clBlack32 = TColor32($FF000000);
  clDimGray32 = TColor32($FF3F3F3F);
  clGray32 = TColor32($FF7F7F7F);
  clLightGray32 = TColor32($FFBFBFBF);
  clWhite32 = TColor32($FFFFFFFF);
  clMaroon32 = TColor32($FF7F0000);
  clGreen32 = TColor32($FF007F00);
  clOlive32 = TColor32($FF7F7F00);
  clNavy32 = TColor32($FF00007F);
  clPurple32 = TColor32($FF7F007F);
  clTeal32 = TColor32($FF007F7F);
  clRed32 = TColor32($FFFF0000);
  clLime32 = TColor32($FF00FF00);
  clYellow32 = TColor32($FFFFFF00);
  clBlue32 = TColor32($FF0000FF);
  clFuchsia32 = TColor32($FFFF00FF);
  clAqua32 = TColor32($FF00FFFF);

  clAliceBlue32 = TColor32($FFF0F8FF);
  clAntiqueWhite32 = TColor32($FFFAEBD7);
  clAquamarine32 = TColor32($FF7FFFD4);
  clAzure32 = TColor32($FFF0FFFF);
  clBeige32 = TColor32($FFF5F5DC);
  clBisque32 = TColor32($FFFFE4C4);
  clBlancheDalmond32 = TColor32($FFFFEBCD);
  clBlueViolet32 = TColor32($FF8A2BE2);
  clBrown32 = TColor32($FFA52A2A);
  clBurlyWood32 = TColor32($FFDEB887);
  clCadetblue32 = TColor32($FF5F9EA0);
  clChartReuse32 = TColor32($FF7FFF00);
  clChocolate32 = TColor32($FFD2691E);
  clCoral32 = TColor32($FFFF7F50);
  clCornFlowerBlue32 = TColor32($FF6495ED);
  clCornSilk32 = TColor32($FFFFF8DC);
  clCrimson32 = TColor32($FFDC143C);
  clDarkBlue32 = TColor32($FF00008B);
  clDarkCyan32 = TColor32($FF008B8B);
  clDarkGoldenRod32 = TColor32($FFB8860B);
  clDarkGray32 = TColor32($FFA9A9A9);
  clDarkGreen32 = TColor32($FF006400);
  clDarkGrey32 = TColor32($FFA9A9A9);
  clDarkKhaki32 = TColor32($FFBDB76B);
  clDarkMagenta32 = TColor32($FF8B008B);
  clDarkOliveGreen32 = TColor32($FF556B2F);
  clDarkOrange32 = TColor32($FFFF8C00);
  clDarkOrchid32 = TColor32($FF9932CC);
  clDarkRed32 = TColor32($FF8B0000);
  clDarkSalmon32 = TColor32($FFE9967A);
  clDarkSeaGreen32 = TColor32($FF8FBC8F);
  clDarkSlateBlue32 = TColor32($FF483D8B);
  clDarkSlateGray32 = TColor32($FF2F4F4F);
  clDarkSlateGrey32 = TColor32($FF2F4F4F);
  clDarkTurquoise32 = TColor32($FF00CED1);
  clDarkViolet32 = TColor32($FF9400D3);
  clDeepPink32 = TColor32($FFFF1493);
  clDeepSkyBlue32 = TColor32($FF00BFFF);
  clDodgerBlue32 = TColor32($FF1E90FF);
  clFireBrick32 = TColor32($FFB22222);
  clFloralWhite32 = TColor32($FFFFFAF0);
  clGainsBoro32 = TColor32($FFDCDCDC);
  clGhostWhite32 = TColor32($FFF8F8FF);
  clGold32 = TColor32($FFFFD700);
  clGoldenRod32 = TColor32($FFDAA520);
  clGreenYellow32 = TColor32($FFADFF2F);
  clGrey32 = TColor32($FF808080);
  clHoneyDew32 = TColor32($FFF0FFF0);
  clHotPink32 = TColor32($FFFF69B4);
  clIndianRed32 = TColor32($FFCD5C5C);
  clIndigo32 = TColor32($FF4B0082);
  clIvory32 = TColor32($FFFFFFF0);
  clKhaki32 = TColor32($FFF0E68C);
  clLavender32 = TColor32($FFE6E6FA);
  clLavenderBlush32 = TColor32($FFFFF0F5);
  clLawnGreen32 = TColor32($FF7CFC00);
  clLemonChiffon32 = TColor32($FFFFFACD);
  clLightBlue32 = TColor32($FFADD8E6);
  clLightCoral32 = TColor32($FFF08080);
  clLightCyan32 = TColor32($FFE0FFFF);
  clLightGoldenRodYellow32 = TColor32($FFFAFAD2);
  clLightGreen32 = TColor32($FF90EE90);
  clLightGrey32 = TColor32($FFD3D3D3);
  clLightPink32 = TColor32($FFFFB6C1);
  clLightSalmon32 = TColor32($FFFFA07A);
  clLightSeagreen32 = TColor32($FF20B2AA);
  clLightSkyblue32 = TColor32($FF87CEFA);
  clLightSlategray32 = TColor32($FF778899);
  clLightSlategrey32 = TColor32($FF778899);
  clLightSteelblue32 = TColor32($FFB0C4DE);
  clLightYellow32 = TColor32($FFFFFFE0);
  clLtGray32 = TColor32($FFC0C0C0);
  clMedGray32 = TColor32($FFA0A0A4);
  clDkGray32 = TColor32($FF808080);
  clMoneyGreen32 = TColor32($FFC0DCC0);
  clLegacySkyBlue32 = TColor32($FFA6CAF0);
  clCream32 = TColor32($FFFFFBF0);
  clLimeGreen32 = TColor32($FF32CD32);
  clLinen32 = TColor32($FFFAF0E6);
  clMediumAquamarine32 = TColor32($FF66CDAA);
  clMediumBlue32 = TColor32($FF0000CD);
  clMediumOrchid32 = TColor32($FFBA55D3);
  clMediumPurple32 = TColor32($FF9370DB);
  clMediumSeaGreen32 = TColor32($FF3CB371);
  clMediumSlateBlue32 = TColor32($FF7B68EE);
  clMediumSpringGreen32 = TColor32($FF00FA9A);
  clMediumTurquoise32 = TColor32($FF48D1CC);
  clMediumVioletRed32 = TColor32($FFC71585);
  clMidnightBlue32 = TColor32($FF191970);
  clMintCream32 = TColor32($FFF5FFFA);
  clMistyRose32 = TColor32($FFFFE4E1);
  clMoccasin32 = TColor32($FFFFE4B5);
  clNavajoWhite32 = TColor32($FFFFDEAD);
  clOldLace32 = TColor32($FFFDF5E6);
  clOliveDrab32 = TColor32($FF6B8E23);
  clOrange32 = TColor32($FFFFA500);
  clOrangeRed32 = TColor32($FFFF4500);
  clOrchid32 = TColor32($FFDA70D6);
  clPaleGoldenRod32 = TColor32($FFEEE8AA);
  clPaleGreen32 = TColor32($FF98FB98);
  clPaleTurquoise32 = TColor32($FFAFEEEE);
  clPaleVioletred32 = TColor32($FFDB7093);
  clPapayaWhip32 = TColor32($FFFFEFD5);
  clPeachPuff32 = TColor32($FFFFDAB9);
  clPeru32 = TColor32($FFCD853F);
  clPlum32 = TColor32($FFDDA0DD);
  clPowderBlue32 = TColor32($FFB0E0E6);
  clRosyBrown32 = TColor32($FFBC8F8F);
  clRoyalBlue32 = TColor32($FF4169E1);
  clSaddleBrown32 = TColor32($FF8B4513);
  clSalmon32 = TColor32($FFFA8072);
  clSandyBrown32 = TColor32($FFF4A460);
  clSeaGreen32 = TColor32($FF2E8B57);
  clSeaShell32 = TColor32($FFFFF5EE);
  clSienna32 = TColor32($FFA0522D);
  clSilver32 = TColor32($FFC0C0C0);
  clSkyblue32 = TColor32($FF87CEEB);
  clSlateBlue32 = TColor32($FF6A5ACD);
  clSlateGray32 = TColor32($FF708090);
  clSlateGrey32 = TColor32($FF708090);
  clSnow32 = TColor32($FFFFFAFA);
  clSpringgreen32 = TColor32($FF00FF7F);
  clSteelblue32 = TColor32($FF4682B4);
  clTan32 = TColor32($FFD2B48C);
  clThistle32 = TColor32($FFD8BFD8);
  clTomato32 = TColor32($FFFF6347);
  clTurquoise32 = TColor32($FF40E0D0);
  clViolet32 = TColor32($FFEE82EE);
  clWheat32 = TColor32($FFF5DEB3);
  clWhitesmoke32 = TColor32($FFF5F5F5);
  clYellowgreen32 = TColor32($FF9ACD32);

  // Some semi-transparent color constants
  clTrWhite32 = TColor32($7FFFFFFF);
  clTrBlack32 = TColor32($7F000000);
  clTrRed32 = TColor32($7FFF0000);
  clTrGreen32 = TColor32($7F00FF00);
  clTrBlue32 = TColor32($7F0000FF);

implementation

end.
