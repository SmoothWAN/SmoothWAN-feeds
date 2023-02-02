module("luci.controller.engardeconf.engardeconf", package.seeall)

local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "vpn", "engconf"}, firstchild(), _("Engarde"), 60)
     e.acl_depends = { "luci-app-engarde-easyconf" }
     e.dependent = false

     entry({"admin", "vpn", "engconf", "guide"}, call("guidehelp"), _("Guide"), 1)
     entry({"admin", "vpn", "engconf", "config"}, cbi("engardeconf/engardeconf"), _("Configuration"), 2)
     entry({"admin", "vpn", "engconf", "logs"}, call("engardelog"), _("View Log"), 3)

end

function guidehelp()
    template.render("engardeconf/guidehelp",
        {title = i18n.translate("Quick Setup")})
end

function engardelog()
    local logfile = fs.readfile("/tmp/engarde.log") or ""
    template.render("tinyvpnconf/file_viewer",
        {title = i18n.translate("Service Script Log"), content = logfile})
end