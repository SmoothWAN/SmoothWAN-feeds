module("luci.controller.piholeconf.pihconf", package.seeall)
  
local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "services", "pihconf"}, firstchild(), _("Pi-hole"), 60)
     e.acl_depends = { "luci-app-piholeconf" }
     e.dependent = false
     
     entry({"admin", "services", "pihconf", "guide"}, call("guidehelp"), _("Guides"), 1)
     entry({"admin", "services", "pihconf", "config"}, cbi("piholeconf/pihconf"), _("Configuration"), 2)
     entry({"admin", "services", "pihconf", "logs"}, call("pihconflog"), _("View Log"), 3)
end

function guidehelp()
    template.render("piholeconf/guidehelp",
        {title = i18n.translate("Quick Setup")})
end

function pihconflog()
    local logfile = io.popen("tac /usr/lib/piholeconf/piholeconfig.log")
    local reverse = logfile:read("*a")
    logfile:close()
    template.render("piholeconf/file_viewer",
        {title = i18n.translate("Installation Log"), content = reverse})
end
