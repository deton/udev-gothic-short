#!/usr/bin/fontforge
# East Asian Ambiguousなグリフの幅を半分に縮める
#   Usage: fontforge -script eaa2narrow.py <srcfont.ttf> <fontfamily> <fontstyle> <version>
#   Ex: fontforge -script eaa2narrow.py source/fontforge_export_BIZUDGothic-Regular.ttf UDEAWH Regular 0.0.1
import datetime
import math
import sys
import fontforge
import psMat

SIDE_BEARING = 60  # 幅を縮小後に残しておく、左右side bearing(余白)の合計値

# East Asian Ambiguousのリスト
# のうち、BIZ UDゴシックで元々半分幅に収まっている文字
eaw_useright = [0x2018, 0x201C]
eaw_useleft = [0x00B0, 0x2019, 0x201D, 0x2032, 0x2033]
# https://github.com/uwabami/locale-eaw-emoji/blob/master/EastAsianAmbiguous.txt
eaw_array = [ \
  0x00A1, 0x00A4, 0x00A7, 0x00A8, 0x00AA, 0x00AD, 0x00AE, 0x00B0, 0x00B1, \
  0x00B2, 0x00B3, 0x00B4, 0x00B6, 0x00B7, 0x00B8, 0x00B9, 0x00BA, 0x00BC, \
  0x00BD, 0x00BE, 0x00BF, 0x00C6, 0x00D0, 0x00D7, 0x00D8, 0x00DE, 0x00DF, \
  0x00E0, 0x00E1, 0x00E6, 0x00E8, 0x00E9, 0x00EA, 0x00EC, 0x00ED, 0x00F0, \
  0x00F2, 0x00F3, 0x00F7, 0x00F8, 0x00F9, 0x00FA, 0x00FC, 0x00FE, 0x0101, \
  0x0111, 0x0113, 0x011B, 0x0126, 0x0127, 0x012B, 0x0131, 0x0132, 0x0133, \
  0x0138, 0x013F, 0x0140, 0x0141, 0x0142, 0x0144, 0x0148, 0x0149, 0x014A, \
  0x014B, 0x014D, 0x0152, 0x0153, 0x0166, 0x0167, 0x016B, 0x01CE, 0x01D0, \
  0x01D2, 0x01D4, 0x01D6, 0x01D8, 0x01DA, 0x01DC, 0x0251, 0x0261, 0x02C4, \
  0x02C7, 0x02C9, 0x02CA, 0x02CB, 0x02CD, 0x02D0, 0x02D8, 0x02D9, 0x02DA, \
  0x02DB, 0x02DD, 0x02DF, 0x0391, 0x0392, 0x0393, 0x0394, 0x0395, 0x0396, \
  0x0397, 0x0398, 0x0399, 0x039A, 0x039B, 0x039C, 0x039D, 0x039E, 0x039F, \
  0x03A0, 0x03A1, 0x03A3, 0x03A4, 0x03A5, 0x03A6, 0x03A7, 0x03A8, 0x03A9, \
  0x03B1, 0x03B2, 0x03B3, 0x03B4, 0x03B5, 0x03B6, 0x03B7, 0x03B8, 0x03B9, \
  0x03BA, 0x03BB, 0x03BC, 0x03BD, 0x03BE, 0x03BF, 0x03C0, 0x03C1, 0x03C3, \
  0x03C4, 0x03C5, 0x03C6, 0x03C7, 0x03C8, 0x03C9, 0x0401, 0x0410, 0x0411, \
  0x0412, 0x0413, 0x0414, 0x0415, 0x0416, 0x0417, 0x0418, 0x0419, 0x041A, \
  0x041B, 0x041C, 0x041D, 0x041E, 0x041F, 0x0420, 0x0421, 0x0422, 0x0423, \
  0x0424, 0x0425, 0x0426, 0x0427, 0x0428, 0x0429, 0x042A, 0x042B, 0x042C, \
  0x042D, 0x042E, 0x042F, 0x0430, 0x0431, 0x0432, 0x0433, 0x0434, 0x0435, \
  0x0436, 0x0437, 0x0438, 0x0439, 0x043A, 0x043B, 0x043C, 0x043D, 0x043E, \
  0x043F, 0x0440, 0x0441, 0x0442, 0x0443, 0x0444, 0x0445, 0x0446, 0x0447, \
  0x0448, 0x0449, 0x044A, 0x044B, 0x044C, 0x044D, 0x044E, 0x044F, 0x0451, \
  0x2010, 0x2013, 0x2014, 0x2015, 0x2016, 0x2018, 0x2019, 0x201C, 0x201D, \
  0x2020, 0x2021, 0x2022, 0x2024, 0x2025, 0x2026, 0x2027, 0x2030, 0x2032, \
  0x2033, 0x2035, 0x203B, 0x203E, 0x2074, 0x207F, 0x2080, 0x2081, 0x2082, \
  0x2083, 0x2084, 0x20AC, 0x2103, 0x2105, 0x2109, 0x2113, 0x2116, 0x2121, \
  0x2122, 0x2126, 0x212B, 0x2153, 0x2154, 0x215B, 0x215C, 0x215D, 0x215E, \
  0x2160, 0x2161, 0x2162, 0x2163, 0x2164, 0x2165, 0x2166, 0x2167, 0x2168, \
  0x2169, 0x216A, 0x216B, 0x2170, 0x2171, 0x2172, 0x2173, 0x2174, 0x2175, \
  0x2176, 0x2177, 0x2178, 0x2179, 0x2189, 0x2190, 0x2191, 0x2192, 0x2193, \
  0x2194, 0x2195, 0x2196, 0x2197, 0x2198, 0x2199, 0x21B8, 0x21B9, 0x21D2, \
  0x21D4, 0x21E7, 0x2200, 0x2202, 0x2203, 0x2207, 0x2208, 0x220B, 0x220F, \
  0x2211, 0x2215, 0x221A, 0x221D, 0x221E, 0x221F, 0x2220, 0x2223, 0x2225, \
  0x2227, 0x2228, 0x2229, 0x222A, 0x222B, 0x222C, 0x222E, 0x2234, 0x2235, \
  0x2236, 0x2237, 0x223C, 0x223D, 0x2248, 0x224C, 0x2252, 0x2260, 0x2261, \
  0x2264, 0x2265, 0x2266, 0x2267, 0x226A, 0x226B, 0x226E, 0x226F, 0x2282, \
  0x2283, 0x2286, 0x2287, 0x2295, 0x2299, 0x22A5, 0x22BF, 0x2312, 0x2460, \
  0x2461, 0x2462, 0x2463, 0x2464, 0x2465, 0x2466, 0x2467, 0x2468, 0x2469, \
  0x246A, 0x246B, 0x246C, 0x246D, 0x246E, 0x246F, 0x2470, 0x2471, 0x2472, \
  0x2473, 0x2474, 0x2475, 0x2476, 0x2477, 0x2478, 0x2479, 0x247A, 0x247B, \
  0x247C, 0x247D, 0x247E, 0x247F, 0x2480, 0x2481, 0x2482, 0x2483, 0x2484, \
  0x2485, 0x2486, 0x2487, 0x2488, 0x2489, 0x248A, 0x248B, 0x248C, 0x248D, \
  0x248E, 0x248F, 0x2490, 0x2491, 0x2492, 0x2493, 0x2494, 0x2495, 0x2496, \
  0x2497, 0x2498, 0x2499, 0x249A, 0x249B, 0x249C, 0x249D, 0x249E, 0x249F, \
  0x24A0, 0x24A1, 0x24A2, 0x24A3, 0x24A4, 0x24A5, 0x24A6, 0x24A7, 0x24A8, \
  0x24A9, 0x24AA, 0x24AB, 0x24AC, 0x24AD, 0x24AE, 0x24AF, 0x24B0, 0x24B1, \
  0x24B2, 0x24B3, 0x24B4, 0x24B5, 0x24B6, 0x24B7, 0x24B8, 0x24B9, 0x24BA, \
  0x24BB, 0x24BC, 0x24BD, 0x24BE, 0x24BF, 0x24C0, 0x24C1, 0x24C2, 0x24C3, \
  0x24C4, 0x24C5, 0x24C6, 0x24C7, 0x24C8, 0x24C9, 0x24CA, 0x24CB, 0x24CC, \
  0x24CD, 0x24CE, 0x24CF, 0x24D0, 0x24D1, 0x24D2, 0x24D3, 0x24D4, 0x24D5, \
  0x24D6, 0x24D7, 0x24D8, 0x24D9, 0x24DA, 0x24DB, 0x24DC, 0x24DD, 0x24DE, \
  0x24DF, 0x24E0, 0x24E1, 0x24E2, 0x24E3, 0x24E4, 0x24E5, 0x24E6, 0x24E7, \
  0x24E8, 0x24E9, 0x24EB, 0x24EC, 0x24ED, 0x24EE, 0x24EF, 0x24F0, 0x24F1, \
  0x24F2, 0x24F3, 0x24F4, 0x24F5, 0x24F6, 0x24F7, 0x24F8, 0x24F9, 0x24FA, \
  0x24FB, 0x24FC, 0x24FD, 0x24FE, 0x24FF, 0x2500, 0x2501, 0x2502, 0x2503, \
  0x2504, 0x2505, 0x2506, 0x2507, 0x2508, 0x2509, 0x250A, 0x250B, 0x250C, \
  0x250D, 0x250E, 0x250F, 0x2510, 0x2511, 0x2512, 0x2513, 0x2514, 0x2515, \
  0x2516, 0x2517, 0x2518, 0x2519, 0x251A, 0x251B, 0x251C, 0x251D, 0x251E, \
  0x251F, 0x2520, 0x2521, 0x2522, 0x2523, 0x2524, 0x2525, 0x2526, 0x2527, \
  0x2528, 0x2529, 0x252A, 0x252B, 0x252C, 0x252D, 0x252E, 0x252F, 0x2530, \
  0x2531, 0x2532, 0x2533, 0x2534, 0x2535, 0x2536, 0x2537, 0x2538, 0x2539, \
  0x253A, 0x253B, 0x253C, 0x253D, 0x253E, 0x253F, 0x2540, 0x2541, 0x2542, \
  0x2543, 0x2544, 0x2545, 0x2546, 0x2547, 0x2548, 0x2549, 0x254A, 0x254B, \
  0x2550, 0x2551, 0x2552, 0x2553, 0x2554, 0x2555, 0x2556, 0x2557, 0x2558, \
  0x2559, 0x255A, 0x255B, 0x255C, 0x255D, 0x255E, 0x255F, 0x2560, 0x2561, \
  0x2562, 0x2563, 0x2564, 0x2565, 0x2566, 0x2567, 0x2568, 0x2569, 0x256A, \
  0x256B, 0x256C, 0x256D, 0x256E, 0x256F, 0x2570, 0x2571, 0x2572, 0x2573, \
  0x2580, 0x2581, 0x2582, 0x2583, 0x2584, 0x2585, 0x2586, 0x2587, 0x2588, \
  0x2589, 0x258A, 0x258B, 0x258C, 0x258D, 0x258E, 0x258F, 0x2592, 0x2593, \
  0x2594, 0x2595, 0x25A0, 0x25A1, 0x25A3, 0x25A4, 0x25A5, 0x25A6, 0x25A7, \
  0x25A8, 0x25A9, 0x25B2, 0x25B3, 0x25B6, 0x25B7, 0x25BC, 0x25BD, 0x25C0, \
  0x25C1, 0x25C6, 0x25C7, 0x25C8, 0x25CB, 0x25CE, 0x25CF, 0x25D0, 0x25D1, \
  0x25E2, 0x25E3, 0x25E4, 0x25E5, 0x25EF, 0x2605, 0x2606, 0x2609, 0x260E, \
  0x260F, 0x261C, 0x261E, 0x2640, 0x2642, 0x2660, 0x2661, 0x2662, 0x2663, \
  0x2664, 0x2665, 0x2666, 0x2667, 0x2668, 0x2669, 0x266A, 0x266C, 0x266D, \
  0x266F, 0x269E, 0x269F, 0x26BF, 0x26C6, 0x26C7, 0x26C8, 0x26C9, 0x26CA, \
  0x26CB, 0x26CC, 0x26CD, 0x26CF, 0x26D0, 0x26D1, 0x26D2, 0x26D3, 0x26D5, \
  0x26D6, 0x26D7, 0x26D8, 0x26D9, 0x26DA, 0x26DB, 0x26DC, 0x26DD, 0x26DE, \
  0x26DF, 0x26E0, 0x26E1, 0x26E3, 0x26E8, 0x26E9, 0x26EB, 0x26EC, 0x26ED, \
  0x26EE, 0x26EF, 0x26F0, 0x26F1, 0x26F4, 0x26F6, 0x26F7, 0x26F8, 0x26F9, \
  0x26FB, 0x26FC, 0x26FE, 0x26FF, 0x273D, 0x2776, 0x2777, 0x2778, 0x2779, \
  0x277A, 0x277B, 0x277C, 0x277D, 0x277E, 0x277F, 0x2B56, 0x2B57, 0x2B58, \
  0x2B59, 0x3248, 0x3249, 0x324A, 0x324B, 0x324C, 0x324D, 0x324E, 0x324F, \
  0xFFFD, \
  0x0001F100, 0x0001F101, 0x0001F102, 0x0001F103, 0x0001F104, 0x0001F105, \
  0x0001F106, 0x0001F107, 0x0001F108, 0x0001F109, 0x0001F10A, 0x0001F110, \
  0x0001F111, 0x0001F112, 0x0001F113, 0x0001F114, 0x0001F115, 0x0001F116, \
  0x0001F117, 0x0001F118, 0x0001F119, 0x0001F11A, 0x0001F11B, 0x0001F11C, \
  0x0001F11D, 0x0001F11E, 0x0001F11F, 0x0001F120, 0x0001F121, 0x0001F122, \
  0x0001F123, 0x0001F124, 0x0001F125, 0x0001F126, 0x0001F127, 0x0001F128, \
  0x0001F129, 0x0001F12A, 0x0001F12B, 0x0001F12C, 0x0001F12D, 0x0001F130, \
  0x0001F131, 0x0001F132, 0x0001F133, 0x0001F134, 0x0001F135, 0x0001F136, \
  0x0001F137, 0x0001F138, 0x0001F139, 0x0001F13A, 0x0001F13B, 0x0001F13C, \
  0x0001F13D, 0x0001F13E, 0x0001F13F, 0x0001F140, 0x0001F141, 0x0001F142, \
  0x0001F143, 0x0001F144, 0x0001F145, 0x0001F146, 0x0001F147, 0x0001F148, \
  0x0001F149, 0x0001F14A, 0x0001F14B, 0x0001F14C, 0x0001F14D, 0x0001F14E, \
  0x0001F14F, 0x0001F150, 0x0001F151, 0x0001F152, 0x0001F153, 0x0001F154, \
  0x0001F155, 0x0001F156, 0x0001F157, 0x0001F158, 0x0001F159, 0x0001F15A, \
  0x0001F15B, 0x0001F15C, 0x0001F15D, 0x0001F15E, 0x0001F15F, 0x0001F160, \
  0x0001F161, 0x0001F162, 0x0001F163, 0x0001F164, 0x0001F165, 0x0001F166, \
  0x0001F167, 0x0001F168, 0x0001F169, 0x0001F170, 0x0001F171, 0x0001F172, \
  0x0001F173, 0x0001F174, 0x0001F175, 0x0001F176, 0x0001F177, 0x0001F178, \
  0x0001F179, 0x0001F17A, 0x0001F17B, 0x0001F17C, 0x0001F17D, 0x0001F17E, \
  0x0001F17F, 0x0001F180, 0x0001F181, 0x0001F182, 0x0001F183, 0x0001F184, \
  0x0001F185, 0x0001F186, 0x0001F187, 0x0001F188, 0x0001F189, 0x0001F18A, \
  0x0001F18B, 0x0001F18C, 0x0001F18D, 0x0001F18F, 0x0001F190, 0x0001F19B, \
  0x0001F19C, 0x0001F19D, 0x0001F19E, 0x0001F19F, 0x0001F1A0, 0x0001F1A1, \
  0x0001F1A2, 0x0001F1A3, 0x0001F1A4, 0x0001F1A5, 0x0001F1A6, 0x0001F1A7, \
  0x0001F1A8, 0x0001F1A9, 0x0001F1AA, 0x0001F1AB, 0x0001F1AC]

