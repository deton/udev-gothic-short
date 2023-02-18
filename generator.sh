#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)

WORK_DIR="$BASE_DIR/build_tmp"
if [ ! -d "$WORK_DIR" ]
then
  mkdir "$WORK_DIR"
fi

VERSION="$1"
FAMILYNAME="$2"
DISP_FAMILYNAME="$3"
DISP_FAMILYNAME_JP="UDEAWN"
LIGA_FLAG="$4"  # 0: リガチャなし 1: リガチャあり
JPDOC_FLAG="$5"  # 0: JetBrains Monoの記号優先 1: 日本語ドキュメントで使用頻度の高い記号はBIZ UDゴシック優先
NERD_FONTS_FLAG="$6"  # 0: Nerd Fonts なし 1: Nerd Fonts あり
W35_FLAG="$7"  # 0: 通常幅 1: 半角3:全角5幅
ITALIC_FLAG="$8"  # 0: 非イタリック 1: イタリック

EM_ASCENT=1802
EM_DESCENT=246
EM=$(($EM_ASCENT + $EM_DESCENT))

#ASCENT=$(($EM_ASCENT + 160))
#DESCENT=$(($EM_DESCENT + 170))
ASCENT=$EM_ASCENT
DESCENT=$EM_DESCENT
TYPO_LINE_GAP=0

ORIG_FULL_WIDTH=2048
ORIG_HALF_WIDTH=$(($ORIG_FULL_WIDTH / 2))

HALF_WIDTH=$(($EM / 2))
SHRINK_X=90
SHRINK_Y=99

ITALIC_ANGLE=-9

if [ $W35_FLAG -eq 1 ]
then
  ASCENT=$(($EM_ASCENT + 180))
  DESCENT=$(($EM_DESCENT + 220))
  HALF_WIDTH=1227
  FULL_WIDTH=$(($HALF_WIDTH / 3 * 5))
  SHRINK_X=100
  SHRINK_Y=100
fi

FONTS_DIRECTORIES="${BASE_DIR}/source/"

SRC_FONT_JBMONO_REGULAR='JetBrainsMonoNL-Regular.ttf'
SRC_FONT_JBMONO_BOLD='JetBrainsMonoNL-Bold.ttf'
if [ "$LIGA_FLAG" == 0 -a "$ITALIC_FLAG" == 1 ]
then
  SRC_FONT_JBMONO_REGULAR='JetBrainsMonoNL-Italic.ttf'
  SRC_FONT_JBMONO_BOLD='JetBrainsMonoNL-BoldItalic.ttf'
elif [ "$LIGA_FLAG" == 1 -a "$ITALIC_FLAG" == 0 ]
then
  SRC_FONT_JBMONO_REGULAR='JetBrainsMono-Regular.ttf'
  SRC_FONT_JBMONO_BOLD='JetBrainsMono-Bold.ttf'
elif [ "$LIGA_FLAG" == 1 -a "$ITALIC_FLAG" == 1 ]
then
  SRC_FONT_JBMONO_REGULAR='JetBrainsMono-Italic.ttf'
  SRC_FONT_JBMONO_BOLD='JetBrainsMono-BoldItalic.ttf'
fi
SRC_FONT_BIZUD_REGULAR='fontforge_export_BIZUDGothic-Regular.ttf'
SRC_FONT_BIZUD_BOLD='fontforge_export_BIZUDGothic-Bold.ttf'

PATH_JBMONO_REGULAR=`find $FONTS_DIRECTORIES -follow -name "$SRC_FONT_JBMONO_REGULAR"`
PATH_JBMONO_BOLD=`find $FONTS_DIRECTORIES -follow -name "$SRC_FONT_JBMONO_BOLD"`
PATH_BIZUD_REGULAR=`find $FONTS_DIRECTORIES -follow -name "$SRC_FONT_BIZUD_REGULAR"`
PATH_BIZUD_BOLD=`find $FONTS_DIRECTORIES -follow -name "$SRC_FONT_BIZUD_BOLD"`
PATH_IDEOGRAPHIC_SPACE=`find $FONTS_DIRECTORIES -follow -name 'ideographic_space.sfd'`
PATH_ZERO_REGULAR=`find $FONTS_DIRECTORIES -follow -name 'zero-Regular.sfd'`
PATH_ZERO_BOLD=`find $FONTS_DIRECTORIES -follow -name 'zero-Bold.sfd'`
PATH_NERD_FONTS=`find $FONTS_DIRECTORIES -follow -name 'JetBrains Mono Regular Nerd Font Complete.ttf'`

MODIFIED_FONT_JBMONO_REGULAR='modified_jbmono_regular.sfd'
MODIFIED_FONT_JBMONO_BOLD='modified_jbmono_bold.sfd'
MODIFIED_FONT_BIZUD_REGULAR='modified_bizud_regular.ttf'
MODIFIED_FONT_BIZUD_BOLD='modified_bizud_bold.ttf'
MODIFIED_FONT_NERD_FONTS_REGULAR='tmp_nerd_fonts_regular.ttf'
MODIFIED_FONT_NERD_FONTS_BOLD='tmp_nerd_fonts_bold.ttf'
MODIFIED_FONT_BIZUD35_REGULAR='tmp_bizud_regular.ttf'
MODIFIED_FONT_BIZUD35_BOLD='tmp_bizud_bold.ttf'

