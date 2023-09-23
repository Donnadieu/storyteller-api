# frozen_string_literal: true

# Guide on Thor in place of Rake: https://technology.doximity.com/articles/move-over-rake-thor-is-the-new-king
# Guide on getting started with Thor: https://github.com/rails/thor/wiki/Getting-Started
#
# Loading the Rails environment in config/environment allows us to
# have access to ActiveRecord, and other classes the same as if we
# were inside a Rails console from our Thor tasks.
require File.expand_path('config/environment', __dir__)

# This just instructs the Thor task display where to look for
# thor tasks. Note that they would not show up with a rake -T
# but instead with a thor -T. Putting them in lib/tasks allows
# them to live side by side with your legacy rake tasks.
Dir['./lib/tasks/**/*.thor'].each { |f| load f }
