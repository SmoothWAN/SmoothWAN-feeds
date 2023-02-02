module("luci.controller.tinyvpnconf.tinyvpnconf", package.seeall)

local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "vpn", "tinyvpnconf"}, firstchild(), _("TinyFEC"), 70)
     e.acl_depends = { "luci-app-tinyfecvpn-easyconf" }
     e.dependent = false

     entry({"admin", "vpn", "tinyvpnconf", "guide"}, call("guidehelp"), _("Guide"), 1)
     entry({"admin", "vpn", "tinyvpnconf", "config"}, cbi("tinyvpnconf/tinyvpnconf"), _("Configuration"), 2)
     entry({"admin", "vpn", "tinyvpnconf", "logs"}, call("tinyvpnlog"), _("View Log"), 3)

end

function guidehelp()
    template.render("tinyvpnconf/guidehelp",
        {title = i18n.translate("Quick Setup")})
end

function tinyvpnlog()
    local logfile = fs.readfile("/tmp/tinyfecvpn.log") or ""
    template.render("tinyvpnconf/file_viewer",
        {title = i18n.translate("Service Script Log"), content = logfile})
end