if [ -z "$SRC_FONT_JBMONO_REGULAR" -o \
-z "$SRC_FONT_JBMONO_BOLD" -o \
-z "$SRC_FONT_BIZUD_REGULAR" -o \
-z "$SRC_FONT_BIZUD_BOLD" ]
then
  echo 'ソースフォントファイルが存在しない'
  exit 1
fi

GEN_SCRIPT_JBMONO='gen_script_jbmono.pe'

NERD_ICON_LIST='
# Powerline フォント -> JetBrains Mono標準のものを使用する
#SelectMore(0ue0a0, 0ue0a2)
#SelectMore(0ue0b0, 0ue0b3)
# 拡張版 Powerline フォント
SelectMore(0ue0a3)
SelectMore(0ue0b4, 0ue0c8)
SelectMore(0ue0ca)
SelectMore(0ue0cc, 0ue0d2)
SelectMore(0ue0d4)
# IEC Power Symbols
SelectMore(0u23fb, 0u23fe)
SelectMore(0u2b58)
# Octicons
SelectMore(0u2665)
SelectMore(0u26A1)
SelectMore(0uf27c)
SelectMore(0uf400, 0uf4a9)
# Font Awesome Extension
SelectMore(0ue200, 0ue2a9)
# Weather
SelectMore(0ue300, 0ue3e3)
# Seti-UI + Custom
SelectMore(0ue5fa, 0ue62e)
# Devicons
SelectMore(0ue700, 0ue7c5)
# Font Awesome
SelectMore(0uf000, 0uf2e0)
# Font Logos (Formerly Font Linux)
SelectMore(0uf300, 0uf31c)
# Material Design Icons
SelectMore(0uf500, 0ufd46)
# Pomicons
SelectMore(0ue000, 0ue00a)
# Codicons
SelectMore(0uea60, 0uebeb)
'

# JetBrains Monoの調整
cat > "${WORK_DIR}/${GEN_SCRIPT_JBMONO}" << _EOT_

# Set parameters
input_list = ["${PATH_JBMONO_REGULAR}", \\
  "${PATH_JBMONO_BOLD}"]
output_list = ["${MODIFIED_FONT_JBMONO_REGULAR}", \\
  "${MODIFIED_FONT_JBMONO_BOLD}"]
zero_list = ["${PATH_ZERO_REGULAR}", \\
  "${PATH_ZERO_BOLD}"]
fontstyle_list    = ["Regular", "Bold"]
if (${ITALIC_FLAG} == 1)
  fontstyle_list    = ["Italic", "Bold Italic"]
endif
fontweight_list = [400, 700]
panoseweight_list = [5, 8]

