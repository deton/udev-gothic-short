
let g:loaded_cellwidth_udeawn = 1

if (&encoding == 'utf-8') && exists('*setcellwidths') && has('vim_starting')
	set ambiwidth=single
	call setcellwidths([
		\ [0x24c2, 0x24c2, 1],
		\ [0x26c8, 0x26c8, 1],
		\ [0x26cf, 0x26cf, 1],
		\ [0x26d1, 0x26d1, 1],
		\ [0x26d3, 0x26d3, 1],
		\ [0x26e9, 0x26e9, 1],
		\ [0x26f0, 0x26f1, 1],
		\ [0x26f4, 0x26f4, 1],
		\ [0x26f7, 0x26f9, 1],
		\ [0x1f170, 0x1f189, 1],
		\
		\ [0x261d, 0x261d, 1],
		\
		\ [0x23ed, 0x23ef, 1],
		\ [0x23f1, 0x23f2, 1],
		\ [0x23f8, 0x23fa, 1],
		\ [0x270c, 0x270d, 1],
		\ [0x1f1e6, 0x1f1ff, 1],
		\ [0x1f321, 0x1f321, 1],
		\ [0x1f324, 0x1f32c, 1],
		\ [0x1f336, 0x1f336, 1],
		\ [0x1f37d, 0x1f37d, 1],
		\ [0x1f396, 0x1f397, 1],
		\ [0x1f399, 0x1f39b, 1],
		\ [0x1f39e, 0x1f39f, 1],
		\ [0x1f3cb, 0x1f3ce, 1],
		\ [0x1f3d4, 0x1f3df, 1],
		\ [0x1f3f3, 0x1f3f3, 1],
		\ [0x1f3f5, 0x1f3f5, 1],
		\ [0x1f3f7, 0x1f3f7, 1],
		\ [0x1f43f, 0x1f43f, 1],
		\ [0x1f441, 0x1f441, 1],
		\ [0x1f4fd, 0x1f4fd, 1],
		\ [0x1f549, 0x1f54a, 1],
		\ [0x1f56f, 0x1f570, 1],
		\ [0x1f573, 0x1f579, 1],
		\ [0x1f587, 0x1f587, 1],
		\ [0x1f58a, 0x1f58d, 1],
		\ [0x1f590, 0x1f590, 1],
		\ [0x1f5a5, 0x1f5a5, 1],
		\ [0x1f5a8, 0x1f5a8, 1],
		\ [0x1f5b1, 0x1f5b2, 1],
		\ [0x1f5bc, 0x1f5bc, 1],
		\ [0x1f5c2, 0x1f5c4, 1],
		\ [0x1f5d1, 0x1f5d3, 1],
		\ [0x1f5dc, 0x1f5de, 1],
		\ [0x1f5e1, 0x1f5e1, 1],
		\ [0x1f5e3, 0x1f5e3, 1],
		\ [0x1f5e8, 0x1f5e8, 1],
		\ [0x1f5ef, 0x1f5ef, 1],
		\ [0x1f5f3, 0x1f5f3, 1],
		\ [0x1f5fa, 0x1f5fa, 1],
		\ [0x1f6cb, 0x1f6cb, 1],
		\ [0x1f6cd, 0x1f6cf, 1],
		\ [0x1f6e0, 0x1f6e5, 1],
		\ [0x1f6e9, 0x1f6e9, 1],
		\ [0x1f6f0, 0x1f6f0, 1],
		\ [0x1f6f3, 0x1f6f3, 1],
		\ ])
endif