# EastAsianWidth.txtで;Wや;FでないのにBIZ UDゴシックではWideになっている文字
expect_narrow = [ \
  0x01CD, 0x01D1, 0x2051, 0x213B, 0x217A, 0x217B, 0x217F, 0x2318, 0x23A7, \
  0x23A8, 0x23A9, 0x23AB, 0x23AC, 0x23AD, 0x23BE, 0x23BF, 0x23C0, 0x23C1, \
  0x23C2, 0x23C3, 0x23C4, 0x23C5, 0x23C6, 0x23C7, 0x23C8, 0x23C9, 0x23CA, \
  0x23CB, 0x23CC, 0x23CE, 0x2423, 0x24EA, 0x2600, 0x2601, 0x2602, 0x2603, \
  0x2616, 0x2617, 0x261D, 0x261F, 0x2713, 0x2756, 0x27A1, 0x29BF, 0x2B05, \
  0x2B06, 0x2B07]


def arrowlr(f):
    # NarrowなU+2190(←)をU+21C4(⇄)の下半分のコピーとして作成
    xmin, ymin, xmax, ymax = f[0x2190].boundingBox()
    origtipy = [p for p in f[0x2190].foreground[0] if p.x <= xmin][0].y
    #ymidorig = ymin + int((ymax - ymin) / 2)
    gsrc = f[0x21C4]
    layersrc = gsrc.layers[gsrc.activeLayer]
    c = layersrc[1].dup()
    g = f[0x2190]
    layer = g.layers[g.activeLayer]
    layer[0] = c
    xmin, ymin, xmax, ymax = layer.boundingBox()
    tipy = [p for p in layer[0] if p.x <= xmin][0].y
    #dy = ymidorig - (ymin + int((ymax - ymin) / 2))  # y=778になる
    dy = origtipy - tipy  # 元の矢印先端と同じy=779にする
    layer[0].transform(psMat.translate(0, dy))
    g.setLayer(layer, g.activeLayer)

    # NarrowなU+2192(→)をU+21C4(⇄)の上半分のコピーとして作成
    c = layersrc[0].dup()
    g = f[0x2192]
    layer = g.layers[g.activeLayer]
    layer[0] = c
    xmin, ymin, xmax, ymax = layer.boundingBox()
    tipy = [p for p in layer[0] if p.x >= xmax][0].y
    dy = origtipy - tipy
    layer[0].transform(psMat.translate(0, dy))
    g.setLayer(layer, g.activeLayer)