i = 0
while (i < SizeOf(input_list))
  # フォントファイルを開く
  Print("Open " + input_list[i])
  Open(input_list[i])

  # 0 をスラッシュゼロにする
  Select(0u0030); Clear()
  MergeFonts(zero_list[i])
  # スラッシュゼロの斜体変形
  if (${ITALIC_FLAG} == 1)
    Select(0u0030)
    Italic(${ITALIC_ANGLE}, 1, 0, 1, 1, 1, 1)
    Move(-44, 0)
  endif

  # サイズ調整
  SelectWorthOutputting()
  UnlinkReference()
  ScaleToEm(${EM_ASCENT}, ${EM_DESCENT})
  if (${W35_FLAG} == 0)
    Scale(${SHRINK_X}, ${SHRINK_Y}, 0, 0)
  endif

  # 半角スペースから幅を取得
  Select(0u0020)
  glyphWidth = GlyphInfo("Width")

  # 幅の調整
  SelectWorthOutputting()
  move_x = (${HALF_WIDTH} - glyphWidth) / 2
  Move(move_x, 0)
  foreach
    w = GlyphInfo("Width")
    if (w > 0)
      SetWidth(${HALF_WIDTH}, 0)
    endif
  endloop

  # JPDOC版では、日本語ドキュメントで使用頻度の高い記号はBIZ UDゴシックを優先して適用する
  if ($JPDOC_FLAG == 1)
    SelectNone()
    SelectMore(0u00A7) # §
    SelectMore(0u00B1) # ±
    SelectMore(0u00B6) # ¶
    SelectMore(0u00F7) # ÷
    SelectMore(0u00D7) # ×
    SelectMore(0u21D2) # ⇒
    SelectMore(0u21D4) # ⇔
    SelectMore(0u21E7, 0u21E8) # ⇧-⇨
    SelectMore(0u25A0, 0u25A1) # ■-□
    SelectMore(0u25B2, 0u25B3) # ▲-△
    SelectMore(0u25B6, 0u25B7) # ▶-▷
    SelectMore(0u25BC, 0u25BD) # ▼-▽
    SelectMore(0u25C0, 0u25C1) # ◀-◁
    SelectMore(0u25C6, 0u25C7) # ◆-◇
    SelectMore(0u25CE, 0u25CF) # ◎-●
    SelectMore(0u25EF) # ◯
    SelectMore(0u221A) # √
    SelectMore(0u221E) # ∞
    SelectMore(0u2010, 0u2022) # ‐-•
    SelectMore(0u2026) # …
    SelectMore(0u2030) # ‰
    SelectMore(0u2190, 0u2194) # ←-↔
    SelectMore(0u2196, 0u2199) # ↖-↙
    SelectMore(0u2200) # ∀
    SelectMore(0u2202, 0u2203) # ∂-∃
    SelectMore(0u2208, 0u220C) # ∈-∌
    SelectMore(0u2211, 0u2212) # ∑-−
    SelectMore(0u2225, 0u222B) # ∥-∫
    SelectMore(0u2260, 0u2262) # ≠-≢
    SelectMore(0u2282, 0u2287) # ⊂-⊇
    SelectMore(0u2500, 0u257F) # ─-╿ (Box Drawing)
    Clear()
  endif

  # BIZ UDゴシックから削除するEast Asian Ambiguousグリフリストの作成
  # https://github.com/uwabami/locale-eaw-emoji/blob/master/EastAsianAmbiguous.txt
  eaw_array = [0x00A1, 0x00A4, 0x00A7, 0x00A8, 0x00AA, 0x00AD, 0x00AE, 0x00B0, 0x00B1, 0x00B2, 0x00B3, 0x00B4, 0x00B6, 0x00B7, 0x00B8, 0x00B9, 0x00BA, 0x00BC, 0x00BD, 0x00BE, 0x00BF, 0x00C6, 0x00D0, 0x00D7, 0x00D8, 0x00DE, 0x00DF, 0x00E0, 0x00E1, 0x00E6, 0x00E8, 0x00E9, 0x00EA, 0x00EC, 0x00ED, 0x00F0, 0x00F2, 0x00F3, 0x00F7, 0x00F8, 0x00F9, 0x00FA, 0x00FC, 0x00FE, 0x0101, 0x0111, 0x0113, 0x011B, 0x0126, 0x0127, 0x012B, 0x0131, 0x0132, 0x0133, 0x0138, 0x013F, 0x0140, 0x0141, 0x0142, 0x0144, 0x0148, 0x0149, 0x014A, 0x014B, 0x014D, 0x0152, 0x0153, 0x0166, 0x0167, 0x016B, 0x01CE, 0x01D0, 0x01D2, 0x01D4, 0x01D6, 0x01D8, 0x01DA, 0x01DC, 0x0251, 0x0261, 0x02C4, 0x02C7, 0x02C9, 0x02CA, 0x02CB, 0x02CD, 0x02D0, 0x02D8, 0x02D9, 0x02DA, 0x02DB, 0x02DD, 0x02DF, 0x0391, 0x0392, 0x0393, 0x0394, 0x0395, 0x0396, 0x0397, 0x0398, 0x0399, 0x039A, 0x039B, 0x039C, 0x039D, 0x039E, 0x039F, 0x03A0, 0x03A1, 0x03A3, 0x03A4, 0x03A5, 0x03A6, 0x03A7, 0x03A8, 0x03A9, 0x03B1, 0x03B2, 0x03B3, 0x03B4, 0x03B5, 0x03B6, 0x03B7, 0x03B8, 0x03B9, 0x03BA, 0x03BB, 0x03BC, 0x03BD, 0x03BE, 0x03BF, 0x03C0, 0x03C1, 0x03C3, 0x03C4, 0x03C5, 0x03C6, 0x03C7, 0x03C8, 0x03C9, 0x0401, 0x0410, 0x0411, 0x0412, 0x0413, 0x0414, 0x0415, 0x0416, 0x0417, 0x0418, 0x0419, 0x041A, 0x041B, 0x041C, 0x041D, 0x041E, 0x041F, 0x0420, 0x0421, 0x0422, 0x0423, 0x0424, 0x0425, 0x0426, 0x0427, 0x0428, 0x0429, 0x042A, 0x042B, 0x042C, 0x042D, 0x042E, 0x042F, 0x0430, 0x0431, 0x0432, 0x0433, 0x0434, 0x0435, 0x0436, 0x0437, 0x0438, 0x0439, 0x043A, 0x043B, 0x043C, 0x043D, 0x043E, 0x043F, 0x0440, 0x0441, 0x0442, 0x0443, 0x0444, 0x0445, 0x0446, 0x0447, 0x0448, 0x0449, 0x044A, 0x044B, 0x044C, 0x044D, 0x044E, 0x044F, 0x0451, 0x2010, 0x2013, 0x2014, 0x2015, 0x2016, 0x2018, 0x2019, 0x201C, 0x201D, 0x2020, 0x2021, 0x2022, 0x2024, 0x2025, 0x2026, 0x2027, 0x2030, 0x2032, 0x2033, 0x2035, 0x203B, 0x203E, 0x2074, 0x207F, 0x2080, 0x2081, 0x2082, 0x2083, 0x2084, 0x20AC, 0x2103, 0x2105, 0x2109, 0x2113, 0x2116, 0x2121, 0x2122, 0x2126, 0x212B, 0x2153, 0x2154, 0x215B, 0x215C, 0x215D, 0x215E, 0x2160, 0x2161, 0x2162, 0x2163, 0x2164, 0x2165, 0x2166, 0x2167, 0x2168, 0x2169, 0x216A, 0x216B, 0x2170, 0x2171, 0x2172, 0x2173, 0x2174, 0x2175, 0x2176, 0x2177, 0x2178, 0x2179, 0x2189, 0x2190, 0x2191, 0x2192, 0x2193, 0x2194, 0x2195, 0x2196, 0x2197, 0x2198, 0x2199, 0x21B8, 0x21B9, 0x21D2, 0x21D4, 0x21E7, 0x2200, 0x2202, 0x2203, 0x2207, 0x2208, 0x220B, 0x220F, 0x2211, 0x2215, 0x221A, 0x221D, 0x221E, 0x221F, 0x2220, 0x2223, 0x2225, 0x2227, 0x2228, 0x2229, 0x222A, 0x222B, 0x222C, 0x222E, 0x2234, 0x2235, 0x2236, 0x2237, 0x223C, 0x223D, 0x2248, 0x224C, 0x2252, 0x2260, 0x2261, 0x2264, 0x2265, 0x2266, 0x2267, 0x226A, 0x226B, 0x226E, 0x226F, 0x2282, 0x2283, 0x2286, 0x2287, 0x2295, 0x2299, 0x22A5, 0x22BF, 0x2312, 0x2460, 0x2461, 0x2462, 0x2463, 0x2464, 0x2465, 0x2466, 0x2467, 0x2468, 0x2469, 0x246A, 0x246B, 0x246C, 0x246D, 0x246E, 0x246F, 0x2470, 0x2471, 0x2472, 0x2473, 0x2474, 0x2475, 0x2476, 0x2477, 0x2478, 0x2479, 0x247A, 0x247B, 0x247C, 0x247D, 0x247E, 0x247F, 0x2480, 0x2481, 0x2482, 0x2483, 0x2484, 0x2485, 0x2486, 0x2487, 0x2488, 0x2489, 0x248A, 0x248B, 0x248C, 0x248D, 0x248E, 0x248F, 0x2490, 0x2491, 0x2492, 0x2493, 0x2494, 0x2495, 0x2496, 0x2497, 0x2498, 0x2499, 0x249A, 0x249B, 0x249C, 0x249D, 0x249E, 0x249F, 0x24A0, 0x24A1, 0x24A2, 0x24A3, 0x24A4, 0x24A5, 0x24A6, 0x24A7, 0x24A8, 0x24A9, 0x24AA, 0x24AB, 0x24AC, 0x24AD, 0x24AE, 0x24AF, 0x24B0, 0x24B1, 0x24B2, 0x24B3, 0x24B4, 0x24B5, 0x24B6, 0x24B7, 0x24B8, 0x24B9, 0x24BA, 0x24BB, 0x24BC, 0x24BD, 0x24BE, 0x24BF, 0x24C0, 0x24C1, 0x24C2, 0x24C3, 0x24C4, 0x24C5, 0x24C6, 0x24C7, 0x24C8, 0x24C9, 0x24CA, 0x24CB, 0x24CC, 0x24CD, 0x24CE, 0x24CF, 0x24D0, 0x24D1, 0x24D2, 0x24D3, 0x24D4, 0x24D5, 0x24D6, 0x24D7, 0x24D8, 0x24D9, 0x24DA, 0x24DB, 0x24DC, 0x24DD, 0x24DE, 0x24DF, 0x24E0, 0x24E1, 0x24E2, 0x24E3, 0x24E4, 0x24E5, 0x24E6, 0x24E7, 0x24E8, 0x24E9, 0x24EB, 0x24EC, 0x24ED, 0x24EE, 0x24EF, 0x24F0, 0x24F1, 0x24F2, 0x24F3, 0x24F4, 0x24F5, 0x24F6, 0x24F7, 0x24F8, 0x24F9, 0x24FA, 0x24FB, 0x24FC, 0x24FD, 0x24FE, 0x24FF, 0x2500, 0x2501, 0x2502, 0x2503, 0x2504, 0x2505, 0x2506, 0x2507, 0x2508, 0x2509, 0x250A, 0x250B, 0x250C, 0x250D, 0x250E, 0x250F, 0x2510, 0x2511, 0x2512, 0x2513, 0x2514, 0x2515, 0x2516, 0x2517, 0x2518, 0x2519, 0x251A, 0x251B, 0x251C, 0x251D, 0x251E, 0x251F, 0x2520, 0x2521, 0x2522, 0x2523, 0x2524, 0x2525, 0x2526, 0x2527, 0x2528, 0x2529, 0x252A, 0x252B, 0x252C, 0x252D, 0x252E, 0x252F, 0x2530, 0x2531, 0x2532, 0x2533, 0x2534, 0x2535, 0x2536, 0x2537, 0x2538, 0x2539, 0x253A, 0x253B, 0x253C, 0x253D, 0x253E, 0x253F, 0x2540, 0x2541, 0x2542, 0x2543, 0x2544, 0x2545, 0x2546, 0x2547, 0x2548, 0x2549, 0x254A, 0x254B, 0x2550, 0x2551, 0x2552, 0x2553, 0x2554, 0x2555, 0x2556, 0x2557, 0x2558, 0x2559, 0x255A, 0x255B, 0x255C, 0x255D, 0x255E, 0x255F, 0x2560, 0x2561, 0x2562, 0x2563, 0x2564, 0x2565, 0x2566, 0x2567, 0x2568, 0x2569, 0x256A, 0x256B, 0x256C, 0x256D, 0x256E, 0x256F, 0x2570, 0x2571, 0x2572, 0x2573, 0x2580, 0x2581, 0x2582, 0x2583, 0x2584, 0x2585, 0x2586, 0x2587, 0x2588, 0x2589, 0x258A, 0x258B, 0x258C, 0x258D, 0x258E, 0x258F, 0x2592, 0x2593, 0x2594, 0x2595, 0x25A0, 0x25A1, 0x25A3, 0x25A4, 0x25A5, 0x25A6, 0x25A7, 0x25A8, 0x25A9, 0x25B2, 0x25B3, 0x25B6, 0x25B7, 0x25BC, 0x25BD, 0x25C0, 0x25C1, 0x25C6, 0x25C7, 0x25C8, 0x25CB, 0x25CE, 0x25CF, 0x25D0, 0x25D1, 0x25E2, 0x25E3, 0x25E4, 0x25E5, 0x25EF, 0x2605, 0x2606, 0x2609, 0x260E, 0x260F, 0x261C, 0x261E, 0x2640, 0x2642, 0x2660, 0x2661, 0x2662, 0x2663, 0x2664, 0x2665, 0x2666, 0x2667, 0x2668, 0x2669, 0x266A, 0x266C, 0x266D, 0x266F, 0x269E, 0x269F, 0x26BF, 0x26C6, 0x26C7, 0x26C8, 0x26C9, 0x26CA, 0x26CB, 0x26CC, 0x26CD, 0x26CF, 0x26D0, 0x26D1, 0x26D2, 0x26D3, 0x26D5, 0x26D6, 0x26D7, 0x26D8, 0x26D9, 0x26DA, 0x26DB, 0x26DC, 0x26DD, 0x26DE, 0x26DF, 0x26E0, 0x26E1, 0x26E3, 0x26E8, 0x26E9, 0x26EB, 0x26EC, 0x26ED, 0x26EE, 0x26EF, 0x26F0, 0x26F1, 0x26F4, 0x26F6, 0x26F7, 0x26F8, 0x26F9, 0x26FB, 0x26FC, 0x26FE, 0x26FF, 0x273D, 0x2776, 0x2777, 0x2778, 0x2779, 0x277A, 0x277B, 0x277C, 0x277D, 0x277E, 0x277F, 0x2B56, 0x2B57, 0x2B58, 0x2B59, 0x3248, 0x3249, 0x324A, 0x324B, 0x324C, 0x324D, 0x324E, 0x324F, 0xFFFD, 0x0001F100, 0x0001F101, 0x0001F102, 0x0001F103, 0x0001F104, 0x0001F105, 0x0001F106, 0x0001F107, 0x0001F108, 0x0001F109, 0x0001F10A, 0x0001F110, 0x0001F111, 0x0001F112, 0x0001F113, 0x0001F114, 0x0001F115, 0x0001F116, 0x0001F117, 0x0001F118, 0x0001F119, 0x0001F11A, 0x0001F11B, 0x0001F11C, 0x0001F11D, 0x0001F11E, 0x0001F11F, 0x0001F120, 0x0001F121, 0x0001F122, 0x0001F123, 0x0001F124, 0x0001F125, 0x0001F126, 0x0001F127, 0x0001F128, 0x0001F129, 0x0001F12A, 0x0001F12B, 0x0001F12C, 0x0001F12D, 0x0001F130, 0x0001F131, 0x0001F132, 0x0001F133, 0x0001F134, 0x0001F135, 0x0001F136, 0x0001F137, 0x0001F138, 0x0001F139, 0x0001F13A, 0x0001F13B, 0x0001F13C, 0x0001F13D, 0x0001F13E, 0x0001F13F, 0x0001F140, 0x0001F141, 0x0001F142, 0x0001F143, 0x0001F144, 0x0001F145, 0x0001F146, 0x0001F147, 0x0001F148, 0x0001F149, 0x0001F14A, 0x0001F14B, 0x0001F14C, 0x0001F14D, 0x0001F14E, 0x0001F14F, 0x0001F150, 0x0001F151, 0x0001F152, 0x0001F153, 0x0001F154, 0x0001F155, 0x0001F156, 0x0001F157, 0x0001F158, 0x0001F159, 0x0001F15A, 0x0001F15B, 0x0001F15C, 0x0001F15D, 0x0001F15E, 0x0001F15F, 0x0001F160, 0x0001F161, 0x0001F162, 0x0001F163, 0x0001F164, 0x0001F165, 0x0001F166, 0x0001F167, 0x0001F168, 0x0001F169, 0x0001F170, 0x0001F171, 0x0001F172, 0x0001F173, 0x0001F174, 0x0001F175, 0x0001F176, 0x0001F177, 0x0001F178, 0x0001F179, 0x0001F17A, 0x0001F17B, 0x0001F17C, 0x0001F17D, 0x0001F17E, 0x0001F17F, 0x0001F180, 0x0001F181, 0x0001F182, 0x0001F183, 0x0001F184, 0x0001F185, 0x0001F186, 0x0001F187, 0x0001F188, 0x0001F189, 0x0001F18A, 0x0001F18B, 0x0001F18C, 0x0001F18D, 0x0001F18F, 0x0001F190, 0x0001F19B, 0x0001F19C, 0x0001F19D, 0x0001F19E, 0x0001F19F, 0x0001F1A0, 0x0001F1A1, 0x0001F1A2, 0x0001F1A3, 0x0001F1A4, 0x0001F1A5, 0x0001F1A6, 0x0001F1A7, 0x0001F1A8, 0x0001F1A9, 0x0001F1AA, 0x0001F1AB, 0x0001F1AC]
  array_end = SizeOf(eaw_array)
  exist_glyph_array = Array(array_end)
  SelectNone()
  j = 0
  while (j < array_end)
    ucode = eaw_array[j]
    if (WorthOutputting(ucode))
      SelectMore(ucode)
      exist_glyph_array[j] = 1
    else
      exist_glyph_array[j] = 0
    endif
    j++
  endloop
  # East Asian Ambiguousのみにするため、それ以外を削除
  SelectInvert(); Clear()

  # パスの小数点以下を切り捨て
  SelectWorthOutputting()
  RoundToInt()

  # 修正後のフォントファイルを保存
  Print("Save " + output_list[i])
  Save("${WORK_DIR}/" + output_list[i])
  Close()

  # 出力フォントファイルの作成
  New()
  Reencode("unicode")
  ScaleToEm(${EM_ASCENT}, ${EM_DESCENT})

  MergeFonts("${WORK_DIR}/" + output_list[i])

  Print("Save " + output_list[i])
  SetOS2Value("Weight", fontweight_list[i]) # Book or Bold
  SetOS2Value("Width",                   5) # Medium
  SetOS2Value("FSType",                  0)
  SetOS2Value("VendorID",           "twr")
  SetOS2Value("IBMFamily",            2057) # SS Typewriter Gothic
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${ASCENT})
  SetOS2Value("WinDescent",            ${DESCENT})
  SetOS2Value("TypoAscent",            ${ASCENT})
  SetOS2Value("TypoDescent",          -${DESCENT})
  SetOS2Value("TypoLineGap",           ${TYPO_LINE_GAP})
  SetOS2Value("HHeadAscent",           ${ASCENT})
  SetOS2Value("HHeadDescent",         -${DESCENT})
  SetOS2Value("HHeadLineGap",            0)
  if (${W35_FLAG} == 0)
    SetPanose([2, 11, panoseweight_list[i], 9, 2, 2, 3, 2, 2, 7])
  else
    SetPanose([2, 11, panoseweight_list[i], 3, 2, 2, 3, 2, 2, 7])
  endif

  fontname_style = fontstyle_list[i]
  # 斜体の設定
  if (Strstr(fontstyle_list[i], 'Italic') >= 0)
    SetItalicAngle(${ITALIC_ANGLE})
    if (Strstr(fontstyle_list[i], ' Italic') >= 0)
      splited_style = StrSplit(fontstyle_list[i], " ")
      fontname_style = splited_style[0] + splited_style[1]
    endif
  endif

  fontfamily = "$FAMILYNAME"
  disp_fontfamily = "$DISP_FAMILYNAME"
  base_style = fontstyle_list[i]
  copyright = "###COPYRIGHT###"
  version = "$VERSION"

  # TTF名設定 - 英語
  SetTTFName(0x409, 0, copyright)
  SetTTFName(0x409, 1, disp_fontfamily)
  SetTTFName(0x409, 2, fontstyle_list[i])
  SetTTFName(0x409, 3, disp_fontfamily + " : " + Strftime("%d-%m-%Y", 0))
  SetTTFName(0x409, 4, disp_fontfamily + " " + fontstyle_list[i])
  SetTTFName(0x409, 5, version)
  SetTTFName(0x409, 6, fontfamily + "-" + fontname_style)
  # TTF名設定 - 日本語
  # SetTTFName(0x411, 1, "${DISP_FAMILYNAME_JP}")
  # SetTTFName(0x411, 2, fontstyle_list[i])
  # SetTTFName(0x411, 3, "FontForge 2.0 : " + \$fullname + " : " + Strftime("%d-%m-%Y", 0))
  # SetTTFName(0x411, 4, "${DISP_FAMILYNAME_JP}" + " " + fontstyle_list[i])

  #Generate("${WORK_DIR}/" + output_list[i], '')
  Generate("${WORK_DIR}/" + fontfamily + "-" + fontname_style + ".ttf", "")
  Close()

  i += 1
