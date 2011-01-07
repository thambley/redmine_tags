config.gem "acts-as-taggable-on", :version => '2.0.6'

require 'redmine'

Redmine::Plugin.register :redmine_tags do
  name        'Redmine Tags'
  author      'Aleksey V Zapparov AKA "ixti"'
  description 'Adds tagging to Redmine'
  version     '0.0.1'
  url         'http://www.ixti.ru/'
  author_url  'http://www.ixti.ru/'

  requires_redmine :version_or_higher => '1.0.0'

  settings :default => {
    :issues_sidebar => 'none',
    :issues_show_count => 0,
    :issues_open_only => 0
  }, :partial => 'tags/settings'
end


require 'dispatcher'

Dispatcher.to_prepare :redmine_tags do
  require_dependency 'issue'
  require_dependency 'issues_helper'
  require_dependency 'queries_helper'

  unless Issue.included_modules.include?(RedmineTags::Patches::IssuePatch)
    Issue.send(:include, RedmineTags::Patches::IssuePatch)
  end

  unless IssuesHelper.included_modules.include?(RedmineTags::Patches::IssuesHelperPatch)
    IssuesHelper.send(:include, RedmineTags::Patches::IssuesHelperPatch)
  end

  unless AutoCompletesController.included_modules.include?(RedmineTags::Patches::AutoCompletesControllerPatch)
    AutoCompletesController.send(:include, RedmineTags::Patches::AutoCompletesControllerPatch)
  end

  unless QueriesHelper.included_modules.include?(RedmineTags::Patches::QueriesHelperPatch)
    QueriesHelper.send(:include, RedmineTags::Patches::QueriesHelperPatch)
  end
end


require 'redmine_tags/hooks/model_issue_hook'
require 'redmine_tags/hooks/views_issues_hook'