def twoDotLeader(f, halfWidth):
    if 0x2025 not in f:
        return
    g = f[0x2025]  # two dot leader(‥)
    layer = g.layers[g.activeLayer]
    c0 = layer[0]
    xmin0, ymin, xmax, ymax = c0.boundingBox()
    c1 = layer[1]
    xmin1, ymin, xmax, ymax = c1.boundingBox()
    # 点の間隔をつめる
    dx = - round((xmin1 - xmin0) / 2)
    c1.transform(psMat.translate(dx, 0))
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)


def threeDotLeader(f, halfWidth):
    if 0x2026 not in f:
        return
    g = f[0x2026]  # three dot leader(…)
    layer = g.layers[g.activeLayer]
    c0 = layer[0]
    xmin0, ymin, xmax, ymax = c0.boundingBox()
    c1 = layer[1]
    xmin1, ymin, xmax, ymax = c1.boundingBox()
    # 点の間隔をつめる。XXX: つまりすぎて少し見にくい気も
    dx = - round((xmin1 - xmin0) / 2)
    c1.transform(psMat.translate(dx, 0))
    c2 = layer[2]
    c2.transform(psMat.translate(dx * 2, 0))
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)


def whiteStar(f, halfWidth):
    if 0x2606 not in f:
        return
    g = f[0x2606]  # white star(☆)
    layer = g.layers[g.activeLayer]
    # 外側と内側の星で別の縮小率を使うので、ずれを回避するため、
    # bbox中心を原点に移動してから縮小したのち位置を戻す。(参考:cica.py)
    xmin, ymin, xmax, ymax = layer.boundingBox()
    cx = (xmin + xmax) / 2
    cy = (ymin + ymax) / 2
    scale0 = halfWidth / (xmax - xmin + SIDE_BEARING)
    trcen = psMat.translate(-cx, -cy)
    layer.transform(trcen)
    layer[0].transform(psMat.scale(scale0, 1))
    # 線が細くなりすぎないように、内側の星は外側(の縮小率)よりも縮める
    layer[1].transform(psMat.scale(scale0 * 0.8, 0.8))
    layer.transform(psMat.inverse(trcen))
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)