endloop

# BIZ UDゴシックの調整
input_list = ["${PATH_BIZUD_REGULAR}", \\
  "${PATH_BIZUD_BOLD}"]
output_list = ["${MODIFIED_FONT_BIZUD_REGULAR}", \\
  "${MODIFIED_FONT_BIZUD_BOLD}"]

i = 0
while (i < SizeOf(input_list))
  New()
  Reencode("unicode")
  ScaleToEm(${EM_ASCENT}, ${EM_DESCENT})

  MergeFonts(input_list[i])

  SelectWorthOutputting()
  UnlinkReference()

  # リガチャが含まれる行にひらがな等の全角文字を入力すると、リガチャが解除される事象への対策
  if ($LIGA_FLAG == 1)
    lookups = GetLookups("GSUB"); numlookups = SizeOf(lookups); j = 0;
    while (j < numlookups)
      RemoveLookup(lookups[j])
      j++
    endloop
  endif

  # East Asian AmbiguousなグリフをBIZ UDゴシックから削除
  j = 0
  while (j < array_end)
    ucode = eaw_array[j]
    if (WorthOutputting(ucode))
      Select(ucode)
      if (exist_glyph_array[j] == 1)
        Clear()
      endif
    endif
    j++
  endloop

  # 斜体に変形
  if (${ITALIC_FLAG} == 1)
    SelectWorthOutputting()
    Italic(${ITALIC_ANGLE})
    foreach
      w = GlyphInfo("Width")
      if (w > 0 && w > ${HALF_WIDTH})
        SetWidth(${ORIG_FULL_WIDTH}, 0)
      elseif (w > 0)
        SetWidth(${ORIG_HALF_WIDTH}, 0)
      endif
    endloop
  endif

  # 全角スペースの可視化
  #Select(0u3000); Clear()
  #MergeFonts("${PATH_IDEOGRAPHIC_SPACE}")

  # 高さ調整
  SetOS2Value("WinAscentIsOffset",       0)
  SetOS2Value("WinDescentIsOffset",      0)
  SetOS2Value("TypoAscentIsOffset",      0)
  SetOS2Value("TypoDescentIsOffset",     0)
  SetOS2Value("HHeadAscentIsOffset",     0)
  SetOS2Value("HHeadDescentIsOffset",    0)
  SetOS2Value("WinAscent",             ${ASCENT})
  SetOS2Value("WinDescent",            ${DESCENT})
  SetOS2Value("TypoAscent",            ${ASCENT})
  SetOS2Value("TypoDescent",          -${DESCENT})
  SetOS2Value("TypoLineGap",           ${TYPO_LINE_GAP})
  SetOS2Value("HHeadAscent",           ${ASCENT})
  SetOS2Value("HHeadDescent",         -${DESCENT})
  SetOS2Value("HHeadLineGap",            0)

  # 修正後のフォントファイルを保存
  Print("Save " + output_list[i])
  Generate("${WORK_DIR}/" + output_list[i])
  Close()

  i++
