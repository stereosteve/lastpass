
(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var module = cache[name], path = expand(root, name), fn;
      if (module) {
        return module;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: name, exports: {}};
        try {
          cache[name] = module.exports;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return cache[name] = module.exports;
        } catch (err) {
          delete cache[name];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle)
        modules[key] = bundle[key];
    };
  }
  return this.require.define;
}).call(this)({"app": function(exports, require, module) {(function() {
  window.Site = require("models/site");
  window.Group = require("models/group");
  window.Sites = require("controllers/sites");
  module.exports = Spine.Controller.create({
    init: function() {
      this.sites = Sites.init({
        el: $("#sites")
      });
      return $.getJSON("/lastpass/fixtures.json", function(data) {
        Group.refresh(data.groups);
        Site.refresh(data.sites);
        return console.log('sites loaded: ' + Site.count());
      });
    }
  });
}).call(this);
}, "controllers/sites": function(exports, require, module) {(function() {
  var Group, GroupList, Site, SiteDetail, SiteList;
  Site = require('models/site');
  Group = require('models/group');
  SiteList = Spine.List.create({
    selectFirst: true,
    template: function(items) {
      return require("views/sites/list")(items);
    }
  });
  GroupList = Spine.List.create({
    template: function(items) {
      return require("views/sites/group-list")(items);
    }
  });
  SiteDetail = Spine.Controller.create({
    proxied: ['render'],
    events: {
      "submit form.site": "onSubmit"
    },
    init: function() {
      return this.render();
    },
    render: function() {
      var html;
      if (!this.current) {
        return;
      }
      html = require("views/sites/form")(this.current);
      return this.el.html(html);
    },
    onSubmit: function(e) {
      var data, error, errors, _i, _len, _results;
      e.preventDefault();
      if (!this.current) {
        return;
      }
      data = $("form.site").serializeForm();
      this.current.updateAttributes(data);
      if (errors = this.current.validate()) {
        console.log(errors);
        _results = [];
        for (_i = 0, _len = errors.length; _i < _len; _i++) {
          error = errors[_i];
          _results.push(this.showError(error));
        }
        return _results;
      }
    },
    showError: function(error) {
      var el, field;
      field = error.field;
      el = $('.' + field);
      el.addClass('error');
      return $('span.error-message', el).text(error.message);
    },
    active: function(item) {
      if (item) {
        this.current = item;
      }
      return this.render();
    }
  });
  module.exports = Spine.Controller.create({
    elements: {
      "#site-search": "siteSearch",
      "#clear-search": "clearSearch"
    },
    proxied: ["render", "selectSite", "search", "selectGroup", "showAll"],
    init: function() {
      this.groups = GroupList.init({
        el: $('.group-list')
      });
      this.groups.bind('change', this.selectGroup);
      Group.bind('refresh change', this.render);
      this.list = SiteList.init({
        el: $('.site-list')
      });
      this.list.bind('change', this.selectSite);
      Site.bind('refresh change', this.render);
      Site.bind('error', this.error);
      this.detail = SiteDetail.init({
        el: $('.site-detail')
      });
      this.siteSearch.bind("keyup", this.search);
      return this.clearSearch.bind("click", this.showAll);
    },
    showAll: function() {
      console.log("show all");
      Site.currentSearch = null;
      Site.currentGroup = null;
      this.render();
      $(".group.item.active").removeClass('active');
      return $("#site-search").val('');
    },
    render: function() {
      this.list.render(Site.current());
      return this.groups.render(Group.all());
    },
    selectSite: function(item) {
      return this.detail.active(item);
    },
    search: function(ev) {
      Site.currentSearch = this.siteSearch.val();
      return this.render();
    },
    selectGroup: function(group) {
      Site.currentGroup = group.id;
      return this.render();
    },
    error: function(e) {
      return console.log("ERROR");
    }
  });
}).call(this);
}, "models/group": function(exports, require, module) {(function() {
  var Group;
  Group = module.exports = Spine.Model.setup("Group", ["name", "bgcolor", "fgcolor"]);
}).call(this);
}, "models/site": function(exports, require, module) {(function() {
  var Site;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Site = module.exports = Spine.Model.setup("Site", ["name", "url", "username", "password", "notes"]);
  Site.extend({
    sorted: function() {
      return this.all().sort(function(a, b) {
        if (a.name > b.name) {
          return 1;
        }
        if (b.name < a.name) {
          return -1;
        }
        return 0;
      });
    },
    select: function(callback) {
      var item, _i, _len, _ref, _results;
      _ref = this.sorted();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (callback(item)) {
          _results.push(item);
        }
      }
      return _results;
    },
    filterGroupId: function(id) {
      return this.select(function(item) {
        return item.group === id;
      });
    },
    search: function(term) {
      return this.select(function(item) {
        return item.search(term);
      });
    },
    current: function() {
      return this.select(__bind(function(site) {
        if (this.currentSearch && !site.search(this.currentSearch)) {
          return false;
        }
        if (this.currentGroup && site.group !== this.currentGroup) {
          return false;
        }
        return true;
      }, this));
    }
  });
  Site.include({
    addError: function(field, message) {
      return this.errors.push({
        field: field,
        message: message
      });
    },
    validate: function() {
      this.errors = [];
      if (!this.name) {
        this.addError('name', 'Name is required');
      }
      if (!this.url) {
        this.addError('url', 'URL is required');
      }
      if (this.errors.length > 0) {
        return this.errors;
      }
    },
    favicon: function() {
      return "/lastpass/favicons/" + this.name.toLowerCase() + ".png";
    },
    search: function(term) {
      var pattern;
      pattern = new RegExp(term, 'i');
      return pattern.test(this.name) || pattern.test(this.url);
    }
  });
}).call(this);
}, "views/sites/form": function(exports, require, module) {var template = jQuery.template("<h2><img class='favicon' src='${ favicon() }' /> ${name} </h2>\n<form class='site'>\n\n  <div class='field name'>\n    <label>Name</label>\n    <input type='text' name='name' value=\"${name}\" />\n    <span class='error-message'></span>\n  </div>\n\n  <div class='field url'>\n    <label>URL</label>\n    <input type='text' name='url' value='{{= url}}' />\n    <span class='error-message'></span>\n  </div>\n\n  <div class='field'>\n    <label>Username</label>\n    <input type='text' name='username' value='{{= username}}' />\n    <span class='error-message'></span>\n  </div>\n\n  <div class='field'>\n    <label>Password</label>\n    <input type='password' name='password' value='{{= password}}' />\n    <span class='error-message'></span>\n  </div>\n\n  <div class='actions'>\n    <input type='submit' class='save' value='Save' />\n  </div>\n\n</form>\n");module.exports = (function(data){ return jQuery.tmpl(template, data); });
}, "views/sites/group-list": function(exports, require, module) {var template = jQuery.template("<div class='group item'><img class='silk' src='/lastpass/img/folder.png' />${name}</div>\n");module.exports = (function(data){ return jQuery.tmpl(template, data); });
}, "views/sites/list": function(exports, require, module) {var template = jQuery.template("<div class='site item'>\n  <img class='favicon' src='${ favicon() }' />\n  <span class='site-name'>${name}</span>\n</div>\n");module.exports = (function(data){ return jQuery.tmpl(template, data); });
}});
