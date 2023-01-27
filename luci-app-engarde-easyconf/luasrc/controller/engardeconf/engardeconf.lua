module("luci.controller.engardeconf.engardeconf", package.seeall)

local fs = require "nixio.fs"
local sys = require "luci.sys"
local template = require "luci.template"
local i18n = require "luci.i18n"


function index()
     local e = entry({"admin", "VPN", "engconf"}, firstchild(), _("Engarde"), 60)
     e.acl_depends = { "luci-app-engarde-easyconf" }
     e.dependent = false

     entry({"admin", "services", "engconf", "guide"}, call("guidehelp"), _("Guide"), 1)
     entry({"admin", "services", "engconf", "config"}, cbi("engardeconf/engardeconf"), _("Configuration"), 2)
end

function guidehelp()
    template.render("engardeconf/guidehelp",
        {title = i18n.translate("Quick Setup")})
end