endloop

# Nerd Fonts グリフの準備
if (${NERD_FONTS_FLAG} == 1)
  input_list = ["${WORK_DIR}/${MODIFIED_FONT_BIZUD_REGULAR}", \\
    "${WORK_DIR}/${MODIFIED_FONT_BIZUD_BOLD}"]
  output_list = ["${MODIFIED_FONT_NERD_FONTS_REGULAR}", \\
    "${MODIFIED_FONT_NERD_FONTS_BOLD}"]

  i = 0
  while (i < SizeOf(input_list))
    Open("$PATH_NERD_FONTS")

    # 必要なグリフのみ残し、残りを削除
    SelectNone()
    $NERD_ICON_LIST
    # 選択していない箇所を選択して削除する
    SelectInvert(); Clear()

    lookups = GetLookups("GSUB"); numlookups = SizeOf(lookups); j = 0;
    while (j < numlookups)
      RemoveLookup(lookups[j]); j++
    endloop
    lookups = GetLookups("GPOS"); numlookups = SizeOf(lookups); j = 0;
    while (j < numlookups)
      RemoveLookup(lookups[j]); j++
    endloop

    # サイズ調整
    SelectWorthOutputting()
    ScaleToEm(${EM_ASCENT}, ${EM_DESCENT})
    if (${W35_FLAG} == 0)
      Scale(${SHRINK_X}, ${SHRINK_Y}, 0, 0)
    endif
    SetWidth(${HALF_WIDTH}, 0)

    MergeFonts(input_list[i])
    if (${W35_FLAG} == 1)
      SelectNone()
      $NERD_ICON_LIST
      SelectInvert()
      move_x = ${FULL_WIDTH} - 2048
      Move(move_x, 0)
    endif

    # JetBrains Monoに含まれるグリフの削除
    j = 0
    while (j < array_end)
      if (WorthOutputting(j))
        Select(j)
        if (exist_glyph_array[j] == 1)
          Clear()
        endif
      endif
      j++
    endloop

    # 高さ調整
    SetOS2Value("WinAscentIsOffset",       0)
    SetOS2Value("WinDescentIsOffset",      0)
    SetOS2Value("TypoAscentIsOffset",      0)
    SetOS2Value("TypoDescentIsOffset",     0)
    SetOS2Value("HHeadAscentIsOffset",     0)
    SetOS2Value("HHeadDescentIsOffset",    0)
    SetOS2Value("WinAscent",             ${ASCENT})
    SetOS2Value("WinDescent",            ${DESCENT})
    SetOS2Value("TypoAscent",            ${ASCENT})
    SetOS2Value("TypoDescent",          -${DESCENT})
    SetOS2Value("TypoLineGap",           ${TYPO_LINE_GAP})
    SetOS2Value("HHeadAscent",           ${ASCENT})
    SetOS2Value("HHeadDescent",         -${DESCENT})
    SetOS2Value("HHeadLineGap",            0)

    Generate("${WORK_DIR}/" + output_list[i], "")
    Close()

    i += 1
  endloop