def nearlyEqual(f, halfWidth):
    # 単に幅を縮めると、丸が縦長になって見にくいので、位置移動だけで変形
    gref = f[0x003D]  # equal(=)
    xminref, ymin, xmaxref, ymax = gref.boundingBox()
    g = f[0x2252]  # nearly equals(≒)
    layer = g.layers[g.activeLayer]
    xmin, ymin, xmax, ymax = layer.boundingBox()
    # =部分の端の点を移動
    for p in layer[0] + layer[1]:
        if p.x <= xmin:
            p.x = xminref
        elif p.x >= xmax:
            p.x = xmaxref
    # 上側の丸
    c2 = layer[2]
    xmin2, ymin, xmax2, ymax = c2.boundingBox()
    offset = (xmin2 - xmin) / 2  # /2 半分に縮小
    dx = xminref + offset - xmin2
    c2.transform(psMat.translate(dx, 0))
    # 下側の丸
    c3 = layer[3]
    xmin3, ymin, xmax3, ymax = c3.boundingBox()
    dx = xmaxref - offset - xmax3
    c3.transform(psMat.translate(dx, 0))
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth


def divide(f, halfWidth):
    gref = f[0x003D]  # equal(=)
    xminref, ymin, xmaxref, ymax = gref.boundingBox()
    wref = xmaxref - xminref
    g = f[0x00F7]  # divide(÷)
    layer = g.layers[g.activeLayer]
    xmin, ymin, xmax, ymax = layer.boundingBox()
    w = xmax - xmin
    dx = round((w - wref) / 2)
    # -部分の端の点を移動
    for p in layer[0]:
        if p.x <= xmin:
            p.x += dx
        elif p.x >= xmax:
            p.x -= dx
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)


