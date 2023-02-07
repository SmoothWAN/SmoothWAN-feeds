module("luci.controller.p2plog.p2plog", package.seeall)

local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "status", "p2plog"}, firstchild(), _("BitTorrent Activity Log"), 100)
     e.acl_depends = { "luci-app-adhomeconfig" }
     e.dependent = false

     entry({"admin", "status", "p2plog", "log"}, call("p2plog"), _("Log history"), 1)

end

function p2plog()
    local logfile = fs.readfile("/tmp/p2p.log") or ""
    template.render("p2plog/file_viewer",
        {title = i18n.translate("P2P Activity logging"), content = logfile})
end