elseif (${W35_FLAG} == 1)
  # 35幅版の準備

  input_list = ["${WORK_DIR}/${MODIFIED_FONT_BIZUD_REGULAR}", \\
    "${WORK_DIR}/${MODIFIED_FONT_BIZUD_BOLD}"]
  output_list = ["${MODIFIED_FONT_BIZUD35_REGULAR}", \\
    "${MODIFIED_FONT_BIZUD35_BOLD}"]

  i = 0
  while (i < SizeOf(input_list))
    New()
    Reencode("unicode")
    ScaleToEm(${EM_ASCENT}, ${EM_DESCENT})

    MergeFonts(input_list[i])

    # 各グリフの幅調整
    SelectWorthOutputting()
    move_x = ${FULL_WIDTH} - 2048
    Move(move_x, 0)

    # 高さ調整
    SetOS2Value("WinAscentIsOffset",       0)
    SetOS2Value("WinDescentIsOffset",      0)
    SetOS2Value("TypoAscentIsOffset",      0)
    SetOS2Value("TypoDescentIsOffset",     0)
    SetOS2Value("HHeadAscentIsOffset",     0)
    SetOS2Value("HHeadDescentIsOffset",    0)
    SetOS2Value("WinAscent",             ${ASCENT})
    SetOS2Value("WinDescent",            ${DESCENT})
    SetOS2Value("TypoAscent",            ${ASCENT})
    SetOS2Value("TypoDescent",          -${DESCENT})
    SetOS2Value("TypoLineGap",           ${TYPO_LINE_GAP})
    SetOS2Value("HHeadAscent",           ${ASCENT})
    SetOS2Value("HHeadDescent",         -${DESCENT})
    SetOS2Value("HHeadLineGap",            0)

    Generate("${WORK_DIR}/" + output_list[i], "")
    Close()

    i += 1
  endloop
