module("luci.controller.tailscaleconf.tailconf", package.seeall)
  
local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "vpn", "tailconf"}, firstchild(), _("Tailscale"), 60)
     e.acl_depends = { "luci-app-tailscaleconf" }
     e.dependent = false
     
     entry({"admin", "vpn", "tailconf", "guide"}, call("guidehelp"), _("Guide"), 1)
     entry({"admin", "vpn", "tailconf", "config"}, cbi("tailscaleconf/tailconf"), _("Configuration"), 2)
     entry({"admin", "vpn", "tailconf", "logs"}, call("tailconflog"), _("View Log"), 3)
end

function guidehelp()
    template.render("tailscaleconf/guidehelp",
        {title = i18n.translate("Quick Setup Guide")})
end

function tailconflog()
    local logfile = fs.readfile("/usr/lib/tailconf/tailconfig.log") or ""
    template.render("tailscaleconf/file_viewer",
        {title = i18n.translate("Install/Service Script Log"), content = logfile})
end
