-- Add support for the LazyFile event
local Event = require 'lazy.core.handler.event'
local UGodot = require 'util.godot'

Event.mappings.LazyFile = { id = 'LazyFile', event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' } }
Event.mappings['User LazyFile'] = Event.mappings.LazyFile

require 'config.globals'
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'

-- check if server is already running in godot project path
local cwd = vim.fn.getcwd()
local is_godot_project = UGodot.is_godot_project(cwd)
local is_server_running = vim.uv.fs_stat(cwd .. '/server.pipe')
-- start server, if not already running
if is_godot_project and not is_server_running then
    vim.fn.serverstart(cwd .. '/server.pipe')
end