endif
_EOT_

fontforge -script ${WORK_DIR}/${GEN_SCRIPT_JBMONO}

for f in `ls "${WORK_DIR}/${FAMILYNAME}"*.ttf`
do
  python3 -m ttfautohint -l 6 -r 45 -a nnn -D latn -f none -S -W -X "13-" -I "$f" "${f}_hinted"
done

# vhea, vmtxテーブル削除
# for f in "${WORK_DIR}/${MODIFIED_FONT_BIZUD_REGULAR}" "${WORK_DIR}/${MODIFIED_FONT_BIZUD_BOLD}"
# do
#   target="${WORK_DIR}/${f##*/}"
#   pyftsubset "${target}" '*' --drop-tables+=vhea --drop-tables+=vmtx --layout-features='*' --glyph-names --symbol-cmap --legacy-cmap --notdef-glyph --notdef-outline --recommended-glyphs --name-IDs='*' --name-legacy --name-languages='*'
# done

if [ $ITALIC_FLAG -eq 1 ]
then
  regular_name='Italic'
  bold_name='BoldItalic'
else
  regular_name='Regular'
  bold_name='Bold'
fi

if [ $NERD_FONTS_FLAG -eq 1 ]
then
  pyftmerge "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_NERD_FONTS_REGULAR}"
  mv -f merged.ttf "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf"

  pyftmerge "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_NERD_FONTS_BOLD}"
  mv -f merged.ttf "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf"
elif [ $W35_FLAG -eq 1 ]
then
  pyftmerge "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_BIZUD35_REGULAR}"
  mv -f merged.ttf "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf"

  pyftmerge "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_BIZUD35_BOLD}"
  mv -f merged.ttf "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf"
else
  # pyftmerge "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_BIZUD_REGULAR%%.ttf}.subset.ttf"
  pyftmerge "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_BIZUD_REGULAR}"
  mv -f merged.ttf "${WORK_DIR}/${FAMILYNAME}-${regular_name}.ttf"

  # pyftmerge "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_BIZUD_BOLD%%.ttf}.subset.ttf"
  pyftmerge "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf_hinted" "${WORK_DIR}/${MODIFIED_FONT_BIZUD_BOLD}"
  mv -f merged.ttf "${WORK_DIR}/${FAMILYNAME}-${bold_name}.ttf"
fi
