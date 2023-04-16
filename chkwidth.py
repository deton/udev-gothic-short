#!/usr/bin/fontforge
# EastAsianWidth.txtで;Wや;Fでないのに、
# Wideになっている文字をリストアップしてstdoutに出力する。
#   Usage: fontforge -script chkwidth.py source/fontforge_export_BIZUDGothic-Regular.ttf
import sys
import fontforge

# ./eawwf.sh で生成した、;W ;F の文字の範囲。2個ずつ対にした範囲(両端含む)
eawwf_range = (
  (0x1100, 0x115F),
  (0x231A, 0x231B),
  (0x2329, 0x2329),
  (0x232A, 0x232A),
  (0x23E9, 0x23EC),
  (0x23F0, 0x23F0),
  (0x23F3, 0x23F3),
  (0x25FD, 0x25FE),
  (0x2614, 0x2615),
  (0x2648, 0x2653),
  (0x267F, 0x267F),
  (0x2693, 0x2693),
  (0x26A1, 0x26A1),
  (0x26AA, 0x26AB),
  (0x26BD, 0x26BE),
  (0x26C4, 0x26C5),
  (0x26CE, 0x26CE),
  (0x26D4, 0x26D4),
  (0x26EA, 0x26EA),
  (0x26F2, 0x26F3),
  (0x26F5, 0x26F5),
  (0x26FA, 0x26FA),
  (0x26FD, 0x26FD),
  (0x2705, 0x2705),
  (0x270A, 0x270B),
  (0x2728, 0x2728),
  (0x274C, 0x274C),
  (0x274E, 0x274E),
  (0x2753, 0x2755),
  (0x2757, 0x2757),
  (0x2795, 0x2797),
  (0x27B0, 0x27B0),
  (0x27BF, 0x27BF),
  (0x2B1B, 0x2B1C),
  (0x2B50, 0x2B50),
  (0x2B55, 0x2B55),
  (0x2E80, 0x2E99),
  (0x2E9B, 0x2EF3),
  (0x2F00, 0x2FD5),
  (0x2FF0, 0x2FFB),
  (0x3000, 0x3000),
  (0x3001, 0x3003),
  (0x3004, 0x3004),
  (0x3005, 0x3005),
  (0x3006, 0x3006),
  (0x3007, 0x3007),
  (0x3008, 0x3008),
  (0x3009, 0x3009),
  (0x300A, 0x300A),
  (0x300B, 0x300B),
  (0x300C, 0x300C),
  (0x300D, 0x300D),
  (0x300E, 0x300E),
  (0x300F, 0x300F),
  (0x3010, 0x3010),
  (0x3011, 0x3011),
  (0x3012, 0x3013),
  (0x3014, 0x3014),
  (0x3015, 0x3015),
  (0x3016, 0x3016),
  (0x3017, 0x3017),
  (0x3018, 0x3018),
  (0x3019, 0x3019),
  (0x301A, 0x301A),
  (0x301B, 0x301B),
  (0x301C, 0x301C),
  (0x301D, 0x301D),
  (0x301E, 0x301F),
  (0x3020, 0x3020),
  (0x3021, 0x3029),
  (0x302A, 0x302D),
  (0x302E, 0x302F),
  (0x3030, 0x3030),
  (0x3031, 0x3035),
  (0x3036, 0x3037),
  (0x3038, 0x303A),
  (0x303B, 0x303B),
  (0x303C, 0x303C),
  (0x303D, 0x303D),
  (0x303E, 0x303E),
  (0x3041, 0x3096),
  (0x3099, 0x309A),
  (0x309B, 0x309C),
  (0x309D, 0x309E),
  (0x309F, 0x309F),
  (0x30A0, 0x30A0),
  (0x30A1, 0x30FA),
  (0x30FB, 0x30FB),
  (0x30FC, 0x30FE),
  (0x30FF, 0x30FF),
  (0x3105, 0x312F),
  (0x3131, 0x318E),
  (0x3190, 0x3191),
  (0x3192, 0x3195),
  (0x3196, 0x319F),
  (0x31A0, 0x31BF),
  (0x31C0, 0x31E3),
  (0x31F0, 0x31FF),
  (0x3200, 0x321E),
  (0x3220, 0x3229),
  (0x322A, 0x3247),
  (0x3250, 0x3250),
  (0x3251, 0x325F),
  (0x3260, 0x327F),
  (0x3280, 0x3289),
  (0x328A, 0x32B0),
  (0x32B1, 0x32BF),
  (0x32C0, 0x32FF),
  (0x3300, 0x33FF),
  (0x3400, 0x4DBF),
  (0x4E00, 0x9FFF),
  (0xA000, 0xA014),
  (0xA015, 0xA015),
  (0xA016, 0xA48C),
  (0xA490, 0xA4C6),
  (0xA960, 0xA97C),
  (0xAC00, 0xD7A3),
  (0xF900, 0xFA6D),
  (0xFA6E, 0xFA6F),
  (0xFA70, 0xFAD9),
  (0xFADA, 0xFAFF),
  (0xFE10, 0xFE16),
  (0xFE17, 0xFE17),
  (0xFE18, 0xFE18),
  (0xFE19, 0xFE19),
  (0xFE30, 0xFE30),
  (0xFE31, 0xFE32),
  (0xFE33, 0xFE34),
  (0xFE35, 0xFE35),
  (0xFE36, 0xFE36),
  (0xFE37, 0xFE37),
  (0xFE38, 0xFE38),
  (0xFE39, 0xFE39),
  (0xFE3A, 0xFE3A),
  (0xFE3B, 0xFE3B),
  (0xFE3C, 0xFE3C),
  (0xFE3D, 0xFE3D),
  (0xFE3E, 0xFE3E),
  (0xFE3F, 0xFE3F),
  (0xFE40, 0xFE40),
  (0xFE41, 0xFE41),
  (0xFE42, 0xFE42),
  (0xFE43, 0xFE43),
  (0xFE44, 0xFE44),
  (0xFE45, 0xFE46),
  (0xFE47, 0xFE47),
  (0xFE48, 0xFE48),
  (0xFE49, 0xFE4C),
  (0xFE4D, 0xFE4F),
  (0xFE50, 0xFE52),
  (0xFE54, 0xFE57),
  (0xFE58, 0xFE58),
  (0xFE59, 0xFE59),
  (0xFE5A, 0xFE5A),
  (0xFE5B, 0xFE5B),
  (0xFE5C, 0xFE5C),
  (0xFE5D, 0xFE5D),
  (0xFE5E, 0xFE5E),
  (0xFE5F, 0xFE61),
  (0xFE62, 0xFE62),
  (0xFE63, 0xFE63),
  (0xFE64, 0xFE66),
  (0xFE68, 0xFE68),
  (0xFE69, 0xFE69),
  (0xFE6A, 0xFE6B),
  (0xFF01, 0xFF03),
  (0xFF04, 0xFF04),
  (0xFF05, 0xFF07),
  (0xFF08, 0xFF08),
  (0xFF09, 0xFF09),
  (0xFF0A, 0xFF0A),
  (0xFF0B, 0xFF0B),
  (0xFF0C, 0xFF0C),
  (0xFF0D, 0xFF0D),
  (0xFF0E, 0xFF0F),
  (0xFF10, 0xFF19),
  (0xFF1A, 0xFF1B),
  (0xFF1C, 0xFF1E),
  (0xFF1F, 0xFF20),
  (0xFF21, 0xFF3A),
  (0xFF3B, 0xFF3B),
  (0xFF3C, 0xFF3C),
  (0xFF3D, 0xFF3D),
  (0xFF3E, 0xFF3E),
  (0xFF3F, 0xFF3F),
  (0xFF40, 0xFF40),
  (0xFF41, 0xFF5A),
  (0xFF5B, 0xFF5B),
  (0xFF5C, 0xFF5C),
  (0xFF5D, 0xFF5D),
  (0xFF5E, 0xFF5E),
  (0xFF5F, 0xFF5F),
  (0xFF60, 0xFF60),
  (0xFFE0, 0xFFE1),
  (0xFFE2, 0xFFE2),
  (0xFFE3, 0xFFE3),
  (0xFFE4, 0xFFE4),
  (0xFFE5, 0xFFE6),
  (0x16FE0, 0x16FE1),
  (0x16FE2, 0x16FE2),
  (0x16FE3, 0x16FE3),
  (0x16FE4, 0x16FE4),
  (0x16FF0, 0x16FF1),
  (0x17000, 0x187F7),
  (0x18800, 0x18AFF),
  (0x18B00, 0x18CD5),
  (0x18D00, 0x18D08),
  (0x1AFF0, 0x1AFF3),
  (0x1AFF5, 0x1AFFB),
  (0x1AFFD, 0x1AFFE),
  (0x1B000, 0x1B0FF),
  (0x1B100, 0x1B122),
  (0x1B132, 0x1B132),
  (0x1B150, 0x1B152),
  (0x1B155, 0x1B155),
  (0x1B164, 0x1B167),
  (0x1B170, 0x1B2FB),
  (0x1F004, 0x1F004),
  (0x1F0CF, 0x1F0CF),
  (0x1F18E, 0x1F18E),
  (0x1F191, 0x1F19A),
  (0x1F200, 0x1F202),
  (0x1F210, 0x1F23B),
  (0x1F240, 0x1F248),
  (0x1F250, 0x1F251),
  (0x1F260, 0x1F265),
  (0x1F300, 0x1F320),
  (0x1F32D, 0x1F335),
  (0x1F337, 0x1F37C),
  (0x1F37E, 0x1F393),
  (0x1F3A0, 0x1F3CA),
  (0x1F3CF, 0x1F3D3),
  (0x1F3E0, 0x1F3F0),
  (0x1F3F4, 0x1F3F4),
  (0x1F3F8, 0x1F3FA),
  (0x1F3FB, 0x1F3FF),
  (0x1F400, 0x1F43E),
  (0x1F440, 0x1F440),
  (0x1F442, 0x1F4FC),
  (0x1F4FF, 0x1F53D),
  (0x1F54B, 0x1F54E),
  (0x1F550, 0x1F567),
  (0x1F57A, 0x1F57A),
  (0x1F595, 0x1F596),
  (0x1F5A4, 0x1F5A4),
  (0x1F5FB, 0x1F5FF),
  (0x1F600, 0x1F64F),
  (0x1F680, 0x1F6C5),
  (0x1F6CC, 0x1F6CC),
  (0x1F6D0, 0x1F6D2),
  (0x1F6D5, 0x1F6D7),
  (0x1F6DC, 0x1F6DF),
  (0x1F6EB, 0x1F6EC),
  (0x1F6F4, 0x1F6FC),
  (0x1F7E0, 0x1F7EB),
  (0x1F7F0, 0x1F7F0),
  (0x1F90C, 0x1F93A),
  (0x1F93C, 0x1F945),
  (0x1F947, 0x1F9FF),
  (0x1FA70, 0x1FA7C),
  (0x1FA80, 0x1FA88),
  (0x1FA90, 0x1FABD),
  (0x1FABF, 0x1FAC5),
  (0x1FACE, 0x1FADB),
  (0x1FAE0, 0x1FAE8),
  (0x1FAF0, 0x1FAF8),
  (0x20000, 0x2A6DF),
  (0x2A6E0, 0x2A6FF),
  (0x2A700, 0x2B739),
  (0x2B73A, 0x2B73F),
  (0x2B740, 0x2B81D),
  (0x2B81E, 0x2B81F),
  (0x2B820, 0x2CEA1),
  (0x2CEA2, 0x2CEAF),
  (0x2CEB0, 0x2EBE0),
  (0x2EBE1, 0x2F7FF),
  (0x2F800, 0x2FA1D),
  (0x2FA1E, 0x2FA1F),
  (0x2FA20, 0x2FFFD),
  (0x30000, 0x3134A),
  (0x3134B, 0x3134F),
  (0x31350, 0x323AF),
  (0x323B0, 0x3FFFD),
)

def main(fontfile):
    font = fontforge.open(fontfile)
    if 0x0020 in font:
        # 半角スペースから幅を取得
        halfWidth = font[0x0020].width
    else:
        # U+3299(㊙)からWide幅を取得。emoji fontには0x0020が無いので
        halfWidth = font[0x3299].width / 2

    idx = 0
    for ucode in range(0x0020, eawwf_range[-1][1] + 1):
        iswf = False
        while idx < len(eawwf_range):
            if eawwf_range[idx][0] <= ucode <= eawwf_range[idx][1]:
                iswf = True
                break
            elif ucode < eawwf_range[idx][0]:
                break
            elif ucode > eawwf_range[idx][0]:
                idx += 1

        if ucode not in font:
            continue
        g = font[ucode]
        if not g.isWorthOutputting():
            continue
        w = g.width
        if w > halfWidth and not iswf:
            print(f"{ucode:x} {chr(ucode)} {w} {iswf}")
    font.close()

if __name__ == '__main__':
    # fontfile
    main(sys.argv[1])
