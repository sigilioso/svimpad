" svimpad - Vim plugin to Springad
" =================================
"
" A plugin to publish notes to <http://springad.com> from Vim.
"
" svimpad is free software: you can redistribute it and/or
" modify it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
" GNU General Public License for more details.
"
 if !has('python')
    echo "Error: required vim compiled with python+"
    finish
endif

let s:script_dir = expand("<sfile>:p:h")

function! Springpad()

python << EOF

import vim
import sys
import os
import pygments
from pygments.lexers import TextLexer, get_lexer_by_name
from pygments.formatters import HtmlFormatter

base_dir = os.path.join(vim.eval('s:script_dir'), 'svimpad')
sys.path.append(base_dir)

from springpad_client import auth_springpad_client

client = auth_springpad_client()
buffer_content = '\n'.join(vim.current.buffer[:])

formatter = HtmlFormatter()
formatter.noclasses = True
# Try to get lexer depending on vim current filetype and set txt if fails
filetype = vim.eval('&ft')
try:
    lexer = get_lexer_by_name(filetype)
except:
    lexer = TextLexer()
# Highlight the note
note = pygments.highlight(buffer_content, lexer, formatter)

# Publish to springpad
client.spring_note('Note from Vim', note)

EOF

endfunction

command! -nargs=0 Springpad call Springpad()