def kome(f, halfWidth):
    g = f[0x203B]  # reference mark(※)
    layer = g.layers[g.activeLayer]
    # 単純化のため、bbox中心を原点に移動してからX縮小・丸の移動後に位置を戻す
    xmin, ymin, xmax, ymax = layer.boundingBox()
    cx = (xmin + xmax) / 2
    cy = (ymin + ymax) / 2
    trcen = psMat.translate(-cx, -cy)
    layer.transform(trcen)
    scalex = halfWidth / (xmax - xmin + SIDE_BEARING)
    xmin0, ymin0, xmax0, ymax0 = layer[0].boundingBox()
    # X部分の幅を縮める。XXX: 線が細くなって見にくくなる
    layer[0].transform(psMat.scale(scalex, 1))
    xmin0s, ymin0, xmax0, ymax0 = layer[0].boundingBox()
    dx = xmin0s - xmin0
    layer[1].transform(psMat.translate(dx, 0))  # 左丸を移動
    layer[3].transform(psMat.translate(-dx, 0))  # 右丸を移動
    layer.transform(psMat.inverse(trcen))
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)


def whiteTriangleDU(f, halfWidth):
    # 単に幅を縮めると、斜め線が細くなって見にくいので補正
    g = f[0x25BD]  # white down-pointing triangle(▽)
    layer = g.layers[g.activeLayer]
    xmin, ymin, xmax, ymax = layer.boundingBox()
    boxw = xmax - xmin
    scalex = halfWidth / (boxw + SIDE_BEARING)

    # 計算を単純にするため外側三角の下点端が原点に来るように移動
    tip0 = layer[0][2]
    transy = psMat.translate(0, -tip0.y)
    layer.transform(psMat.compose(transy, psMat.translate(-tip0.x, 0)))
    # 幅を縮める
    layer.transform(psMat.scale(scalex, 1))

    c0 = layer[0]
    c1 = layer[1]
    d = c0[0].y - c1[0].y

    # 平行線の距離(d)と、相似な三角形の辺の比が同じことを使って、
    # 内側三角の上辺左右端のdxと、下点端のdyを計算する。
    # 外側contour(c0)は左上の点から時計回り。
    # 内側contour(c1)は左上の点から反時計回り。
    # 相似三角形1: c0下点(原点) -- c0右上点 -- c0右上点から垂線を下ろしたx軸上点
    #              (0, 0) -- (c0[1].x, c0[1].y) -- (c0[1].x, 0)
    # 相似三角形2: c0下点(原点) -- c1下点+dy -- c1+(dx,dy)線から原点への垂線交点
    #              (0, 0) -- (0, c11y) -- (c1nx, c1ny)
    # 原点と相似三角形2の3点目の距離をdにしたい。
    #     (0, 0) -- (c0[1].x, c0[1].y) : (0, 0) -- (c0[1].x, 0)
    #   = (0, 0) -- (0, c11y)          : (0, 0) -- (c1nx, c1ny)
    # →
    #     sqrt(c0[1].x ** 2 + c0[1].y ** 2) : c0[1].x
    #   = c11y : d
    c11y = d * math.sqrt(c0[1].x ** 2 + c0[1].y ** 2) / c0[1].x
    # 内側三角の右上がりの辺の傾きは外側に合わせて平行にする。
    #   c0[1].y / c0[1].x = (c1[2].y - c11y) / c12x
    c12x = c0[1].x * (c1[2].y - c11y) / c0[1].y
    dy = c11y - c1[1].y
    dxright = c12x - c1[2].x
    dxleft = -dxright

    # 内側三角の左上点を右に移動
    c1[0].x += dxleft
    # 内側三角の右上点を左に移動
    c1[2].x += dxright
    # 内側三角の下点を上に移動
    c1[1].y += dy

    # y方向位置を戻す。x方向は後でcenterInWidth()で中央に寄せる
    layer.transform(psMat.inverse(transy))

    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)

    # white up-pointing triangle(△)
    g = f[0x25B3]
    layer = g.layers[g.activeLayer]
    layer.transform(psMat.scale(scalex, 1))
    c1 = layer[1]
    c1[0].y -= dy
    c1[1].x += dxleft
    c1[2].x += dxright
    g.setLayer(layer, g.activeLayer)
    g.width = halfWidth
    centerInWidth(g)


