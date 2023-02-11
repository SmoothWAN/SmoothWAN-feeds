module("luci.controller.ntopngconfig.ntopconf", package.seeall)

local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "services", "ntopconf"}, firstchild(), _("Ntopng"), 20)
     e.acl_depends = { "luci-app-ntopngconfig" }
     e.dependent = false

     entry({"admin", "services", "ntopconf", "guide"}, call("guidehelp"), _("Guide"), 1)
     entry({"admin", "services", "ntopconf", "config"}, cbi("ntopngconfig/ntopconf"), _("Configuration"), 2)
     entry({"admin", "services", "ntopconf", "logs"}, call("ntopconflog"), _("View Log"), 3)
end

function guidehelp()
    template.render("ntopngconfig/guidehelp",
        {title = i18n.translate("Quick Setup")})
end

function ntopconflog()
    local logfile = fs.readfile("/tmp/ntopconf.log") or ""
    template.render("ntopngconfig/file_viewer",
        {title = i18n.translate("Install/Service Script Log"), content = logfile})
end