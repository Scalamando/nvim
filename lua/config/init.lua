-- Add support for the LazyFile event
local Event = require 'lazy.core.handler.event'

Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' } }
Event.mappings['User LazyFile'] = Event.mappings.LazyFile

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