def narrow_withscale(f, halfWidth, scalex, ucoderange):
    for ucode in ucoderange:
        if ucode not in f:
            continue
        if ucode not in eaw_array:
            continue
        g = f[ucode]
        if not g.isWorthOutputting():
            continue
        w = g.width
        if w <= halfWidth:
            continue
        g.transform(psMat.scale(scalex, 1))
        g.width = halfWidth


def greek(f, halfWidth):
    """Ambiguousなギリシャ文字をNarrowにする"""
    maxboxw = 1921  # ギリシャ文字群のbboxの最大幅。TODO:bbox.peでの調査不要に
    # scalex=0.5だと細すぎる印象があるのでなるべく大きくなるようにしたい。
    # かといって文字ごとにscaleがばらばらだと大きさがそろわず読みにくい。
    # ただし、0.53 (=1024/1921)なので0.5と違いがわからない程度
    scalex = halfWidth / maxboxw
    # Unicode Block: Greek and Coptic
    narrow_withscale(f, halfWidth, scalex, range(0x0370, 0x0400))


def cyrillic(f, halfWidth):
    """Ambiguousなキリル文字をNarrowにする"""
    maxboxw = 1855  # キリル文字群のbboxの最大幅。TODO:bbox.peでの調査不要に
    scalex = halfWidth / maxboxw  # 0.55
    # Unicode Block: Cyrillic
    narrow_withscale(f, halfWidth, scalex, range(0x0400, 0x0500))


def centerInWidth(g):
    w = g.width
    b = round((g.left_side_bearing + g.right_side_bearing) / 2)
    g.left_side_bearing = b
    g.right_side_bearing = b
    g.width = w  # g.widthが縮む場合があるので再設定


def main(fontfile, fontfamily, fontstyle, version):
    font = fontforge.open(fontfile)

    # 半角スペースから幅を取得
    halfWidth = font[0x0020].width

    # East Asian Ambiguousなグリフの幅を半分にする。
    arrowlr(font)
    greek(font, halfWidth)
    cyrillic(font, halfWidth)
    twoDotLeader(font, halfWidth)
    threeDotLeader(font, halfWidth)
    whiteStar(font, halfWidth)
    nearlyEqual(font, halfWidth)
    divide(font, halfWidth)
    kome(font, halfWidth)
    whiteTriangleDU(font, halfWidth)
    # TODO: □ ±◇∴∵➡⬅

    # 元々半分幅な文字は縮めると細すぎるので縮めずそのまま使う。
    # 右半分だけにする
    for ucode in eaw_useright:
        g = font[ucode]
        if not g.isWorthOutputting():
            continue
        w = g.width
        if w > 0 and w > halfWidth:
            g.transform(psMat.translate(-halfWidth, 0))
            g.width = halfWidth

    # 左半分だけにする
    for ucode in eaw_useleft:
        g = font[ucode]
        if not g.isWorthOutputting():
            continue
        w = g.width
        if w > 0 and w > halfWidth:
            g.width = halfWidth

    for ucode in eaw_array + expect_narrow:
        if ucode not in font:
            continue
        g = font[ucode]
        if not g.isWorthOutputting():
            continue
        w = g.width
        if w > 0 and w > halfWidth:
            xmin, ymin, xmax, ymax = g.boundingBox()
            boxw = xmax - xmin
            # 文字幅をNarrowに収まるように縮める
            if 0x2500 <= ucode <= 0x259F:  # Box Drawing, Block Elements
                g.transform(psMat.scale(0.5, 1))
            elif boxw > halfWidth:
                # +60: side bearing(余白)を加える
                scalex = halfWidth / (boxw + SIDE_BEARING)
                g.transform(psMat.scale(scalex, 1))
            #else:
                # bboxがNarrowに収まる場合は横にずらして中央に移動
                #g.transform(psMat.translate(-halfWidth / 2, 0))
            g.width = halfWidth
            centerInWidth(g)

    # 修正後のフォントファイルを保存
    copyright = "###COPYRIGHT###"
    uniqueid = f"{fontfamily} : {datetime.datetime.now().strftime('%d-%m-%Y')}"

    # TTF名設定 - 英語
    font.appendSFNTName(0x409, 0, copyright)
    font.appendSFNTName(0x409, 1, fontfamily)
    font.appendSFNTName(0x409, 2, fontstyle)
    font.appendSFNTName(0x409, 3, uniqueid)
    font.appendSFNTName(0x409, 4, fontfamily + " " + fontstyle)
    font.appendSFNTName(0x409, 5, version)
    font.appendSFNTName(0x409, 6, fontfamily + "-" + fontstyle)
    # TTF名設定 - 日本語
    font.appendSFNTName(0x411, 0, copyright)
    font.appendSFNTName(0x411, 1, fontfamily)
    font.appendSFNTName(0x411, 2, fontstyle)
    font.appendSFNTName(0x411, 3, uniqueid)
    font.appendSFNTName(0x411, 4, fontfamily + " " + fontstyle)
    font.appendSFNTName(0x411, 5, version)
    font.appendSFNTName(0x411, 6, fontfamily + "-" + fontstyle)

    # 修正後のフォントファイルを保存
    font.generate(f"{fontfamily}-{fontstyle}.ttf")
    font.close()


if __name__ == '__main__':
    # fontfile, fontfamily, fontstyle, version
    main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
